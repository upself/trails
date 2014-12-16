/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.software;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import org.apache.struts.validator.ValidatorActionForm;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategory;

@Entity(name = "ProductInfo")
@Table(name = "PRODUCT_INFO")
public class ProductInfo extends ValidatorActionForm implements Serializable {

	private static final long serialVersionUID = -997959136881916526L;

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinColumn(name = "SOFTWARE_CATEGORY_ID")
	private SoftwareCategory softwareCategory;

	@Basic
	@Column(name = "PRIORITY")
	private Integer priority;

	@Basic
	@Column(name = "LICENSABLE")
	private boolean licensable;

	@Basic
	@Column(name = "CHANGE_JUSTIFICATION")
	private String changeJustification;

	@Basic
	@Column(name = "COMMENTS")
	private String comments;

	@Basic
	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Basic
	@Column(name = "RECORD_TIME")
	private Date recordTime;

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public void setLicensable(boolean licensable) {
		this.licensable = licensable;
	}

	public boolean isLicensable() {
		return licensable;
	}

	public String getChangeJustification() {
		return changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public Integer getPriority() {
		return priority;
	}

	public void setPriority(Integer priority) {
		this.priority = priority;
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

	public SoftwareCategory getSoftwareCategory() {
		return softwareCategory;
	}

	public void setSoftwareCategory(SoftwareCategory softwareCategory) {
		this.softwareCategory = softwareCategory;
	}
}