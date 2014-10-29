/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class InstalledSoftwareEff extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long id;
	
	private InstalledSoftware installedSoftware;
	
	private Integer installedSoftwareId;

	private Integer authenticated;
	
	private String owner;

	private Integer userCount;

	private String comment;

    private String remoteUser;

    private Date recordTime;
    
    private Long softwareLparId;

    private String softwareCategoryName;

    private int softwareCategoryId;
    
    private String softwareName;
    
    private String loader;


    
	public Integer getInstalledSoftwareId() {
		return installedSoftwareId;
	}

	public void setInstalledSoftwareId(Integer installedSoftwareId) {
		this.installedSoftwareId = installedSoftwareId;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	/**
	 * @return Returns the softwareLpar.
	 */
	public InstalledSoftware getInstalledSoftware() {
		return installedSoftware;
	}

	/**
	 * @param softwareLpar
	 *            The softwareLpar to set.
	 */
	public void setInstalledSoftware(InstalledSoftware installedSoftware) {
		this.installedSoftware = installedSoftware;
	}
	public Integer getAuthenticated() {
		return authenticated;
	}

	public void setAuthenticated(Integer authenticated) {
		this.authenticated = authenticated;
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public Integer getUserCount() {
		return userCount;
	}

	public void setUserCount(Integer userrCount) {
		this.userCount = userrCount;
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

	public Long getSoftwareLparId() {
		return softwareLparId;
	}

	public void setSoftwareLparId(Long softwareLparId) {
		this.softwareLparId = softwareLparId;
	}

    /**
     * @return Returns the softwareName.
     */
    public String getSoftwareName() {
        return softwareName;
    }

    /**
     * @param softwareName
     *            The softwareName to set.
     */
    public void setSoftwareName(String softwareName) {
        this.softwareName = softwareName;
    }

    /**
     * @return Returns the loader.
     */
    public String getLoader() {
        return loader;
    }

    /**
     * @param loader
     *            The loader to set.
     */
    public void setLoader(String loader) {
        this.loader = loader;
    }
	
}