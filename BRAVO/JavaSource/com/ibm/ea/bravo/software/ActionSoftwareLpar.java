package com.ibm.ea.bravo.software;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;

public class ActionSoftwareLpar extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(ActionSoftwareLpar.class);

	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLpar.home");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLpar.view");

		//		// get the id parameter
		//		String hardwareLparId = getParameter(request, Constants.LPAR_ID);
		//		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		//		
		//		// if the id parameter exists, we view the detail of one hardware
		// lpar
		//		if (! EaUtils.isBlank(hardwareLparId)) {
		//			
		//			FormHardware hardware = new FormHardware(hardwareLparId, accountId);
		//			request.setAttribute(Constants.HARDWARE, hardware);
		//			ActionErrors errors = hardware.init();
		//			
		//			// if there are errors, return there
		//			if (!errors.isEmpty()) {
		//				saveErrors(request, errors);
		//				return mapping.findForward(Constants.ERROR);
		//			}
		//			
		//	    	// get the account
		//	    	Account account =
		// DelegateAccount.getAccount(hardware.getAccountId());
		//	    	request.setAttribute(Constants.ACCOUNT, account);
		//	    	
		//			return mapping.findForward(Constants.SUCCESS);
		//		}
		//		
		//		// populate the list
		//// List list = DelegateMachineType.search("all", "");
		//// request.setAttribute(Constants.LIST, list);
		//		
		//// return mapping.findForward(Constants.LIST);
		return mapping.findForward(Constants.HOME);
	}

	public ActionForward search(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLpar.search");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward create(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLpar.create");
		//    	ActionErrors errors = new ActionErrors();
		//
		//    	// get the id parameter
		//		String hardwareLparId = getParameter(request, Constants.LPAR_ID);
		//		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		//		String lparName = getParameter(request, Constants.LPAR_NAME);
		//		
		//		// if the account id parameter doesn't exist, return an error
		//		if (EaUtils.isBlank(accountId)) {
		//			// TODO fill this out more
		//			saveErrors(request, errors);
		//			return mapping.findForward(Constants.ERROR);
		//		}
		//		
		//    	// otherwise get the account
		//    	Account account = DelegateAccount.getAccount(accountId);
		//    	request.setAttribute(Constants.ACCOUNT, account);
		//    	
		//    	if (account == null) {
		//    		saveErrors(request, errors);
		//			return mapping.findForward(Constants.HOME);
		//    	}
		//		
		//		// initialize the form
		//		FormHardware hardware = new FormHardware(hardwareLparId, accountId);
		//		hardware.setLparName(lparName);
		//		request.setAttribute(Constants.HARDWARE, hardware);
		//		errors = hardware.init();
		//		
		//		// if there are errors, return there
		//		if (!errors.isEmpty()) {
		//			saveErrors(request, errors);
		//			return mapping.findForward(Constants.ERROR);
		//		}
		//		
		//		// initialize action specific form properties
		//		hardware.setDiscrepancyType(DelegateDiscrepancy.getDiscrepancyType(Constants.DISCREPANCY_TYPE_ID_MISSING));
		//		hardware.setDiscrepancyTypeId(hardware.getDiscrepancyType().getId().toString());
		//		hardware.getReadOnly().put(Constants.DISCREPANCY_TYPE,
		// Constants.TRUE);
		//		hardware.setAction(Constants.CRUD_CREATE);
		//
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLpar.update");
		/*
		 * // get the id parameter String softwareLparId = getParameter(request,
		 * Constants.LPAR_ID); String accountId = getParameter(request,
		 * Constants.ACCOUNT_ID);
		 *  // if the id parameter doesn't exist, return an error if
		 * (EaUtils.isBlank(softwareLparId)) { // TODO fill this out more
		 * saveErrors(request, errors); return
		 * mapping.findForward(Constants.ERROR); }
		 *  // initialize the form FormHardware hardware = new
		 * FormHardware(hardwareLparId, accountId);
		 * request.setAttribute(Constants.HARDWARE, hardware); errors =
		 * hardware.init(request);
		 *  // if there are errors, return there // TODO more here if
		 * (!errors.isEmpty()) { saveErrors(request, errors); return
		 * mapping.findForward(Constants.ERROR); }
		 *  // get the account Account account =
		 * DelegateAccount.getAccount(hardware.getAccountId(), request);
		 * request.setAttribute(Constants.ACCOUNT, account);
		 *  // initialize action specific form properties
		 * hardware.getReadOnly().put(Constants.LPAR_NAME, Constants.TRUE);
		 * hardware.setAction(Constants.CRUD_UPDATE);
		 */
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLpar.delete");
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLpar.edit");
		return mapping.findForward(Constants.SUCCESS);
	}

}
