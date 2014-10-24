package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "VERSION")
@Cacheable
public class Version extends SoftwareItem {

	private static final long serialVersionUID = 2346085222196143754L;

	@Basic
	@Column(name = "IDENTIFIER", length = 255)
	protected String identifier;

	@Basic
	@Column(name = "MANUFACTURER_ID")
	protected Long manufacturer;

	@Basic
	@Column(name = "PRODUCT_ID")
	protected Long productInfo;

	@Basic
	@Column(name = "VERSION")
	protected int version;

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public Long getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Long manufacturer) {
		this.manufacturer = manufacturer;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((identifier == null) ? 0 : identifier.hashCode());
		result = prime * result
				+ ((manufacturer == null) ? 0 : manufacturer.hashCode());
		result = prime * result
				+ ((productInfo == null) ? 0 : productInfo.hashCode());
		result = prime * result + version;
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
		if (!(obj instanceof Version)) {
			return false;
		}
		Version other = (Version) obj;
		if (identifier == null) {
			if (other.identifier != null) {
				return false;
			}
		} else if (!identifier.equals(other.identifier)) {
			return false;
		}
		if (manufacturer == null) {
			if (other.manufacturer != null) {
				return false;
			}
		} else if (!manufacturer.equals(other.manufacturer)) {
			return false;
		}
		if (productInfo == null) {
			if (other.productInfo != null) {
				return false;
			}
		} else if (!productInfo.equals(other.productInfo)) {
			return false;
		}
		if (version != other.version) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Version [identifier=");
		builder.append(identifier);
		builder.append(", manufacturer=");
		builder.append(manufacturer);
		builder.append(", distProductId=");
		builder.append(productInfo);
		builder.append(", version=");
		builder.append(version);
		builder.append("]");
		return builder.toString();
	}

	public Long getProductInfo() {
		return productInfo;
	}

	public void setProductInfo(Long productInfo) {
		this.productInfo = productInfo;
	}

}
