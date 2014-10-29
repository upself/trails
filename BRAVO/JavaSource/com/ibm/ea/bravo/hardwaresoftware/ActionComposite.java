package com.ibm.ea.bravo.hardwaresoftware;

import java.util.ArrayList;
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
import com.ibm.ea.bravo.account.AccountStatistics;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.contact.AccountContact;
import com.ibm.ea.bravo.contact.DelegateContact;
import com.ibm.ea.bravo.contact.LparContact;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.properties.DelegateProperties;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.Hardware;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.InstalledSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.utils.EaUtils;

public class ActionComposite extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(ActionComposite.class);

	public ActionForward search(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionComposite.search");
		ActionErrors errors = new ActionErrors();

		// cast the form
		FormCompositeSearch searchForm = (FormCompositeSearch) form;

		// if the search form is null, create one with the parameter values
		if (searchForm == null || EaUtils.isBlank(searchForm.getContext())) {
			searchForm = new FormCompositeSearch();
			searchForm.setContext(getParameter(request, Constants.CONTEXT));
			searchForm
					.setAccountId(getParameter(request, Constants.ACCOUNT_ID));
			searchForm.setSearch(getParameter(request, Constants.SEARCH));
			searchForm.setStatus(getParameter(request, Constants.STATUS));
		}

		String accountId = searchForm.getAccountId();

		// validate the account id and search string
		// if we don't know the account context, we need to send the user home
		if (EaUtils.isBlank(accountId)) {
			return mapping.findForward(Constants.HOME);
		}

		// otherwise get the account
		Account account = DelegateAccount.getAccount(accountId, request);
		if (account == null) {
			return mapping.findForward(Constants.HOME);
		}
		request.setAttribute(Constants.ACCOUNT, account);
		request.setAttribute(Constants.Is_APMM_ACCOUNT, DelegateAccount
				.isAPMMAccount(account.getCustomer().getCustomerName()));

		// validate the form
		errors = searchForm.validate(mapping, request);
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// default the hardware status to ACTIVE if no status is provided
		// for convenience
		String hardwareStatus = searchForm.getStatus();
		hardwareStatus = EaUtils.isBlank(hardwareStatus) ? Constants.ACTIVE
				: hardwareStatus;

		// pull the list based on the hardwareStatus
		List<String> hwStatus = new ArrayList<String>();
		if (hardwareStatus.equalsIgnoreCase(Constants.ACTIVE)
				|| hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
			hwStatus.add("");
			hwStatus.add(Constants.ACTIVE);
		}
		if (hardwareStatus.equalsIgnoreCase(Constants.INACTIVE)
				|| hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
			hwStatus.add(Constants.INACTIVE);
		}
		if (hardwareStatus.equalsIgnoreCase(Constants.HWCOUNT)
				|| hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
			hwStatus.add(Constants.HWCOUNT);
		}
		if (hardwareStatus.equalsIgnoreCase(Constants.ONHOLD)
				|| hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
			hwStatus.add(Constants.ONHOLD);
		}
		if (hardwareStatus.equalsIgnoreCase(Constants.REMOVED)
				|| hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
			hwStatus.add(Constants.REMOVED);
		}

		List<String> status = new ArrayList<String>();
		status.add(Constants.ACTIVE);
		if (hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
			status.add(Constants.INACTIVE);
		}

		// Get all with a composite
		List<SoftwareLpar> composites = DelegateComposite.search(searchForm
				.getSearch(), account, hwStatus, status);

		// get hardware lpars with no composite
		List<HardwareLpar> hardwareLpars = DelegateHardware
				.searchLparNoComposite(searchForm.getSearch(), account,
						hwStatus, status);

		// get software lpars with no composite
		List<SoftwareLpar> softwareLpars = DelegateSoftware
				.searchLparNoComposite(searchForm.getSearch(), account, status);

		// get hardwares without hardware lpar
		// List hardwares = DelegateHardware.searchHardwareNoLpars(searchForm
		// .getSearch(), account, hwStatus, status);
		List<Hardware> hardwares = DelegateHardware
				.getHardwaresNoLparsByCustomerByStatusSerial(account
						.getCustomer(), hwStatus, searchForm.getSearch()
						.toUpperCase());

		if (hardwares.size() + composites.size() + hardwareLpars.size()
				+ softwareLpars.size() > 800) {
			errors
					.add(
							Constants.SEARCH,
							new ActionMessage(
									"The search results exceeded 800 records. Please search again and narrow your search."));
		}

		// if the result size is invalid, return an error
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			composites.clear();
			hardwareLpars.clear();
			softwareLpars.clear();
			hardwares.clear();
		}

		request.setAttribute("composites", composites);
		request.setAttribute("hardwareLpars", hardwareLpars);
		request.setAttribute("softwareLpars", softwareLpars);
		request.setAttribute("hardwares", hardwares);

		// get the statistics
		AccountStatistics accountStatistics = new AccountStatistics();

		// skip the statistics if you have "accountStatistics = false" in the
		// BRAVO properties file
		String statisticsFlag = DelegateProperties.getProperty(
				Constants.APP_PROPERTIES, Constants.ACCOUNT_STATISTICS);
		logger.debug("statisticsFlag = " + statisticsFlag);

		if (statisticsFlag == null
				|| statisticsFlag.equalsIgnoreCase(Constants.TRUE)) {
			accountStatistics = DelegateAccount.getStatistics(account);
		}

		request.setAttribute(Constants.ACCOUNT_STATISTICS, accountStatistics);

		// determine if a multi report exists
		account.setMultiReport(DelegateAccount.getMultiReport(account));

		// At this point I need to return the Contact Account List
		// for this I need customerId
		List<AccountContact> contactList = new ArrayList<AccountContact>();
		if (account.getCustomer() != null) {
			String cid = account.getCustomer().getCustomerId().toString();
			long custId = Long.parseLong(cid);
			contactList = DelegateContact.getAccountContacts(custId);
		}
		request.setAttribute(Constants.CONTACT_LIST, contactList);

		logger.debug("ActionComposite.search SUCCESS");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionComposite.view");

		Lpar lpar = new Lpar();
		request.setAttribute(Constants.LPAR, lpar);

		// get the account id parameter
		String accountId = getParameter(request, Constants.ACCOUNT_ID);

		// get the account
		Account account = DelegateAccount.getAccount(accountId, request);

		// if the account is null, its invalid
		if (account == null) {
			// TODO - invalid account
			return mapping.findForward(Constants.HOME);
		}
		request.setAttribute(Constants.ACCOUNT, account);
		request.setAttribute(Constants.Is_APMM_ACCOUNT, DelegateAccount
				.isAPMMAccount(account.getCustomer().getCustomerName()));

		String hwId = getParameter(request, "hwId");
		String swId = getParameter(request, "swId");
		HardwareLpar hardwareLpar = null;
		SoftwareLpar softwareLpar = null;

		if (!EaUtils.isBlank(hwId)) {
			// get the hardware lpar
			hardwareLpar = DelegateHardware.getHardwareLpar(hwId);
			lpar.setHardwareLpar(hardwareLpar);
			if (hardwareLpar != null) {
				lpar.setSoftwareLpar(hardwareLpar.getSoftwareLpar());
			}
		} else if (!EaUtils.isBlank(swId)) {
			// get the software lpar
			// softwareLpar = DelegateSoftware.getSoftwareLpar(lparName,
			// account);
			softwareLpar = DelegateSoftware
					.getSoftwareLparByIdWithHardwareLparData(new Long(swId));

			lpar.setSoftwareLpar(softwareLpar);
			if (softwareLpar != null) {
				lpar.setHardwareLpar(softwareLpar.getHardwareLpar());
			}
		}

		// if the hardware and software lpars are both null, return to the
		// account
		if (lpar.getHardwareLpar() == null && lpar.getSoftwareLpar() == null) {
			// TODO - invalid lpar
			return mapping.findForward(Constants.ERROR);
		}

		// initialize lpar
		lpar.init();

		// At this point I need to return the Contact Account List
		List<LparContact> contactlist = new ArrayList<LparContact>();
		if (lpar.getHardwareLpar() != null) {
			String cid = lpar.getHardwareLpar().getId().toString();
			long hwlparid = Long.parseLong(cid);
			contactlist = DelegateContact.getLparContacts(hwlparid);
		}
		request.setAttribute(Constants.CONTACT_LIST, contactlist);

		// get the software if a software lpar exists
		List<InstalledSoftware> softwarelist = new ArrayList<InstalledSoftware>();
		if (lpar.getSoftwareLpar() != null
				&& lpar.getSoftwareLpar().getStatus().equalsIgnoreCase(
						Constants.ACTIVE)) {
			softwarelist = DelegateSoftware.getInstalledSoftwares(lpar
					.getSoftwareLpar());
		}
		request.setAttribute(Constants.LIST, softwarelist);

		return mapping.findForward(Constants.SUCCESS);
	}
}
