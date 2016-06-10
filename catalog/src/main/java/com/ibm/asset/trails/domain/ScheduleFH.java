package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "SCHEDULE_F_H")
@org.hibernate.annotations.Entity
@Cacheable
public class ScheduleFH  extends DomainEntity implements Serializable{


	private static final long serialVersionUID = -6203943942246313660L;
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "SCHEDULE_F_ID")
	private ScheduleF scheduleF;
	
	@Column(name = "SOFTWARE_ID")
	private Long softwareId;

	@Column(name = "SOFTWARE_TITLE")
	private String softwareTitle;

	@Column(name = "SOFTWARE_NAME")
	private String softwareName;

	@Column(name = "MANUFACTURER")
	private String manufacturer;
	
	@Column(name = "LEVEL")
	private String level;

	@Column(name = "HW_OWNER")
	private String hwOwner;

	@Column(name = "SERIAL")
	private String serial;

	@Column(name = "MACHINE_TYPE")
	private String machineType;

	@Column(name = "HOSTNAME")
	private String hostname;

	@Column(name = "CUSTOMER_ID")
	private Long customerId;
	
	@Column(name = "STATUS_ID")
	private Long statusId;

	@Column(name = "SCOPE_ID")
	private Long scopeId;

	@Column(name = "SOURCE_ID")
	private Long sourceId;
	
	@Column(name="SW_FINANCIAL_RESP")
	private String SWFinanceResp;
	
	@Column(name = "BUSINESS_JUSTIFICATION")
	private String businessJustification;
	
	@Column(name = "SOURCE_LOCATION")
	private String sourceLocation;
	
	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ScheduleF getScheduleF() {
		return scheduleF;
	}

	public void setScheduleF(ScheduleF scheduleF) {
		this.scheduleF = scheduleF;
	}

	public Long getSoftwareId() {
		return softwareId;
	}

	public void setSoftwareId(Long softwareId) {
		this.softwareId = softwareId;
	}

	public String getSoftwareTitle() {
		return softwareTitle;
	}

	public void setSoftwareTitle(String softwareTitle) {
		this.softwareTitle = softwareTitle;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getHwOwner() {
		return hwOwner;
	}

	public void setHwOwner(String hwOwner) {
		this.hwOwner = hwOwner;
	}

	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}

	public String getMachineType() {
		return machineType;
	}

	public void setMachineType(String machineType) {
		this.machineType = machineType;
	}

	public String getHostname() {
		return hostname;
	}

	public void setHostname(String hostname) {
		this.hostname = hostname;
	}

	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}

	public Long getStatusId() {
		return statusId;
	}

	public void setStatusId(Long statusId) {
		this.statusId = statusId;
	}

	public Long getScopeId() {
		return scopeId;
	}

	public void setScopeId(Long scopeId) {
		this.scopeId = scopeId;
	}

	public Long getSourceId() {
		return sourceId;
	}

	public void setSourceId(Long sourceId) {
		this.sourceId = sourceId;
	}

	public String getSWFinanceResp() {
		return SWFinanceResp;
	}

	public void setSWFinanceResp(String sWFinanceResp) {
		SWFinanceResp = sWFinanceResp;
	}

	public String getBusinessJustification() {
		return businessJustification;
	}

	public void setBusinessJustification(String businessJustification) {
		this.businessJustification = businessJustification;
	}

	public String getSourceLocation() {
		return sourceLocation;
	}

	public void setSourceLocation(String sourceLocation) {
		this.sourceLocation = sourceLocation;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

}
