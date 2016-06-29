package com.ibm.asset.trails.domain;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "SCHEDULE_F")
@NamedQueries({
		@NamedQuery(name = "findScheduleFTotal",query="select count(*) from ScheduleF where account=:account"),
		@NamedQuery(name = "findScheduleFByAccountAndSw", query = "FROM ScheduleF WHERE account = :account AND software.softwareName = :softwareName"),
		@NamedQuery(name = "findScheduleFByAccountAndSwNotId", query = "FROM ScheduleF WHERE account = :account AND software.softwareName = :softwareName AND id = :id"),
		@NamedQuery(name = "findScheduleFById", query = "FROM ScheduleF SF JOIN FETCH SF.account WHERE SF.id = :id"),
		@NamedQuery(name = "scheduleFDetails", query = "FROM ScheduleF SF LEFT OUTER JOIN FETCH SF.scheduleFHList JOIN FETCH SF.account WHERE SF.id = :id"),
		@NamedQuery(name = "scheduleFList", query = "FROM ScheduleF SF JOIN FETCH SF.account WHERE SF.account = :account"),
		@NamedQuery(name = "findScheduleFByAccountAndSwAndLevel", query = "FROM ScheduleF SF JOIN FETCH SF.account WHERE SF.account = :account AND SF.softwareName = :softwareName AND SF.level = :level"),
		@NamedQuery(name = "findScheduleFByAccountAndManAndLevel", query = "FROM ScheduleF SF JOIN FETCH SF.account WHERE SF.software is null AND SF.account = :account AND SF.manufacturerName = :manufacturerName  AND SF.level = :level")})
public class ScheduleF {

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

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_ID", referencedColumnName="SOFTWARE_ID")
	private Software software;

	@Column(name = "SOFTWARE_TITLE")
	private String softwareTitle;

	@Column(name = "SOFTWARE_NAME")
	private String softwareName;

	@Column(name = "MANUFACTURER")
	private String manufacturer;
	
