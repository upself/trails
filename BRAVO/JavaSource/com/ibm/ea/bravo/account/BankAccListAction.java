package com.ibm.ea.bravo.account;

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

public class BankAccListAction extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(BankAccListAction.class);
 
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
		
		if ((request.isUserInRole(Constants.ASSET_ADMIN_GROUP))
				|| (request.isUserInRole(Constants.EA_ADMIN_GROUP))
				|| (request.isUserInRole(Constants.TOOL_ADMIN_GROUP))
				|| (request.isUserInRole(Constants.TAP_ADMIN_GROUP))) {
			return mapping.findForward(Constants.ADMIN);
		} else {
        return mapping.findForward(Constants.SUCCESS);
		}
    }
    
}
