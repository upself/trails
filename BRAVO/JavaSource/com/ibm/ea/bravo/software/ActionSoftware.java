package com.ibm.ea.bravo.software;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

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
import com.ibm.ea.bravo.discrepancy.DelegateDiscrepancy;
import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.hardware.FormHardware;
import com.ibm.ea.sigbank.BankAccount;
//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End
import com.ibm.ea.utils.EaUtils;

public class ActionSoftware extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(ActionSoftware.class);

	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.home");

		// get the id parameter
		String lparId = getParameter(request, Constants.LPAR_ID);

		// if the id parameter exists, we view the detail of one software lpar
		if (!EaUtils.isBlank(lparId)) {
			FormSoftware software = new FormSoftware(lparId);
			software.setLparId(lparId);
			request.setAttribute(Constants.SOFTWARE, software);
			ActionErrors errors = software.init();

			/*// Hide the tables if there is no data
			SoftwareLpar sl = software.getSoftwareLpar();
			if ((!EaUtils.isEmpty(sl.getOsName())) || 
				(!EaUtils.isEmpty(sl.getOsType())) ||
				(sl.getOsMajorVersion() != null) ||
				(sl.getOsMinorVersion() != null) ||
				(!EaUtils.isEmpty(sl.getOsInstallDate())) ||
				(!EaUtils.isEmpty(sl.getOsSubVersion()))) {
				request.setAttribute(Constants.DISPLAY_OS, true);
			}
			
			if ((!EaUtils.isEmpty(sl.getBiosManufacturer())) || 
				(!EaUtils.isEmpty(sl.getBiosModel())) ||
				(sl.getBiosDate() != null) ||
				(!EaUtils.isEmpty(sl.getBiosUniqueId())) ||
				(!EaUtils.isEmpty(sl.getBiosSerialNumber()))) {
				request.setAttribute(Constants.DISPLAY_BIOS, true);
			}

			if ((!EaUtils.isEmpty(sl.getServerType())) ||
				(sl.getDisk() != null) ||
				(!EaUtils.isEmpty(sl.getBoardSerial())) ||
				(!EaUtils.isEmpty(sl.getCaseAssetTag())) ||
				(!EaUtils.isEmpty(sl.getCaseSerial()))) {
				request.setAttribute(Constants.DISPLAY_MISC, true);
			}

			if ((sl.getDedicatedProcessors() != null) ||
				(sl.getTotalProcessors() != null) ||
				(sl.getSharedProcessors() != null) ||
				(sl.getProcessorType() != null) ||
				(sl.getSharedProcByCores() != null) ||
				(sl.getDedicatedProcByCores() != null) ||
				(sl.getTotalProcByCores() != null)) {
				request.setAttribute(Constants.DISPLAY_PROCESSORS, true);
			}

			if ((sl.getMemory() != null) ||
				(sl.getPhysicalTotalKB() != null) ||
				(sl.getVirtualMemory() != null) ||
				(sl.getPhysicalFreeMemory() != null) ||
				(sl.getVirtualFreeMemory() != null) ||
				(sl.getNodeCapacity() != null) ||
				(sl.getLparCapacity() != null)) {
				request.setAttribute(Constants.DISPLAY_MEMORY, true);
			}*/
			
			// if there are errors, return there
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}

			// get the account
			Account account = DelegateAccount.getAccount(software
					.getAccountId(), request);
			request.setAttribute(Constants.ACCOUNT, account);

			// get the software
			List<InstalledSoftware> list = null;
			if (software.getSoftwareLpar().getStatus().equalsIgnoreCase(
					Constants.ACTIVE)) {
				list = DelegateSoftware.getInstalledSoftwares(software
						.getSoftwareLpar());
			}
			request.setAttribute(Constants.LIST, list);
			
			// get the ip address
