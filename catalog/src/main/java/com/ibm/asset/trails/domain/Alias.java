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
@Table(name = "ALIAS")
@Cacheable
public class Alias extends DomainEntity implements Serializable {

	private static final long serialVersionUID = 2037670509647387682L;

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "NAME", length = 64, unique = true)
	protected String name;

	@Basic
	@Column(name = "PREFERRED")
	protected boolean preferred;

	@Override
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean getPreferred() {
		return preferred;
	}

	public void setPreferred(Boolean preferred) {
		this.preferred = preferred;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("AliasType [id=");
		builder.append(id);
		builder.append(", name=");
		builder.append(name);
		builder.append(", preferred=");
		builder.append(preferred);
		builder.append("]");
		return builder.toString();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + (preferred ? 1231 : 1237);
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
		if (!(obj instanceof Alias)) {
			return false;
		}
		Alias other = (Alias) obj;
		if (name == null) {
			if (other.name != null) {
				return false;
			}
		} else if (!name.equals(other.name)) {
			return false;
		}
		if (preferred != other.preferred) {
			return false;
		}
		return super.equals(obj);
	}

}
