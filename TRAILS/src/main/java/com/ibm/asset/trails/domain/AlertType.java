package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "ALERT_TYPE")
@NamedQueries({
		@NamedQuery(name = "findAlertTypeById", query = "FROM AlertType AT WHERE AT.id = :id"),
		@NamedQuery(name = "getAlertTypeByCode", query = "FROM AlertType a WHERE a.code=:code"),
		@NamedQuery(name = "getAlertTypeList", query = "FROM AlertType ORDER BY name ASC") })
public class AlertType extends AbstractDomainEntity {
	private static final long serialVersionUID = -1543290200848510819L;

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "NAME")
	protected String name;

	@Basic
	@Column(name = "CODE")
	protected String code;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.alertType", cascade = CascadeType.ALL)
	protected Set<AlertTypeCause> alertTypeCauses = new HashSet<AlertTypeCause>();

	public Set<AlertTypeCause> getAlertTypeCauses() {
		return alertTypeCauses;
	}

	public void setAlertTypeCauses(Set<AlertTypeCause> alertTypeCauses) {
		this.alertTypeCauses = alertTypeCauses;
	}

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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((alertTypeCauses == null) ? 0 : alertTypeCauses.hashCode());
		result = prime * result + ((code == null) ? 0 : code.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		AlertType other = (AlertType) obj;
		if (alertTypeCauses == null) {
			if (other.alertTypeCauses != null)
				return false;
		} else if (!alertTypeCauses.equals(other.alertTypeCauses))
			return false;
		if (code == null) {
			if (other.code != null)
				return false;
		} else if (!code.equals(other.code))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}

}
