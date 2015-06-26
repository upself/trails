package com.ibm.asset.trails.domain;

import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "LICENSE")
@org.hibernate.annotations.Entity
@NamedQueries({
		@NamedQuery(name = "licenseTotalByAccount", query = "SELECT COUNT(*) FROM License L WHERE L.account.id = :account AND L.status = 'ACTIVE'"),
		@NamedQuery(name = "licenseBaseline", query = "SELECT L.id AS licenseId, L.fullDesc AS fullDesc,  CASE LENGTH(COALESCE(sw.softwareName, '')) WHEN 0 THEN 'No' ELSE 'Yes' END AS catalogMatch, COALESCE(sw.softwareName, L.fullDesc) AS productName, L.swproPID AS swproPID, L.capacityType.code AS capTypeCode, L.capacityType.description AS capTypeDesc, coalesce(L.quantity - sum(LUQV.usedQuantity),l.quantity) AS availableQty, L.quantity AS quantity, L.expireDate AS expireDate, L.cpuSerial AS cpuSerial, L.extSrcId AS extSrcId, L.account.account AS ownerAccountNumber FROM License L LEFT OUTER JOIN L.usedLicenses LUQV LEFT OUTER JOIN L.software sw WHERE L.account.id = :account AND L.status = 'ACTIVE' group by L.id, L.fullDesc, CASE LENGTH(COALESCE(sw.softwareName, '')) WHEN 0 THEN 'No' ELSE 'Yes' END, COALESCE(sw.softwareName, L.fullDesc), L.swproPID, L.capacityType.code, L.capacityType.description, L.quantity, L.expireDate, L.cpuSerial, L.extSrcId, L.account.account"),
		@NamedQuery(name = "freePoolReport", query = "SELECT COALESCE(sw.softwareName, L.fullDesc), CASE LENGTH(COALESCE(sw.softwareName, '')) WHEN 0 THEN 'No' ELSE 'Yes' END, L.fullDesc, L.swproPID, CONCAT(CONCAT(RTRIM(CHAR(L.capacityType.code)), '-'), L.capacityType.description), L.environment, L.quantity, coalesce(L.quantity - sum(LUQV.usedQuantity),L.quantity), L.expireDate, L.poNumber, L.cpuSerial, CASE L.ibmOwned WHEN 1 THEN 'IBM' ELSE 'Cust' END, L.extSrcId, L.pool, L.recordTime FROM License L LEFT OUTER JOIN L.usedLicenses LUQV LEFT OUTER JOIN L.software sw WHERE L.account.account = :account AND L.status = 'ACTIVE' group by sw.softwareName, L.fullDesc, L.swproPID, CASE LENGTH(COALESCE(sw.softwareName, '')) WHEN 0 THEN 'No' ELSE 'Yes' END, CONCAT(CONCAT(RTRIM(CHAR(L.capacityType.code)), '-'), L.capacityType.description), L.environment, L.quantity, L.expireDate, L.poNumber, L.cpuSerial, CASE L.ibmOwned WHEN 1 THEN 'IBM' ELSE 'Cust' END, L.extSrcId, L.pool, L.recordTime having coalesce(l.quantity - sum(LUQV.usedQuantity),l.quantity) > 0 ORDER BY sw.softwareName ASC"),
		@NamedQuery(name = "licenseDetails", query = "FROM License L JOIN fetch l.account join fetch l.capacityType LEFT OUTER JOIN FETCH L.software LEFT OUTER JOIN FETCH L.usedLicenses WHERE L.id = :id"),
		@NamedQuery(name = "productNameByAccount", query = "SELECT DISTINCT(l.prodName) From License l WHERE l.account.id=:accountId and UPPER(l.prodName) like :key and ((l.account.softwareFinancialResponsibility='IBM' and l.ibmOwned=true) or (l.account.softwareFinancialResponsibility='CUSTOMER' and l.ibmOwned=false) or l.account.softwareFinancialResponsibility='BOTH' or l.account.softwareFinancialResponsibility in ('IBM','CUSTOMER','BOTH') ) and l.status='ACTIVE' ORDER BY l.prodName ASC"),
		@NamedQuery(name = "manufacturerNameByAccount", query = "SELECT DISTINCT(l.software.manufacturer.manufacturerName) From License l WHERE l.account.id=:accountId and UPPER(l.software.manufacturer.manufacturerName) like :key and ((l.account.softwareFinancialResponsibility='IBM' and l.ibmOwned=true) or (l.account.softwareFinancialResponsibility='CUSTOMER' and l.ibmOwned=false) or l.account.softwareFinancialResponsibility='BOTH' or l.account.softwareFinancialResponsibility in ('IBM','CUSTOMER','BOTH') ) and l.status='ACTIVE' ORDER BY l.software.manufacturer.manufacturerName ASC") })
public class License extends AbstractDomainEntity {
	private static final long serialVersionUID = 6487639250238014719L;

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinTable(name = "LICENSE_SW_MAP", joinColumns = { @JoinColumn(name = "LICENSE_ID") }, inverseJoinColumns = { @JoinColumn(name = "SOFTWARE_ID", referencedColumnName = "SOFTWARE_ID") })
	private Software software;

