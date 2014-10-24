package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "SIGNATURE")
public class Signature extends KbDefinition {

	private static final long serialVersionUID = 5946257269742433779L;

	@Basic
	@Column(name = "CONFIDENCE_LEVEL")
	protected Integer confidenceLevel;

	@Basic
	@Column(name = "C_VERSION_PLATFORM_ID")
	protected Long platformCVersion;

	@Basic
	@Column(name = "PLATFORM_ID")
	protected Long platformType;

	@Basic
	@Column(name = "DISCOVERED_SOFTWARE_ITEM_ID")
	protected Long softwareItem;

	public Integer getConfidenceLevel() {
		return confidenceLevel;
	}

	public void setConfidenceLevel(Integer confidenceLevel) {
		this.confidenceLevel = confidenceLevel;
	}

	public Long getPlatformCVersion() {
		return platformCVersion;
	}

	public void setPlatformCVersion(Long platformCVersion) {
		this.platformCVersion = platformCVersion;
	}

	public Long getPlatformType() {
		return platformType;
	}

	public void setPlatformType(Long platformType) {
		this.platformType = platformType;
	}

	public Long getSoftwareItem() {
		return softwareItem;
	}

	public void setSoftwareItem(Long softwareItem) {
		this.softwareItem = softwareItem;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((confidenceLevel == null) ? 0 : confidenceLevel.hashCode());
		result = prime
				* result
				+ ((platformCVersion == null) ? 0 : platformCVersion.hashCode());
		result = prime * result
				+ ((platformType == null) ? 0 : platformType.hashCode());
		result = prime * result
				+ ((softwareItem == null) ? 0 : softwareItem.hashCode());
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
		if (!(obj instanceof Signature)) {
			return false;
		}
		Signature other = (Signature) obj;
		if (confidenceLevel == null) {
			if (other.confidenceLevel != null) {
				return false;
			}
		} else if (!confidenceLevel.equals(other.confidenceLevel)) {
			return false;
		}
		if (platformCVersion == null) {
			if (other.platformCVersion != null) {
				return false;
			}
		} else if (!platformCVersion.equals(other.platformCVersion)) {
			return false;
		}
		if (platformType == null) {
			if (other.platformType != null) {
				return false;
			}
		} else if (!platformType.equals(other.platformType)) {
			return false;
		}
		if (softwareItem == null) {
			if (other.softwareItem != null) {
				return false;
			}
		} else if (!softwareItem.equals(other.softwareItem)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Signature [confidenceLevel=");
		builder.append(confidenceLevel);
		builder.append(", platformCVersion=");
		builder.append(platformCVersion);
		builder.append(", platformType=");
		builder.append(platformType);
		builder.append(", softwareItem=");
		builder.append(softwareItem);
		builder.append("]");
		return builder.toString();
	}

}
