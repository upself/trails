package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity(name = "AlertType")
@Table(name = "ALERT_TYPE")
@NamedQueries({
	@NamedQuery(name = "findAlertTypeById", query = "FROM AlertType AT LEFT OUTER JOIN FETCH AT.alertCauseSet WHERE AT.id = :id"),
	@NamedQuery(name = "getAlertTypeByCode", query = "FROM AlertType a WHERE a.code=:code"),
	@NamedQuery(name = "getAlertTypeList", query = "FROM AlertType ORDER BY name ASC")
})
public class DataExceptionType extends AbstractDomainEntity {
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

	@OneToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "ALERT_TYPE_CAUSE", joinColumns = @JoinColumn(name = "ALERT_TYPE_ID"), inverseJoinColumns = @JoinColumn(name = "ALERT_CAUSE_ID"))
	protected Set<DataExceptionCause> alertCauseSet = new HashSet<DataExceptionCause>();

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

	public Set<DataExceptionCause> getAlertCauseSet() {
		return alertCauseSet;
	}

	public void setAlertCauseSet(Set<DataExceptionCause> alertCauseSet) {
		this.alertCauseSet = alertCauseSet;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof DataExceptionType))
			return false;
		DataExceptionType castOther = (DataExceptionType) other;
		return new EqualsBuilder().append(name, castOther.name)
				.append(code, castOther.code).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(name).append(code).toHashCode();
	}
}
