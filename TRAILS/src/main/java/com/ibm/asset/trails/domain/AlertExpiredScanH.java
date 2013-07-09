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
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "ALERT_EXP_SCAN_H")
@org.hibernate.annotations.Entity
@NamedQueries( { @NamedQuery(name = "alertExpiredScanHistory", query = "select new com.ibm.asset.trails.form.AlertHistoryReport(a.comments, a.remoteUser, a.creationTime, a.recordTime, a.open) from AlertExpiredScanH a where a.alertExpiredScan.id = :id") })
public class AlertExpiredScanH implements Alert {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ALERT_EXPIRED_SCAN_ID")
	private AlertExpiredScan alertExpiredScan;

	@Column(name = "COMMENTS")
	private String comments;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "CREATION_TIME")
	private Date creationTime;

	@Column(name = "OPEN")
	private boolean open;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public Date getCreationTime() {
		return creationTime;
	}

	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public boolean isOpen() {
		return open;
	}

	public void setOpen(boolean open) {
		this.open = open;
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

	public AlertExpiredScan getAlertExpiredScan() {
		return alertExpiredScan;
	}

	public void setAlertExpiredScan(AlertExpiredScan alertExpiredScan) {
		this.alertExpiredScan = alertExpiredScan;
	}
}