	@Column(name = "PO_NUMBER")
	private String poNumber;

	@Column(name = "CPU_SERIAL")
	private String cpuSerial;

	@Column(name = "IBM_OWNED")
	private Boolean ibmOwned;

	@Column(name = "EXPIRE_DATE")
	private Date expireDate;

	@Column(name = "QUANTITY")
	private Integer quantity;

	@Column(name = "FULL_DESC")
	private String fullDesc;

	@Column(name = "PROD_NAME")
	private String prodName;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CAP_TYPE")
	private CapacityType capacityType;

	@Column(name = "LIC_TYPE")
	private String licenseType;

	@Column(name = "VERSION")
	private String version;

	@Column(name = "EXT_SRC_ID")
	private String extSrcId;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "STATUS")
	private String status;

	@Column(name = "TRY_AND_BUY")
	private boolean tryAndBuy;

	@OneToMany(mappedBy = "license", fetch = FetchType.LAZY)
	private Set<UsedLicense> usedLicenses;

	@OneToMany(mappedBy = "license", fetch = FetchType.LAZY)
	private Set<UsedLicenseHistory> usedLicenseHistories;

	@Column(name = "POOL")
	private Integer pool;

	@Column(name = "ENVIRONMENT")
	private String environment;
	
	@Column(name = "PID")
	private String swproPID;

	public String getEnvironment() {
		return environment;
	}

	public void setEnvironment(String environment) {
		this.environment = environment;
	}

	public int getAvailableQty() {
		int result = this.quantity;
		if (usedLicenses == null || usedLicenses.isEmpty()) {
			result = this.quantity;
		} else {
			for (UsedLicense ul : usedLicenses) {
				result = result - ul.getUsedQuantity();
			}
		}
		return result;
	}

	public String getPoolAsString() {
		return getPool().intValue() == 1 ? "Yes" : "No";
	}

	public String getProductName() {
		if (getSoftware() != null) {
			String lsSoftwareName = getSoftware().getSoftwareName();

			return lsSoftwareName != null && lsSoftwareName.length() > 0 ? lsSoftwareName
					: getFullDesc();
		} else {
			return getFullDesc();
		}
	}

	public String getCatalogMatch() {
		if (getSoftware() != null) {
			String lsSoftwareName = getSoftware().getSoftwareName();

			return lsSoftwareName != null && lsSoftwareName.length() > 0 ? "Yes"
					: "No";
		} else {
			return "No";
		}
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public CapacityType getCapacityType() {
		return capacityType;
	}

	public void setCapacityType(CapacityType capacityType) {
		this.capacityType = capacityType;
	}

	public String getCpuSerial() {
		return cpuSerial;
	}

	public void setCpuSerial(String cpuSerial) {
		this.cpuSerial = cpuSerial;
	}

	public Date getExpireDate() {
		return expireDate;
	}

	public void setExpireDate(Date expireDate) {
		this.expireDate = expireDate;
	}

	public String getExtSrcId() {
		return extSrcId;
	}

	public void setExtSrcId(String extSrcId) {
		this.extSrcId = extSrcId;
	}

	public String getFullDesc() {
		return fullDesc;
	}

	public void setFullDesc(String fullDesc) {
		this.fullDesc = fullDesc;
	}

	public Boolean getIbmOwned() {
		return ibmOwned;
	}

	public void setIbmOwned(Boolean ibmOwned) {
		this.ibmOwned = ibmOwned;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getPoNumber() {
		return poNumber;
	}

	public void setPoNumber(String poNumber) {
		this.poNumber = poNumber;
	}

	public Integer getPool() {
		return pool;
	}

	public void setPool(Integer pool) {
		this.pool = pool;
	}

	public String getProdName() {
		return prodName;
	}

	public void setProdName(String prodName) {
		this.prodName = prodName;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof License))
			return false;
		License castOther = (License) other;
		return new EqualsBuilder().append(extSrcId, castOther.extSrcId)
				.isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(extSrcId).toHashCode();
	}

	public void setUsedLicenseHistories(
			Set<UsedLicenseHistory> usedLicenseHistories) {
		this.usedLicenseHistories = usedLicenseHistories;
	}

	public Set<UsedLicenseHistory> getUsedLicenseHistories() {
		return usedLicenseHistories;
	}

	public void setUsedLicenses(Set<UsedLicense> usedLicenses) {
		this.usedLicenses = usedLicenses;
	}

	public Set<UsedLicense> getUsedLicenses() {
		return usedLicenses;
	}

	public void setSoftware(Software software) {
		this.software = software;
	}

	public Software getSoftware() {
		return software;
	}

	public String getLicenseType() {
		return licenseType;
	}

	public void setLicenseType(String licenseType) {
		this.licenseType = licenseType;
	}

	public boolean isTryAndBuy() {
		return tryAndBuy;
	}

	public void setTryAndBuy(boolean tryAndBuy) {
		this.tryAndBuy = tryAndBuy;
	}

	public String getSwproPID() {
		return swproPID;
	}

	public void setSwproPID(String swproPID) {
		this.swproPID = swproPID;
	}
}
