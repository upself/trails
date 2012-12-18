/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.report;

import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.cndb.DelegateCndb;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ActionReport extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(ActionReport.class);

	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionReport.home");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward department(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionReport.department");

		DynaActionForm departmentForm = (DynaActionForm) form;

		String id = (String) departmentForm.get("id");
		if (EaUtils.isBlank(id)) {
			id = getParameter(request, Constants.ID);
		}

		request.setAttribute(Constants.DEPARTMENT, DelegateCndb
				.getDepartments());

		if (EaUtils.isBlank(id)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		List<DepartmentScanReport> report = DelegateReport.getDepartmentScanReport(id);

		departmentForm.set("id", id);
		request.setAttribute("DynaDepartmentForm", departmentForm);
		request.setAttribute(Constants.REPORT, report);

		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward geo(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionReport.geo");

		List<DepartmentScanReport> report = DelegateReport.getGeoScanReport();

		request.setAttribute(Constants.REPORT, report);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward discrepancySummary(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionReport.discrepancySummary");

		List<DiscrepancySummary> report = DelegateReport.getDiscrepancySummaryReport();

		request.setAttribute(Constants.REPORT, report);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward rollup(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionReport.rollup");

		String geoId = getParameter(request, "geo");
		String regionId = getParameter(request, "region");
		String countryId = getParameter(request, "country");
		
		List<DepartmentScanReport> report = new Vector<DepartmentScanReport>();
		
		if(!EaUtils.isBlank(geoId)) {
			report = DelegateReport.getGeoRollupReport(geoId);
		}
		else if(!EaUtils.isBlank(regionId)) {
			report = DelegateReport.getRegionRollupReport(regionId);
		}
		else if(!EaUtils.isBlank(countryId)) {
			report = DelegateReport.getCountryCodeRollupReport(countryId);
		}
		else {
			return mapping.findForward(Constants.HOME);
		}
		
		request.setAttribute(Constants.REPORT, report);

		return mapping.findForward(Constants.SUCCESS);
	}
}
