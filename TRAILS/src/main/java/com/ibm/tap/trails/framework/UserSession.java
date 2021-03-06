package com.ibm.tap.trails.framework;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ReconSetting;

public class UserSession {

	@SuppressWarnings("unused")
	public static final String USER_SESSION = "userSession";

	private String remoteUser;

	private Account account;

	private List alertCountReport;
	
	private List exceptionCountReport;
//AB added
	//Story 26012
	private List<String> SchedulefDefValResult;
	
	private String quantityValResult;
 
	// CPA - 3/31/09 - Commenting out for performance reasons
	//private Integer maxAlertAge;


	public List<String> getSchedulefDefValResult() {
		return SchedulefDefValResult;
	}

	public void setSchedulefDefValResult(List<String> schedulefDefValResult) {
		SchedulefDefValResult = schedulefDefValResult;
	}

	public String getQuantityValResult() {
		return quantityValResult;
	}

	public void setQuantityValResult(String quantityValResult) {
		this.quantityValResult = quantityValResult;
	}



	private ReconSetting reconSetting;

	public UserSession(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public List getAlertCountReport() {
		return alertCountReport;
	}

	public void setAlertCountReport(List alertCountReport) {
		this.alertCountReport = alertCountReport;
	}

	public void setExceptionCountReport(List exceptionCountReport) {
		this.exceptionCountReport = exceptionCountReport;
	}

	public List getExceptionCountReport() {
		return exceptionCountReport;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/* CPA - 3/31/09 - Commenting out for performance reasons
	public Integer getMaxAlertAge() {
		return maxAlertAge;
	}

	public void setMaxAlertAge(Integer maxAlertAge) {
		this.maxAlertAge = maxAlertAge;
	}
	*/

	public ReconSetting getReconSetting() {
		return reconSetting;
	}

	public void setReconSetting(ReconSetting reconSetting) {
		this.reconSetting = reconSetting;
	}

}
