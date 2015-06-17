package com.ibm.asset.trails.domain;

import java.sql.Timestamp;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

/**
 * The persistent class for the SOFTWARE database table.
 * 
 */
@Entity
@Table(name = "SOFTWARE")
@org.hibernate.annotations.Entity
@NamedQueries({
		@NamedQuery(name = "Software.findAll", query = "FROM Software s"),
		@NamedQuery(name = "softwareDetail", query = "FROM Software s where s.softwareId=:softwareId"),

		@NamedQuery(name = "softwareBySoftwareName", query = "FROM Software WHERE UCASE(softwareName) = :name and status = 'ACTIVE' order by PRODUCT_ROLE desc"),
		@NamedQuery(name = "inactiveSoftwareBySoftwareName", query = "FROM Software WHERE UCASE(softwareName) = :name order by PRODUCT_ROLE desc"),
		//@NamedQuery(name = "softwareByAliasName", query = "FROM Software sw JOIN sw.productInfo.alias AS A where UCASE(A.name) = :name and status = 'ACTIVE' order by sw.productRole desc"),
		@NamedQuery(name = "softwareByAliasName", query = "FROM Software sw JOIN sw.productInfo.alias AS A where UCASE(A.name) = :name and sw.status = 'ACTIVE' order by sw.productRole desc"),
		@NamedQuery(name = "inactiveSoftwareByAliasName", query = "FROM Software sw JOIN sw.productInfo.alias AS A where UCASE(A.name) = :name order by sw.productRole desc") })
public class Software extends AbstractDomainEntity {
	private static final long serialVersionUID = 1L;

	@Column(name = "CHANGE_JUSTIFICATION")
	private String changeJustification;

	@Column(name = "comments")
	private String comments;

	@Column(name = "LEVEL")
	private String level;

	@ManyToOne(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY)
	private Manufacturer manufacturer;

	@Column(name = "PRIORITY", nullable = true)
	private int priority;

	@Column(name = "RECORD_TIME")
	private Timestamp recordTime;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "SOFTWARE_CATEGORY_ID", nullable = true)
	private long softwareCategoryId;

	@Id
	@Column(name = "SOFTWARE_ID")
	private long softwareId;

	@Column(name = "SOFTWARE_NAME")
	private String softwareName;

	@Column(name = "STATUS")
	private String status;

	@Column(name = "TYPE")
	private String type;

	@Column(name = "VENDOR_MANAGED")
	private int vendorManaged;

	@Column(name = "PRODUCT_ROLE")
	private String productRole;

	@Column(name = "VERSION")
	private String version;
	
	@Column(name = "PID")
	private String pid;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_ID", referencedColumnName="ID")
	private ProductInfo productInfo;

	public Software() {
	}

	public String getChangeJustification() {
		return this.changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public String getComments() {
		return this.comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getLevel() {
		return this.level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public Manufacturer getManufacturerId() {
		return this.manufacturer;
	}

	public void setManufacturerId(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}

	public int getPriority() {
		return this.priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public Timestamp getRecordTime() {
		return this.recordTime;
	}

	public void setRecordTime(Timestamp recordTime) {
		this.recordTime = recordTime;
	}

	public String getRemoteUser() {
		return this.remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public long getSoftwareCategoryId() {
		return this.softwareCategoryId;
	}

	public void setSoftwareCategoryId(long softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}

	public long getSoftwareId() {
		return this.softwareId;
	}

	public void setSoftwareId(long softwareId) {
		this.softwareId = softwareId;
	}

	public String getSoftwareName() {
		return this.softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getVendorManaged() {
		return this.vendorManaged;
	}

	public void setVendorManaged(int vendorManaged) {
		this.vendorManaged = vendorManaged;
	}

	public String getProductRole() {
		return productRole;
	}

	public void setProductRole(String productRole) {
		this.productRole = productRole;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof Software))
			return false;
		Software castOther = (Software) other;

		return new EqualsBuilder().append(softwareId, castOther.softwareId)
				.isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(softwareId).toHashCode();
	}

}

