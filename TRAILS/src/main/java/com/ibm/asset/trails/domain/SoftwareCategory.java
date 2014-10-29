package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "SOFTWARE_CATEGORY")
@org.hibernate.annotations.Entity(mutable = false)
public class SoftwareCategory implements Serializable {
	private static final long serialVersionUID = 5480882644728772153L;

	@Id
	@Column(name = "SOFTWARE_CATEGORY_ID")
	private Long softwareCategoryId;

	@Column(name = "SOFTWARE_CATEGORY_NAME")
	private String softwareCategoryName;

	@Column(name = "CHANGE_JUSTIFICATION")
	private String changeJustification;

	@Column(name = "COMMENTS")
	private String comments;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "STATUS")
	private String status;

	public String getChangeJustification() {
		return changeJustification;
	}

	public String getComments() {
		return comments;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public Long getSoftwareCategoryId() {
		return softwareCategoryId;
	}

	public String getSoftwareCategoryName() {
		return softwareCategoryName;
	}

	public String getStatus() {
		return status;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public void setSoftwareCategoryId(Long softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}

	public void setSoftwareCategoryName(String softwareCategoryName) {
		this.softwareCategoryName = softwareCategoryName;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
