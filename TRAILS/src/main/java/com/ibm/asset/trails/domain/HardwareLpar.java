package com.ibm.asset.trails.domain;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "HARDWARE_LPAR")
@org.hibernate.annotations.Entity(mutable = false)
public class HardwareLpar {

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@Column(name = "NAME")
	private String name;

	@Column(name = "EXT_ID")
	private String extId;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "HARDWARE_ID")
	private Hardware hardware;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "STATUS")
	private String status;

	@Column(name = "LPAR_STATUS")
	private String lparStatus;

	@Column(name = "PART_MIPS")
	private Integer partLsprMips;

	@Column(name = "SERVER_TYPE")
	private String serverType;

	@Column(name = "EFFECTIVE_THREADS")
	private BigDecimal effectiveThreads;

	public String getServerType() {
		return serverType;
	}

	public void setServerType(String serverType) {
		this.serverType = serverType;
	}

	/**
	 * @return the partLsprMips
	 */
	public Integer getPartLsprMips() {
		return partLsprMips;
	}

	/**
	 * @param partLsprMips
	 *            the partLsprMips to set
	 */
	public void setPartLsprMips(Integer partLsprMips) {
		this.partLsprMips = partLsprMips;
	}

	/**
	 * @return the partMsu
	 */
	public Integer getPartMsu() {
		return partMsu;
	}

	/**
	 * @param partMsu
	 *            the partMsu to set
	 */
	public void setPartMsu(Integer partMsu) {
		this.partMsu = partMsu;
	}

	/**
	 * @return the partGartnerMips
	 */
	public BigDecimal getPartGartnerMips() {
		return partGartnerMips;
	}

	/**
	 * @param partGartnerMips
	 *            the partGartnerMips to set
	 */
	public void setPartGartnerMips(BigDecimal partGartnerMips) {
		this.partGartnerMips = partGartnerMips;
	}

	@Column(name = "PART_MSU")
	private Integer partMsu;

	@Column(name = "PART_GARTNER_MIPS")
	private BigDecimal partGartnerMips;

	@Column(name = "SPLA")
	private String spla;

	@Column(name = "SYSPLEX")
	private String sysplex;

	@Column(name = "INTERNET_ICC_FLAG")
	private String internetIccFlag;

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public Hardware getHardware() {
		return hardware;
	}

	public void setHardware(Hardware hardware) {
		this.hardware = hardware;
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

	public String getExtId() {
		return extId;
	}

	public void setExtId(String extId) {
		this.extId = extId;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getLparStatus() {
		return status;
	}

	public void setLparStatus(String lparStatus) {
		this.status = lparStatus;
	}

	public String getSpla() {
		return this.spla;
	}

	public void setSpla(String spla) {
		this.spla = spla;
	}

	public String getSysplex() {
		return this.sysplex;
	}

	public void setSysplex(String sysplex) {
		this.sysplex = sysplex;
	}

	public String getInternetIccFlag() {
		return this.internetIccFlag;
	}

	public void setInternetIccFlag(String internetIccFlag) {
		this.internetIccFlag = internetIccFlag;
	}

	public BigDecimal getEffectiveThreads() {
		return effectiveThreads;
	}

	public void setEffectiveThreads(BigDecimal effectiveThreads) {
		this.effectiveThreads = effectiveThreads;
	}
}
