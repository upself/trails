package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Transient;

@Entity
public class DisplayAlertUnlicensedSw {

	@Transient
	private final int ALERT_AGE_YELLOW = 45;

	@Transient
	private final int ALERT_AGE_RED = 90;

	@Id
	@Column(name = "SOFTWARE_ITEM_NAME")
	private String softwareItemName;

	@Column(name = "ALERT_COUNT")
	private Integer alertCount;

	@Column(name = "ALERT_AGE")
	private Integer alertAge;

	@Column(name = "CREATION_TIME")
	private Date creationTime;

	public String getAlertStatus() {
		if (getAlertAge() > ALERT_AGE_RED) {
			return "<font class=\"alert-stop\">Red</font>";
		} else if (getAlertAge() > ALERT_AGE_YELLOW) {
			return "<font class=\"orange-med\">Yellow</font>";
		} else {
			return "<font class=\"alert-go\">Green</font>";
		}
	}

	public Integer getAlertAge() {
		return alertAge;
	}

	public Integer getAlertCount() {
		return alertCount;
	}

	public Date getCreationTime() {
		return creationTime;
	}

	public String getSoftwareItemName() {
		return softwareItemName;
	}

	public void setAlertAge(Integer alertAge) {
		this.alertAge = alertAge;
	}

	public void setAlertCount(Integer alertCount) {
		this.alertCount = alertCount;
	}

	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
	}

	public void setSoftwareItemName(String softwareItemName) {
		this.softwareItemName = softwareItemName;
	}
}
