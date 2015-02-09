/*
 * Created on Jun 2, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.hardware;

import java.math.BigDecimal;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.FormBase;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class FormHardware extends FormBase {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String lparName;

	private String machineType;
	
	private String assetType;
	
	private String serial;

	private String country;

	private String comment;

	private String status;

	private String id;

	private String accountId;

	private String action;

	private String search;

	private Customer customer;

	private Hardware hardware;

	private String extId;

	private String techImageId;

	private Integer processorCount;
	
	private Integer processorCountEff;
	
	private Integer chips;
	
	private String serverType;
	
	private String owner;
	
	private String mastProcessorType;
	
	private String processorManufacturer;
	
	private String processorModel;
	
	private BigDecimal nbrCoresPerChip;
	
	private BigDecimal nbrOfChipsMax;
	
	private String shared;
	
	private Integer cpuMIPS;
	
	private BigDecimal cpuGartnerMIPS;
	
	private Integer cpuMSU;
	
	private Integer partMIPS;

	private BigDecimal partGartnerMIPS;
	
	private Integer partMSU;
	
	private BigDecimal effectiveThreads;
	
	private String lparStatus;
	
	private String lparStatusIcon;
	
	private String hardwareStatus;
	
	private String sysplex;
	
	private String spla;
	
	private String internetIccFlag;
	
	private Integer cpuIfl;
	
	private String os_type;
	
	
	public String getOs_type() {
		return os_type;
	}

	public void setOs_type(String os_type) {
		this.os_type = os_type;
	}

	public Integer getCpuIfl() {
		return cpuIfl;
	}

	public void setCpuIfl(Integer cpuIfl) {
		this.cpuIfl = cpuIfl;
	}

	public String getServerType() {
		return serverType;
	}

	public void setServerType(String serverType) {
		this.serverType = serverType;
	}

	public Integer getCpuMIPS() {
		return cpuMIPS;
	}
	
	public void setCpuMIPS(Integer cpuMIPS) {
		this.cpuMIPS = cpuMIPS;
	}
	
	public BigDecimal getCpuGartnerMIPS() {
		return cpuGartnerMIPS;
	}

	public void setCpuGartnerMIPS(BigDecimal cpuGartnerMIPS) {
		this.cpuGartnerMIPS = cpuGartnerMIPS;
	}

	public Integer getCpuMSU() {
		return cpuMSU;
	}
	
	public void setCpuMSU(Integer cpuMSU) {
		this.cpuMSU = cpuMSU;
	}

	public Integer getPartMIPS() {
		return partMIPS;
	}
	
	public void setPartMIPS(Integer partMIPS) {
		this.partMIPS = partMIPS;
	}

	public BigDecimal getPartGartnerMIPS() {
		return partGartnerMIPS;
	}

	public void setPartGartnerMIPS(BigDecimal partGartnerMIPS) {
		this.partGartnerMIPS = partGartnerMIPS;
	}

	public Integer getPartMSU() {
		return partMSU;
	}

	public void setPartMSU(Integer partMSU) {
		this.partMSU = partMSU;
	}

	public BigDecimal getEffectiveThreads() {
		return effectiveThreads;
	}

	public void setEffectiveThreads(BigDecimal effectiveThreads) {
		this.effectiveThreads = effectiveThreads;
	}

	public Integer getChips() {
		return chips;
	}

	public void setChips(Integer chips) {
		this.chips = chips;
	}
	
	public String getLparStatus() {
		return lparStatus;
	}
	
	public void setLparStatus(String lparStatus) {
		this.lparStatus = lparStatus;
	}
	
	public String getLparStatusIcon() {
		return lparStatusIcon;
	}
	
	public void setLparStatusIcon(String lparStatusIcon) {
		this.lparStatusIcon = lparStatusIcon;
	}
	
	public String getHardwareStatus() {
		return hardwareStatus;
	}
	
	public void setHardwareStatus(String hardwareStatus) {
		this.hardwareStatus = hardwareStatus;
	}
	
	public String getSysplex() {
		return sysplex;
	}
	
	public void setSysplex(String sysplex) {
		this.sysplex = sysplex;
	}
	
	public String getSpla() {
		return spla;
	}
	
	public void setSpla(String spla) {
		this.spla = spla;
	}
	
	public String getInternetIccFlag() {
		return internetIccFlag;
	}
	
	public void setInternetIccFlag(String internetIccFlag) {
		this.internetIccFlag = internetIccFlag;
	}

	public FormHardware() {
	}

	public FormHardware(String hardwareLparId, String accountId) {
		this();
		this.id = hardwareLparId;
		this.accountId = accountId;
		this.status = Constants.ACTIVE;
	}

	public ActionErrors init(FormHardware hardware, HttpServletRequest request)
			throws Exception {
		ActionErrors errors = init(request);

		if (errors.isEmpty()) {

			// overwrite the data from the user
			this.lparName = hardware.getLparName();
			this.comment = hardware.getComment();
			this.action = hardware.getAction();

		}

		return errors;
	}

	public ActionErrors init(HttpServletRequest request) throws Exception {
		ActionErrors errors = new ActionErrors();

		// try to initialize using the hardware lpar first
		if (!EaUtils.isBlank(this.id)) {

			// initialize from the database
			HardwareLpar hardwareLpar = DelegateHardware
					.getHardwareLpar(this.id);
			if (hardwareLpar == null) {
				errors.add(Constants.HARDWARE_LPAR, new ActionMessage(
						Constants.INVALID));
				return errors;
			}

			// initialize the customer
			this.customer = hardwareLpar.getCustomer();
			this.accountId = this.customer.getAccountNumber().toString();

			// initialize other fields
			this.lparName = hardwareLpar.getName();
			this.lparStatusIcon = hardwareLpar.getStatusIcon();
			this.status = hardwareLpar.getStatus();
			this.extId = hardwareLpar.getExtId();
			this.techImageId = hardwareLpar.getTechImageId();
			this.partMIPS = hardwareLpar.getPartMIPS();
			this.partMSU = hardwareLpar.getPartMSU();
			this.lparStatus = hardwareLpar.getLparStatus();
			this.sysplex = hardwareLpar.getSysplex();
			this.spla = hardwareLpar.getSpla();
			this.internetIccFlag = hardwareLpar.getInternetIccFlag();
			this.os_type = hardwareLpar.getOs_type();
			
			if (hardwareLpar.getHardware() != null) {
				this.hardware = hardwareLpar.getHardware();
				this.machineType = hardwareLpar.getHardware().getMachineType()
						.getName();
				this.assetType = hardwareLpar.getHardware().getMachineType()
						.getType();
				this.serial = hardwareLpar.getHardware().getSerial();
				this.country = hardwareLpar.getHardware().getCountry();
				this.processorCount = hardwareLpar.getHardware()
						.getProcessorCount();
				if(hardwareLpar.getHardwareLparEff() !=null) {this.processorCountEff = hardwareLpar.getHardwareLparEff().getProcessorCount();}
				this.chips = hardwareLpar.getHardware().getChips();
				this.owner = hardwareLpar.getHardware().getOwner();
				this.serverType = hardwareLpar.getServerType();
				this.mastProcessorType = hardwareLpar.getHardware().getMastProcessorType();
				this.processorManufacturer = hardwareLpar.getHardware().getProcessorManufacturer();
				this.processorModel = hardwareLpar.getHardware().getProcessorModel();
				this.nbrCoresPerChip = hardwareLpar.getHardware().getNbrCoresPerChip();
				this.nbrOfChipsMax = hardwareLpar.getHardware().getNbrOfChipsMax();
				this.shared = hardwareLpar.getHardware().getShared();
				this.cpuMIPS = hardwareLpar.getHardware().getCpuMIPS();
				this.cpuGartnerMIPS = hardwareLpar.getHardware().getCpuGartnerMIPS();
				this.cpuMSU = hardwareLpar.getHardware().getCpuMSU();
				this.effectiveThreads = hardwareLpar.getEffectiveThreads();
				this.hardwareStatus = hardwareLpar.getHardware().getHardwareStatus();
				this.cpuIfl = hardwareLpar.getHardware().getCpuIfl();
			}

		} else {

			// initialize the customer
			Account account = DelegateAccount.getAccount(this.accountId,
					request);
			if (account == null) {
				errors.add(Constants.ACCOUNT, new ActionMessage(
						Constants.INVALID));
				return errors;
			}

			// initialize the customer
			this.customer = account.getCustomer();
			this.status = Constants.ACTIVE;
		}

		// initialize form read only fields
		this.readOnly.put(Constants.MACHINE_TYPE, Constants.TRUE);
		this.readOnly.put(Constants.SERIAL, Constants.TRUE);
		this.readOnly.put(Constants.COUNTRY, Constants.TRUE);

		return errors;
	}

	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();

		// lpar name is required
		if (EaUtils.isBlank(this.lparName)) {
			errors.add(Constants.LPAR_NAME, new ActionMessage(
					Constants.REQUIRED));
		} else {
			// lpar name is unique for an account, only applies when creating
			// new lpars
			if (this.action.equalsIgnoreCase(Constants.CREATE)) {
				try {
					if (DelegateHardware.getHardwareLpar(this.lparName,
							this.accountId, request) != null) {
						errors.add(Constants.LPAR_NAME, new ActionMessage(
								Constants.LPAR_NAME_EXISTS));
					}
				} catch (ExceptionAccountAccess e) {
					errors.add(Constants.LPAR_NAME, new ActionMessage(
							Constants.ACCOUNT_ACCESS));
				}
			}
		}

		// comment is required
		if (EaUtils.isBlank(this.comment)) {
			errors
					.add(Constants.COMMENT, new ActionMessage(
							Constants.REQUIRED));
		} else if (this.comment.length() > Constants.MAX_COMMENT_LENGTH) {
			errors.add(Constants.COMMENT, new ActionMessage(
					Constants.LENGTH_MAX_255));
		}

		return errors;
	}

	public String getStatusImage() {
		if (this.status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_OK
					+ "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_NA
					+ "\" width=\"12\" height=\"10\"/>";
	}

	public String getStatusIcon() {
		if (this.status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}

	/**
	 * @return Returns the accountId.
	 */
	public String getAccountId() {
		return this.accountId;
	}

	/**
	 * @param accountId
	 *            The accountId to set.
	 */
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	/**
	 * @return Returns the action.
	 */
	public String getAction() {
		return this.action;
	}

	/**
	 * @param action
	 *            The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}

	/**
	 * @return Returns the comment.
	 */
	public String getComment() {
		return this.comment;
	}

	/**
	 * @param comment
	 *            The comment to set.
	 */
	public void setComment(String comment) {
		this.comment = comment;
	}

	/**
	 * @return Returns the country.
	 */
	public String getCountry() {
		return this.country;
	}

	/**
	 * @param country
	 *            The country to set.
	 */
	public void setCountry(String country) {
		this.country = country;
	}

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return this.customer;
	}

	/**
	 * @param customer
	 *            The customer to set.
	 */
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	/**
	 * @return Returns the hardware.
	 */
	public Hardware getHardware() {
		return this.hardware;
	}

	/**
	 * @param hardware
	 *            The hardware to set.
	 */
	public void setHardware(Hardware hardware) {
		this.hardware = hardware;
	}

	/**
	 * @return Returns the id.
	 */
	public String getId() {
		return this.id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return Returns the lparName.
	 */
	public String getLparName() {
		return this.lparName;
	}

	/**
	 * @param lparName
	 *            The lparName to set.
	 */
	public void setLparName(String lparName) {
		this.lparName = lparName;
	}

	/**
	 * @return Returns the machineType.
	 */
	public String getMachineType() {
		return this.machineType;
	}

	/**
	 * @param machineType
	 *            The machineType to set.
	 */
	public void setMachineType(String machineType) {
		this.machineType = machineType;
	}
	
	/**
	 * @return the assetType
	 */
	public String getAssetType() {
		return assetType;
	}

	/**
	 * @param assetType the assetType to set
	 */
	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}

	/**
	 * @return Returns the search.
	 */
	public String getSearch() {
		return this.search;
	}

	/**
	 * @param search
	 *            The search to set.
	 */
	public void setSearch(String search) {
		this.search = search;
	}

	/**
	 * @return Returns the serial.
	 */
	public String getSerial() {
		return this.serial;
	}

	/**
	 * @param serial
	 *            The serial to set.
	 */
	public void setSerial(String serial) {
		this.serial = serial;
	}

	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return this.status;
	}

	/**
	 * @param status
	 *            The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getOwner() {
		return this.owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getExtId() {
		return extId;
	}

	public void setExtId(String extId) {
		this.extId = extId;
	}

	public String getTechImageId() {
		return techImageId;
	}

	public void setTechImageId(String techImageId) {
		this.techImageId = techImageId;
	}

	public Integer getProcessorCount() {
		return processorCount;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}
	
	public Integer getProcessorCountEff() {
		return processorCountEff;
	}

	public void setProcessorCountEff(Integer processorCountEff) {
		this.processorCountEff = processorCountEff;
	}
	
	public String getMastProcessorType() {
		return mastProcessorType;
	}

	public void setMastProcessorType(String mastProcessorType) {
		this.mastProcessorType = mastProcessorType;
	}
	
	public String getProcessorManufacturer() {
		return processorManufacturer;
	}

	public void setProcessorManufacturer(String processorManufacturer) {
		this.processorManufacturer = processorManufacturer;
	}
	
	public String getProcessorModel() {
		return processorModel;
	}

	public void setProcessorModel(String processorModel) {
		this.processorModel = processorModel;
	}
	
	public BigDecimal getNbrCoresPerChip() {
		return nbrCoresPerChip;
	}

	public void setNbrCoresPerChip(BigDecimal nbrCoresPerChip) {
		this.nbrCoresPerChip = nbrCoresPerChip;
	}
	
	public BigDecimal getNbrOfChipsMax() {
		return nbrOfChipsMax;
	}

	public void setNbrOfChipsMax(BigDecimal nbrOfChipsMax) {
		this.nbrOfChipsMax = nbrOfChipsMax;
	}
	
	public String getShared() {
		return shared;
	}

	public void setShared(String shared) {
		this.shared = shared;
	}
}
