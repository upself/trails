package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.hibernate.annotations.Formula;


@Entity
@Table(name = "ALERT_HARDWARE")
@org.hibernate.annotations.Entity
@NamedQueries( {
		@NamedQuery(name = "alertHardwareTotalByAccount", query = "select count(*) from AlertViewHardware a where a.account = :account and a.open = 1"),
		@NamedQuery(name = "assignAlertHardware", query = "update AlertHardware a set a.remoteUser = :remoteUser, a.comments = :comments where a.id in (:ids)"),
		@NamedQuery(name = "alertHardwareById", query = "FROM AlertHardware WHERE id = :id")})
public class AlertHardware {

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "HARDWARE_ID")
	private Hardware hardware;

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

	@Formula(value = "days(current timestamp) - days(creation_time)")
	private Integer alertAge;

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

	public Hardware getHardware() {
		return hardware;
	}

	public void setHardware(Hardware hardware) {
		this.hardware = hardware;
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

	public Integer getAlertAge() {
		return alertAge;
	}

	public void setAlertAge(Integer alertAge) {
		this.alertAge = alertAge;
	}

}
