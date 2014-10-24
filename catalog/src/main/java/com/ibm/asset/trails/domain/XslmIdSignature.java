package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "XSLMID_SIGNATURE")
public class XslmIdSignature extends Signature {

	private static final long serialVersionUID = 2157142170841148524L;

	@Basic
	@Column(name = "FEATURE_ID")
	protected String featureId;

	@Basic
	@Column(name = "PRODUCT_ID")
	protected String productId;

	@Basic
	@Column(name = "PUBLISHER_ID")
	protected String publisherId;

	@Basic
	@Column(name = "VERSION_ID")
	protected String versionId;

	public String getFeatureId() {
		return featureId;
	}

	public void setFeatureId(String featureId) {
		this.featureId = featureId;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getPublisherId() {
		return publisherId;
	}

	public void setPublisherId(String publisherId) {
		this.publisherId = publisherId;
	}

	public String getVersionId() {
		return versionId;
	}

	public void setVersionId(String versionId) {
		this.versionId = versionId;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((featureId == null) ? 0 : featureId.hashCode());
		result = prime * result
				+ ((productId == null) ? 0 : productId.hashCode());
		result = prime * result
				+ ((publisherId == null) ? 0 : publisherId.hashCode());
		result = prime * result
				+ ((versionId == null) ? 0 : versionId.hashCode());
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
		if (!(obj instanceof XslmIdSignature)) {
			return false;
		}
		XslmIdSignature other = (XslmIdSignature) obj;
		if (featureId == null) {
			if (other.featureId != null) {
				return false;
			}
		} else if (!featureId.equals(other.featureId)) {
			return false;
		}
		if (productId == null) {
			if (other.productId != null) {
				return false;
			}
		} else if (!productId.equals(other.productId)) {
			return false;
		}
		if (publisherId == null) {
			if (other.publisherId != null) {
				return false;
			}
		} else if (!publisherId.equals(other.publisherId)) {
			return false;
		}
		if (versionId == null) {
			if (other.versionId != null) {
				return false;
			}
		} else if (!versionId.equals(other.versionId)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("XslmIdSignature [featureId=");
		builder.append(featureId);
		builder.append(", productId=");
		builder.append(productId);
		builder.append(", publisherId=");
		builder.append(publisherId);
		builder.append(", versionId=");
		builder.append(versionId);
		builder.append("]");
		return builder.toString();
	}

}
