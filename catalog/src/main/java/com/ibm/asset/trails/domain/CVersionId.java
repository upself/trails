package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "C_VERSION_ID")
@Cacheable
public class CVersionId extends DomainEntity implements Serializable {

	private static final long serialVersionUID = -1626927708256322812L;

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "C_VERSION_ID")
	protected String cVersionId;

	@Basic
	@Column(name = "PLATFORM_ID")
	protected Long platform;

	@Override
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getcVersionId() {
		return cVersionId;
	}

	public void setcVersionId(String cVersionId) {
		this.cVersionId = cVersionId;
	}

	public Long getPlatform() {
		return platform;
	}

	public void setPlatform(Long platform) {
		this.platform = platform;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((cVersionId == null) ? 0 : cVersionId.hashCode());
		result = prime * result
				+ ((platform == null) ? 0 : platform.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (!(obj instanceof CVersionId)) {
			return false;
		}
		CVersionId other = (CVersionId) obj;
		if (cVersionId == null) {
			if (other.cVersionId != null) {
				return false;
			}
		} else if (!cVersionId.equals(other.cVersionId)) {
			return false;
		}
		if (platform == null) {
			if (other.platform != null) {
				return false;
			}
		} else if (!platform.equals(other.platform)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("CVersionId [id=");
		builder.append(id);
		builder.append(", cVersionId=");
		builder.append(cVersionId);
		builder.append(", platform=");
		builder.append(platform);
		builder.append("]");
		return builder.toString();
	}

}
