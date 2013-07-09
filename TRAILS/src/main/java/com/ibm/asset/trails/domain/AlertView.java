package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.DiscriminatorType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;


@Entity
@Table(name = "V_ALERTS")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "TYPE", discriminatorType = DiscriminatorType.STRING)
@org.hibernate.annotations.Entity(mutable = false)
@NamedQueries({
		@NamedQuery(name = "alertTotalByAccount", query = "select count(*) from AlertView a where a.account = :account and a.open = 1"),
		@NamedQuery(name = "maxAlertAgeByAccount", query = "select max(a.alertAge) from AlertView a where a.account = :account and a.open = 1") })
@Cacheable
public abstract class AlertView {

	public static final String hardwareType = "HARDWARE";

	public static final String hardwareLparType = "HARDWARE_LPAR";

	public static final String softwareLparType = "SOFTWARE_LPAR";

	public static final String expiredScanType = "EXPIRED_SCAN";

	public static final String expiredMaintType = "EXPIRED_MAINT";

	public static final int yellow = 45;

	public static final int red = 90;

	@Id
	@Column(name = "PK")
	private String id;

	@Column(name = "ID")
	private Long tableId;

	@ManyToOne
	@JoinColumn(name = "CUSTOMER_ID", nullable = false)
	private Account account;

	@Column(name = "COMMENTS")
	private String comments;

	@Column(name = "REMOTE_USER", nullable = false)
	private String remoteUser;

	@Column(name = "ALERT_AGE", nullable = true)
	private Integer alertAge;

	@Column(name = "CREATION_TIME", nullable = false)
	private Date creationTime;

	@Column(name = "RECORD_TIME", nullable = false)
	private Date recordTime;

	@Column(name = "OPEN", nullable = false)
	private boolean open;

	@Column(name = "TYPE", insertable = false, updatable = false, nullable = false)
	private String type;

	@Column(name = "DISPLAY_NAME", nullable = false)
	private String displayName;

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
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

	public String getId() {
		return id;
	}

	public void setId(String id) {
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

	public Integer getAlertAge() {
		return alertAge;
	}

	public void setAlertAge(Integer alertAge) {
		this.alertAge = alertAge;
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

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getAlertStatus() {
		if (getAlertAge() > red) {
			return "<font class=\"alert-stop\">Red</font>";
		} else if (getAlertAge() > yellow) {
			return "<font class=\"orange-med\">Yellow</font>";
		} else {
			return "<font class=\"alert-go\">Green</font>";
		}
	}

	public Long getTableId() {
		return tableId;
	}

	public void setTableId(Long tableId) {
		this.tableId = tableId;
	}
}