//			List ipAddress = DelegateSoftware.getSoftwareLparIPAddress(software.getSoftwareLpar());
//			request.setAttribute(Constants.SOFTWARE_LPAR_IP_ADDRESS, ipAddress);

			/*// get the hdisk
			List hdisk = DelegateSoftware.getSoftwareLparHDisk(software.getSoftwareLpar());
			request.setAttribute(Constants.SOFTWARE_LPAR_HDISK, hdisk);

			// get the memory module
			List memMod = DelegateSoftware.getSoftwareLparMemMod(software.getSoftwareLpar());
			request.setAttribute(Constants.SOFTWARE_LPAR_MEM_MOD, memMod);

			// get the ADC data
			List adc = DelegateSoftware.getSoftwareLparADC(software.getSoftwareLpar());
			request.setAttribute(Constants.SOFTWARE_LPAR_ADC, adc);

			// get the processor data
			List processor = DelegateSoftware.getSoftwareLparProcessor(software.getSoftwareLpar());
			request.setAttribute(Constants.SOFTWARE_LPAR_PROCESSOR, processor);*/

			// get the software statistics
			SoftwareStatistics softwareStatistics = DelegateSoftware
					.getSoftwareStatistics(software.getSoftwareLpar());
			request.setAttribute(Constants.SOFTWARE_STATISTICS,
					softwareStatistics);
			logger.debug("softwareStatistics = " + softwareStatistics);

			List<BankAccount> bankAccounts = DelegateSoftware
					.getSoftwareBankAccounts(software.getSoftwareLpar());
			request.setAttribute(Constants.BANK_ACCOUNT_LIST, bankAccounts);
			
			// Show the delete button only for the users in scan team bluegroup.
			if (request.isUserInRole(Constants.SCAN_TEAM_GROUP) || request.isUserInRole(Constants.SCAN_TEAM_SUBGROUP)) {
				request.setAttribute("showDelete", "TRUE");
			}

			return mapping.findForward(Constants.SUCCESS);
		}

		return mapping.findForward(Constants.HOME);
	}

	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.view");

		// get the id parameter
		String softwareId = getParameter(request, Constants.ID);
		String lparId = getParameter(request, Constants.LPAR_ID);

		// if the id parameter exists, we view the detail of one software lpar
		if (!EaUtils.isBlank(softwareId)) {
			FormSoftware software = new FormSoftware(softwareId, lparId);
			request.setAttribute(Constants.SOFTWARE, software);
			ActionErrors errors = software.init();

			// if there are errors, return there
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}

			// get the account
			Account account = DelegateAccount.getAccount(software
					.getAccountId(), request);
			request.setAttribute(Constants.ACCOUNT, account);

			// get the signatures
			List<InstalledSignature> signatureList = DelegateSoftware.getSignatures(softwareId);
			request.setAttribute(Constants.SIGNATURE_LIST, signatureList);

			// get the filters
			List<InstalledFilter> filterList = DelegateSoftware.getFilters(softwareId);
			request.setAttribute(Constants.FILTER_LIST, filterList);

			// get the soft audit products
			List<InstalledSaProduct> softAuditList = DelegateSoftware.getSoftAudits(softwareId);
			request.setAttribute(Constants.SOFT_AUDIT_LIST, softAuditList);

			// get the vm products
			List<InstalledVmProduct> vmList = DelegateSoftware.getVmProducts(softwareId);
			request.setAttribute(Constants.VM_LIST, vmList);
			
			// get the tadz products
			List<InstalledTadz> tadzList = DelegateSoftware.getTadzProducts(softwareId);
			request.setAttribute(Constants.TADZ_LIST, tadzList);

			// get the comment history
			List<SoftwareDiscrepancyH> commentList = DelegateSoftware.getCommentHistory(softwareId);
			request.setAttribute(Constants.COMMENT_LIST, commentList);

			// get the Dorana products
