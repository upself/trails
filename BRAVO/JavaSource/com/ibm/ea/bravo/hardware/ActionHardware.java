package com.ibm.ea.bravo.hardware;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.contact.DelegateContact;
import com.ibm.ea.bravo.contact.HardwareContact;
import com.ibm.ea.bravo.contact.LparContact;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.utils.EaUtils;

public class ActionHardware extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(ActionHardware.class);
	
    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.home");

    	// get the id parameter
		String hardwareLparId = getParameter(request, Constants.LPAR_ID);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		
		// if the id parameter exists, we view the detail of one hardware lpar
		if (! EaUtils.isBlank(hardwareLparId)) {
			
			FormHardware hardware = new FormHardware(hardwareLparId, accountId);
			request.setAttribute(Constants.HARDWARE, hardware);
			ActionErrors errors = hardware.init(request);
			
			// if there are errors, return there
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}
			
	    	// get the account
	    	Account account = DelegateAccount.getAccount(hardware.getAccountId(), request);
	    	request.setAttribute(Constants.ACCOUNT, account);
	    	
			List<LparContact> contactlist = DelegateContact.getLparContacts(hardwareLparId);
			request.setAttribute(Constants.CONTACT_LIST, contactlist);
			
			// if the hardware lpar has a hardware, populate the hardware contact list 
	    	List<HardwareContact> contactHwList = null;
	    	if (hardware.getHardware() != null) {
				contactHwList = DelegateContact.getHardwareContacts(hardware.getHardware().getId().toString());
	    	}
			request.setAttribute(Constants.CONTACT_HW_LIST, contactHwList);

	    	request.setAttribute(Constants.COMMENT_LIST, null);

			return mapping.findForward(Constants.SUCCESS);
		}
		
    	return mapping.findForward(Constants.HOME);
    }
    	
    public ActionForward view(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.view");
        	
		// get the id parameter
		String hardwareLparId = getParameter(request, Constants.LPAR_ID);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		
		// if the id parameter exists, we view the detail of one hardware lpar
		if (! EaUtils.isBlank(hardwareLparId)) {
			
			FormHardware hardware = new FormHardware(hardwareLparId, accountId);
			request.setAttribute(Constants.HARDWARE, hardware);
			ActionErrors errors = hardware.init(request);
			
			// if there are errors, return there
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}
			
	    	// get the account
	    	Account account = DelegateAccount.getAccount(hardware.getAccountId(), request);
	    	request.setAttribute(Constants.ACCOUNT, account);
	    	
	    	// get the comment history
	    	request.setAttribute(Constants.COMMENT_LIST, null);

	    	return mapping.findForward(Constants.SUCCESS);
		}
		
    	return mapping.findForward(Constants.HOME);
    }
    
    public ActionForward asset(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.asset");
    	
    	ActionErrors errors = new ActionErrors();
    	
    	// get accountId parameter
    	String accountId = getParameter(request, Constants.ACCOUNT_ID);
		if (EaUtils.isBlank(accountId)) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
        	
		// get the lpar id parameter
		String lparId = getParameter(request, Constants.LPAR_ID);
		if (EaUtils.isBlank(lparId)) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// get account object
		Account account = DelegateAccount.getAccount(accountId, request);
		if (account == null) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// is this a hardware or software lpar?
		Hardware hardware = null;
		HardwareLpar hardwareLpar = DelegateHardware.getHardwareLpar(lparId);
		if (hardwareLpar != null) {
			// does account match?
			if (hardwareLpar.getCustomer().getCustomerId().longValue()
					== account.getCustomer().getCustomerId().longValue()) {
				hardware = hardwareLpar.getHardware();
				logger.debug("it was a hw lpar");
			}
		}
		SoftwareLpar softwareLpar = DelegateSoftware.getSoftwareLparByIdWithHardwareLparData(new Long(lparId).longValue());
		if (softwareLpar != null) {
			// does account match?
			if (softwareLpar.getCustomer().getCustomerId().longValue()
					== account.getCustomer().getCustomerId().longValue()) {
				hardware = softwareLpar.getHardwareLpar().getHardware();
				logger.debug("it was a sw lpar");
			}
		}
		if (hardware == null) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// get any scrt records for this hardware
		List<SCRTRecord> scrtRecords = DelegateHardware.getSCRTRecords(hardware);
		
		// populate request object
		request.setAttribute(Constants.ACCOUNT, account);
		request.setAttribute(Constants.HARDWARE, hardware);
		request.setAttribute(Constants.SCRT_RECORDS, scrtRecords);

    	return mapping.findForward(Constants.SUCCESS);
    }
    
    public ActionForward search(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.search");

    	return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward create(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.create");
    	ActionErrors errors = new ActionErrors();

    	// get the id parameter
		String hardwareLparId = getParameter(request, Constants.LPAR_ID);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		
		// if the account id parameter doesn't exist, return an error
		if (EaUtils.isBlank(accountId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// otherwise get the account
    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
    	
    	if (account == null) {
    		saveErrors(request, errors);
			return mapping.findForward(Constants.HOME);
    	}
		
		// initialize the form
		FormHardware hardware = new FormHardware(hardwareLparId, accountId);
		hardware.setLparName(lparName);
		request.setAttribute(Constants.HARDWARE, hardware);
		errors = hardware.init(request);
		
		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// initialize action specific form properties
		hardware.setAction(Constants.CRUD_CREATE);

    	return mapping.findForward(Constants.SUCCESS);
    }
    	
    public ActionForward update(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.update");
    	ActionErrors errors = new ActionErrors();
    	
		// get the id parameter
		String hardwareLparId = getParameter(request, Constants.LPAR_ID);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		
		// if the id parameter doesn't exist, return an error
		if (EaUtils.isBlank(hardwareLparId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// initialize the form
		FormHardware hardware = new FormHardware(hardwareLparId, accountId);
		request.setAttribute(Constants.HARDWARE, hardware);
		errors = hardware.init(request);
		
		// if there are errors, return there
		// TODO more here
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// get the account
    	Account account = DelegateAccount.getAccount(hardware.getAccountId(), request);
    	request.setAttribute(Constants.ACCOUNT, account);
    	
		// initialize action specific form properties
		hardware.getReadOnly().put(Constants.LPAR_NAME, Constants.TRUE);
		hardware.setAction(Constants.CRUD_UPDATE);

    	return mapping.findForward(Constants.SUCCESS);
    }
    	
    public ActionForward delete(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.delete");
    	ActionErrors errors = new ActionErrors();
    	
		// get the id parameter
		String hardwareLparId = getParameter(request, Constants.LPAR_ID);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		
		// if the id parameter doesn't exist, return an error
		if (EaUtils.isBlank(hardwareLparId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// initialize the form
		FormHardware hardware = new FormHardware(hardwareLparId, accountId);
		request.setAttribute(Constants.HARDWARE, hardware);
		errors = hardware.init(request);
		
		// if there are errors, return there
		// TODO more here
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// get the account
    	Account account = DelegateAccount.getAccount(hardware.getAccountId(), request);
    	request.setAttribute(Constants.ACCOUNT, account);
    	
		// initialize action specific form properties
		hardware.getReadOnly().put(Constants.LPAR_NAME, Constants.TRUE);
		hardware.setAction(Constants.CRUD_DELETE);

    	return mapping.findForward(Constants.SUCCESS);
    }
    	
    public ActionForward edit(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHardwareLpar.edit");
    	ActionErrors errors = new ActionErrors();
    	
    	// cast the form
    	FormHardware hardwareForm = (FormHardware) form;

    	// validate the form exists
    	if (form == null) {
    		return mapping.findForward(Constants.INVALID);
    	}
    	
    	// if the user canceled the edit, return them to a previous screen
		if (hardwareForm.getAction().equalsIgnoreCase(Constants.CANCEL)) {
    		
	    	// get the account
	    	Account account = DelegateAccount.getAccount(hardwareForm.getAccountId(), request);
	    	request.setAttribute(Constants.ACCOUNT, account);
    	
    		// if a hardware lpar id is in the form, return to the detail screen
    		if (!EaUtils.isBlank(hardwareForm.getId())) {
    			FormHardware hardware = new FormHardware(hardwareForm.getId(), hardwareForm.getAccountId());
    			request.setAttribute(Constants.HARDWARE, hardware);
    			hardware.init(request);
	    		
	    		return mapping.findForward(Constants.SUCCESS);
    		}
    		
    		// otherwise, return to the account detail
    		request.setAttribute(Constants.LPAR_ID, hardwareForm.getAccountId());

    		return mapping.findForward(Constants.ACCOUNT);
    	}
		
		// initialize the form
		FormHardware hardware = new FormHardware(hardwareForm.getId(), hardwareForm.getAccountId());
		request.setAttribute(Constants.HARDWARE, hardware);
		errors = hardware.init(hardwareForm, request);

		// TODO more here
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// validate the form
    	errors = hardware.validate(mapping, request);
    	
    	// get the account
    	Account account = DelegateAccount.getAccount(hardware.getAccountId(), request);
    	request.setAttribute(Constants.ACCOUNT, account);
    	
		// if there were errors, return them to the user
		if (!errors.isEmpty()) {
    		saveErrors(request, errors);
			request.setAttribute(Constants.HARDWARE, hardware);

    		// if we're updating, disable the hardware lpar name
    		if (hardware.getAction().equalsIgnoreCase(Constants.UPDATE))
    			hardware.getReadOnly().put(Constants.LPAR_NAME, Constants.TRUE);
    		
    		return mapping.findForward(Constants.ERROR);
    	}
		
		// no errors, save the changes to the database
		hardware.setRemoteUser(request.getRemoteUser());
		hardware = DelegateHardware.save(hardware, request);
		request.setAttribute(Constants.HARDWARE, hardware);
		
		// if the save was unsuccessful
		if (hardware == null) {
			hardware = new FormHardware(hardwareForm.getId(), hardwareForm.getAccountId());
			request.setAttribute(Constants.HARDWARE, hardware);
			errors = hardware.init(hardwareForm, request);
			
			errors.add(Constants.DB, new ActionMessage(Constants.UNKNOWN_DB_ERROR));
			saveErrors(request, errors);

			return mapping.findForward(Constants.ERROR);
		}
		
		// if the save was successful, initialize the rest of the form
		errors = hardware.init(request);
		
		// make sure we initialized okay
		if (! errors.isEmpty()) {
			errors.add(Constants.DB, new ActionMessage(Constants.UNKNOWN_DB_ERROR));
			saveErrors(request, errors);

			return mapping.findForward(Constants.ERROR);
		}
    	
    	return mapping.findForward(Constants.SUCCESS);
    }
    	
}
