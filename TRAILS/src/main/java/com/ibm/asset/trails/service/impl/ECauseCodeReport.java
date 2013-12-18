package com.ibm.asset.trails.service.impl;

public enum ECauseCodeReport
{

	// 1. Cause Code|2. target date|3. owner|4. change date|5. change person|6.
	// Internal
	// ID|7. message
	NOLICIBM("Unlicensed IBM SW alert report", 17, 5, 6, 7, 8, 9, 10, 11),
	NOLICISV("Unlicensed ISV SW alert report", 17, 5, 6, 7, 8, 9, 10, 11),
	HARDWARE("HW w/o HW LPAR alert report", 3, 9, 10, 11, 12, 13, 14, 15),
	HW_LPAR("HW LPAR w/o SW LPAR alert report", 4, 10, 11, 12, 13, 14, 15, 16),
	SW_LPAR("SW LPAR w/o HW LPAR alert report", 5, 8, 9, 10, 11, 12, 13, 14),
	EXP_SCAN("Outdated SW LPAR alert report", 6, 8, 9, 10, 11, 12, 13, 14);

	private String reportName;
	private int colCauseCode;
	private int colTargetDate;
	private int colOwner;
	private int colChangeDate;
	private int colChangePerson;
	private int colInternalId;
	private int colMessage;
	private long alertTypeId;

	private ECauseCodeReport(String reportName, int alertTypeId, int causeCode,
			int targetDate, int owner, int changeDate, int changePerson,
			int causeCodeId, int message) {
		this.reportName = reportName;
		this.colCauseCode = causeCode;
		this.colTargetDate = targetDate;
		this.colOwner = owner;
		this.colChangeDate = changeDate;
		this.colChangePerson = changePerson;
		this.colInternalId = causeCodeId;
		this.colMessage = message;
		this.alertTypeId = alertTypeId;
	}

	public String getReportName() {
		return this.reportName;
	}

	public int getColCauseCode() {
		return colCauseCode;
	}

	public int getColTargetDate() {
		return colTargetDate;
	}

	public int getColOwner() {
		return colOwner;
	}

	public int getColChangeDate() {
		return colChangeDate;
	}

	public int getColChangePerson() {
		return colChangePerson;
	}

	public int getColInternalId() {
		return colInternalId;
	}

	public int getColMessage() {
		return colMessage;
	}

	public long getAlertTypeId() {
		return alertTypeId;
	}

	public static ECauseCodeReport getReportByName(String name) {
		for (ECauseCodeReport report : ECauseCodeReport.values()) {
			if (report.getReportName().equals(name)) {
				return report;
			}
		}
		return null;
	}

}
