package com.ibm.ea.bravo.systemstatus;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.sigbank.BankAccount;

public class ActionSystemStatus extends ActionBase {
	private static final Logger logger = Logger
			.getLogger(ActionSystemStatus.class);

	public ActionForward home(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {	
		
		//loads a list of BankAccounts for the Bank account combobox
		pHttpServletRequest.setAttribute(Constants.BANK_ACCOUNT_NAMES,
				DelegateSystemStatus.getBankAccountNames());
		
		return pActionMapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward submit_form(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		FormSubmit formSubmit = (FormSubmit) form;
		//gets a list of objects BankAccount to pass to a home.jsp systemStatusPage
		//to feed data into the Bank Account combobox options collection
		List<BankAccount> bankAccountNames = DelegateSystemStatus.getBankAccountNames();

		//loads a list of BankAccounts for the Bank account combobox
		request.setAttribute(Constants.BANK_ACCOUNT_NAMES, bankAccountNames);
		
		//creates a list of selected BankAccountJobs, based on user selection
		request.setAttribute(Constants.BANK_ACCOUNT_JOB_LIST,
				DelegateSystemStatus.getSelectedBankAccountJobs(formSubmit));
		
		//Select the List of SystemStatus objects from the database
		request.setAttribute(Constants.SYSTEM_SCHEDULE_STATUS_LIST,
				DelegateSystemStatus.selectSystemScheduleStatusList(formSubmit));

		
		//currently disabled option to call reset of the submit form, now, after submit chosen values will stay
		//in place - also in struts-config.xml "<!-- SYSTEM STATUS submit -->" scope="session"
		
//		formSubmit.reset(mapping, request);
		
		return mapping.findForward(Constants.SUCCESS);
	}
}
