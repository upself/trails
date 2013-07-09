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
@Table(name = "ALERT_EXPIRED_MAINT")
@org.hibernate.annotations.Entity
@NamedQueries( {
		@NamedQuery(name = "alertExpiredMaintTotalByAccount", query = "SELECT COUNT(*) FROM AlertExpiredMaint WHERE license.account = :account AND open = 1"),
		@NamedQuery(name = "alertExpiredMaintTotalByRemoteUser", query = "SELECT COUNT(*) FROM AlertExpiredMaint WHERE remoteUser = :remoteUser AND open = 1"),
		@NamedQuery(name = "assignAlertExpiredMaint", query = "UPDATE AlertExpiredMaint SET remoteUser = :remoteUser, comments = :comments WHERE id IN (:ids)") })
public class AlertExpiredMaint implements Alert {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "LICENSE_ID")
	private License license;

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

	public Date getCreationTime() {
		return creationTime;
	}

	public Long getId() {
		return id;
	}

	public License getLicense() {
		return license;
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

	public void setComments(String comments) {
		this.comments = comments;
	}

	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setLicense(License license) {
		this.license = license;
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
