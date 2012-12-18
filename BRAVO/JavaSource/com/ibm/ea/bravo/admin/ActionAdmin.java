package com.ibm.ea.bravo.admin;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.sigbank.BankAccount;
import com.ibm.ea.sigbank.BankAccountInclusion;

public class ActionAdmin extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(ActionAdmin.class);

    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("Admin.home");
    	
        return mapping.findForward(Constants.SUCCESS);
    }
    
    public ActionForward updateBank(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("Admin.updateBank");
		FormCustomerBank tff = (FormCustomerBank) form;
		if (tff == null) {
			logger.debug("Null form");
			return mapping.findForward(Constants.ERROR);
		}
		
		String[] selected = tff.getSelected();
		String[] selectedExcludes = tff.getSelectedIncludes();
		if ( selected != null ) {
			logger.debug("Creating Exceptions");
			List<String> listId = Arrays.asList(selected);
			Iterator<String> i = listId.iterator();
			while (i.hasNext()) {
				String id = (String) i.next();
				DelegateSoftware.saveAccountBankInclusion(request.getParameter("customerId"), id);
			}
		}
		if ( selectedExcludes != null ) {
			logger.debug("Removing Exceptions");
			List<String> listId = Arrays.asList(selectedExcludes);
			Iterator<String> i = listId.iterator();
			while (i.hasNext()) {
				String id = (String) i.next();
				DelegateSoftware.deleteAccountBankInclusion(request.getParameter("customerId"), id);					
			}
		}
    	tff.init();
    	tff = null;
        return mapping.findForward(Constants.SUCCESS);
    }
    
    public ActionForward bank(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
		List<BankAccount> customerBank = null;
		List<BankAccountInclusion> bankInclusion = null;
    	logger.debug("Admin.bank");
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		// get the account
		Account account = DelegateAccount.getAccount(accountId, request);
		request.setAttribute(Constants.ACCOUNT, account);
		customerBank = DelegateSoftware.getCustomerBank(account.getCustomer().getCustomerId().toString());
		bankInclusion = DelegateSoftware.getBankInclusion(account.getCustomer().getAccountNumberStr());
		request.setAttribute("customerBank", customerBank);
		request.setAttribute("bankInclude", bankInclusion);
		request.setAttribute("accountId", accountId);
		
        return mapping.findForward(Constants.SUCCESS);
    }
    
}
