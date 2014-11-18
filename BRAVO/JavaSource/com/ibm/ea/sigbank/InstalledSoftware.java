/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.software.SoftwareDiscrepancyH;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class InstalledSoftware 	extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long id;

	private SoftwareLpar softwareLpar;
	
	private Long softwareLparId;

	//Change Bravo to use Software View instead of Product Object Start
	//private Product software;
	private Software software;
	//Change Bravo to use Software View instead of Product Object End

	private DiscrepancyType discrepancyType;

	private Integer users;

	private Integer processorCount;

	private Integer authenticated;

	private String version;

	private Boolean researchFlag;

	private String invalidCategory;

    private String softwareCategoryName;

    private int softwareCategoryId;
    
    private String softwareName;

	private SoftwareDiscrepancyH lastDiscrepancy;
	
	private InstalledSoftwareEff installedSoftwareEff;
	
	private String softwareOwner;
	
	private Integer userCount;
	
	private String comment;
	
	private String remoteUser;
	
	private Date recordTime;
	
	private String status;
	
	private Date scanTime;
	

	public String getKeyManaged() {
		String keyManaged = "No";
		if (software != null
				&& (software.getVendorManaged().toString()
						.equalsIgnoreCase("1"))) {
			keyManaged = "Yes";
		}
		return keyManaged;
	}

	/**
	 * @return Returns the lastDiscrepancy.
	 */
	public SoftwareDiscrepancyH getLastDiscrepancy() {
		return lastDiscrepancy;
	}

	/**
	 * @param lastDiscrepancy
	 *            The lastDiscrepancy to set.
	 */
	public void setLastDiscrepancy(SoftwareDiscrepancyH lastDiscrepancy) {
		this.lastDiscrepancy = lastDiscrepancy;
	}
	
	public Integer getAuthenticated() {
		return authenticated;
	}

	public void setAuthenticated(Integer authenticated) {
		this.authenticated = authenticated;
	}

	public String getSoftwareOwner() {
		return softwareOwner;
	}

	public void setSoftwareOwner(String softwareOwner) {
		this.softwareOwner = softwareOwner;
	}

	public Integer getUserCount() {
		return userCount;
	}

	public void setUserCount(Integer userCount) {
		this.userCount = userCount;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public DiscrepancyType getDiscrepancyType() {
		return discrepancyType;
	}

	public void setDiscrepancyType(DiscrepancyType discrepancyType) {
		this.discrepancyType = discrepancyType;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getInvalidCategory() {
		return invalidCategory;
	}

	public void setInvalidCategory(String invalidCategory) {
		this.invalidCategory = invalidCategory;
	}

	public Integer getProcessorCount() {
		return processorCount;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	public Boolean getResearchFlag() {
		return researchFlag;
	}

	public void setResearchFlag(Boolean researchFlag) {
		this.researchFlag = researchFlag;
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

	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

	public Long getSoftwareLparId() {
		return softwareLparId;
	}

	public void setSoftwareLparId(Long softwareLparId) {
		this.softwareLparId = softwareLparId;
	}

	public Integer getUsers() {
		return users;
	}

	public void setUsers(Integer users) {
		this.users = users;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

    /**
     * @return Returns the softwareName.
     */
    public String getSoftwareName() {
        return this.softwareName;
    }

    /**
     * @param softwareName
     *            The softwareName to set.
     */
    public void setSoftwareName(String softwareName) {
        this.softwareName = softwareName;
    }

    /**
     * @return Returns the softwareCategoryName.
     */
    public String getSoftwareCategoryName() {
        return softwareCategoryName;
    }

    /**
     * @param softwareCategoryName
     *            The softwareCategoryName to set.
     */
    public void setSoftwareCategoryName(String softwareCategoryName) {
        this.softwareCategoryName = softwareCategoryName;
    }

    /**
     * @return Returns the softwareCategorId.
     */
    public int getSoftwareCategoryId() {
        return softwareCategoryId;
    }

    /**
     * @param softwareCategorId
     *            The softwareCategorId to set.
     */
    public void setSoftwareCategoryId(int softwareCategoryId) {
        this.softwareCategoryId = softwareCategoryId;
    }

	public InstalledSoftwareEff getInstalledSoftwareEff() {
		return installedSoftwareEff;
	}

	public void setInstalledSoftwareEff(InstalledSoftwareEff installedSoftwareEff) {
		this.installedSoftwareEff = installedSoftwareEff;
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
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param remoteUser The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	public Date getScanTime() {
		return scanTime;
	}

	public void setScanTime(Date scanTime) {
		this.scanTime = scanTime;
	}
	
}