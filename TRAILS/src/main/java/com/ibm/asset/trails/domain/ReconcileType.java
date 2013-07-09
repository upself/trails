package com.ibm.asset.trails.domain;

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;


@Entity
@Table(name = "RECONCILE_TYPE")
@Cacheable
public class ReconcileType extends AbstractDomainEntity {
	private static final long serialVersionUID = 2341804152154090336L;

	@Id
	@Column(name = "ID")
	private Long id;

	@Column(name = "NAME")
	private String name;

	@Column(name = "IS_MANUAL")
	private boolean manual;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public boolean isManual() {
		return manual;
	}

	public void setManual(boolean manual) {
		this.manual = manual;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof ReconcileType))
			return false;
		ReconcileType castOther = (ReconcileType) other;
		return new EqualsBuilder().append(name, castOther.name)
				.append(manual, castOther.manual).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(name).append(manual).toHashCode();
	}

}
