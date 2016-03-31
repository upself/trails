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
@Table(name = "SCHEDULE_F_H")
@NamedQueries({
		@NamedQuery(name = "findscheduleFHIdTotal", query = "select count(*) from ScheduleFH  where scheduleF =:scheduleF"),
		@NamedQuery(name = "scheduleFHList", query = "FROM ScheduleFH SH JOIN FETCH SH.scheduleF WHERE SH.scheduleF.id =:scheduleFId ") })
public class ScheduleFH {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

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

	@ManyToOne
	@JoinColumn(name = "SCHEDULE_F_ID")
	private ScheduleF scheduleF;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_ID", referencedColumnName = "SOFTWARE_ID")
	private Software software;

	@Column(name = "SOFTWARE_TITLE")
	private String softwareTitle;

	@Column(name = "SOFTWARE_NAME")
	private String softwareName;

	@Column(name = "MANUFACTURER")
	private String manufacturer;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "SCOPE_ID")
	private Scope scope;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "SOURCE_ID")
	private Source source;

	@Column(name = "SOURCE_LOCATION")
	private String sourceLocation;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "STATUS_ID")
	private Status status;

	@Column(name = "BUSINESS_JUSTIFICATION")
	private String businessJustification;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	// AB added begin
	@Column(name = "SW_FINANCIAL_RESP")
	private String SWFinanceResp;

	public void setSWFinanceResp(String sWFinanceResp) {
		SWFinanceResp = sWFinanceResp;
	}

	public String getSWFinanceResp() {
		return SWFinanceResp;
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

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public String getBusinessJustification() {
		return businessJustification;
	}

	public void setBusinessJustification(String businessJustification) {
		this.businessJustification = businessJustification;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
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

	public ScheduleF getScheduleF() {
		return scheduleF;
	}

	public void setScheduleF(ScheduleF scheduleF) {
		this.scheduleF = scheduleF;
	}

	public Scope getScope() {
		return scope;
	}

	public void setScope(Scope scope) {
		this.scope = scope;
	}

	public Software getSoftware() {
		return software;
	}

	public void setSoftware(Software software) {
		this.software = software;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getSoftwareTitle() {
		return softwareTitle;
	}

	public void setSoftwareTitle(String softwareTitle) {
		this.softwareTitle = softwareTitle;
	}

	public Source getSource() {
		return source;
	}

	public void setSource(Source source) {
		this.source = source;
	}

	public String getSourceLocation() {
		return sourceLocation;
	}

	public void setSourceLocation(String sourceLocation) {
		this.sourceLocation = sourceLocation;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

}