//			List<InstalledDoranaProduct> doranaList = DelegateSoftware.getDoranas(softwareId);
//			request.setAttribute(Constants.DORANA_LIST, doranaList);

			return mapping.findForward(Constants.SUCCESS);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward search(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.search");

		ActionErrors errors = new ActionErrors();

		// cast the form
		FormSoftwareSearch searchForm = (FormSoftwareSearch) form;

		String lparId = searchForm.getLparId();
		String lparName = searchForm.getLparName();
		String accountId = searchForm.getAccountId();

		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// validate: software lpar id, or account id + software name
		if (EaUtils.isBlank(lparId)) {
			if (EaUtils.isBlank(accountId) || EaUtils.isBlank(accountId)) {
				// TODO search required fields
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}
		}

		FormSoftware software = new FormSoftware();
		request.setAttribute(Constants.SOFTWARE, software);
		software.setAccountId(accountId);
		software.setLparId(lparId);
		software.setSoftwareName(lparName);
		errors = software.init();

		// otherwise get the lpar
		Account account = DelegateAccount.getAccount(accountId, request);
		request.setAttribute(Constants.ACCOUNT, account);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward create(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.create");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String id = getParameter(request, Constants.ID);
		String softwareId = getParameter(request, Constants.SOFTWARE_ID);
		String lparId = getParameter(request, Constants.LPAR_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);
		logger.debug("Donnie softwareId " + softwareId + " id " + id);

		// if this software product already exists as an installed_software,
		// send the user to update discrepancy
		InstalledSoftware installedSoftware = DelegateSoftware
				.getInstalledSoftware(softwareId, lparId);
		if (installedSoftware != null) {
			request.setAttribute(Constants.ID, installedSoftware.getId()
					.toString());
			return mapping.findForward("update");
		}

		// initialize the form
		FormSoftware software = new FormSoftware();
		software.setSoftwareId(softwareId);
		software.setLparId(lparId);
		software.setAccountId(accountId);
		software.setId(id);
		software.setLparName(lparName);
		request.setAttribute(Constants.SOFTWARE, software);

		// validate the form
		errors = software.init();
		if (EaUtils.isBlank(accountId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// get the account
		Account account = DelegateAccount.getAccount(accountId, request);
		request.setAttribute(Constants.ACCOUNT, account);

		// initialize action specific form properties
		/* Donnie changed this to the other method of setting discrepancy
		software.setDiscrepancyType(DelegateDiscrepancy
				.getDiscrepancyType(Constants.DISCREPANCY_TYPE_ID_MISSING));
		*/
		software.setDiscrepancyType(DelegateDiscrepancy
		.getDiscrepancyType(new String("" + DelegateDiscrepancy.MISSING)));

		software.setDiscrepancyTypeId(software.getDiscrepancyType().getId()
				.toString());
		software.getReadOnly().put(Constants.DISCREPANCY_TYPE, Constants.TRUE);
		software.getReadOnly().put(Constants.INVALID_CATEGORY, Constants.TRUE);
		software.setAction(Constants.CRUD_CREATE);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward selectInit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.selectInit");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String lparId = getParameter(request, Constants.LPAR_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);

		if (EaUtils.isBlank(accountId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// get the account
		Account account = DelegateAccount.getAccount(accountId, request);
		request.setAttribute(Constants.ACCOUNT, account);

		request.setAttribute(Constants.LPAR_ID, lparId);
		request.setAttribute(Constants.LPAR_NAME, lparName);
		request.setAttribute(Constants.ACCOUNT_ID, accountId);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward select(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.select");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String lparId = getParameter(request, Constants.LPAR_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		String accountId = getParameter(request, Constants.ACCOUNT_ID);

		if (EaUtils.isBlank(accountId)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// get the account
		Account account = DelegateAccount.getAccount(accountId, request);
		request.setAttribute(Constants.ACCOUNT, account);

		request.setAttribute(Constants.LPAR_ID, lparId);
		request.setAttribute(Constants.LPAR_NAME, lparName);
		request.setAttribute(Constants.ACCOUNT_ID, accountId);

		FormSoftwareSearch searchForm = (FormSoftwareSearch) form;

		if (searchForm != null) {
			errors = searchForm.validate(mapping, request);

			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.SUCCESS);
			}
		}

		Long size = DelegateSoftware.searchSigBankCount(searchForm.getSearch());

		if (size == null) {
			errors.add(Constants.SEARCH, new ActionMessage(
					Constants.UNKNOWN_ERROR));
			saveErrors(request, errors);
			return mapping.findForward(Constants.SUCCESS);
		}

		if (size.intValue() > Constants.MAX_SEARCH_RESULT_SIZE) {
			errors.add(Constants.SEARCH, new ActionMessage(
					Constants.SEARCH_TOO_LARGE));
			saveErrors(request, errors);
			return mapping.findForward(Constants.SUCCESS);
		}

		//Change Bravo to use Software View instead of Product Object Start
		//List<Product> list = DelegateSoftware.searchSoftware(searchForm.getSearch());
		List<Software> list = DelegateSoftware.searchSoftware(searchForm.getSearch());
		//Change Bravo to use Software View instead of Product Object Start
		request.setAttribute(Constants.LIST, list);
		
		logger.debug("Getting ready to return list");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.update");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String id = getParameter(request, Constants.ID);
		String lparId = getParameter(request, Constants.LPAR_ID);

		// if the id parameter doesn't exist, return an error
		if (EaUtils.isBlank(id)) {
			// TODO fill this out more
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// initialize the form
		FormSoftware software = new FormSoftware(id, lparId);
		request.setAttribute(Constants.SOFTWARE, software);
		errors = software.init();

		// if there are errors, return there
		// TODO more here
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// get the account
		Account account = DelegateAccount.getAccount(software.getAccountId(),
				request);
		request.setAttribute(Constants.ACCOUNT, account);

		// initialize action specific form properties
		software.setAction(Constants.CRUD_UPDATE);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.delete");
		ActionErrors errors = new ActionErrors();

		// get the id parameter
		String hardwareLparId = getParameter(request, Constants.ID);
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
		Account account = DelegateAccount.getAccount(hardware.getAccountId(),
				request);
		request.setAttribute(Constants.ACCOUNT, account);

		// initialize action specific form properties
		hardware.getReadOnly().put(Constants.LPAR_NAME, Constants.TRUE);
		hardware.setAction(Constants.CRUD_DELETE);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.edit");
		ActionErrors errors = new ActionErrors();

		// cast the form
		FormSoftware softwareForm = (FormSoftware) form;

		// validate the form exists
		if (form == null) {
			return mapping.findForward(Constants.INVALID);
		}

		// if the user canceled the edit, return them to a previous screen
		if (softwareForm.getAction().equalsIgnoreCase(Constants.CANCEL)) {

			// if a software id is in the form, return to the software detail
			// screen
			if (!EaUtils.isBlank(softwareForm.getId())) {
				request.setAttribute(Constants.ID, softwareForm.getId());
				return mapping.findForward(Constants.SOFTWARE);
			}

			// if a software lpar name is in the form, return to the software
			// lpar detail screen
			if (!EaUtils.isBlank(softwareForm.getLparName())) {
				request.setAttribute(Constants.ACCOUNT_ID, softwareForm
						.getAccountId());
				request.setAttribute(Constants.LPAR_NAME, softwareForm
						.getLparName());
				return mapping.findForward(Constants.LPAR);
			}

			// otherwise, return to the account detail
			request.setAttribute(Constants.ID, softwareForm.getAccountId());
			return mapping.findForward(Constants.ACCOUNT);
		}

		// initialize the form
		FormSoftware software = new FormSoftware(softwareForm.getId(),
				softwareForm.getLparId(), softwareForm.getAccountId());
		software.setSoftwareId(softwareForm.getSoftwareId());
		software.setLparName(softwareForm.getLparName());
		software.setProcessorCount(softwareForm.getProcessorCount());
		software.setUsers(softwareForm.getUsers());
		request.setAttribute(Constants.SOFTWARE, software);
		software.setId(softwareForm.getId());
		software.setDiscrepancyType(softwareForm.getDiscrepancyType());
		software.setDiscrepancyTypeId(softwareForm.getDiscrepancyTypeId());
		software.setDiscrepancyTypeList(softwareForm.getDiscrepancyTypeList());
		errors = software.init(softwareForm);

		// TODO more here
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

		// validate the form
		errors = software.validate(mapping, request);

		// if there were errors, return them to the user
		if (!errors.isEmpty()) {
			saveErrors(request, errors);

			// get the account
			Account account = DelegateAccount.getAccount(software
					.getAccountId(), request);
			request.setAttribute(Constants.ACCOUNT, account);

			// if we're creating, disable the discrepancy type
			if (software.getAction().equalsIgnoreCase(Constants.CREATE))
				software.getReadOnly().put(Constants.DISCREPANCY_TYPE,
						Constants.TRUE);

			return mapping.findForward(Constants.ERROR);
		}

		// get the account
		Account account = DelegateAccount.getAccount(software.getAccountId(),
				request);
		request.setAttribute(Constants.ACCOUNT, account);

		// no errors, save the changes to the database
		software.setRemoteUser(request.getRemoteUser());
		software = DelegateSoftware.saveSoftwareForm(software, request);
		request.setAttribute(Constants.SOFTWARE, software);

		// if the save was unsuccessful
		if (software == null) {
			software = new FormSoftware(softwareForm.getId(), softwareForm
					.getLparId());
			request.setAttribute(Constants.SOFTWARE, software);
			errors = software.init(softwareForm);
			errors.add(Constants.DB, new ActionMessage(
					Constants.UNKNOWN_DB_ERROR));
			saveErrors(request, errors);

			return mapping.findForward(Constants.ERROR);
		}

		// if the save was successful, initialize the rest of the form
		errors = software.init();

		// make sure we initialized okay
		if (!errors.isEmpty()) {
			errors.add(Constants.DB, new ActionMessage(
					Constants.UNKNOWN_DB_ERROR));
			saveErrors(request, errors);

			return mapping.findForward(Constants.ERROR);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward validate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionSoftware.validate");
		ActionForward forward = mapping.findForward(Constants.HOME);

		FormSoftware softwareForm = (FormSoftware) form;

		// Show the delete button only for the users in scan team bluegroup.
		if (request.isUserInRole(Constants.SCAN_TEAM_GROUP) || request.isUserInRole(Constants.SCAN_TEAM_SUBGROUP)) {
			request.setAttribute("showDelete", "TRUE");
		}

		// validate the form exists
		if (form == null) {
			return mapping.findForward(Constants.INVALID);
		}

		// get the parameters
		String context = softwareForm.getContext();
		String accountId = softwareForm.getAccountId();
		String lparName = softwareForm.getLparName();
		String lparId = softwareForm.getLparId();

		request.setAttribute(Constants.ACCOUNT_ID, accountId);
		request.setAttribute(Constants.LPAR_NAME, lparName);
		request.setAttribute(Constants.LPAR_ID, lparId);

		if (context.equalsIgnoreCase(Constants.LPAR)
				|| context.equalsIgnoreCase(Constants.SOFTWARE)) {

			forward = validateLpar(mapping, softwareForm, request, context);
		}

		return forward;
	}

	public ActionForward validateLpar(ActionMapping mapping,
			FormSoftware softwareForm, HttpServletRequest request,
			String context) throws Exception {
		logger.debug("ActionSoftware.validateLpar");
		ActionErrors errors = new ActionErrors();

		String accountId = softwareForm.getAccountId();
		String[] lsaValidateSelected = softwareForm.getValidateSelected();

		if (lsaValidateSelected == null) {
			// TODO add error
			saveErrors(request, errors);
			softwareForm.reset(mapping, request);
			return forward(mapping, context);
		}

		// get the account
		Account account = DelegateAccount.getAccount(accountId, request);

		// if the account is invalid, save an error
		if (account == null) {
			// TODO SoftwareDiscrepancy invalid account error
			saveErrors(request, errors);
			return forward(mapping, context);
		}

		// get the VALID discrepancy type
		DiscrepancyType validDiscrepancyType = DelegateDiscrepancy
				.getDiscrepancyType("4");

		// process the list of checkboxes
		List<String> list = Arrays.asList(lsaValidateSelected);
		Iterator<String> i = list.iterator();
		while (i.hasNext()) {

			String id = (String) i.next();
			if (EaUtils.isBlank(id))
				continue;

			InstalledSoftware installedSoftware = DelegateSoftware
					.getInstalledSoftware(id);
			if (installedSoftware == null)
				continue;

			FormSoftware form = new FormSoftware();
			form.setAccountId(accountId);
			form.setSoftware(installedSoftware.getSoftware());
			form.setSoftwareLpar(installedSoftware.getSoftwareLpar());
			form.setVersion(installedSoftware.getVersion());
			form.setInvalidCategory(installedSoftware.getInvalidCategory());
			form.setDiscrepancyType(validDiscrepancyType);
			form.setRemoteUser(request.getRemoteUser());
			form.setComment("Mass Validate");
			form.setId(installedSoftware.getId().toString());

			// save the form to the database
			DelegateSoftware.saveSoftwareForm(form, request);

		}

		softwareForm.reset(mapping, request);
		return mapping.findForward(context);
	}

	private ActionForward forward(ActionMapping mapping, String context) {
		if (context.equalsIgnoreCase(Constants.LPAR)) {
			return mapping.findForward(Constants.LPAR);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward copy(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		logger.debug("ActionSoftware.copy");

		String lparId = getParameter(request, Constants.LPAR_ID);

		if (!EaUtils.isBlank(lparId)) {

			// Get the software lpar object
			SoftwareLpar softwareLpar = DelegateSoftware
					.getSoftwareLpar(lparId);

			Account account = DelegateAccount.getAccount(softwareLpar
					.getCustomer().getAccountNumber()
					+ "", request);

			// Get the list of software Lpars
			List<SoftwareLpar> softwareLparList = DelegateSoftware.getSoftwareLpars(account);
			
			if ( softwareLparList == null ) {
				logger.warn("Cannot copy because list is null for account " + account.getCustomer().getCustomerName());
			}


			// set the attribute
			request.setAttribute(Constants.LIST, softwareLparList);
			request.setAttribute(Constants.ACCOUNT, account);
			request.setAttribute(Constants.LPAR, softwareLpar);

			return mapping.findForward(Constants.SUCCESS);
		}else {
			logger.debug("LparId is null  " + lparId);
			return mapping.findForward(Constants.ERROR);
		}

	}

	public ActionForward applyCopy(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		logger.debug("ActionSoftware.applyCopy");

		String lparId = getParameter(request, Constants.LPAR_ID);

		FormSoftwareCopy copy = (FormSoftwareCopy) form;

		SoftwareLpar softwareLpar = DelegateSoftware.getSoftwareLpar(lparId);

		request.setAttribute(Constants.LPAR_NAME, softwareLpar.getName());
		request.setAttribute(Constants.ACCOUNT_ID, softwareLpar.getCustomer()
				.getAccountNumber()
				+ "");

		copy.setSourceSoftwareLpar(softwareLpar);

		SoftwareCopy softwareCopy = new SoftwareCopy(request.getRemoteUser(),
				copy);
		addBatch(softwareCopy);

		return mapping.findForward(Constants.SUCCESS);

	}
	
	public ActionForward deleteManual(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionSoftware.deleteManual");

		String lsForward = Constants.SUCCESS;

		if (pActionForm == null) {
			lsForward = Constants.ERROR;
			logger.debug("Form is null");
		} else {
			FormSoftware lfsDeleteManual = (FormSoftware) pActionForm;
			String lsAccountId = lfsDeleteManual.getAccountId();
			Account laDeleteManual = DelegateAccount.getAccount(lsAccountId,
					pHttpServletRequest);
			String lsLparId = lfsDeleteManual.getLparId();
			SoftwareLpar lslDeleteManual = DelegateSoftware
					.getSoftwareLpar(lsLparId);
			List<InstalledSoftware> llInstalledSoftware = DelegateSoftware
					.getInstalledSoftwares(lslDeleteManual);
			SoftwareStatistics lssDeleteManual = DelegateSoftware
					.getSoftwareStatistics(lslDeleteManual);
			List<BankAccount> llBankAccount = DelegateSoftware
					.getSoftwareBankAccounts(lslDeleteManual);
			String[] lsaDeleteSelected = lfsDeleteManual.getDeleteSelected();
			ActionErrors laeDeleteManual = new ActionErrors();

			lfsDeleteManual.setSoftwareLpar(lslDeleteManual);

			pHttpServletRequest.setAttribute(Constants.ACCOUNT, laDeleteManual);
			pHttpServletRequest.setAttribute(Constants.SOFTWARE, lfsDeleteManual);
			pHttpServletRequest.setAttribute(Constants.LIST, llInstalledSoftware);
			pHttpServletRequest.setAttribute(Constants.SOFTWARE_STATISTICS,
					lssDeleteManual);
			pHttpServletRequest.setAttribute(Constants.BANK_ACCOUNT_LIST,
					llBankAccount);

			// Show the delete button only for the users in scan team bluegroup
			if (pHttpServletRequest.isUserInRole(Constants.SCAN_TEAM_GROUP) || pHttpServletRequest.isUserInRole(Constants.SCAN_TEAM_SUBGROUP)) {
				pHttpServletRequest.setAttribute("showDelete", "TRUE");
			}

			if (lsaDeleteSelected == null || lsaDeleteSelected.length == 0) {
				lsForward = Constants.ERROR;
				laeDeleteManual.add(Constants.STATUS, 
						new ActionMessage(Constants.SELECT_FOR_MANUAL_DELETION));
				saveErrors(pHttpServletRequest, laeDeleteManual);
				lfsDeleteManual.reset(pActionMapping, pHttpServletRequest);
			} else {
				String lsLparName = lfsDeleteManual.getLparName();
				List<String> llDeleteSelected = Arrays.asList(lsaDeleteSelected);
				ListIterator<String> lliDeleteSelected = llDeleteSelected.listIterator();
				Long llSoftwareId = null;
				Long llCustomerId = laDeleteManual.getCustomer().getCustomerId();
				ManualQueue lmqTemp = null;

				lfsDeleteManual.setSoftwareLpar(lslDeleteManual);

				logger.debug(new StringBuffer("Account ID: ").append(lsAccountId));
				logger.debug(new StringBuffer("Lpar ID: ").append(lsLparId));
				logger.debug(new StringBuffer("Lpar name: ").append(lsLparName));

				while (lliDeleteSelected.hasNext()) {
					llSoftwareId = Long.valueOf((String) lliDeleteSelected.next());
					ManualQueue manualQueue = DelegateSoftware.getManualQueue(new Long(lsLparId), llSoftwareId);
					
					// Insert into the Manual_Queue table only if a row doesn't already exist
					if ( manualQueue == null) {
						manualQueue = new ManualQueue();
						manualQueue.setId(null);
						manualQueue.getCustomer().setCustomerId(llCustomerId);
						manualQueue.setSoftwareLparId(Long.parseLong(lsLparId));
						manualQueue.setHostName(lsLparName);
						manualQueue.setSoftwareId(llSoftwareId);
						manualQueue.setRemoteUser(pHttpServletRequest.getRemoteUser());
						manualQueue.setDeleted(0);
					}
					else if(manualQueue.getDeleted() == 1){
						manualQueue.setDeleted(0);
					}
					try {
						DelegateSoftware.saveManualQueue(manualQueue);
					} catch (Exception e) {
						lsForward = Constants.ERROR;
						laeDeleteManual.add(Constants.STATUS, 
								new ActionMessage(Constants.UNKNOWN_DB_ERROR));
						saveErrors(pHttpServletRequest, laeDeleteManual);
						break;
					}
				}


				if (lsForward.equalsIgnoreCase(Constants.SUCCESS)) {
					lfsDeleteManual.setDeleteSelected(new String[] {});
					pHttpServletRequest.setAttribute(Constants.SOFTWARE, lfsDeleteManual);
					laeDeleteManual.add(Constants.STATUS, 
							new ActionMessage(Constants.MANUAL_SUBMITTED_FOR_DELETION));
					saveErrors(pHttpServletRequest, laeDeleteManual);
				}
			}
		}

		return pActionMapping.findForward(lsForward);			
	}

	public ActionForward determineButton(ActionMapping pActionMapping,
			ActionForm pActionForm, HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws Exception {
		logger.debug("ActionSoftware.determineButton");

		if (pActionForm == null) {
			logger.error("Form is null");
			return pActionMapping.findForward(Constants.ERROR);
		} else {
			FormSoftware lfsDetermineButton = (FormSoftware) pActionForm;

			if (lfsDetermineButton.getButtonPressed().equalsIgnoreCase("Validate")) {
				return validate(pActionMapping, pActionForm, pHttpServletRequest,
						pHttpServletResponse);
			} else if (lfsDetermineButton.getButtonPressed().equalsIgnoreCase(
					"Delete")) {
				return deleteManual(pActionMapping, pActionForm, pHttpServletRequest,
						pHttpServletResponse);
			} else {
				logger.error("Could not determine which button was pressed");
				return pActionMapping.findForward(Constants.ERROR);
			}
		}
	}
}
