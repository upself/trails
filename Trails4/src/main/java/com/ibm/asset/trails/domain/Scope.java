package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;


@Entity
@Table(name = "SCOPE")
@NamedQueries({
		@NamedQuery(name = "scopeDetails", query = "FROM Scope WHERE UPPER(description) = :description"),
		@NamedQuery(name = "scopeList", query = "FROM Scope ORDER BY description") })
public class Scope extends AbstractDomainEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@Basic
	@Column(name = "DESCRIPTION")
	private String description;

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public boolean equals(final Object other) {
		if (this == other)
			return true;
		if (!(other instanceof Scope))
			return false;
		Scope castOther = (Scope) other;
		return new EqualsBuilder().append(description, castOther.description)
				.isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(description).toHashCode();
	}

}
