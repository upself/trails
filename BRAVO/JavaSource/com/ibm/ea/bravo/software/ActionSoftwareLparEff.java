package com.ibm.ea.bravo.software;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class ActionSoftwareLparEff extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(ActionSoftwareLparEff.class);

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
		logger.debug("ActionSoftwareLparEff.create");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String softwareLparId = getParameter(request, Constants.LPAR_ID);

		// if the lpar id parameter doesn't exist, return an error
		if (EaUtils.isBlank(softwareLparId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// get the software lpar with history of changes to effective
		SoftwareLpar softwareLpar = DelegateSoftware.getSoftwareLparWithHistory(softwareLparId);
		
		// make sure softwareLpar isn't null
		if(softwareLpar == null) {
			errors.add(Constants.SOFTWARE_LPAR, new ActionMessage(
					Constants.INVALID));
		}
		
		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// make sure that effective doesn't exist
		if(softwareLpar.getSoftwareLparEff() != null) {
			errors.add(Constants.SOFTWARE_LPAR_EFF, new ActionMessage(
					Constants.SOFTWARE_LPAR_EFF_EXISTS));
		}
		
		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		FormSoftwareLparEff softwareLparEffForm = new FormSoftwareLparEff(softwareLpar);
		softwareLparEffForm.setAction(Constants.CRUD_CREATE);
		errors = softwareLparEffForm.init(request);
		
		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		request.setAttribute(Constants.SOFTWARE_LPAR_EFF, softwareLparEffForm);		
		request.setAttribute(Constants.ACCOUNT,softwareLpar.getCustomer());
		request.setAttribute(Constants.LIST,null);
		
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLparEff.update");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String softwareLparId = getParameter(request, Constants.LPAR_ID);
		String id = getParameter(request, Constants.ID);

		// if the lpar id parameter doesn't exist, return an error
		if (EaUtils.isBlank(softwareLparId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// if the id parameter doesn't exist, return an error
		if (EaUtils.isBlank(id)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// get the software lpar with history of changes to effective
		SoftwareLpar softwareLpar = DelegateSoftware.getSoftwareLparWithHistory(softwareLparId);
		
		// make sure softwareLpar isn't null
		if(softwareLpar == null) {
			errors.add(Constants.SOFTWARE_LPAR, new ActionMessage(
					Constants.INVALID));
		}
		
		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		// make sure that effective doesn't exist
		if(softwareLpar.getSoftwareLparEff() == null) {
			errors.add(Constants.SOFTWARE_LPAR_EFF, new ActionMessage(
					Constants.SOFTWARE_LPAR_EFF_EXISTS));
		}
		
		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		FormSoftwareLparEff softwareLparEffForm = new FormSoftwareLparEff(softwareLpar);
		softwareLparEffForm.setAction(Constants.CRUD_UPDATE);
		errors = softwareLparEffForm.init(request);
		
		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		request.setAttribute(Constants.SOFTWARE_LPAR_EFF, softwareLparEffForm);
		request.setAttribute(Constants.ACCOUNT,softwareLpar.getCustomer());
		request.setAttribute(Constants.LIST,softwareLpar.getSoftwareLparEff().getSoftwareLparEffHs());

		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLparEff.delete");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftwareLparEff.edit");
		ActionErrors errors = new ActionErrors();

		// cast the form
		FormSoftwareLparEff softwareLparEffForm = (FormSoftwareLparEff) form;

		// validate the form exists
		if (form == null) {
			return mapping.findForward(Constants.INVALID);
		}
		
		// if the user canceled the edit, return them to a previous screen
		if (softwareLparEffForm.getAction().equalsIgnoreCase(Constants.CANCEL)) {

			// if a software lpar id is in the form, return to the detail screen
			if (!EaUtils.isBlank(softwareLparEffForm.getLparId())) {
				request.setAttribute(Constants.LPAR_ID, softwareLparEffForm
						.getLparId());
				return mapping.findForward(Constants.SUCCESS);
			}

			// otherwise, return to the account detail
			request.setAttribute(Constants.LPAR_ID, softwareLparEffForm
					.getAccountId());
			
			return mapping.findForward(Constants.ACCOUNT);
		}
		
		errors = softwareLparEffForm.validate(mapping, request);
		
		// if there were errors, return them to the user
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
		DelegateSoftware.saveSoftwareLparEffForm(softwareLparEffForm,request);

		return mapping.findForward(Constants.SUCCESS);
	}

}
