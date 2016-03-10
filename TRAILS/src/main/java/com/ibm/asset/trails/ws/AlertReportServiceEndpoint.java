package com.ibm.asset.trails.ws;

import java.util.Date;
import java.util.List;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.form.AlertOverviewReport;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.AlertReportService;
import com.ibm.asset.trails.ws.common.AccountAlertOverview;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/alert")
public class AlertReportServiceEndpoint {

	@Autowired
	private AlertReportService alertReportService;
	
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
}
