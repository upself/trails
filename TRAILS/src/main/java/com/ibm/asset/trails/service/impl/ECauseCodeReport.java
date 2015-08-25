package com.ibm.asset.trails.service.impl;

public enum ECauseCodeReport
{

	// 1. Report Name|2. Alert Type Id |3. Assignee|4. Assignee comments|5. Assigned date/time|
	// 6. Cause Code (CC)|7. CC target date|8. CC owner|9. CC change date|10. CC change person|
	// 11. CC Internal ID|12. message
	NOLICIBM("Unlicensed IBM SW alert report", 17, -1, -1, -1, 6, 7, 8, 9, 10, 11, 12),
	NOLICISV("Unlicensed ISV SW alert report", 17, -1, -1, -1, 6, 7, 8, 9, 10, 11, 12),
	HARDWARE("HW w/o HW LPAR alert report", 3, -1, -1, -1, 9, 10, 11, 12, 13, 14, 15),
	HW_LPAR("HW LPAR w/o SW LPAR alert report", 4, -1, -1, -1, 10, 11, 12, 13, 14, 15, 16),
	SW_LPAR("SW LPAR w/o HW LPAR alert report", 5, -1, -1, -1, 8, 9, 10, 11, 12, 13, 14),
	EXP_SCAN("Outdated SW LPAR alert report", 6, -1, -1, -1,  8, 9, 10, 11, 12, 13, 14), 
	SOM1B("SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED", 37, -1, -1, -1, 19, 20, 21, 22, 23, 24, 25),
	SOM3("SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE", 57, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);

	private String reportName;
	private long alertTypeId;
	private int colAssignee;
	private int colAssigneeComments;
	private int colAssignedDate;
	private int colCauseCode;
	private int colTargetDate;
	private int colOwner;
	private int colChangeDate;
	private int colChangePerson;
	private int colInternalId;
	private int colMessage;

	private ECauseCodeReport(String reportName, int alertTypeId, int assignee, int assigneeComments, int assignedDate,
			int causeCode,int targetDate, int owner, int changeDate, int changePerson,
			int causeCodeId, int message) {
		this.reportName = reportName;
		this.alertTypeId = alertTypeId;
		this.colAssignee = assignee;
		this.colAssigneeComments = assigneeComments;
		this.colAssignedDate = assignedDate;
		this.colCauseCode = causeCode;
		this.colTargetDate = targetDate;
		this.colOwner = owner;
		this.colChangeDate = changeDate;
		this.colChangePerson = changePerson;
		this.colInternalId = causeCodeId;
		this.colMessage = message;
		
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
	
	public int getColAssignee() {
		return colAssignee;
	}

	public int getColAssigneeComments() {
		return colAssigneeComments;
	}

	public int getColAssignedDate() {
		return colAssignedDate;
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
