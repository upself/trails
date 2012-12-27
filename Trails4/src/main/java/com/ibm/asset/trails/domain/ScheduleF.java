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
@NamedQueries( {
		@NamedQuery(name = "findScheduleFByAccountAndSw", query = "FROM ScheduleF WHERE account = :account AND productInfo = :productInfo"),
		@NamedQuery(name = "findScheduleFByAccountAndSwNotId", query = "FROM ScheduleF WHERE account = :account AND productInfo = :productInfo AND id = :id"),
		@NamedQuery(name = "findScheduleFById", query = "FROM ScheduleF SF JOIN FETCH SF.account JOIN FETCH SF.productInfo WHERE SF.id = :id"),
		@NamedQuery(name = "scheduleFDetails", query = "FROM ScheduleF SF LEFT OUTER JOIN FETCH SF.scheduleFHList JOIN FETCH SF.account WHERE SF.id = :id"),
		@NamedQuery(name = "scheduleFList", query = "FROM ScheduleF SF JOIN FETCH SF.account WHERE SF.account = :account") })
public class ScheduleF {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_ID")
	private ProductInfo productInfo;

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

	public ProductInfo getProductInfo() {
		return productInfo;
	}

	public void setProductInfo(ProductInfo productInfo) {
		this.productInfo = productInfo;
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

	@Override
	public boolean equals(Object o) {
		if (o instanceof ScheduleF) {

			// check are these object same, writing them separately for easy
			// reading.
			ScheduleF other = (ScheduleF) o;
			if (!this.getSoftwareTitle().equals(other.getSoftwareTitle())) {
				return false;
			}
			if (!this.getSoftwareName().equals(other.getSoftwareName())) {
				return false;
			}

			if (!this.getManufacturer().equals(other.getManufacturer())) {
				return false;
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

			return true;
		}
		return super.equals(o);
	}
	/*
	 * public Set<ScheduleFH> getScheduleFHSet() { return scheduleFHSet; }
	 * 
	 * public void setScheduleFHSet(Set<ScheduleFH> scheduleFHSet) {
	 * this.scheduleFHSet = scheduleFHSet; }
	 */
}
