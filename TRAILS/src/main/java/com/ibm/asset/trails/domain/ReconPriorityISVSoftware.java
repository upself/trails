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
@Table(name = "RECON_PRIORITY_ISV_SW")
@NamedQueries({@NamedQuery(name = "findReconPriorityISVSoftwareByUniqueKeys1", query = "FROM ReconPriorityISVSoftware rPISVSW WHERE rPISVSW.account.id is null and rPISVSW.manufacturer.id =:manufacturerId") 
              ,@NamedQuery(name = "findReconPriorityISVSoftwareByUniqueKeys2", query = "FROM ReconPriorityISVSoftware rPISVSW WHERE rPISVSW.account.id = :customerId and rPISVSW.manufacturer.id =:manufacturerId")})
public class ReconPriorityISVSoftware extends AbstractDomainEntity {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID", nullable = true)
	private Account account;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MANUFACTURER_ID", nullable = false)
	private Manufacturer manufacturer;
	
	@Column(name = "ACTION",  nullable = false)
	private String action;

	@Column(name = "REMOTE_USER", nullable = false)
	private String remoteUser;

	@Column(name = "RECORD_TIME",  nullable = false)
	private Date recordTime;

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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

	public Manufacturer getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
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
