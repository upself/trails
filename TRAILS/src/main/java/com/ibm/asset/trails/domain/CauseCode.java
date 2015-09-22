package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "CAUSE_CODE")
@NamedQueries({
		@NamedQuery(name = "getCauseCodeById", query = "select cc from CauseCode cc where cc.id  = :id "),
		@NamedQuery(name = "isCauseCodeExists", query = "select cc.id from CauseCode cc where cc.id  = :id "),
		@NamedQuery(name = "getAlertTypeId", query = "select cc.alertType.id from CauseCode cc where cc.id  = :id "),
		@NamedQuery(name = "getAlertCauseName", query = "select cc.alertCause.name from CauseCode cc where cc.id  = :id ") })
public class CauseCode {

	@Id
	@Column(name = "ID")
	private long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ALERT_TYPE_ID")
	private AlertType alertType;

	@Column(name = "ALERT_ID")
	private long alertId;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ALERT_CAUSE_ID")
	private AlertCause alertCause;

	@Column(name = "TARGET_DATE")
	private Date targetDate;

	@Column(name = "OWNER")
	private String owner;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public AlertType getAlertType() {
		return alertType;
	}

	public void setAlertType(AlertType alertType) {
		this.alertType = alertType;
	}

	public long getAlertId() {
		return alertId;
	}

	public void setAlertId(long alertId) {
		this.alertId = alertId;
	}

	public AlertCause getAlertCause() {
		return alertCause;
	}

	public void setAlertCause(AlertCause alertCause) {
		this.alertCause = alertCause;
	}

	public Date getTargetDate() {
		return targetDate;
	}

	public void setTargetDate(Date targetDate) {
		this.targetDate = targetDate;
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
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

}
