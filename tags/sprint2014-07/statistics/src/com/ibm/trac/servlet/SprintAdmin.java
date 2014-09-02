/**
 * 
 */
package com.ibm.trac.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ibm.trac.domain.Sprint;
import com.ibm.trac.service.SprintService;

/**
 * @author zhangyi
 * 
 */
public class SprintAdmin extends HttpServlet {

	private static final long serialVersionUID = -4294057735048096331L;

	private static final String REQ_LOAD_EFFORT = "sprintLoadEffort";
	private static final String REQ_DELETE_SPRINT = "sprintDelete";
	private static final String REQ_EDIT_SPRINT = "sprintEdit";
	private static final String REQ_UPDATE_SPRINT = "sprintUpdate";
	private static final String REQ_SPRINT_ADMIN = "sprintAdd";

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

		SprintService sprintMgr = new SprintService();

		String requestURI = req.getRequestURI();
		if (requestURI.indexOf(REQ_SPRINT_ADMIN) != -1) {
			String name = req.getParameter("name");
			String start = req.getParameter("start");
			String end = req.getParameter("end");
			int width = Integer.valueOf(req.getParameter("width"));
			int height = Integer.valueOf(req.getParameter("height"));
			sprintMgr.insertSprint(name, start, end, width, height);
		}

		if (requestURI.indexOf(REQ_LOAD_EFFORT) != -1) {
			long id = Long.valueOf(req.getParameter("id"));
			sprintMgr.loadEffort(id);
		}
		if (requestURI.indexOf(REQ_DELETE_SPRINT) != -1) {
			long id = Long.valueOf(req.getParameter("id"));
			sprintMgr.deleteSprint(id);
		}

		if (requestURI.indexOf(REQ_EDIT_SPRINT) != -1) {
			long id = Long.valueOf(req.getParameter("id"));
			Sprint sprint = sprintMgr.loadSprint(id);
			req.setAttribute("sprint", sprint);
			req.getRequestDispatcher("sprintUpdate.jsp").forward(req, resp);
			return;
		}

		if (requestURI.indexOf(REQ_UPDATE_SPRINT) != -1) {
			long id = Long.valueOf(req.getParameter("id"));
			String name = req.getParameter("name");
			String start = req.getParameter("start");
			String end = req.getParameter("end");
			int width = Integer.valueOf(req.getParameter("width"));
			int height = Integer.valueOf(req.getParameter("height"));

			sprintMgr.updateSprint(id, name, start, end, width, height);
		}

		List<Sprint> sprints = sprintMgr.loadSprint();
		req.setAttribute("sprints", sprints);

		RequestDispatcher dispatcher = req
				.getRequestDispatcher("sprintAdmin.jsp");
		dispatcher.forward(req, resp);

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
