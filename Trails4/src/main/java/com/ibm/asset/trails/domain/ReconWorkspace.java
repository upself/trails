package com.ibm.asset.trails.domain;

import java.io.Serializable;


public class ReconWorkspace implements Serializable {

    /**
	 * 
	 */
    private static final long serialVersionUID = 1L;

    // TODO called it this because of hibernate would not use the correct
    // mapping in where clause
    private Integer           alertAgeI;

    private String            hostname;

    private String            serial;

    private String            country;

    private String            owner;

    private String            assetType;

    private Integer           processorCount;

    private String            productInfoName;

    private Long              reconcileTypeId;

    private String            reconcileTypeName;

    private String            assignee;

    private Long              installedSoftwareId;

    private boolean           selected;

    private Long              alertId;

    private Long              reconcileId;

    private Long              productInfoId;

    private Integer           hardwareProcessorCount;

    private Integer           chips;

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
}
