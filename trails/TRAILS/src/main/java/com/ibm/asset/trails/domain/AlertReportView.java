package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


@Entity
@Table(name = "V_ALERT_REPORT")
@org.hibernate.annotations.Entity(mutable = false)
public abstract class AlertReportView {

	@Id
	@Column(name = "PK")
	private String id;

	@ManyToOne
	@JoinColumn(name = "CUSTOMER_ID", nullable = false)
	private Account account;

	@Column(name = "OPEN", nullable = false)
	private boolean open;

	@Column(name = "ASSIGNED", nullable = false)
	private Integer assigned;

	@Column(name = "RED", nullable = false)
	private Integer red;

	@Column(name = "YELLOW", nullable = false)
	private Integer yellow;

	@Column(name = "GREEN", nullable = false)
	private Integer green;

	@Column(name = "DISPLAY_NAME", nullable = false)
	private String displayName;

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public Integer isAssigned() {
		return assigned;
	}

	public void setAssigned(Integer assigned) {
		this.assigned = assigned;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public Integer getGreen() {
		return green;
	}

	public void setGreen(Integer green) {
		this.green = green;
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

	public Integer getRed() {
		return red;
	}

	public void setRed(Integer red) {
		this.red = red;
	}

	public Integer getYellow() {
		return yellow;
	}

	public void setYellow(Integer yellow) {
		this.yellow = yellow;
	}

}