	@Column(name = "MANUFACTURER_NAME")
	private String manufacturerName;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "SCOPE_ID")
	private Scope scope;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "SOURCE_ID")
	private Source source;
	
	//AB added begin
	@Column(name="SW_FINANCIAL_RESP")
	private String SWFinanceResp;
	
	public String getSWFinanceResp() {
		return SWFinanceResp;
	}

	public void setSWFinanceResp(String sWFinanceResp) {
		SWFinanceResp = sWFinanceResp;
	}
	//AB added end
	
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

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "scheduleF")
	private List<ScheduleFH> scheduleFHList = new ArrayList<ScheduleFH>();

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
	
	public String getManufacturerName() {
		return manufacturerName;
	}

	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
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

	public List<ScheduleFH> getScheduleFHList() {
		return scheduleFHList;
	}

	public void setScheduleFHList(List<ScheduleFH> scheduleFHList) {
		this.scheduleFHList = scheduleFHList;
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

	@Override
	public boolean equals(Object o) {
		if (o instanceof ScheduleF) {

			// check are these object same, writing them separately for easy
			// reading.
			ScheduleF other = (ScheduleF) o;
			if(null != this.getSoftwareTitle() && null != other.getSoftwareTitle()){
			    if (!this.getSoftwareTitle().equals(other.getSoftwareTitle())) {
				   return false;
			    }
			}
			
			if (!this.getManufacturer().equals(other.getManufacturer())) {
				return false;
			}
			
			if(null != this.getManufacturerName() && null != other.getManufacturerName()){
				if (!this.getManufacturerName().equals(other.getManufacturerName())) {
					return false;
				}
			}

			if (!this.getScope().getId().equals(other.getScope().getId())) {
				return false;
			}

			if (!this.getSource().getId().equals(other.getSource().getId())) {
				return false;
			}

			if (!this.getSourceLocation().equals(other.getSourceLocation())) {
				return false;
			}

			if (!this.getStatus().getId().equals(other.getStatus().getId())) {
				return false;
			}

			if (!this.getLevel().equals(other.getLevel())) {
				return false;
			}
			//AB added
			if (this.getSWFinanceResp() != null && other.getSWFinanceResp() != null) {
				if (!this.getSWFinanceResp().equals(other.getSWFinanceResp())) {
					return false;
				}
			} else if (!((this.getSWFinanceResp() == null ||this.getSWFinanceResp() == "") && (other.getSWFinanceResp() == null || other.getSWFinanceResp() == ""))) {
				return false;
			}
			
			if (this.getHwOwner() != null && other.getHwOwner() != null) {
				if (!this.getHwOwner().equals(other.getHwOwner())) {
					return false;
				}
			} else if (!((this.getHwOwner() == null ||this.getHwOwner() == "") && (other.getHwOwner() == null || other.getHwOwner() == ""))) {
				return false;
			}

			if (this.getSerial() != null && other.getSerial() != null) {
				if (!this.getSerial().equals(other.getSerial())) {
					return false;
				}
			} else if (!((this.getSerial() == null || this.getSerial() == "") && (other.getSerial() == null || other.getSerial() == "" ))
					) {
				return false;
			}

			if (this.getMachineType() != null && other.getMachineType() != null) {
				if (!this.getMachineType().equals(other.getMachineType())) {
					return false;
				}
			} else if (!((this.getMachineType() == null || this.getMachineType() == "" ) && (other.getMachineType() == null || other.getMachineType() == ""))
					) {
				return false;
			}

			if (this.getHostname() != null && other.getHostname() != null) {
				if (!this.getHostname().equals(other.getHostname())) {
					return false;
				}
			} else if (!((this.getHostname() == null || this.getHostname() == "" ) && ( other.getHostname() == null ||  other.getHostname() == "" ))
					) {
				return false;
			}

			return true;
		}
		return super.equals(o);
	}
	/*
	 * add Keyquals method to filter duplicating record 
	 *  according to unique key of recon 
	 * 
	 * software_name +level + HW_OWNER+ serial+ machine_type + hostname
	 */
	public boolean Keyquals(Object o) {
		if (o instanceof ScheduleF) {

			ScheduleF other = (ScheduleF) o;

			if(null != this.getSoftwareName() && null != other.getSoftwareName()){
				if (!this.getSoftwareName().equals(other.getSoftwareName())) {
					  return false;
				 }
			}

			if (!this.getLevel().equals(other.getLevel())) {
				return false;
			}
	
			if (this.getHwOwner() != null && other.getHwOwner() != null) {
				if (!this.getHwOwner().equals(other.getHwOwner())) {
					return false;
				}
			} else if (!((this.getHwOwner() == null ||this.getHwOwner() == "") && (other.getHwOwner() == null || other.getHwOwner() == ""))) {
				return false;
			}

			if (this.getSerial() != null && other.getSerial() != null) {
				if (!this.getSerial().equals(other.getSerial())) {
					return false;
				}
			} else if (!((this.getSerial() == null || this.getSerial() == "") && (other.getSerial() == null || other.getSerial() == "" ))
					) {
				return false;
			}

			if (this.getMachineType() != null && other.getMachineType() != null) {
				if (!this.getMachineType().equals(other.getMachineType())) {
					return false;
				}
			} else if (!((this.getMachineType() == null || this.getMachineType() == "" ) && (other.getMachineType() == null || other.getMachineType() == ""))
					) {
				return false;
			}

			if (this.getHostname() != null && other.getHostname() != null) {
				if (!this.getHostname().equals(other.getHostname())) {
					return false;
				}
			} else if (!((this.getHostname() == null || this.getHostname() == "" ) && ( other.getHostname() == null ||  other.getHostname() == "" ))
					) {
				return false;
			}
			
			if( this.getLevel().equals(ScheduleFLevelEnumeration.MANUFACTURER.toString()) && other.getLevel().equals(ScheduleFLevelEnumeration.MANUFACTURER.toString())){
				if (!this.getManufacturer().equals(other.getManufacturer())) {
					return false;
				}
			}

			return true;
		}
       return super.equals(o);
	}
}
