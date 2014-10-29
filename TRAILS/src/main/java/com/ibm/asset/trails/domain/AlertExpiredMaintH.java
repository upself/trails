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
@Table(name = "ALERT_EXP_MAINT_H")
@org.hibernate.annotations.Entity
@NamedQueries( { @NamedQuery(name = "alertExpiredMaintHistory", query = "SELECT new com.ibm.asset.trails.form.AlertHistoryReport(comments, remoteUser, creationTime, recordTime, open) FROM AlertExpiredMaintH WHERE alertExpiredMaint.id = :id") })
public class AlertExpiredMaintH implements Alert {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ALERT_EXPIRED_MAINT_ID")
	private AlertExpiredMaint alertExpiredMaint;

	@Column(name = "COMMENTS")
	private String comments;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "CREATION_TIME")
	private Date creationTime;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "OPEN")
	private boolean open;

	public AlertExpiredMaint getAlertExpiredMaint() {
		return alertExpiredMaint;
	}

	public String getComments() {
		return comments;
	}

	public Date getCreationTime() {
		return creationTime;
	}

	public Long getId() {
		return id;
	}

	public boolean isOpen() {
		return open;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setAlertExpiredMaint(AlertExpiredMaint alertExpiredMaint) {
		this.alertExpiredMaint = alertExpiredMaint;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setOpen(boolean open) {
		this.open = open;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

}
