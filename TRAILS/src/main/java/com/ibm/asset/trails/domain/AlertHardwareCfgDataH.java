package com.ibm.asset.trails.domain;

import java.util.Date;

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

import org.hibernate.annotations.Formula;

@Entity
@Table(name = "ALERT_HARDWARE_CFGDATA_H")
@org.hibernate.annotations.Entity
@NamedQueries( { @NamedQuery(name = "alertHardwareCfgDataHistory", query = "select new com.ibm.asset.trails.form.AlertHistoryReport(a.comments, a.remoteUser, a.creationTime, a.recordTime, a.open) from AlertHardwareCfgDataH a where a.alertHardwareCfgData.id = :id") })
public class AlertHardwareCfgDataH {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "ALERT_HARDWARE_CFGDATA_ID")
	private AlertHardwareCfgData alertHardwareCfgData;

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

	public AlertHardwareCfgData getAlertHardwareCfgData() {
		return alertHardwareCfgData;
	}

	public void setAlertHardwareCfgData(AlertHardwareCfgData alertHardwareCfgData) {
		this.alertHardwareCfgData = alertHardwareCfgData;
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
