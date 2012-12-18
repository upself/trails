package com.ibm.ea.bravo.systemstatus;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;

public class ActionSystemStatus extends ActionBase {
	private static final Logger logger = Logger
			.getLogger(ActionSystemStatus.class);

	public ActionForward home(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionSystemStatus.home");

		// Select the List of SystemStatus objects from the database
		pHttpServletRequest.setAttribute(Constants.SYSTEM_SCHEDULE_STATUS_LIST,
				DelegateSystemStatus.selectSystemScheduleStatusList());

		// Select the List of BankAccountJob objects from the database
		pHttpServletRequest.setAttribute(Constants.BANK_ACCOUNT_JOB_LIST,
				DelegateSystemStatus.selectBankAccountJobList());

		return pActionMapping.findForward(Constants.SUCCESS);
	}
}
