package com.ibm.asset.trails.ws.common;

import java.util.Date;
import java.util.List;

import com.ibm.asset.trails.form.AlertOverviewReport;

public class AccountAlertOverview {
	private List<AlertOverviewReport> overviewList;
	private Date reportTimestamp;
	private Integer reportMinutesOld;
	
	public List<AlertOverviewReport> getOverviewList() {
		return overviewList;
	}
	public void setOverviewList(List<AlertOverviewReport> overviewList) {
		this.overviewList = overviewList;
	}
	public Date getReportTimestamp() {
		return reportTimestamp;
	}
	public void setReportTimestamp(Date reportTimestamp) {
		this.reportTimestamp = reportTimestamp;
	}
	public Integer getReportMinutesOld() {
		return reportMinutesOld;
	}
	public void setReportMinutesOld(Integer reportMinutesOld) {
		this.reportMinutesOld = reportMinutesOld;
	}
}
