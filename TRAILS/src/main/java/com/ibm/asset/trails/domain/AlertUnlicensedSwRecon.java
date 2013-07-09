package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Formula;


@Entity
@Table(name = "ALERT_UNLICENSED_SW")
@org.hibernate.annotations.Entity
public class AlertUnlicensedSwRecon {

	@Id
	@Column(name = "ID")
	private Long id;

	@OneToOne(fetch=FetchType.LAZY,optional=false)
	@JoinColumn(name = "INSTALLED_SOFTWARE_ID")
	private InstalledSoftware installedSoftware;

	@Column(name = "COMMENTS")
	private String comments;

	@Column(name = "TYPE")
	private String type;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "CREATION_TIME")
	private Date creationTime;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "OPEN")
	private boolean open;

	@OneToOne(fetch = FetchType.LAZY, optional = true)
	@JoinColumn(name = "INSTALLED_SOFTWARE_ID", referencedColumnName = "INSTALLED_SOFTWARE_ID", insertable = false, updatable = false)
	private Reconcile reconcile;

	@Formula("case when open = 0 then days(record_time) - days(creation_time) else days(current timestamp) - days(creation_time) end")
	private Integer alertAge;

	public Integer getAlertAge() {
		return alertAge;
	}

	public void setAlertAge(Integer alertAge) {
		this.alertAge = alertAge;
	}

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

	public InstalledSoftware getInstalledSoftware() {
		return installedSoftware;
	}

	public void setInstalledSoftware(InstalledSoftware installedSoftware) {
		this.installedSoftware = installedSoftware;
	}

	public boolean isOpen() {
		return open;
	}

	public void setOpen(boolean open) {
		this.open = open;
	}

	public Reconcile getReconcile() {
		return reconcile;
	}

	public void setReconcile(Reconcile reconcile) {
		this.reconcile = reconcile;
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

}
