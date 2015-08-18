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
@Table(name = "PRIORITY_ISV_SW")
@NamedQueries({@NamedQuery(name = "findPriorityISVTotal", query = "SELECT COUNT(*) FROM PriorityISVSoftware")
			  ,@NamedQuery(name = "findPriorityISVSoftwareByUniqueKeys1", query = "from PriorityISVSoftware pISVSW where UCASE(pISVSW.level) = :level and pISVSW.manufacturer.id = :manufacturerId and pISVSW.account.id = :customerId and pISVSW.status.description = 'ACTIVE' order by pISVSW.manufacturer.id asc") 
              ,@NamedQuery(name = "findPriorityISVSoftwareByUniqueKeys2", query = "from PriorityISVSoftware pISVSW where UCASE(pISVSW.level) = :level and pISVSW.manufacturer.id = :manufacturerId and pISVSW.status.description = 'ACTIVE' order by pISVSW.manufacturer.id asc")
              ,@NamedQuery(name = "findPriorityISVSoftwareBymanufacturerId", query = "from PriorityISVSoftware pISVSW where  pISVSW.manufacturer.id = :manufacturerId and pISVSW.status.description = 'ACTIVE' order by pISVSW.manufacturer.id asc")})

public class PriorityISVSoftware extends AbstractDomainEntity {
	private static final long serialVersionUID = -1570160658765275811L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@Column(name = "LEVEL", length=8, nullable = false)
	private String level;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "CUSTOMER_ID", nullable = true)
	private Account account;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "MANUFACTURER_ID", nullable = false)
	private Manufacturer manufacturer;

	@Column(name = "EVIDENCE_LOCATION", nullable = false)
	private String evidenceLocation;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "STATUS_ID", nullable = false)
	private Status status;
	
	@Column(name = "BUSINESS_JUSTIFICATION", nullable = false)
	private String businessJustification;
	
	@Column(name="REMOTE_USER", nullable = false)
	private String remoteUser;
	
	@Column(name="RECORD_TIME", nullable = false)
	private Date recordTime;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public Manufacturer getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}

	public String getEvidenceLocation() {
		return evidenceLocation;
	}

	public void setEvidenceLocation(String evidenceLocation) {
		this.evidenceLocation = evidenceLocation;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public String getBusinessJustification() {
		return businessJustification;
	}

	public void setBusinessJustification(String businessJustification) {
		this.businessJustification = businessJustification;
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

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return 0;
	}
}
