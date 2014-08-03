/**
 * 
 */
package com.ibm.trac.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ibm.trac.domain.EffortProgress;
import com.ibm.trac.domain.Sprint;
import com.ibm.trac.service.EffortProgressService;
import com.ibm.trac.service.SprintService;

/**
 * @author zhangyi
 * 
 */
public class EffortProgressServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7282878694327781771L;

	private static final String REQ_ADD_PROGRESS = "addProgress";
	private static final String REQ_DEL_PROGRESS = "deleteProgress";

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest
	 * , javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		long sprintId = Long.valueOf(req.getParameter("sprintId"));
		SprintService sprintService = new SprintService();
		EffortProgressService efforProgressService = new EffortProgressService();
		Sprint sprint = sprintService.loadSprint(sprintId);

		String requestURI = req.getRequestURI();
		if (requestURI.indexOf(REQ_ADD_PROGRESS) != -1) {
			efforProgressService.addEffortRecord(sprint);
		}

		if (requestURI.indexOf(REQ_DEL_PROGRESS) != -1) {
			long id = Long.valueOf(req.getParameter("id"));
			efforProgressService.delEffortRecord(id);
		}

		List<EffortProgress> list = efforProgressService
				.loadEfforProgress(sprint);

		req.setAttribute("progress", list);
		req.setAttribute("sprint", sprint);
		req.getRequestDispatcher("displayEffortProgress.jsp")
				.forward(req, resp);

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest
	 * , javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}

}
