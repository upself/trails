package com.ibm.asset.trails.domain;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "PVU")
@org.hibernate.annotations.Entity(mutable = false)
@NamedQueries( {
		@NamedQuery(name = "pvuList", query = "FROM ProcessorValueUnit p"),
		@NamedQuery(name = "pvuWithInfo", query = "FROM ProcessorValueUnit p join fetch p.processorValueUnitInfo where p.id = :id") })
public class ProcessorValueUnit {
	@Id
	@Column(name = "ID")
	private Long id;

	@Column(name = "PROCESSOR_BRAND", nullable = false)
	private String processorBrand;

	@Column(name = "PROCESSOR_MODEL", nullable = false)
	private String processorModel;

	@OneToMany(mappedBy = "processorValueUnit")
	private List<ProcessorValueUnitInfo> processorValueUnitInfo;

	@OneToMany(mappedBy = "processorValueUnit")
	private List<PvuMap> pvuMap;

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

	public void setProcessorValueUnitInfo(
			List<ProcessorValueUnitInfo> processorValueUnitInfo) {
		this.processorValueUnitInfo = processorValueUnitInfo;
	}

	public List<ProcessorValueUnitInfo> getProcessorValueUnitInfo() {
		if (processorValueUnitInfo == null) {
			processorValueUnitInfo = new ArrayList<ProcessorValueUnitInfo>();
		}

		return processorValueUnitInfo;
	}

	public boolean isActive() {
		for (ProcessorValueUnitInfo pvuInfo : getProcessorValueUnitInfo()) {
			if (pvuInfo.getStatus().equals("ACTIVE")) {
				return true;
			}
		}
		return false;
	}

	public void setPvuMap(List<PvuMap> pvuMap) {
		this.pvuMap = pvuMap;
	}

	public List<PvuMap> getPvuMap() {
		if (pvuMap == null) {
			pvuMap = new ArrayList<PvuMap>();
		}

		return pvuMap;
	}

	@Override
	public int hashCode() {
		return this.processorBrand.hashCode() + this.processorModel.hashCode();
	}

	@Override
	public boolean equals(Object other) {
		if (this == other)
			return true;
		if (!(other instanceof ProcessorValueUnit))
			return false;
		final ProcessorValueUnit that = (ProcessorValueUnit) other;
		if (!this.processorBrand.equals(that.getProcessorBrand()))
			return false;
		if (!this.processorModel.equals(that.getProcessorModel()))
			return false;
		return true;
	}
}