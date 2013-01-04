package com.ibm.asset.trails.domain;

import java.util.Date;

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


@Entity
@Table(name = "RECON_PVU", schema = "EAADMIN")
@org.hibernate.annotations.Entity
@NamedQueries( { @NamedQuery(name = "getReconPvuByUniqueKeys", query = "FROM ReconPvu reconPvu WHERE reconPvu.processorBrand=:prcsrBrand AND reconPvu.processorModel=:prcsrModel") })
public class ReconPvu {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@Column(name = "PROCESSOR_BRAND", nullable = false)
	private String processorBrand;

	@Column(name = "PROCESSOR_MODEL", nullable = false)
	private String processorModel;

	@Column(name = "ACTION", nullable = false)
	private String action;

	@Column(name = "REMOTE_USER", nullable = false)
	private String remoteUser;

	@Column(name = "RECORD_TIME", nullable = false)
	private Date recordTime;

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

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public MachineType getMachineType() {
		return machineType;
	}

	public void setMachineType(MachineType machineType) {
		this.machineType = machineType;
	}

	@Override
	public int hashCode() {
		return this.processorBrand.hashCode() + this.processorModel.hashCode();
	}
}
