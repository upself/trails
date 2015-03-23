/*
 * Created on Jun 2, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.discrepancy.DelegateDiscrepancy;
import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.FormBase;
import com.ibm.ea.cndb.Customer;
//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class FormSoftware extends FormBase {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(FormSoftware.class);

	private String lparName;
	private String softwareName;
	private String manufacturer;
	private String licenseLevel;
	private String discrepancyTypeId;
	private String comment;
	private String status;
	private String processorCount;
	private String users;
	private String version;
	private String invalidCategory;
	// private String manualDeleteActive;

	private String id;
	private String lparId;
	private String softwareId;
	private String accountId;
	private String action;
	private String search;
	private String context;

	private SoftwareLpar softwareLpar;
	//Change Bravo to use Software View instead of Product Object Start
	//private Product software;
	private Software software;
	//Change Bravo to use Software View instead of Product Object End
	private Customer customer;
	private DiscrepancyType discrepancyType;

	private List<DiscrepancyType> discrepancyTypeList;
	private List<InvalidCategory> invalidCategoryList;

	private String[] validateSelected;
	private String[] deleteSelected;
	private String buttonPressed;

	public FormSoftware() {
	}

	public FormSoftware(String softwareLparId) {
		this.lparId = softwareLparId;
	}

	public FormSoftware(String softwareId, String softwareLparId) {
		this();
		this.id = softwareId;
		this.lparId = softwareLparId;
	}

	public FormSoftware(String softwareId, String softwareLparId,
			String accountId) {
		this();
		this.id = softwareId;
		this.lparId = softwareLparId;
		this.accountId = accountId;
	}

	public ActionErrors init(FormSoftware software) throws Exception {
		ActionErrors errors = init();

		if (errors.isEmpty()) {

			// overwrite the data from the user
			comment = software.getComment();
			action = software.getAction();
			invalidCategory = software.getInvalidCategory();

			discrepancyTypeId = software.getDiscrepancyTypeId();
			discrepancyType = DelegateDiscrepancy
					.getDiscrepancyType(discrepancyTypeId);
		}

		return errors;
	}

	public ActionErrors init() throws Exception {
		logger.debug("FormSoftware.init");
		ActionErrors errors = new ActionErrors();

		// Donnie added next check
		if (EaUtils.isBlank(id)) {
			id = null;
		}

		// try to initialize using the installed software id
		if (!EaUtils.isBlank(id)) {
			logger.debug("*** id is not blank block");
			// get the software
			InstalledSoftware installedSoftware = DelegateSoftware
					.getInstalledSoftware(id);

			// if the software isn't valid, return an error
			if (installedSoftware == null) {
				// TODO - add error for invalid software id
				logger.debug("*** installedSoftware is null");
				return errors;
			}

			// initialize the customer
			customer = installedSoftware.getSoftwareLpar().getCustomer();
			accountId = customer.getAccountNumber().toString();

			// initialize other fields
			softwareLpar = installedSoftware.getSoftwareLpar();
			software = installedSoftware.getSoftware();
			// discrepancyType = installedSoftware.getDiscrepancyType();
			status = installedSoftware.getStatus();
			invalidCategory = installedSoftware.getInvalidCategory();

			discrepancyType = installedSoftware.getDiscrepancyType();
			discrepancyTypeId = installedSoftware.getDiscrepancyType().getId()
					.toString();

			lparId = softwareLpar.getId().toString();
			lparName = softwareLpar.getName();
			softwareId = software.getSoftwareId().toString();
			
			//Change Bravo to use Software View instead of Product Object Start
			//softwareName = software.getSoftwareItem().getName();
			softwareName = software.getSoftwareName();
			//Change Bravo to use Software View instead of Product Object End
			manufacturer = software.getManufacturer().getManufacturerName();
			licenseLevel = software.getLevel();

			// try to initialize using the software lpar
		} else if (!EaUtils.isBlank(lparId)) {
			logger.debug("*** lparId is not blank block");

			// initialize from the database
			softwareLpar = DelegateSoftware.getSoftwareLpar(lparId);
			logger.debug("*** softwareLpar=" + softwareLpar.toString());

			// if the
			if (softwareLpar == null) {
				logger.debug("*** softwareLpar is null");
				errors.add(Constants.SOFTWARE_LPAR, new ActionMessage(
						Constants.INVALID));
				return errors;
			}

			// initialize the customer
			customer = softwareLpar.getCustomer();
			logger.debug("*** customer=" + customer.toString());
			accountId = customer.getAccountNumber().toString();
			logger.debug("*** accountId=" + accountId.toString());

			// initialize from the database
			if (!EaUtils.isBlank(softwareId)) {
				logger.debug("*** softwareId is not blank block");
				software = DelegateSoftware.getSigBank(softwareId);
				logger.debug("*** software=" + software.toString());

				// if the
				if (software == null) {
					logger.debug("*** software is null");
					errors.add(Constants.SOFTWARE, new ActionMessage(
							Constants.INVALID));
					return errors;
				}

				// initialize other fields
				softwareId = software.getSoftwareId().toString();
				//Change Bravo to use Software View instead of Product Object Start
				//softwareName = software.getSoftwareItem().getName();
				softwareName = software.getSoftwareName();
				//Change Bravo to use Software View instead of Product Object End
				manufacturer = software.getManufacturer().getManufacturerName();
				licenseLevel = software.getLevel();
			}

			// initialize other fields
			lparId = softwareLpar.getId().toString();
			lparName = softwareLpar.getName();

			// try to initialize using the software lpar
		} else if (!EaUtils.isBlank(softwareId)) {
			logger.debug("*** softwareId is not blank block");

			// initialize from the database
			software = DelegateSoftware.getSigBank(softwareId);

			// if the
			if (software == null) {
				errors.add(Constants.SOFTWARE, new ActionMessage(
						Constants.INVALID));
				return errors;
			}

			softwareId = software.getSoftwareId().toString();
			//Change Bravo to use Software View instead of Product Object Start
			//softwareName = software.getSoftwareItem().getName();
			softwareName = software.getSoftwareName();
			//Change Bravo to use Software View instead of Product Object End
			manufacturer = software.getManufacturer().getManufacturerName();
			licenseLevel = software.getLevel();
		}

		// initialize form read only fields
		readOnly.put(Constants.SOFTWARE_NAME, Constants.TRUE);
		readOnly.put(Constants.MANUFACTURER, Constants.TRUE);
		readOnly.put(Constants.LICENSE_LEVEL, Constants.TRUE);

		// initialize drop downs based on create or update
		// discrepancyTypeList = DelegateDiscrepancy.getDiscrepancies();
		discrepancyTypeList = new ArrayList<DiscrepancyType>();

		logger.debug("*** discrepancyTypeId=" + discrepancyTypeId);
		logger.debug("*** toString=" + toString());

		long r = checkDiscrepancy(status, discrepancyTypeId);
		discrepancyTypeId = new String("" + r);
		populateDiscrepancyTypeList();

		// Commented out for testing 11/2009
		// readOnly.put(Constants.DISCREPANCY_TYPE, Constants.TRUE);
		// readOnly.put(Constants.INVALID_CATEGORY, Constants.TRUE);
		if(id != null && status.equals(Constants.INACTIVE))
		{
			readOnly.put(Constants.DISCREPANCY_TYPE, Constants.TRUE);
			readOnly.put(Constants.INVALID_CATEGORY, Constants.TRUE);
			readOnly.put(Constants.COMMENT, Constants.TRUE);
		}
		if ((discrepancyTypeId != null
				&& discrepancyTypeId.equals(new String(""
						+ DelegateDiscrepancy.MISSING))) ||
				(status.equals(Constants.INACTIVE))		) {
			readOnly.put(Constants.DISCREPANCY_TYPE, Constants.TRUE);
			readOnly.put(Constants.INVALID_CATEGORY, Constants.TRUE);
		}

		/**
		 * // if id is null, its a create and only have missing if (id == null)
		 * { // logger.debug(
		 * "Donnie: id was null so it looks like an add and discrepancyTypeId is "
		 * + discrepancyTypeId ); discrepancyTypeList.add(DelegateDiscrepancy
		 * .getDiscrepancyType(DelegateDiscrepancy.MISSING)); // Donnie --
		 * commented out the next line -- uncommented out -- in originally
		 * discrepancyTypeId =
		 * DelegateDiscrepancy.getDiscrepancyType(DelegateDiscrepancy
		 * .MISSING).toString(); // Donnie -- my added line that I am now
		 * commenting out // discrepancyTypeId = new String("" +
		 * DelegateDiscrepancy.MISSING); // Donnie -- added this following line
		 * -- commenting this out // discrepancyType =
		 * DelegateDiscrepancy.getDiscrepancyType(discrepancyTypeId); } else if(
		 * status.equals(Constants.INACTIVE) ) { discrepancyTypeId = new
		 * String("" + DelegateDiscrepancy.MISSING); discrepancyType =
		 * DelegateDiscrepancy .getDiscrepancyType(discrepancyTypeId); //
		 * logger.
		 * debug("Donnie: status was inactive -- commented out the two below");
		 * readOnly.put(Constants.DISCREPANCY_TYPE, Constants.TRUE);
		 * readOnly.put(Constants.INVALID_CATEGORY, Constants.TRUE); } else if
		 * (discrepancyTypeId != null && discrepancyTypeId.equals(new String(""
		 * + DelegateDiscrepancy.MISSING))) { // logger.debug(
		 * "Donnie: desicrepancyTypeId is not null equals MISSING");
		 * readOnly.put(Constants.DISCREPANCY_TYPE, Constants.TRUE);
		 * readOnly.put(Constants.INVALID_CATEGORY, Constants.TRUE); //
		 * otherwise, have everything but missing } else { //
		 * logger.debug("Donnie: nothing else fits");
		 * discrepancyTypeList.add(DelegateDiscrepancy
		 * .getDiscrepancyType(DelegateDiscrepancy.NONE));
		 * discrepancyTypeList.add(DelegateDiscrepancy
		 * .getDiscrepancyType(DelegateDiscrepancy.FALSE_HIT));
		 * discrepancyTypeList.add(DelegateDiscrepancy
		 * .getDiscrepancyType(DelegateDiscrepancy.INVALID));
		 * discrepancyTypeList.add(DelegateDiscrepancy
		 * .getDiscrepancyType(DelegateDiscrepancy.VALID)); }
		 **/
		// build the list of invalid software categories
		invalidCategoryList = DelegateSoftware.getInvalidCategoryList();

		return errors;
	}

	public void populateDiscrepancyTypeList() {
		Iterator<DiscrepancyType> i = discrepancyTypeList.listIterator();
		try {
			while (i.hasNext()) {
				DiscrepancyType d = (DiscrepancyType) i.next();
				DiscrepancyType dTemp = DelegateDiscrepancy
						.getDiscrepancyType(d.getId().longValue());
				d.setName(dTemp.getName());
				d.setRecordTime(dTemp.getRecordTime());
				d.setRemoteUser(dTemp.getRemoteUser());
				d.setStatus(dTemp.getStatus());
			}
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}

	}

	public long checkDiscrepancy(String status, String discrepancyTypeId) {
		discrepancyTypeList = new ArrayList<DiscrepancyType>();
		// if id is null, its a create and only have missing
		if (id == null) {
			DiscrepancyType d = new DiscrepancyType();
			d.setId(DelegateDiscrepancy.MISSING);
			discrepancyTypeList.add(d);
			return DelegateDiscrepancy.MISSING;
		} else if (status.equals(Constants.INACTIVE)) {
			DiscrepancyType d = new DiscrepancyType();
			d.setId(DelegateDiscrepancy.NONE);
			discrepancyTypeList.add(d);
			return DelegateDiscrepancy.NONE;
		} else if (discrepancyTypeId != null
				&& discrepancyTypeId.equals(new String(""
						+ DelegateDiscrepancy.MISSING))) {
			DiscrepancyType d = new DiscrepancyType();
			d.setId(DelegateDiscrepancy.MISSING);
			discrepancyTypeList.add(d);
			return DelegateDiscrepancy.MISSING;
		} else {
			DiscrepancyType d1 = new DiscrepancyType();
			d1.setId(DelegateDiscrepancy.NONE);
			discrepancyTypeList.add(d1);

			DiscrepancyType d2 = new DiscrepancyType();
			d2.setId(DelegateDiscrepancy.FALSE_HIT);
			discrepancyTypeList.add(d2);

			DiscrepancyType d3 = new DiscrepancyType();
			d3.setId(DelegateDiscrepancy.INVALID);
			discrepancyTypeList.add(d3);

			DiscrepancyType d4 = new DiscrepancyType();
			d4.setId(DelegateDiscrepancy.VALID);
			discrepancyTypeList.add(d4);
			
			DiscrepancyType d7 = new DiscrepancyType();
			d7.setId(DelegateDiscrepancy.FH_RESET);
			discrepancyTypeList.add(d7);
			
			if (discrepancyTypeId == null) {
				return DelegateDiscrepancy.NONE;
			} else {
				return new Long(discrepancyTypeId).longValue();
			}

		}

	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		validateSelected = new String[] {};
		deleteSelected = new String[] {};
		buttonPressed = null;
	}

	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();

		// discrepancy type is required
		if (EaUtils.isBlank(discrepancyTypeId)) {
			errors.add(Constants.DISCREPANCY_TYPE, new ActionMessage(
					Constants.REQUIRED));
		} else {
			// if the discrepancy is "INVALID", the invalid software category is
			// required
			if (discrepancyTypeId.equalsIgnoreCase(Long
					.toString(DelegateDiscrepancy.INVALID))
					&& EaUtils.isBlank(invalidCategory)) {
				errors.add(Constants.INVALID_CATEGORY, new ActionMessage(
						Constants.REQUIRED));
			}
		}

		// comment is required
		if (EaUtils.isBlank(comment)) {
			errors
					.add(Constants.COMMENT, new ActionMessage(
							Constants.REQUIRED));
		} else if (comment.length() > Constants.MAX_COMMENT_LENGTH) {
			errors.add(Constants.COMMENT, new ActionMessage(
					Constants.LENGTH_MAX_255));
		}

		// TODO validate: only the user that created a discrepancy can close it

		return errors;
	}

	public String getStatusImage() {
		if (status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_OK
					+ "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_NA
					+ "\" width=\"12\" height=\"10\"/>";
	}

	public String getStatusIcon() {
		if (status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getContext() {
		return context;
	}

	public void setContext(String context) {
		this.context = context;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public DiscrepancyType getDiscrepancyType() {
		return discrepancyType;
	}

	public void setDiscrepancyType(DiscrepancyType discrepancyType) {
		this.discrepancyType = discrepancyType;
	}

	public String getDiscrepancyTypeId() {
		return discrepancyTypeId;
	}

	public void setDiscrepancyTypeId(String discrepancyTypeId) {
		this.discrepancyTypeId = discrepancyTypeId;
	}

	public List<DiscrepancyType> getDiscrepancyTypeList() {
		return discrepancyTypeList;
	}

	public void setDiscrepancyTypeList(List<DiscrepancyType> discrepancyTypeList) {
		this.discrepancyTypeList = discrepancyTypeList;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getInvalidCategory() {
		return invalidCategory;
	}

	public void setInvalidCategory(String invalidCategory) {
		this.invalidCategory = invalidCategory;
	}

	public List<InvalidCategory> getInvalidCategoryList() {
		return invalidCategoryList;
	}

	public void setInvalidCategoryList(List<InvalidCategory> invalidCategoryList) {
		this.invalidCategoryList = invalidCategoryList;
	}

	public String getLicenseLevel() {
		return licenseLevel;
	}

	public void setLicenseLevel(String licenseLevel) {
		this.licenseLevel = licenseLevel;
	}

	public String getLparId() {
		return lparId;
	}

	public void setLparId(String lparId) {
		this.lparId = lparId;
	}

	public String getLparName() {
		return lparName;
	}

	public void setLparName(String lparName) {
		this.lparName = lparName;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public String getProcessorCount() {
		return processorCount;
	}

	public void setProcessorCount(String processorCount) {
		this.processorCount = processorCount;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public String[] getValidateSelected() {
		return validateSelected;
	}

	public void setValidateSelected(String[] validateSelected) {
		this.validateSelected = validateSelected;
	}

	//Change Bravo to use Software View instead of Product Object Start
	/*public Product getSoftware() {
		return software;
	}

	public void setSoftware(Product software) {
		this.software = software;
	}*/
	
	public Software getSoftware() {
		return software;
	}

	public void setSoftware(Software software) {
		this.software = software;
	}
	//Change Bravo to use Software View instead of Product Object End
	
	public String getSoftwareId() {
		return softwareId;
	}

	public void setSoftwareId(String softwareId) {
		this.softwareId = softwareId;
	}

	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getUsers() {
		return users;
	}

	public void setUsers(String users) {
		this.users = users;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String toString() {
		String s = "[FormSoftware] ";
		s += "lparName=" + this.getLparName();
		s += ",softwareName=" + this.getSoftwareName();
		s += ",manufacturer=" + this.getManufacturer();
		s += ",licenseLevel=" + this.getLicenseLevel();
		s += ",discrepancyTypeId=" + this.getDiscrepancyTypeId();
		s += ",comment=" + this.getComment();
		s += ",status=" + this.getStatus();
		s += ",processorCount=" + this.getProcessorCount();
		s += ",users=" + this.getUsers();
		s += ",version=" + this.getVersion();
		s += ",invalidCategory=" + this.getInvalidCategory();
		s += ",id=" + this.getId();
		s += ",lparId=" + this.getLparId();
		s += ",softwareId=" + this.getSoftwareId();
		s += ",accountId=" + this.getAccountId();
		s += ",action=" + this.getAction();
		s += ",search=" + this.getSearch();
		s += ",context=" + this.getContext();
		return s;
	}

	public String[] getDeleteSelected() {
		return deleteSelected;
	}

	public void setDeleteSelected(String[] deleteSelected) {
		this.deleteSelected = deleteSelected;
	}

	public String getButtonPressed() {
		return buttonPressed;
	}

	public void setButtonPressed(String buttonPressed) {
		this.buttonPressed = buttonPressed;
	}
}