/*
 * Created on Jun 3, 2006
 * 
 * TODO To change the template for this generated file go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

public class SoftwareLparEffH extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long id;

	private Integer processorCount;

	private String action;

	private SoftwareLparEff softwareLparEff;

	private String remoteUser;

	private String status;

	private Date recordTime;

	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return Returns the processorCount.
	 */
	public Integer getProcessorCount() {
		return processorCount;
	}

	/**
	 * @param processorCount
	 *            The processorCount to set.
	 */
	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	/**
	 * @return Returns the action.
	 */
	public String getAction() {
		return action;
	}

	/**
	 * @param action
	 *            The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}

	public SoftwareLparEff getSoftwareLparEff() {
		return softwareLparEff;
	}

	public void setSoftwareLparEff(SoftwareLparEff softwareLparEff) {
		this.softwareLparEff = softwareLparEff;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
