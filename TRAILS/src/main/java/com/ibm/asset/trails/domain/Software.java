package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.*;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import java.sql.Timestamp;


/**
 * The persistent class for the SOFTWARE database table.
 * 
 */
@Entity
@Table(name = "SOFTWARE")
@NamedQuery(name="Software.findAll", query="SELECT s FROM Software s")
public class Software extends AbstractDomainEntity {
	private static final long serialVersionUID = 1L;

	@Column(name="CHANGE_JUSTIFICATION")
	private String changeJustification;

	private String comments;

	@Column(name="\"LEVEL\"")
	private String level;

	@Column(name="MANUFACTURER_ID")
	private long manufacturerId;

	@Column(name="\"PRIORITY\"")
	private int priority;

	@Column(name="RECORD_TIME")
	private Timestamp recordTime;

	@Column(name="REMOTE_USER")
	private String remoteUser;

	@Column(name="SOFTWARE_CATEGORY_ID")
	private long softwareCategoryId;

	@Column(name="SOFTWARE_ID")
	private long softwareId;

	@Column(name="SOFTWARE_NAME")
	private String softwareName;

	@Column(name="\"STATUS\"")
	private String status;

	@Column(name="\"TYPE\"")
	private String type;

	@Column(name="VENDOR_MANAGED")
	private int vendorManaged;

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

	public long getManufacturerId() {
		return this.manufacturerId;
	}

	public void setManufacturerId(long manufacturerId) {
		this.manufacturerId = manufacturerId;
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
	
	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof Software))
			return false;
		Software castOther = (Software) other;
		return new EqualsBuilder().append(softwareId,
				castOther.softwareId).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(softwareId).toHashCode();
	}

}