package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity(name = "AlertHistory")
@Table(name = "H_ALERT")
@NamedQueries({ @NamedQuery(name = "getAlertHistoryByAlertId", query = "FROM AlertHistory ah WHERE ah.alert.id=:alertId ORDER BY ah.recordTime ASC") })
public class DataExceptionHistory implements Serializable {

	private static final long serialVersionUID = 1L;

	@ManyToOne
	@JoinColumn(name = "ALERT_ID")
	protected DataException alert;

	@ManyToOne
	@JoinColumn(name = "CUSTOMER_ID")
	protected Account account;

	@ManyToOne
	@JoinColumn(name = "ALERT_TYPE_ID")
	protected AlertType alertType;

	@ManyToOne
	@JoinColumn(name = "ALERT_CAUSE_ID")
	protected AlertCause alertCause;

	@Basic
	@Column(name = "open")
	protected boolean open;

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "CREATION_TIME")
	protected Date creationTime;

	@Basic
	@Column(name = "RECORD_TIME")
	protected Date recordTime;

	@Basic
	@Column(name = "REMOTE_USER", length = 32)
	protected String remoteUser;

	@Basic
	@Column(name = "ASSIGNEE")
	protected String assignee;

	@Basic
	@Column(name = "COMMENT", length = 255)
	protected String comment;

	/**
	 * @return the alert
	 */
	public DataException getAlert() {
		return alert;
	}

	/**
	 * @param alert
	 *            the alert to set
	 */
	public void setAlert(DataException alert) {
		this.alert = alert;
	}

	/**
	 * @return the account
	 */
	public Account getAccount() {
		return account;
	}

	/**
	 * @param account
	 *            the account to set
	 */
	public void setAccount(Account account) {
		this.account = account;
	}

	/**
	 * @return the alertType
	 */
	public AlertType getAlertType() {
		return alertType;
	}

	/**
	 * @param alertType
	 *            the alertType to set
	 */
	public void setAlertType(AlertType alertType) {
		this.alertType = alertType;
	}

	/**
	 * @return the alertCause
	 */
	public AlertCause getAlertCause() {
		return alertCause;
	}

	/**
	 * @param alertCause
	 *            the alertCause to set
	 */
	public void setAlertCause(AlertCause alertCause) {
		this.alertCause = alertCause;
	}

	/**
	 * @return the open
	 */
	public boolean isOpen() {
		return open;
	}

	/**
	 * @param open
	 *            the open to set
	 */
	public void setOpen(boolean open) {
		this.open = open;
	}

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the creationTime
	 */
	public Date getCreationTime() {
		return creationTime;
	}

	/**
	 * @param creationTime
	 *            the creationTime to set
	 */
	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
	}

	/**
	 * @return the recordTime
	 */
	public Date getRecordTime() {
		return recordTime;
	}

	/**
	 * @param recordTime
	 *            the recordTime to set
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	/**
	 * @return the remoteUser
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @param remoteUser
	 *            the remoteUser to set
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/**
	 * @return the assignee
	 */
	public String getAssignee() {
		return assignee;
	}

	/**
	 * @param assignee
	 *            the assignee to set
	 */
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	/**
	 * @return the comment
	 */
	public String getComment() {
		return comment;
	}

	/**
	 * @param comment
	 *            the comment to set
	 */
	public void setComment(String comment) {
		this.comment = comment;
	}

}
