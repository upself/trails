package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


public class Recon implements Serializable {

	private static final long serialVersionUID = 1L;

	private Long reconcileTypeId;

	private ReconcileType reconcileType;

	private List<ReconWorkspace> list = new ArrayList<ReconWorkspace>();

	private List<InstalledSoftware> installedSoftwareList = new ArrayList<InstalledSoftware>();

	private String runon;

	private boolean automated;

	private boolean manual;

	private Long installedSoftwareId;

	private InstalledSoftware installedSoftware;

	private String comments;

	private List<License> licenseList;

	private Integer maxLicenses;

	private String per;

	public List<InstalledSoftware> getInstalledSoftwareList() {
		return installedSoftwareList;
	}

	public void setInstalledSoftwareList(List<InstalledSoftware> installedSoftwareList) {
		this.installedSoftwareList = installedSoftwareList;
	}

	public List<ReconWorkspace> getList() {
		return list;
	}

	public void setList(List<ReconWorkspace> list) {
		this.list = list;
	}

	public ReconcileType getReconcileType() {
		return reconcileType;
	}

	public void setReconcileType(ReconcileType reconcileType) {
		this.reconcileType = reconcileType;
	}

	public Long getReconcileTypeId() {
		return reconcileTypeId;
	}

	public void setReconcileTypeId(Long reconcileTypeId) {
		this.reconcileTypeId = reconcileTypeId;
	}

	public boolean isAutomated() {
		return automated;
	}

	public void setAutomated(boolean automated) {
		this.automated = automated;
	}

	public InstalledSoftware getInstalledSoftware() {
		return installedSoftware;
	}

	public void setInstalledSoftware(InstalledSoftware installedSoftware) {
		this.installedSoftware = installedSoftware;
	}

	public Long getInstalledSoftwareId() {
		return installedSoftwareId;
	}

	public void setInstalledSoftwareId(Long installedSoftwareId) {
		this.installedSoftwareId = installedSoftwareId;
	}

	public boolean isManual() {
		return manual;
	}

	public void setManual(boolean manual) {
		this.manual = manual;
	}

	public String getRunon() {
		return runon;
	}

	public void setRunon(String runon) {
		this.runon = runon;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		if (comments == null) {
			this.comments = comments;
		} else {
			this.comments = comments.replaceAll("\\s\\s+|\\n|\\r|\\t", " ");
		}
	}

	public List<License> getLicenseList() {
		return licenseList;
	}

	public void setLicenseList(List<License> licenseList) {
		this.licenseList = licenseList;
	}

	public Integer getMaxLicenses() {
		return maxLicenses;
	}

	public void setMaxLicenses(Integer maxLicenses) {
		this.maxLicenses = maxLicenses;
	}

	public String getPer() {
		return per;
	}

	public void setPer(String per) {
		this.per = per;
	}
}
