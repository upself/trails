package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "V_ALERT_RED_AGING")
@org.hibernate.annotations.Entity(mutable = false)
@NamedQueries( { @NamedQuery(name = "alertRedAgingByAccount", query = "from AlertViewRedAging where customerId = :account") })
public class AlertViewRedAging {

	@Id
	@Column(name = "ID")
	private String id;

	@Column(name = "CUSTOMER_ID", nullable = false)
	private Long customerId;

	@Column(name = "ACCOUNT_NUMBER", nullable = false)
	private Long accountNumber;

	@Column(name = "CUSTOMER_TYPE", nullable = false)
	private String customerType;

	@Column(name = "DISPLAY_NAME", nullable = false)
	private String displayName;

	@Column(name = "ALERT_AGE", nullable = false)
	private Integer alertAge;

	@Column(name = "MACHINE_TYPE", nullable = true)
	private String machineType;

	@Column(name = "SERIAL", nullable = true)
	private String serial;

	@Column(name = "HARDWARE_LPAR_NAME", nullable = true)
	private String hardwareLparName;

	@Column(name = "SOFTWARE_LPAR_NAME", nullable = true)
	private String softwareLparName;

	@Column(name = "SOFTWARE_NAME", nullable = true)
	private String softwareName;

	public Long getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}

	public Integer getAlertAge() {
		return alertAge;
	}

	public void setAlertAge(Integer alertAge) {
		this.alertAge = alertAge;
	}

	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getHardwareLparName() {
		return hardwareLparName;
	}

	public void setHardwareLparName(String hardwareLparName) {
		this.hardwareLparName = hardwareLparName;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getMachineType() {
		return machineType;
	}

	public void setMachineType(String machineType) {
		this.machineType = machineType;
	}

	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}

	public String getSoftwareLparName() {
		return softwareLparName;
	}

	public void setSoftwareLparName(String softwareLparName) {
		this.softwareLparName = softwareLparName;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

}
