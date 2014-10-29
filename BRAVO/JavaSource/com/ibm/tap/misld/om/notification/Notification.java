/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.notification;

import java.io.Serializable;
import java.util.Date;

import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 *  
 */
public class Notification implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private Long notificationId;

	private Customer customer;

	private String notificationType;

	private String remoteUser;

	private Date recordTime;

	private String status;

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return customer;
	}

	/**
	 * @param customer
	 *            The customer to set.
	 */
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	/**
	 * @return Returns the notificationId.
	 */
	public Long getNotificationId() {
		return notificationId;
	}

	/**
	 * @param notificationId
	 *            The notificationId to set.
	 */
	public void setNotificationId(Long notificationId) {
		this.notificationId = notificationId;
	}

	/**
	 * @return Returns the notificationType.
	 */
	public String getNotificationType() {
		return notificationType;
	}

	/**
	 * @param notificationType
	 *            The notificationType to set.
	 */
	public void setNotificationType(String notificationType) {
		this.notificationType = notificationType;
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