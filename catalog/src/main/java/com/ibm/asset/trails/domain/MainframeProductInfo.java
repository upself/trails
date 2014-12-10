/**
 * 
 */
package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Parameter;

/**
 * @author zhangyi
 * 
 */
@Entity
@Table(name = "PRODUCT_INFO")
public class MainframeProductInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7673013153360069518L;

	@Id
	@GeneratedValue(generator = "mfGenerator")
	@GenericGenerator(name = "mfGenerator", strategy = "foreign", parameters = @Parameter(name = "property", value = "softwerItem"))
	protected Long id;

	@OneToOne(optional = true)
	@PrimaryKeyJoinColumn
	private SoftwareItem softwerItem;

	@Basic
	@Column(name = "SOFTWARE_CATEGORY_ID")
	protected Long softwareCategoryId;

	@Basic
	@Column(name = "PRIORITY")
	protected Integer priority;

	@Basic
	@Column(name = "LICENSABLE")
	protected boolean licensable;

	@Basic
	@Column(name = "CHANGE_JUSTIFICATION")
	protected String changeJustification;

	@Basic
	@Column(name = "REMOTE_USER")
	protected String remoteUser;

	@Basic
	@Column(name = "RECORD_TIME")
	protected Date recordTime;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getSoftwareCategoryId() {
		return softwareCategoryId;
	}

	public void setSoftwareCategoryId(Long softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}

	public Integer getPriority() {
		return priority;
	}

	public void setPriority(Integer priority) {
		this.priority = priority;
	}

	public boolean isLicensable() {
		return licensable;
	}

	public void setLicensable(boolean licensable) {
		this.licensable = licensable;
	}

	public String getChangeJustification() {
		return changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
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

	public SoftwareItem getSoftwerItem() {
		return softwerItem;
	}

	public void setSoftwerItem(SoftwareItem softwerItem) {
		this.softwerItem = softwerItem;
	}

}
