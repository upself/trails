/*
 * Created on Sep 18, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Bundle {

	private Long id;
	//Change Bravo to use Software View instead of Product Object Start
	//private Product software;
	private Software software;
	//Change Bravo to use Software View instead of Product Object End
	private String name;
	private String remoteUser;
	private Date recordTime;
	private String status;
	
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
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
	
	//Change Bravo to use Software View instead of Product Object Start
	/**
	 * @return Returns the software.
	 */
	/*public Product getSoftware() {
		return software;
	}*/
	/**
	 * @param software The software to set.
	 */
	/*public void setSoftware(Product software) {
		this.software = software;
	}*/
	
	/**
	 * @return Returns the software.
	 */
	public Software getSoftware() {
		return software;
	}
	/**
	 * @param software The software to set.
	 */
	public void setSoftware(Software software) {
		this.software = software;
	}
	//Change Bravo to use Software View instead of Product Object End
	
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
}
