package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "HARDWARE_LPAR_EFF")
@org.hibernate.annotations.Entity(mutable = false)
public class HardwareLparEff {
	@Id
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "PROCESSOR_COUNT")
	private Integer processorCount;
	
	@Column(name = "status")
	private String status;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HARDWARE_LPAR_ID")
	private HardwareLpar hardwareLpar;

	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getProcessorCount() {
		if(null != status && status.equalsIgnoreCase("INACTIVE")){
			return 0;
		}
		
		return processorCount;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public HardwareLpar getHardwareLpar() {
		return hardwareLpar;
	}

	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
	}

}
