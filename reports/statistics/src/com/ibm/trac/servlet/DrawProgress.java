/**
 * 
 */
package com.ibm.trac.servlet;

import java.io.IOException;
import java.text.ParseException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;

import com.ibm.trac.chart.DrawLineChart;
import com.ibm.trac.domain.Sprint;
import com.ibm.trac.service.SprintService;

/**
 * @author zhangyi
 * 
 */
public class DrawProgress extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1559690235206629940L;

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

		long sprintId = Long.valueOf((String) req.getParameter("id"));
		SprintService sprintMgmt = new SprintService();
		Sprint sprint = sprintMgmt.loadSprint(sprintId);

		DrawLineChart lineChart = new DrawLineChart(sprint);
		JFreeChart chart = null;
		try {
			chart = lineChart.draw();
		} catch (ParseException e) {
			e.printStackTrace();
		}

		ChartUtilities.writeChartAsPNG(resp.getOutputStream(), chart,
				sprint.getWidth(), sprint.getHeight());

	}

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
		doPost(req, resp);
	}

}
