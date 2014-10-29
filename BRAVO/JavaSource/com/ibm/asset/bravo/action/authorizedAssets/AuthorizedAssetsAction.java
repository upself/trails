package com.ibm.asset.bravo.action.authorizedAssets;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.asset.bravo.dao.AuthorizedInstalledProductDao;
import com.ibm.asset.bravo.dao.jpa.AuthorizedInstalledProductDaoJpa;
import com.ibm.asset.bravo.domain.InstalledProduct;
import com.ibm.ea.bravo.FormSearch;
import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.utils.EaUtils;

public class AuthorizedAssetsAction extends ActionBase {
	private static final Logger logger = Logger
			.getLogger(AuthorizedAssetsAction.class);

	public ActionForward searchLpars(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("AuthorizedAssetsAction.searchLpars");
		ActionErrors errors = new ActionErrors();
		// cast the form
		FormSearch searchForm = (FormSearch) form;

		// if the search form is null, create one with the parameter values
		if (searchForm == null || EaUtils.isBlank(searchForm.getContext())) {
			searchForm = new FormSearch();
			searchForm.setContext(getParameter(request, Constants.CONTEXT));
			searchForm.setSearch(getParameter(request, Constants.SEARCH));
		}

		String accountId = getParameter(request, Constants.ACCOUNT_ID);

		// validate the account id and search string
		// if we don't know the account context, we need to send the user home
		if (EaUtils.isBlank(accountId)) {
			return mapping.findForward(Constants.HOME);
		}

		// otherwise get the account
		Account account = DelegateAccount.getAccount(accountId, request);
		request.setAttribute(Constants.Is_APMM_ACCOUNT, DelegateAccount.isAPMMAccount(account.getCustomer().getCustomerName()));
		request.setAttribute(Constants.ACCOUNT, account);

		// validate the form
		errors = searchForm.validate(mapping, request);
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		List<HardwareLpar> hardwareLpars = DelegateHardware.searchHardwareLparsWithAuthorizedProductsByCustomer(
				searchForm.getSearch(), account);
		if (hardwareLpars.size() > 100) {
			errors
					.add(
							Constants.SEARCH,
							new ActionMessage(
									"The search results exceeded 100 records. Please search again and narrow your search."));
		}

		// if the result size is invalid, return an error
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			hardwareLpars.clear();
		}
		request.setAttribute("hardwareLpars", hardwareLpars);
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward viewInstalledSoftwares(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		logger.debug("AuthorizedAssetsAction.viewInstalledSoftwares");
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
			String hwLparId = getParameter(request, "hwLparId");
			if (!EaUtils.isBlank(hwLparId)) {
				logger.debug(hwLparId);
				List<? extends InstalledProduct> authorizedProducts = null;
				HardwareLpar hardwareLpar = DelegateHardware.getHardwareLpar(hwLparId);
				AuthorizedInstalledProductDao aipJpa = new AuthorizedInstalledProductDaoJpa();
				authorizedProducts = aipJpa.getAuthorizedProductByHwLpar(hardwareLpar);
				request.setAttribute("hardwareLpar", hardwareLpar);
				request.setAttribute("assets", authorizedProducts);
			}
		}
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward search(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("AuthorizedAssetsAction.search");

		// get the id parameter
		String accountId = getParameter(request, Constants.ACCOUNT_ID);

		// validate the account ID
		if (EaUtils.isBlank(accountId)) {
			return mapping.findForward(Constants.HOME);
		}

		// get the account
		Account account = DelegateAccount.getAccount(accountId, request);
		if (account == null) {
			return mapping.findForward(Constants.HOME);
		}
		request.setAttribute(Constants.Is_APMM_ACCOUNT, DelegateAccount.isAPMMAccount(account.getCustomer().getCustomerName()));
		request.setAttribute(Constants.ACCOUNT, account);

//		request.setAttribute("hardwareLpars", null);
		return mapping.findForward(Constants.SUCCESS);
	}

}
