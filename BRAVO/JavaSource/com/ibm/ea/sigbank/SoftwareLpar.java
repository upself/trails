/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.cndb.CountryCode;
import com.ibm.ea.utils.EaUtils;
import com.ibm.tap.misld.om.cndb.Customer;
/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareLpar extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;

	private String name;

	private Customer customer;

	private SoftwareLparEff softwareLparEff;

	private String model;

	private String biosSerial;

	private Integer processorCount;

	private Date scantime;

	private Date acquisitionTime;

	private String remoteUser;

	private String status;

	private Date recordTime;

	private HardwareLpar hardwareLpar;

	private String objectId;
	
	private String computerId;

	private String osName;
	
	private String osType;
	
	private Integer osMajorVersion;

	private Integer osMinorVersion;
	
	private String osSubVersion;
	
	private String osInstallDate;
	
	private String userName;

	private String biosManufacturer;
	
	private String biosModel;

	private String serverType;

	private String techImgId;
	
	private String extId;
	
	private Integer memory;
	
	private Integer disk;
	
	private Integer dedicatedProcessors;

	private Integer totalProcessors;
	
	private Integer sharedProcessors;
	
	private Integer processorType;
	
	private Integer sharedProcByCores;
	
	private Integer dedicatedProcByCores;
	
	private Integer totalProcByCores;

	private String alias;
	
	private Integer physicalTotalKB;
	
	private Integer virtualMemory;
	
	private Integer physicalFreeMemory;
	
	private Integer virtualFreeMemory;

	private Integer nodeCapacity;
	
	private Integer lparCapacity;

	private Date biosDate;
	
	private String biosSerialNumber;
	
	private String biosUniqueId;
	
	private String boardSerial;
	
	private String caseSerial;
	
	private String caseAssetTag;
	
	private String powerOnPassword;
	
	private CountryCode countryCode;
	
	private Integer countryCodeId;
	
    private String countryCodeDefault;
    
    private boolean  usMachines;
	
	private String comment;
	
	public String getAlias() {
		return alias;
	}

	public void setAlias(String alias) {
		this.alias = alias;
	}

	public Date getBiosDate() {
		return biosDate;
	}

	public void setBiosDate(Date biosDate) {
		this.biosDate = biosDate;
	}

	public String getBiosManufacturer() {
		return biosManufacturer;
	}

	public void setBiosManufacturer(String biosManufacturer) {
		this.biosManufacturer = biosManufacturer;
	}

	public String getBiosModel() {
		return biosModel;
	}

	public void setBiosModel(String biosModel) {
		this.biosModel = biosModel;
	}

	public String getBiosSerialNumber() {
		return biosSerialNumber;
	}

	public void setBiosSerialNumber(String biosSerialNumber) {
		this.biosSerialNumber = biosSerialNumber;
	}

	public String getBiosUniqueId() {
		return biosUniqueId;
	}

	public void setBiosUniqueId(String biosUniqueId) {
		this.biosUniqueId = biosUniqueId;
	}

	public String getBoardSerial() {
		return boardSerial;
	}

	public void setBoardSerial(String boardSerial) {
		this.boardSerial = boardSerial;
	}

	public String getCaseAssetTag() {
		return caseAssetTag;
	}

	public void setCaseAssetTag(String caseAssetTag) {
		this.caseAssetTag = caseAssetTag;
	}

	public String getCaseSerial() {
		return caseSerial;
	}

	public void setCaseSerial(String caseSerial) {
		this.caseSerial = caseSerial;
	}

	public String getComputerId() {
		return computerId;
	}

	public void setComputerId(String computerId) {
		this.computerId = computerId;
	}

	public Integer getDedicatedProcByCores() {
		return dedicatedProcByCores;
	}

	public void setDedicatedProcByCores(Integer dedicatedProcByCores) {
		this.dedicatedProcByCores = dedicatedProcByCores;
	}

	public Integer getDedicatedProcessors() {
		return dedicatedProcessors;
	}

	public void setDedicatedProcessors(Integer dedicatedProcessors) {
		this.dedicatedProcessors = dedicatedProcessors;
	}

	public Integer getDisk() {
		return disk;
	}

	public void setDisk(Integer disk) {
		this.disk = disk;
	}

	public Integer getLparCapacity() {
		return lparCapacity;
	}

	public void setLparCapacity(Integer lparCapacity) {
		this.lparCapacity = lparCapacity;
	}

	public Integer getMemory() {
		return memory;
	}

	public void setMemory(Integer memory) {
		this.memory = memory;
	}

	public Integer getNodeCapacity() {
		return nodeCapacity;
	}

	public void setNodeCapacity(Integer nodeCapacity) {
		this.nodeCapacity = nodeCapacity;
	}

	public String getObjectId() {
		return objectId;
	}

	public void setObjectId(String objectId) {
		this.objectId = objectId;
	}

	public String getOsInstallDate() {
		return osInstallDate;
	}

	public void setOsInstallDate(String osInstallDate) {
		this.osInstallDate = osInstallDate;
	}

	public Integer getOsMajorVersion() {
		return osMajorVersion;
	}

	public void setOsMajorVersion(Integer osMajorVersion) {
		this.osMajorVersion = osMajorVersion;
	}

	public Integer getOsMinorVersion() {
		return osMinorVersion;
	}

	public void setOsMinorVersion(Integer osMinorVersion) {
		this.osMinorVersion = osMinorVersion;
	}

	public String getOsName() {
		return osName;
	}

	public void setOsName(String osName) {
		this.osName = osName;
	}

	public String getOsSubVersion() {
		return osSubVersion;
	}

	public void setOsSubVersion(String osSubVersion) {
		this.osSubVersion = osSubVersion;
	}

	public String getOsType() {
		return osType;
	}

	public void setOsType(String osType) {
		this.osType = osType;
	}

	public Integer getPhysicalFreeMemory() {
		return physicalFreeMemory;
	}

	public void setPhysicalFreeMemory(Integer physicalFreeMemory) {
		this.physicalFreeMemory = physicalFreeMemory;
	}

	public Integer getPhysicalTotalKB() {
		return physicalTotalKB;
	}

	public void setPhysicalTotalKB(Integer physicalTotalKB) {
		this.physicalTotalKB = physicalTotalKB;
	}

	public String getPowerOnPassword() {
		return powerOnPassword;
	}

	public void setPowerOnPassword(String powerOnPassword) {
		this.powerOnPassword = powerOnPassword;
	}

	public Integer getProcessorType() {
		return processorType;
	}

	public void setProcessorType(Integer processorType) {
		this.processorType = processorType;
	}

	public String getServerType() {
		return serverType;
	}

	public void setServerType(String serverType) {
		this.serverType = serverType;
	}

	public Integer getSharedProcByCores() {
		return sharedProcByCores;
	}

	public void setSharedProcByCores(Integer sharedProcByCores) {
		this.sharedProcByCores = sharedProcByCores;
	}

	public Integer getSharedProcessors() {
		return sharedProcessors;
	}

	public void setSharedProcessors(Integer sharedProcessors) {
		this.sharedProcessors = sharedProcessors;
	}

	public String getTechImgId() {
		return techImgId;
	}

	public void setTechImgId(String techImgId) {
		this.techImgId = techImgId;
	}

	public Integer getTotalProcByCores() {
		return totalProcByCores;
	}

	public void setTotalProcByCores(Integer totalProcByCores) {
		this.totalProcByCores = totalProcByCores;
	}

	public Integer getTotalProcessors() {
		return totalProcessors;
	}

	public void setTotalProcessors(Integer totalProcessors) {
		this.totalProcessors = totalProcessors;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Integer getVirtualFreeMemory() {
		return virtualFreeMemory;
	}

	public void setVirtualFreeMemory(Integer virtualFreeMemory) {
		this.virtualFreeMemory = virtualFreeMemory;
	}

	public Integer getVirtualMemory() {
		return virtualMemory;
	}

	public void setVirtualMemory(Integer virtualMemory) {
		this.virtualMemory = virtualMemory;
	}

	public Date getAcquisitionTime() {
		return acquisitionTime;
	}

	public void setAcquisitionTime(Date acquisitionTime) {
		this.acquisitionTime = acquisitionTime;
	}

	public String getBiosSerial() {
		return biosSerial;
	}

	public void setBiosSerial(String biosSerial) {
		this.biosSerial = biosSerial;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public HardwareLpar getHardwareLpar() {
		return hardwareLpar;
	}

	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getProcessorCount() {
		return processorCount;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public Date getScantime() {
		return scantime;
	}

	public void setScantime(Date scantime) {
		this.scantime = scantime;
	}

	public SoftwareLparEff getSoftwareLparEff() {
		return softwareLparEff;
	}

	public void setSoftwareLparEff(SoftwareLparEff softwareLparEff) {
		this.softwareLparEff = softwareLparEff;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getUrl() {
		if (this == null)
			return "<a href=\"/BRAVO/software/selectInit.do?accountId="
					+ customer.getAccountNumber() + "&lparName=" + name
					+ "&lparId=" + id + "\">No Software Records</a>";
		else
			return "<a href=\"/BRAVO/lpar/view.do?accountId="
					+ getCustomer().getAccountNumber() + "&lparName=" + name
					+ "\">View Details</a>";
	}

	public String getAcquisitionDate() {
		return EaUtils.monthDayYear(acquisitionTime);
	}

	public String getScantimeDate() {
		return EaUtils.monthDayYear(scantime);
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

	public String getExtId() {
		return extId;
	}

	public void setExtId(String extId) {
		this.extId = extId;
	}

	public Integer getCountryCodeId() {
		return countryCodeId;
	}

	public void setCountryCodeId(Integer countryCodeId) {
		this.countryCodeId = countryCodeId;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	/**
	 * @return Returns the countryCode.
	 */
	public CountryCode getCountryCode() {
		return countryCode;
	}

	/**
	 * @param countryCode
	 *            The countryCode to set.
	 */
	public void setCountryCode(CountryCode countryCode) {
		this.countryCode = countryCode;
	}
    
    /**
     * @return Returns the countryCodeDefault.
     */
    public String getCountryCodeDefault() {
        return countryCodeDefault;
    }
    /**
     * @param name The countryCodeDefault to set.
     */
    public void setCountryCodeDefault(String countryCodeDefault) {
        this.countryCodeDefault = countryCodeDefault;
    }


    /**
     * @return Returns the usMachines.
     */
    public boolean isUsMachines() {
        return usMachines;
    }

    /**
     * @param usMachines
     *            The usMachines to set.
     */
    public void setUsMachines(boolean usMachines) {
        this.usMachines = usMachines;
    }
	
}
