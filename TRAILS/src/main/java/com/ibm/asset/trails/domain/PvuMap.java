package com.ibm.asset.trails.domain;

// Generated Oct 20, 2009 11:27:52 PM by Hibernate Tools 3.2.4.GA

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;


@Entity
@Table(name = "PVU_MAP", schema = "EAADMIN")
@NamedQueries({
		@NamedQuery(name = "getAvilablePvuMap", query = "FROM PvuMap pvuMap WHERE pvuMap.processorValueUnit.id=:pvuId and pvuMap.processorBrand=:processorBrand"),
		@NamedQuery(name = "getPvuMapByBrandAndModelAndMachineTypeId", query = "FROM PvuMap PVUM WHERE PVUM.processorBrand = :processorBrand AND PVUM.processorModel=:processorModel AND PVUM.machineType = :machineType"),
		@NamedQuery(name = "removePvuMapById", query = "DELETE FROM PvuMap pvuMap WHERE pvuMap.id=:id"),
		@NamedQuery(name = "modelListUnderBrandAndMachineTypeId", query = "SELECT DISTINCT PVUM.processorModel FROM PvuMap PVUM WHERE PVUM.processorBrand =:processorBrand AND PVUM.machineType.id = :machineTypeId"),
		@NamedQuery(name = "modelListUnderBrandAndPvuIdAndMachineTypeId", query = "SELECT PVUM.processorModel FROM PvuMap PVUM WHERE PVUM.processorBrand = :processorBrand AND PVUM.processorValueUnit.id = :pvuId AND PVUM.machineType.id = :machineTypeId"),
		@NamedQuery(name = "updateModelPvuId", query = "UPDATE PvuMap pvuMap SET pvuMap.processorValueUnit.id=:pvuId WHERE pvuMap.processorBrand =:processorBrand And pvuMap.processorModel=:processorModel"),
		@NamedQuery(name = "removePvuUnique", query = "DELETE FROM PvuMap pvuMap WHERE pvuMap.processorBrand=:processorBrand AND pvuMap.processorModel=:processorModel AND pvuMap.machineType=:machineType") })
public class PvuMap extends AbstractDomainEntity {
	private static final long serialVersionUID = -3811690785818481965L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@Column(name = "PROCESSOR_BRAND", nullable = false)
	private String processorBrand;

	@Column(name = "PROCESSOR_MODEL", nullable = false)
	private String processorModel;

	@ManyToOne
	@JoinColumn(name = "PVU_ID", nullable = false)
	private ProcessorValueUnit processorValueUnit;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MACHINE_TYPE_ID", nullable = false)
	private MachineType machineType;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getProcessorBrand() {
		return processorBrand;
	}

	public void setProcessorBrand(String processorBrand) {
		this.processorBrand = processorBrand;
	}

	public String getProcessorModel() {
		return processorModel;
	}

	public void setProcessorModel(String processorModel) {
		this.processorModel = processorModel;
	}

	public void setProcessorValueUnit(ProcessorValueUnit processorValueUnit) {
		this.processorValueUnit = processorValueUnit;
	}

	public ProcessorValueUnit getProcessorValueUnit() {
		return processorValueUnit;
	}

	public MachineType getMachineType() {
		return machineType;
	}

	public void setMachineType(MachineType machineType) {
		this.machineType = machineType;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof PvuMap))
			return false;
		PvuMap castOther = (PvuMap) other;
		return new EqualsBuilder()
				.append(processorBrand, castOther.processorBrand)
				.append(processorModel, castOther.processorModel).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(processorBrand)
				.append(processorModel).toHashCode();
	}

}
