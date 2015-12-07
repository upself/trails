package com.ibm.asset.trails.service.impl;

public enum ECauseCodeReport
{

	// 1. Report Name|2. Alert Type Code |3. Assignee|4. Assignee comments|5. Assigned date/time|
	// 6. Cause Code (CC)|7. CC target date|8. CC owner|9. CC change date|10. CC change person|
	// 11. CC Internal ID|12. message
	SOM1a("SOM1a: HW WITH HOSTNAME", "HARDWARE", 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
	SOM1b("SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED", "HWCFGDTA", 16, 17, 18, 19, 20, 21, 22, 23, 24, 25),
	SOM2a("SOM2a: HW LPAR WITH SW LPAR", "HW_LPAR", 8, 9, 10, 11, 12, 13, 14, 15, 16, 17),
	SOM2b("SOM2b: SW LPAR WITH HW LPAR", "SW_LPAR", 5, 6, 7, 8, 9, 10, 11, 12, 13, 14),
	SOM2c("SOM2c: UNEXPIRED SW LPAR", "EXP_SCAN", 7, 8, 9, 10, 11, 12, 13, 14, 15, 16), 
	SOM3("SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE", "SWISCOPE", 7, 8, 9, 10, 11, 12, 13, 14, 15, 16),
	SOM4a("SOM4a: IBM SW INSTANCES REVIEWED", "SWIBM", 7, 8, 9, 10, 11, 12, 13, 14, 15, 16),
	SOM4b("SOM4b: PRIORITY ISV SW INSTANCES REVIEWED", "SWISVPR", 7, 8, 9, 10, 11, 12, 13, 14, 15, 16),
    SOM4c("SOM4c: ISV SW INSTANCES REVIEWED", "SWISVNPR", 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);

	private String reportName;
	private String alertTypeCode;
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

	private ECauseCodeReport(String reportName, String alertTypeCode, int assignee, int assigneeComments, int assignedDate,
			int causeCode,int targetDate, int owner, int changeDate, int changePerson,
			int causeCodeId, int message) {
		this.reportName = reportName;
		this.alertTypeCode = alertTypeCode;
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

	public String getAlertTypeCode() {
		return alertTypeCode;
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
