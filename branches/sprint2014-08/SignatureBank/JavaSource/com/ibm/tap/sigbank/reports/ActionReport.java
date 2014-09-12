package com.ibm.tap.sigbank.reports;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.tap.sigbank.filter.SoftwareFilterDelegate;
import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Pagination;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.tap.sigbank.framework.navigate.NavigationController;
import com.ibm.tap.sigbank.signature.SoftwareSignatureDelegate;
import com.ibm.tap.sigbank.software.SoftwareDelegate;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryDelegate;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionReport extends BaseAction {

	public ActionForward report(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.reportsLink);

		if (user.isAdminAccess()) {
			return mapping.findForward(Constants.EDIT);
		}

		return mapping.findForward(Constants.VIEW);
	}

	public ActionForward history(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.reportsLink);
		user.setLevelTwoOpenLink(NavigationController.historyLink);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward softwareCategory(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.reportsLink);
		user.setLevelTwoOpenLink(NavigationController.historyLink);

		String year = request.getParameter("year");
		String month = request.getParameter("month");

		request.setAttribute("year", year);
		request.setAttribute("month", month);

		if (Util.isBlankString(year)) {
			request.setAttribute(Constants.REPORT, SoftwareCategoryDelegate
					.getHistoryYears());
			return mapping.findForward("year");
		}

		if (Util.isBlankString(month)) {
			request.setAttribute(Constants.REPORT, SoftwareCategoryDelegate
					.getHistoryMonths(year));
			return mapping.findForward("month");
		}

		request.setAttribute(Constants.REPORT, SoftwareCategoryDelegate
				.getHistoryByYearByMonth(year, month));

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward software(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.reportsLink);
		user.setLevelTwoOpenLink(NavigationController.historyLink);

		String year = request.getParameter("year");
		String month = request.getParameter("month");

		request.setAttribute("year", year);
		request.setAttribute("month", month);

		if (Util.isBlankString(year)) {
			request.setAttribute(Constants.REPORT, SoftwareDelegate
					.getHistoryYears());
			return mapping.findForward("year");
		}

		if (Util.isBlankString(month)) {
			request.setAttribute(Constants.REPORT, SoftwareDelegate
					.getHistoryMonths(year));
			return mapping.findForward("month");
		}

		request.setAttribute(Constants.REPORT, SoftwareDelegate
				.getHistoryByYearByMonth(year, month));

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward filter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.reportsLink);
		user.setLevelTwoOpenLink(NavigationController.historyLink);

		String year = request.getParameter("year");
		String month = request.getParameter("month");

		request.setAttribute("year", year);
		request.setAttribute("month", month);

		if (Util.isBlankString(year)) {
			request.setAttribute(Constants.REPORT, SoftwareFilterDelegate
					.getHistoryYears());
			return mapping.findForward("year");
		}

		if (Util.isBlankString(month)) {
			request.setAttribute(Constants.REPORT, SoftwareFilterDelegate
					.getHistoryMonths(year));
			return mapping.findForward("month");
		}

		Pagination pagination = new Pagination(request, new Integer(
				SoftwareFilterDelegate
						.getHistoryByYearByMonthCount(year, month).intValue()),
				500);

		request.setAttribute(Constants.PAGINATION, pagination);

		request.setAttribute(Constants.REPORT, SoftwareFilterDelegate
				.getHistoryByYearByMonth(year, month, pagination));

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward signature(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.reportsLink);
		user.setLevelTwoOpenLink(NavigationController.historyLink);

		String year = request.getParameter("year");
		String month = request.getParameter("month");

		request.setAttribute("year", year);
		request.setAttribute("month", month);

		if (Util.isBlankString(year)) {
			request.setAttribute(Constants.REPORT, SoftwareSignatureDelegate
					.getHistoryYears());
			return mapping.findForward("year");
		}

		if (Util.isBlankString(month)) {
			request.setAttribute(Constants.REPORT, SoftwareSignatureDelegate
					.getHistoryMonths(year));
			return mapping.findForward("month");
		}

		request.setAttribute(Constants.REPORT, SoftwareSignatureDelegate
				.getHistoryByYearByMonth(year, month));

		return mapping.findForward(Constants.SUCCESS);
	}

}