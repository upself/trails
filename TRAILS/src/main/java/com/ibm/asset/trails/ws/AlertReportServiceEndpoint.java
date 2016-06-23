package com.ibm.asset.trails.ws;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.form.AlertOverviewReport;
import com.ibm.asset.trails.service.AccountDataExceptionService;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.AlertReportService;
import com.ibm.asset.trails.ws.common.AccountAlertOverview;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/alert")
public class AlertReportServiceEndpoint {

	@Autowired
	private AlertReportService alertReportService;
	
	@Autowired
	private AccountDataExceptionService accountDataExceptionService;
	
	@Autowired
	private AccountService accountService;
	
	
	@POST
	@Path("/overview")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAccountAlertOverview(@FormParam("accountId") Long accountId) {
		if(null == accountId){
			return WSMsg.failMessage("Account ID is required");
		}else{
			Account account = accountService.getAccount(accountId);
			if(null == account){
				return WSMsg.failMessage("Account doesn't exist");
			}else{
				AccountAlertOverview overview = new AccountAlertOverview();
				List list = alertReportService.getAlertsOverview(account);
				Date reportTimestamp = alertReportService.selectReportTimestamp();
				Integer reportMinutesOld = alertReportService.selectReportMinutesOld();
				
				overview.setOverviewList(list);
				overview.setReportTimestamp(reportTimestamp);
				overview.setReportMinutesOld(reportMinutesOld);
				
				return WSMsg.successMessage("SUCCESS", overview);
			}
		}
	}
	
	@POST
	@Path("/account/summary")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAccountAlertSummary(@FormParam("accountId") Long accountId, @FormParam("alertType") String alertType) {
		if(null == accountId){
			return WSMsg.failMessage("Account ID is required");
		} else if(!StringUtils.hasText(alertType)){
			return WSMsg.failMessage("Alert Type is required");
		} else {
			Account account = accountService.getAccount(accountId);
			if(null == account){
				return WSMsg.failMessage("Account doesn't exist");
			}else{
				List<Map<String, String>> alertSummary = accountDataExceptionService.getAlertTypeSummary(account.getId(), alertType);
				if(null == alertSummary || alertSummary.size() <= 0){
					return WSMsg.failMessage("There is no " + alertType + " alerts.");
				}else{
					return WSMsg.successMessage("SUCCESS", alertSummary);
				}
			}
		}
	}
}
