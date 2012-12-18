/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import java.util.Date;

import com.ibm.ea.bravo.framework.common.OrmBase;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class InstalledSoftwareEff extends OrmBase {
	/**
     * 
     */
    private static final long serialVersionUID = 5408682566354887675L;

    private Long id;
	
	private InstalledSoftware installedSoftware;

	private String authenticated;
	
	private String owner;

	private Integer userCount;

	private String comment;

    private String remoteUser;

    private Date recordTime;



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
	public String getAuthenticated() {
		return authenticated;
	}

	public void setAuthenticated(String authenticated) {
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
	
}