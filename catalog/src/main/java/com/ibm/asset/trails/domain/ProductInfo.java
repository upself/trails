package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "PRODUCT_INFO")
@Cacheable
public class ProductInfo extends Product implements Serializable {

	private static final long serialVersionUID = -418391816924595506L;

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

	@OneToOne(mappedBy = "productInfo", cascade = CascadeType.ALL, optional = true, fetch = FetchType.EAGER)
	protected Recon recon;

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

	public boolean getLicensable() {
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

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ProductInfo [softwareCategoryId=");
		builder.append(softwareCategoryId);
		builder.append(", priority=");
		builder.append(priority);
		builder.append(", licensable=");
		builder.append(licensable);
		builder.append(", changeJustification=");
		builder.append(changeJustification);
		builder.append(", remoteUser=");
		builder.append(remoteUser);
		builder.append(", recordTime=");
		builder.append(recordTime);
		builder.append("]");
		return builder.toString();
	}

	public Recon getRecon() {
		return recon;
	}

	public void setRecon(Recon recon) {
		this.recon = recon;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime
				* result
				+ ((changeJustification == null) ? 0 : changeJustification
						.hashCode());
		result = prime * result + (licensable ? 1231 : 1237);
		result = prime * result
				+ ((priority == null) ? 0 : priority.hashCode());
		result = prime * result + ((recon == null) ? 0 : recon.hashCode());
		result = prime * result
				+ ((recordTime == null) ? 0 : recordTime.hashCode());
		result = prime * result
				+ ((remoteUser == null) ? 0 : remoteUser.hashCode());
		result = prime
				* result
				+ ((softwareCategoryId == null) ? 0 : softwareCategoryId
						.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (!super.equals(obj)) {
			return false;
		}
		if (!(obj instanceof ProductInfo)) {
			return false;
		}
		ProductInfo other = (ProductInfo) obj;
		if (changeJustification == null) {
			if (other.changeJustification != null) {
				return false;
			}
		} else if (!changeJustification.equals(other.changeJustification)) {
			return false;
		}
		if (licensable != other.licensable) {
			return false;
		}
		if (priority == null) {
			if (other.priority != null) {
				return false;
			}
		} else if (!priority.equals(other.priority)) {
			return false;
		}
		if (recordTime == null) {
			if (other.recordTime != null) {
				return false;
			}
		} else if (!recordTime.equals(other.recordTime)) {
			return false;
		}
		if (remoteUser == null) {
			if (other.remoteUser != null) {
				return false;
			}
		} else if (!remoteUser.equals(other.remoteUser)) {
			return false;
		}
		if (softwareCategoryId == null) {
			if (other.softwareCategoryId != null) {
				return false;
			}
		} else if (!softwareCategoryId.equals(other.softwareCategoryId)) {
			return false;
		}
		return true;
	}

}
