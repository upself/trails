package com.ibm.asset.trails.domain;

public class ReconSetting {

	private Long reconcileType;

	private String alertStatus;

	private String alertColor;

	private String assigned;

	private String assignee;

	private String owner;

	private String[] countries = new String[6];

	private String[] names = new String[6];

	private String[] serialNumbers = new String[6];

	private String[] productInfoNames = new String[6];

	public String getAlertColor() {
		return alertColor;
	}

	public void setAlertColor(String alertColor) {
		this.alertColor = alertColor;
	}

	public String getAlertStatus() {
		return alertStatus;
	}

	public void setAlertStatus(String alertStatus) {
		this.alertStatus = alertStatus;
	}

	public String getAssigned() {
		return assigned;
	}

	public void setAssigned(String assigned) {
		this.assigned = assigned;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String[] getCountries() {
		return countries;
	}

	public void setCountries(String[] countries) {
		this.countries = countries;
	}

	public String[] getNames() {
		return names;
	}

	public void setNames(String[] names) {
		this.names = names;
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public Long getReconcileType() {
		return reconcileType;
	}

	public void setReconcileType(Long reconcileType) {
		this.reconcileType = reconcileType;
	}

	public String[] getSerialNumbers() {
		return serialNumbers;
	}

	public void setSerialNumbers(String[] serialNumbers) {
		this.serialNumbers = serialNumbers;
	}

	public String[] getProductInfoNames() {
		return productInfoNames;
	}

	public void setProductInfoNames(String[] productInfoNames) {
		this.productInfoNames = productInfoNames;
	}
}

