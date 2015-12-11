package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.math.BigDecimal;

public class ReconWorkspace implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// TODO called it this because of hibernate would not use the correct
	// mapping in where clause
	private Integer alertAgeI;

	private String hostname;
	private String sl_hostname;
	
	public String getSl_hostname() {
		return sl_hostname;
	}

	public void setSl_hostname(String sl_hostname) {
		this.sl_hostname = sl_hostname;
	}

	private String serial;

	private String country;

	private String owner;

	private String assetType;

	private Integer processorCount;

	private String productInfoName;

	private Long reconcileTypeId;

	private String reconcileTypeName;

	private String assignee;

	private Long installedSoftwareId;

	private boolean selected;

	private Long alertId;

	private Long reconcileId;

	private Long productInfoId;

	private Integer hardwareProcessorCount;

	private Integer chips;

	private Integer cpuLsprMips;

	private Integer partLsprMips;

	private BigDecimal cpuGartnerMips;

	private BigDecimal partGartnerMips;

	private String pid;

	private String osType;

	private String scope;

	private String assetName;

	public String getAssetName() {
		return assetName;
	}

	public void setAssetName(String assetName) {
		this.assetName = assetName;
	}

	public String getScope() {
		return scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * @return the cpuLsprMips
	 */
	public Integer getCpuLsprMips() {
		return cpuLsprMips;
	}

	/**
	 * @param cpuLsprMips
	 *            the cpuLsprMips to set
	 */
	public void setCpuLsprMips(Integer cpuLsprMips) {
		this.cpuLsprMips = cpuLsprMips;
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
	 * @return the cpuGartnerMips
	 */
	public BigDecimal getCpuGartnerMips() {
		return cpuGartnerMips;
	}

	/**
	 * @param cpuGartnerMips
	 *            the cpuGartnerMips to set
	 */
	public void setCpuGartnerMips(BigDecimal cpuGartnerMips) {
		this.cpuGartnerMips = cpuGartnerMips;
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

	/**
	 * @return the cpuMsu
	 */
	public Integer getCpuMsu() {
		return cpuMsu;
	}

	/**
	 * @param cpuMsu
	 *            the cpuMsu to set
	 */
	public void setCpuMsu(Integer cpuMsu) {
		this.cpuMsu = cpuMsu;
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

	private Integer cpuMsu;

	private Integer partMsu;

	private String hardwareStatus;

	private String lparStatus;

	private String spla;

	private String sysplex;

	private String internetIccFlag;

	private String mastProcessorType;

	private String processorManufacturer;

	private String mastProcessorModel;

	private BigDecimal nbrCoresPerChip;

	private BigDecimal nbrOfChipsMax;

	private String shared;

	private String lparServerType;

	private Integer cpuIFL;

	private BigDecimal effectiveThreads;

	private Integer hwLparEffProcessorCount;
	private String hwLparEffProcessorStatus;

	public String getLparServerType() {
		return lparServerType;
	}

	public void setLparServerType(String lparServerType) {
		this.lparServerType = lparServerType;
	}

	public Integer getAlertAgeI() {
		return alertAgeI;
	}

	public void setAlertAgeI(Integer alertAgeI) {
		this.alertAgeI = alertAgeI;
	}

	public String getAssetType() {
		return assetType;
	}

	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getHostname() {
		return hostname;
	}

	public void setHostname(String hostname) {
		this.hostname = hostname;
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}

	public String getProductInfoName() {
		return productInfoName;
	}

	public void setProductInfoName(String productInfoName) {
		this.productInfoName = productInfoName;
	}

	public Long getReconcileTypeId() {
		return reconcileTypeId;
	}

	public void setReconcileTypeId(Long reconcileTypeId) {
		this.reconcileTypeId = reconcileTypeId;
	}

	public String getReconcileTypeName() {
		return reconcileTypeName;
	}

	public void setReconcileTypeName(String reconcileTypeName) {
		this.reconcileTypeName = reconcileTypeName;
	}

	public Integer getProcessorCount() {
		return processorCount;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	public Long getInstalledSoftwareId() {
		return installedSoftwareId;
	}

	public void setInstalledSoftwareId(Long installedSoftwareId) {
		this.installedSoftwareId = installedSoftwareId;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public Long getAlertId() {
		return alertId;
	}

	public void setAlertId(Long alertId) {
		this.alertId = alertId;
	}

	public Long getReconcileId() {
		return reconcileId;
	}

	public void setReconcileId(Long reconcileId) {
		this.reconcileId = reconcileId;
	}

	public Long getProductInfoId() {
		return productInfoId;
	}

	public void setProductInfoId(Long productInfoId) {
		this.productInfoId = productInfoId;
	}

	public Integer getHardwareProcessorCount() {
		return hardwareProcessorCount;
	}

	public void setHardwareProcessorCount(Integer hardwareProcessorCount) {
		this.hardwareProcessorCount = hardwareProcessorCount;
	}

	public Integer getHwLparEffProcessorCount() {
		return hwLparEffProcessorCount;
	}

	public void setHwLparEffProcessorCount(Integer hwLparEffProcessorCount) {
		this.hwLparEffProcessorCount = hwLparEffProcessorCount;
	}

	public String getHwLparEffProcessorStatus() {
		return hwLparEffProcessorStatus;
	}

	public void setHwLparEffProcessorStatus(String hwLparEffProcessorStatus) {
		this.hwLparEffProcessorStatus = hwLparEffProcessorStatus;
	}

	public String getAlertStatus() {
		if (reconcileId != null) {
			return "<font class=\"blue-med\">Blue</font>";
		} else if (getAlertAgeI() > AlertView.red) {
			return "<font class=\"alert-stop\">Red</font>";
		} else if (getAlertAgeI() > AlertView.yellow) {
			return "<font class=\"orange-med\">Yellow</font>";
		}

		return "<font class=\"alert-go\">Green</font>";
	}

	/**
	 * @return the chips
	 */
	public Integer getChips() {
		return chips;
	}

	/**
	 * @param chips
	 *            the chips to set
	 */
	public void setChips(Integer chips) {
		this.chips = chips;
	}

	public String getHardwareStatus() {
		return hardwareStatus;
	}

	public void setHardwareStatus(String hardwareStatus) {
		this.hardwareStatus = hardwareStatus;
	}

	public String getLparStatus() {
		return lparStatus;
	}

	public void setLparStatus(String lparStatus) {
		this.lparStatus = lparStatus;
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

	public String getMastProcessorType() {
		return mastProcessorType;
	}

	public void setMastProcessorType(String mastProcessorType) {
		this.mastProcessorType = mastProcessorType;
	}

	public String getProcessorManufacturer() {
		return processorManufacturer;
	}

	public void setProcessorManufacturer(String processorManufacturer) {
		this.processorManufacturer = processorManufacturer;
	}

	public String getMastProcessorModel() {
		return mastProcessorModel;
	}

	public void setMastProcessorModel(String mastProcessorModel) {
		this.mastProcessorModel = mastProcessorModel;
	}

	public BigDecimal getNbrCoresPerChip() {
		return nbrCoresPerChip;
	}

	public void setNbrCoresPerChip(BigDecimal nbrCoresPerChip) {
		this.nbrCoresPerChip = nbrCoresPerChip;
	}

	public BigDecimal getNbrOfChipsMax() {
		return nbrOfChipsMax;
	}

	public void setNbrOfChipsMax(BigDecimal nbrOfChipsMax) {
		this.nbrOfChipsMax = nbrOfChipsMax;
	}

	public String getShared() {
		return shared;
	}

	public void setShared(String shared) {
		this.shared = shared;
	}

	public Integer getCpuIFL() {
		return cpuIFL;
	}

	public void setCpuIFL(Integer cpuIFL) {
		this.cpuIFL = cpuIFL;
	}

	public String getOsType() {
		return osType;
	}

	public void setOsType(String osType) {
		this.osType = osType;
	}

	public BigDecimal getEffectiveThreads() {
		return effectiveThreads;
	}

	public void setEffectiveThreads(BigDecimal effectiveThreads) {
		this.effectiveThreads = effectiveThreads;
	}
}
