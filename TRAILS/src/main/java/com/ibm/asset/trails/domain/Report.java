package com.ibm.asset.trails.domain;

public class Report {

	private String reportDisplayName;

	private String reportFileName;

	public Report(String psReportDisplayName, String psReportFileName) {
	  super();

	  reportDisplayName = psReportDisplayName;
	  reportFileName = psReportFileName;
  }

	public String getReportDisplayName() {
		return reportDisplayName;
	}

	public void setReportDisplayName(String reportDisplayName) {
		this.reportDisplayName = reportDisplayName;
	}

	public String getReportFileName() {
		return reportFileName;
	}

	public void setReportFileName(String reportFileName) {
		this.reportFileName = reportFileName;
	}
}
