package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "RELEASE")
@Cacheable
public class Release extends SoftwareItem {

	private static final long serialVersionUID = -6531983832411180946L;

	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinTable(name = "RELEASE_CVERSIONID", joinColumns = { @JoinColumn(name = "RELEASE_ID") }, inverseJoinColumns = { @JoinColumn(name = "C_VERSION_ID_ID") })
	protected Set<CVersionId> cVersionId = new HashSet<CVersionId>();

	@Basic
	@Column(name = "IDENTIFIER", length = 255)
	protected String identifier;

	@Basic
	@Column(name = "MANUFACTURER_ID")
	protected Long manufacturer;

	@Basic
	@Column(name = "RELEASE", length = 255)
	protected String release;

	@Basic
	@Column(name = "VERSION_ID")
	protected Long version;

	public Set<CVersionId> getcVersionId() {
		if (cVersionId == null) {
			cVersionId = new HashSet<CVersionId>();
		}
		return cVersionId;
	}

	public void setcVersionId(Set<CVersionId> cVersionId) {
		this.cVersionId = cVersionId;
	}

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

	public String getRelease() {
		return release;
	}

	public void setRelease(String release) {
		this.release = release;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Release [cVersionId=");
		builder.append(cVersionId);
		builder.append(", identifier=");
		builder.append(identifier);
		builder.append(", manufacturer=");
		builder.append(manufacturer);
		builder.append(", release=");
		builder.append(release);
		builder.append(", version=");
		builder.append(version);
		builder.append("]");
		return builder.toString();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((cVersionId == null) ? 0 : cVersionId.hashCode());
		result = prime * result
				+ ((identifier == null) ? 0 : identifier.hashCode());
		result = prime * result
				+ ((manufacturer == null) ? 0 : manufacturer.hashCode());
		result = prime * result + ((release == null) ? 0 : release.hashCode());
		result = prime * result + ((version == null) ? 0 : version.hashCode());
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
		if (!(obj instanceof Release)) {
			return false;
		}
		Release other = (Release) obj;
		if (cVersionId == null) {
			if (other.cVersionId != null) {
				return false;
			}
		} else if (!cVersionId.equals(other.cVersionId)) {
			return false;
		}
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
		if (release == null) {
			if (other.release != null) {
				return false;
			}
		} else if (!release.equals(other.release)) {
			return false;
		}
		if (version == null) {
			if (other.version != null) {
				return false;
			}
		} else if (!version.equals(other.version)) {
			return false;
		}
		return super.equals(obj);
	}

}
