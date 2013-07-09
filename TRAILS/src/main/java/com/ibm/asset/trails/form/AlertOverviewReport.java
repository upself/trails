package com.ibm.asset.trails.form;

public class AlertOverviewReport {

	private String name;

	private Long id;

	private Long accountNumber;

	private String alertName;

	private Long assignedCount;

	private Long redSum;

	private Long yellowSum;

	private Long greenSum;

	public AlertOverviewReport(String name, Long id, String alertName,
			Long assignedCount, Long redSum, Long yellowSum, Long greenSum) {
		this.name = name;
		this.id = id;
		this.alertName = alertName;
		this.assignedCount = assignedCount;
		this.redSum = redSum;
		this.yellowSum = yellowSum;
		this.greenSum = greenSum;
	}

	public AlertOverviewReport(String name, Long accountNumber, Long id,
			String alertName, Long assignedCount, Long redSum, Long yellowSum,
			Long greenSum) {
		this.name = name;
		this.accountNumber = accountNumber;
		this.id = id;
		this.alertName = alertName;
		this.assignedCount = assignedCount;
		this.redSum = redSum;
		this.yellowSum = yellowSum;
		this.greenSum = greenSum;
	}

	public String getAlertName() {
		return alertName;
	}

	public void setAlertName(String alertName) {
		this.alertName = alertName;
	}

	public String getAlertNameWithCount() {

		int sum = getGreenSum().intValue() + getYellowSum().intValue()
				+ getRedSum().intValue();

		return getAlertName() + "(" + sum + ")";
	}

	public Long getAssignedCount() {
		return assignedCount;
	}

	public void setAssignedCount(Long assignedCount) {
		this.assignedCount = assignedCount;
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

	public Long getGreenSum() {
		return greenSum;
	}

	public void setGreenSum(Long greenSum) {
		this.greenSum = greenSum;
	}

	public Long getRedSum() {
		return redSum;
	}

	public void setRedSum(Long redSum) {
		this.redSum = redSum;
	}

	public Long getYellowSum() {
		return yellowSum;
	}

	public void setYellowSum(Long yellowSum) {
		this.yellowSum = yellowSum;
	}

	public Long getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}
}
