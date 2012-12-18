package com.ibm.ea.bravo.bankaccount;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class ActionBankAccount extends ActionBase {
	private static final Logger logger = Logger
			.getLogger(ActionBankAccount.class);

	public ActionForward connected(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.connected");
		pHttpServletRequest.setAttribute("bankAccountSection", Constants.CONNECTED);

		// Select the List of BankAccount objects from the database
		pHttpServletRequest.setAttribute(Constants.LIST, DelegateBankAccount
				.selectConnectedBankAccountList());

		return pActionMapping.findForward(Constants.SUCCESS);
	}

	public ActionForward connectedAddEdit(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.connectedAddEdit");
		pHttpServletRequest.setAttribute("bankAccountSection", Constants.CONNECTED);

		return addEdit(pActionMapping, pActionForm, pHttpServletRequest,
				pHttpServletResponse, Constants.CONNECTED);
	}

	public ActionForward connectionStatus(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.connectionStatus");
		pHttpServletRequest.setAttribute("bankAccountSection", Constants.CONNECTED);

		// Get the id parameter
		String lsId = getParameter(pHttpServletRequest, Constants.ID);

		// Select the BankAccount object from the database
		pHttpServletRequest.setAttribute("bankAccount", DelegateBankAccount
				.selectBankAccountDetails(Long.valueOf(lsId)));

		return pActionMapping.findForward(Constants.SUCCESS);
	}

	public ActionForward disconnected(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.connected");
		pHttpServletRequest.setAttribute("bankAccountSection",
				Constants.DISCONNECTED);

		// Select the List of BankAccount objects from the database
		pHttpServletRequest.setAttribute(Constants.LIST, DelegateBankAccount
				.selectDisconnectedBankAccountList());

		return pActionMapping.findForward(Constants.SUCCESS);
	}

	public ActionForward disconnectedAddEdit(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.disconnectedAddEdit");
		pHttpServletRequest.setAttribute("bankAccountSection",
				Constants.DISCONNECTED);

		return addEdit(pActionMapping, pActionForm, pHttpServletRequest,
				pHttpServletResponse, Constants.DISCONNECTED);
	}

	public ActionForward home(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.home");
		pHttpServletRequest.setAttribute("bankAccountSection", "");

		return pActionMapping.findForward(Constants.SUCCESS);
	}

	public ActionForward save(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.save");

		FormBankAccount lFormBankAccount = (FormBankAccount) pActionForm;

		if (super.isCancelled(pHttpServletRequest)) {
			// Send them back to the appropriate bank account list page
			if (lFormBankAccount.getConnectionType().equalsIgnoreCase(
					Constants.CONNECTED)) {
				return pActionMapping.findForward("connected");
			} else {
				return pActionMapping.findForward("disconnected");
			}
		} else {
			ActionErrors lActionErrors = new ActionErrors();
	
			pHttpServletRequest.setAttribute("bankAccountSection",
					lFormBankAccount.getConnectionType().equalsIgnoreCase(
							Constants.CONNECTED) ? Constants.CONNECTED
							: Constants.DISCONNECTED);
	
			// Save the BankAccount object from the given form
			lActionErrors = DelegateBankAccount.saveBankAccount(lFormBankAccount,
					pHttpServletRequest.getRemoteUser());
	
			// If there are errors send them back to the form and display errors
			if (!lActionErrors.isEmpty()) {
				saveErrors(pHttpServletRequest, (ActionMessages) lActionErrors);
	
				return pActionMapping.findForward(Constants.ERROR);
			} else {
				// Send them back to the appropriate bank account list page
				if (lFormBankAccount.getConnectionType().equalsIgnoreCase(
						Constants.CONNECTED)) {
					return pActionMapping.findForward("connected");
				} else {
					return pActionMapping.findForward("disconnected");
				}
			}
		} 
	}

	public ActionForward updateConnectionType(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionBankAccount.updateConnectionType");

		Long llId = Long.valueOf(getParameter(pHttpServletRequest, Constants.ID));
		FormBankAccount lFormBankAccount = new FormBankAccount(llId);
		ActionErrors lActionErrors = lFormBankAccount.init();

		if (lActionErrors.isEmpty()) {
			String lsConnectionType = lFormBankAccount.getConnectionType()
					.equalsIgnoreCase(Constants.CONNECTED) ? Constants.DISCONNECTED
					: Constants.CONNECTED;

			pHttpServletRequest.setAttribute("bankAccountSection", lsConnectionType);
			lFormBankAccount.setConnectionType(lsConnectionType);
			pHttpServletRequest.setAttribute("bankAccountForm", lFormBankAccount);

			return pActionMapping.findForward(Constants.SUCCESS);
		} else {
			saveErrors(pHttpServletRequest, lActionErrors);

			return pActionMapping.findForward(Constants.ERROR);
		}
	}

	private ActionForward addEdit(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse, String psConnectionType)
			throws Exception {
		// Get the id parameter
		String lsId = getParameter(pHttpServletRequest, Constants.ID);
		FormBankAccount lFormBankAccount = null;
		ActionErrors lActionErrors = new ActionErrors();

		// If the id parameter exists, we are editing a connected or disconnected
		// bank account
		if (!EaUtils.isEmpty(lsId)) {
			lFormBankAccount = new FormBankAccount(Long.valueOf(lsId));
			lActionErrors = lFormBankAccount.init();
		} else {
			lFormBankAccount = new FormBankAccount(psConnectionType);
		}

		if (lActionErrors.isEmpty()) {
			pHttpServletRequest.setAttribute("bankAccountForm", lFormBankAccount);

			return pActionMapping.findForward(Constants.SUCCESS);
		} else {
			saveErrors(pHttpServletRequest, lActionErrors);

			return pActionMapping.findForward(Constants.ERROR);
		}
	}
}
