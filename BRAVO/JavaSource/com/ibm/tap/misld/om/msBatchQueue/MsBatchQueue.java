/*
 * Created on Feb 8, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.om.msBatchQueue;

import java.sql.Blob;
import java.util.Date;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MsBatchQueue {

	private Long batchQueueId;

	private Blob batchObject;

	private String remoteUser;

	private Date recordTime;

	private String status;

	/**
	 * @return Returns the batchObject.
	 */
	public Blob getBatchObject() {
		return batchObject;
	}

	/**
	 * @param batchObject
	 *            The batchObject to set.
	 */
	public void setBatchObject(Blob batchObject) {
		this.batchObject = batchObject;
	}

	/**
	 * @return Returns the batchQueueId.
	 */
	public Long getBatchQueueId() {
		return batchQueueId;
	}

	/**
	 * @param batchQueueId
	 *            The batchQueueId to set.
	 */
	public void setBatchQueueId(Long batchQueueId) {
		this.batchQueueId = batchQueueId;
	}

	/**
	 * @return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return recordTime;
	}

	/**
	 * @param recordTime
	 *            The recordTime to set.
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
	 * @param remoteUser
	 *            The remoteUser to set.
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
	 * @param status
	 *            The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}