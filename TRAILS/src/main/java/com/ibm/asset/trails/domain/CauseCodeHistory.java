package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "CAUSE_CODE_H")
public class CauseCodeHistory {

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
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

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CAUSE_CODE_ID")
	private CauseCode causeCode;

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

	public CauseCode getCauseCode() {
		return causeCode;
	}

	public void setCauseCode(CauseCode causeCode) {
		this.causeCode = causeCode;
	}

}
