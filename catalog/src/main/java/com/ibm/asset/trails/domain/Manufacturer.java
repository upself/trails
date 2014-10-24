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
@Table(name = "MANUFACTURER")
@Cacheable
public class Manufacturer extends KbDefinition {

	private static final long serialVersionUID = -7889688857898361973L;

	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinTable(name = "MANUFACTURER_ALIAS", joinColumns = { @JoinColumn(name = "MANUFACTURER_ID") }, inverseJoinColumns = { @JoinColumn(name = "ALIAS_ID") })
	protected Set<Alias> alias = new HashSet<Alias>();

	@Basic
	@Column(name = "DID", length = 16)
	protected String dId;

	@Basic
	@Column(name = "NAME", length = 64)
	protected String name;

	@Basic
	@Column(name = "WEBSITE", length = 128)
	protected String website;

	public Set<Alias> getAlias() {
		if (alias == null) {
			return new HashSet<Alias>();
		}
		return alias;
	}

	public void setalias(Set<Alias> alias) {
		this.alias = alias;
	}

	public String getdId() {
		return dId;
	}

	public void setdId(String dId) {
		this.dId = dId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getWebsite() {
		return website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((alias == null) ? 0 : alias.hashCode());
		result = prime * result + ((dId == null) ? 0 : dId.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((website == null) ? 0 : website.hashCode());
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
		if (!(obj instanceof Manufacturer)) {
			return false;
		}
		Manufacturer other = (Manufacturer) obj;
		if (alias == null) {
			if (other.alias != null) {
				return false;
			}
		} else if (!alias.equals(other.alias)) {
			return false;
		}
		if (dId == null) {
			if (other.dId != null) {
				return false;
			}
		} else if (!dId.equals(other.dId)) {
			return false;
		}
		if (name == null) {
			if (other.name != null) {
				return false;
			}
		} else if (!name.equals(other.name)) {
			return false;
		}
		if (website == null) {
			if (other.website != null) {
				return false;
			}
		} else if (!website.equals(other.website)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Manufacturer [alias=");
		builder.append(alias);
		builder.append(", dId=");
		builder.append(dId);
		builder.append(", name=");
		builder.append(name);
		builder.append(", website=");
		builder.append(website);
		builder.append("]");
		return builder.toString();
	}

}
