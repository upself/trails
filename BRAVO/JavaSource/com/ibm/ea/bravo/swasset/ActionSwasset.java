package com.ibm.ea.bravo.swasset;

import java.util.Arrays;
import java.util.Iterator;
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
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class ActionSwasset extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(ActionSwasset.class);

	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSwasset.view");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		logger.debug(accountId);

		// if the id parameter exists, we view the detail of one account
		if (!EaUtils.isBlank(accountId)) {
			// setup the account
			Account account = DelegateAccount.getAccount(accountId, request);

			if (account == null) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.HOME);
			}
			request.setAttribute(Constants.ACCOUNT, account);
			
			errors = validateUser(request);
			if (!errors.isEmpty()) {
				return mapping.findForward(Constants.ERROR);
			}
			
			// Get all software lpars
			Integer count = DelegateSwasset.getSwassetDataSize(account);
			if (count > Constants.MAX_SWASSET_SEARCH_RESULT_SIZE) {
				logger.debug("Result set greater than 25");
				errors.add(Constants.SEARCH, new ActionMessage(
						Constants.SEARCH_SWASSET_TOO_LARGE));
			}

			List<Swasset> softwarelpars = null;

			// if the result size is invalid, return an error
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
			} else {
				softwarelpars = DelegateSwasset.getSwassetData(account);
			}

			request.setAttribute("lpars", softwarelpars);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward search(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSwasset.search");
		ActionErrors errors = new ActionErrors();
		List<Swasset> softwarelpars = null;
		
		// cast the form
		FormSwasset searchForm = (FormSwasset) form;

		// if the search form is null, create one with the parameter values
		if (searchForm == null || EaUtils.isBlank(searchForm.getContext())) {
			searchForm = new FormSwasset();
			searchForm.setContext(getParameter(request, Constants.CONTEXT));
			searchForm
					.setAccountId(getParameter(request, Constants.ACCOUNT_ID));
			searchForm.setSearch(getParameter(request, Constants.SEARCH));
		}

		searchForm.setType("swLpar");
		String accountId = searchForm.getAccountId();

		// validate the account id and search string
		// if we don't know the account context, we need to send the user home
		if (EaUtils.isBlank(accountId)) {
			return mapping.findForward(Constants.HOME);
		}

		// otherwise get the account
		Account account = DelegateAccount.getAccount(accountId, request);

		if (account == null) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.HOME);
		}
		request.setAttribute(Constants.ACCOUNT, account);
		
		errors = validateUser(request);
		if (!errors.isEmpty()) {
			return mapping.findForward(Constants.ERROR);
		}

		// validate the form
		errors = searchForm.validate(mapping, request);
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
//			return mapping.findForward(Constants.ERROR);
		}
		else 
		{
			// Get all software lpars
			Integer count = DelegateSwasset.getSwassetDataSize(account, searchForm.getSearch());
			if (count > Constants.MAX_SWASSET_SEARCH_RESULT_SIZE) {
				logger.debug("Result set greater than 25");
				errors.add(Constants.SEARCH, new ActionMessage(
						Constants.SEARCH_SWASSET_TOO_LARGE));
			}
	
			// if the result size is invalid, return an error
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
			} else {
				softwarelpars = DelegateSwasset.getSwassetData(account, searchForm.getSearch());
			}
		}
		request.setAttribute(Constants.SEARCH, searchForm.getSearch());
		request.setAttribute("lpars", softwarelpars);

		logger.debug("ActionSwasset.search SUCCESS");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSwasset.delete");
		String lsForward = Constants.SUCCESS;

		ActionErrors errors = new ActionErrors();

		// cast the form
		FormSwasset swassetForm = (FormSwasset) form;

		// if the search form is null, create one with the parameter values
		if (swassetForm == null || EaUtils.isBlank(swassetForm.getContext())) {
			swassetForm = new FormSwasset();
			swassetForm.setContext(getParameter(request, Constants.CONTEXT));
			swassetForm
					.setAccountId(getParameter(request, Constants.ACCOUNT_ID));
			swassetForm.setSearch(getParameter(request, Constants.SEARCH));
		}

		String accountId = swassetForm.getAccountId();

		// validate the account id
		// if we don't know the account context, we need to send the user home
		if (EaUtils.isBlank(accountId)) {
			return mapping.findForward(Constants.HOME);
		}

		// otherwise get the account
		Account account = DelegateAccount.getAccount(accountId, request);

		if (account == null) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.HOME);
		}
		request.setAttribute(Constants.ACCOUNT, account);

		errors = validateUser(request);
		if (!errors.isEmpty()) {
			return mapping.findForward(Constants.ERROR);
		}
		
		String[] selected = swassetForm.getSelected();
		if (selected == null || selected.length == 0) {
			lsForward = Constants.ERROR;
			errors.add(Constants.STATUS, 
					new ActionMessage(Constants.SELECT_FOR_LPAR_DELETION));
			saveErrors(request, errors);
			swassetForm.reset(mapping, request);
			return mapping.findForward(lsForward);
		}

//		 process the list of checkboxes
		List<String> list = Arrays.asList(selected);
		Iterator<String> i = list.iterator();
		while (i.hasNext()) {
			String idName = (String) i.next();
			if (EaUtils.isBlank(idName))
				continue;
			logger.debug("Selected id and name: "+idName);
			
			String[] lpars = idName.split(",");
			Long swLparId = Long.parseLong(lpars[0]);
			SwassetQueue queue = DelegateSwasset.getSwassetQueue(swLparId, lpars[2]);
			if(queue == null)
			{
				queue = new SwassetQueue();
				queue.getCustomer().setCustomerId(account.getCustomer().getCustomerId());
				queue.setSoftwareLparId(swLparId);
				queue.setHostName(lpars[1]);
				queue.setType(lpars[2]);
				queue.setRemoteUser(request.getRemoteUser());
				queue.setDeleted(0);
				queue.setComments(null);
			}
			else if(queue.getDeleted() == 1){
				queue.setDeleted(0);
				queue.setComments(null);
			}
			
			logger.debug("swLparId: "+queue.getSoftwareLparId());
			logger.debug("hostName: "+queue.getHostName());
			logger.debug("scanType: "+queue.getType());
			
			DelegateSwasset.saveSwassetQueue(queue);
		}
		errors.add(Constants.STATUS, 
				new ActionMessage(Constants.SUBMITTED_FOR_DELETION));
		saveErrors(request, errors);
		// Retrieve the data again
		
		List<Swasset> softwarelpars = DelegateSwasset.getSwassetData(account, swassetForm.getSearch());
		
		request.setAttribute("lpars", softwarelpars);
		
		return mapping.findForward(lsForward);
	}

	private ActionErrors validateUser(HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();
		if (!request.isUserInRole(Constants.SCAN_TEAM_GROUP)) {
			errors.add(Constants.STATUS, 
					new ActionMessage(Constants.SWASSET_NOT_AUTHORIZED));
			saveErrors(request, errors);
		}
		return errors;
	}
}
