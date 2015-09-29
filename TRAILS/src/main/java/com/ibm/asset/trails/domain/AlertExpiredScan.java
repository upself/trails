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
@Table(name = "ALERT_EXPIRED_SCAN")
@org.hibernate.annotations.Entity
@NamedQueries( {
		@NamedQuery(name = "alertExpiredScanTotalByAccount", query = "select count(*) from AlertExpiredScan a where a.softwareLpar.account = :account and a.open = 1"),
		@NamedQuery(name = "assignAlertExpiredScan", query = "update AlertExpiredScan a set a.remoteUser = :remoteUser, a.comments = :comments where a.id in (:ids)"),
		@NamedQuery(name = "alertExpiredScanById", query = "FROM AlertExpiredScan WHERE id = :id")})
public class AlertExpiredScan implements Alert {

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_LPAR_ID")
	private SoftwareLpar softwareLpar;

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

	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
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
}
