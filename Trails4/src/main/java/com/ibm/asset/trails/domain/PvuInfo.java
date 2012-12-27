package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity(name = "PvuInfo")
@Table(name = "PVU_INFO")
public class PvuInfo extends AbstractDomainEntity {

	@Id
	@Column(name = "ID", nullable = false)
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "PVU_ID", nullable = false)
	protected Long pvuId;

	@Basic
	@Column(name = "PROCESSOR_TYPE", nullable = false)
	protected String processorType;

	@Basic
	@Column(name = "VALUE_UNITS_PER_CORE", nullable = false)
	protected Integer valueUnitsPerCore;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getProcessorType() {
		return processorType;
	}

	public void setProcessorType(String processorType) {
		this.processorType = processorType;
	}

	public Long getPvuId() {
		return pvuId;
	}

	public void setPvuId(Long pvuId) {
		this.pvuId = pvuId;
	}

	public Integer getValueUnitsPerCore() {
		return valueUnitsPerCore;
	}

	public void setValueUnitsPerCore(Integer valueUnitsPerCore) {
		this.valueUnitsPerCore = valueUnitsPerCore;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof PvuInfo))
			return false;
		PvuInfo castOther = (PvuInfo) other;
		return new EqualsBuilder().append(pvuId, castOther.pvuId)
				.append(processorType, castOther.processorType)
				.append(valueUnitsPerCore, castOther.valueUnitsPerCore)
				.isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(pvuId).append(processorType)
				.append(valueUnitsPerCore).toHashCode();
	}
	
}
