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
public class BundleH {

	private Long id;
	private Bundle bundle;
	private String remoteUser;
	private Date recordTime;
	
	/**
	 * @return Returns the bundle.
	 */
	public Bundle getBundle() {
		return bundle;
	}
	/**
	 * @param bundle The bundle to set.
	 */
	public void setBundle(Bundle bundle) {
		this.bundle = bundle;
	}
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
