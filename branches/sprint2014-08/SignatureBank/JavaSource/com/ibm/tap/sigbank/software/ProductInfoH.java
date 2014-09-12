package com.ibm.tap.sigbank.software;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

@Entity(name = "ProductInfoH")
@Table(name = "PRODUCT_INFO_H")
public class ProductInfoH implements Serializable {
	private static final long serialVersionUID = -4428351320132987575L;

	@Id
	@GenericGenerator(name="generator", strategy="increment")
    @GeneratedValue(generator="generator")
	@Column(name = "ID")
	private Long productInfoHId;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRODUCT_ID")
	private ProductInfo productInfo;

	@Basic
	@Column(name = "SOFTWARE_CATEGORY_NAME")
	private String softwareCategory;

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

	public void setProductInfoHId(Long productInfoHId) {
		this.productInfoHId = productInfoHId;
	}

	public Long getProductInfoHId() {
		return productInfoHId;
	}

	public void setProductInfo(ProductInfo productInfo) {
		this.productInfo = productInfo;
	}

	public ProductInfo getProductInfo() {
		return productInfo;
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

	public String getSoftwareCategory() {
		return softwareCategory;
	}

	public void setSoftwareCategory(String softwareCategory) {
		this.softwareCategory = softwareCategory;
	}
}