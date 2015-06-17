/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProductMap;


/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Software
	extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
    private Long softwareId;
    private String softwareName;
    private Manufacturer manufacturer;
    private SoftwareCategory softwareCategory;
    private Integer priority;
    private Integer vendorManaged;
    private String level;
    private String type;
    private String comments;
    private String remoteUser;
    private Date recordTime;
    private String status;
    private String softwareCategoryId;
    private String manufacturerId;
    private String owner;
    private MicrosoftProductMap microsoftProductMap;
    private String changeJustification;
    
    //Change Bravo to use Software View instead of Product Object Start
    private String version;
    private String productRole;
    //Change Bravo to use Software View instead of Product Object End

	public Integer getVendorManaged() {
		return vendorManaged;
	}

	public void setVendorManaged(Integer vendorManaged) {
		this.vendorManaged = vendorManaged;
	}

	public String getSoftwareType() {
		String softwareType = "";
		
		return softwareType;
	}

	public String getStatusImage() {
		if (status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_OK + "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_NA + "\" width=\"12\" height=\"10\"/>";
	}

	public String getStatusIcon() {
		if (status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}

	/**
	 * @return Returns the comments.
	 */
	public String getComments() {
		return comments;
	}
	/**
	 * @param comments The comments to set.
	 */
	public void setComments(String comments) {
		this.comments = comments;
	}
	/**
	 * @return Returns the level.
	 */
	public String getLevel() {
		return level;
	}
	/**
	 * @param level The level to set.
	 */
	public void setLevel(String level) {
		this.level = level;
	}
	/**
	 * @return Returns the manufacturer.
	 */
	public Manufacturer getManufacturer() {
		return manufacturer;
	}
	/**
	 * @param manufacturer The manufacturer to set.
	 */
	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}
	/**
	 * @return Returns the manufacturerId.
	 */
	public String getManufacturerId() {
		return manufacturerId;
	}
	/**
	 * @param manufacturerId The manufacturerId to set.
	 */
	public void setManufacturerId(String manufacturerId) {
		this.manufacturerId = manufacturerId;
	}
	/**
	 * @return Returns the owner.
	 */
	public String getOwner() {
		return owner;
	}
	/**
	 * @param owner The owner to set.
	 */
	public void setOwner(String owner) {
		this.owner = owner;
	}
	/**
	 * @return Returns the priority.
	 */
	public Integer getPriority() {
		return priority;
	}
	/**
	 * @param priority The priority to set.
	 */
	public void setPriority(Integer priority) {
		this.priority = priority;
	}
	/**
	 * @return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return recordTime;
	}
	/**
	 * @param recordTime The recordTime to set.
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}
	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}
	/**
	 * @param remoteUser The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
	/**
	 * @return Returns the softwareCategory.
	 */
	public SoftwareCategory getSoftwareCategory() {
		return softwareCategory;
	}
	/**
	 * @param softwareCategory The softwareCategory to set.
	 */
	public void setSoftwareCategory(SoftwareCategory softwareCategory) {
		this.softwareCategory = softwareCategory;
	}
	/**
	 * @return Returns the softwareCategoryId.
	 */
	public String getSoftwareCategoryId() {
		return softwareCategoryId;
	}
	/**
	 * @param softwareCategoryId The softwareCategoryId to set.
	 */
	public void setSoftwareCategoryId(String softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}
	/**
	 * @return Returns the softwareId.
	 */
	public Long getSoftwareId() {
		return softwareId;
	}
	/**
	 * @param softwareId The softwareId to set.
	 */
	public void setSoftwareId(Long softwareId) {
		this.softwareId = softwareId;
	}
	/**
	 * @return Returns the softwareName.
	 */
	public String getSoftwareName() {
		return softwareName;
	}
	/**
	 * @param softwareName The softwareName to set.
	 */
	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}

    /**
     * @return Returns the microsoftProductMap.
     */
    public MicrosoftProductMap getMicrosoftProductMap() {
        return microsoftProductMap;
    }

    /**
     * @param microsoftProductMap
     *            The microsoftProductMap to set.
     */
    public void setMicrosoftProductMap(MicrosoftProductMap microsoftProductMap) {
        this.microsoftProductMap = microsoftProductMap;
    }
    
    //Change Bravo to use Software View instead of Product Object Start
    /**
	 * @return Returns the version.
	 */
	public String getVersion() {
		return version;
	}
	/**
	 * @param version The version to set.
	 */
	public void setVersion(String version) {
		this.version = version;
	}
	
	 /**
	   * @return Returns the productRole.
	   */
	 public String getProductRole() {
	   return productRole;
	 }
	 
	 /**
	   * @param productRole The productRole to set.
	   */
	 public void setProductRole(String productRole) {
	   this.productRole = productRole;
	 }

	/**
	 * @return the changeJustification
	 */
	public String getChangeJustification() {
		return changeJustification;
	}

	/**
	 * @param changeJustification the changeJustification to set
	 */
	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}
	 
	 
	//Change Bravo to use Software View instead of Product Object End
}