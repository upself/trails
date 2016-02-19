package com.ibm.asset.trails.ws;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFView;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

public class ScheduleFServiceEndpoint {
	@Autowired
	private ScheduleFService scheduleFService;
	
	@Autowired
	private AccountService accountService;
	
	@Autowired
	private ReportService reportService;
	
	@POST
	@Path("/scheduleF/all/")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllScheduleFByAccount(@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort,
			@FormParam("dir") String dir,
			@FormParam("accountId") Long accountId){
		
			List<ScheduleF> schFlist = new ArrayList<ScheduleF>();
			List<ScheduleFView> schFViewList =new ArrayList<ScheduleFView>();
			Long total = Long.valueOf(0);
			
			if(null == accountId){
			   return WSMsg.failMessage("Account ID is required");
			}
			else if(null == currentPage){
			   return WSMsg.failMessage("Current Page Parameter is required");
			}
			else if(null == pageSize){
			   return WSMsg.failMessage("Page Size Parameter is required");
			}
			else if(null == sort || "".equals(sort.trim())){
			   return WSMsg.failMessage("Sort Column Parameter is required"); 	
			}
			else if(null == dir || "".equals(dir.trim())){
			   return WSMsg.failMessage("Sort Direction Parameter is required"); 	
			}else{
				Account account = accountService.getAccount(accountId);
				if(null == account){
					return WSMsg.failMessage("Account doesn't exist");
				}
				currentPage=currentPage-1;
				schFlist = getScheduleFService().paginatedList(account, Integer.valueOf(currentPage), Integer.valueOf(pageSize), sort,dir);
				schFViewList = scheduleFtransformer(schFlist);
				total = Long.valueOf(schFViewList.size());
			}
		
		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(schFViewList);
		return WSMsg.successMessage("SUCCESS", page);
	}
	
	@GET
	@Path("/scheduleF/download/{accountId}")
	public Response downloadScheduleFReport(@PathParam("accountId") Long accountId) throws IOException {

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		PrintWriter pw = new PrintWriter(new OutputStreamWriter(bos, "utf-8"), true);
		Account account = accountService.getAccount(accountId);
		getReportService().getScheduleFReport(account,pw);

		ResponseBuilder responseBuilder = Response.ok(bos.toByteArray());
		responseBuilder.header("Content-Type",
				"application/vnd.ms-excel;charset=UTF-8");
		responseBuilder.header("Content-Disposition",
				"attachment; filename=ScheduleF_View.xls");

		return responseBuilder.build();
	}
	
	
	public List<ScheduleFView> scheduleFtransformer(List<ScheduleF> scheFlist){
		List<ScheduleFView> scheFViewList = new ArrayList<ScheduleFView>();
		if(scheFlist!=null && scheFlist.size()>0){
			for(ScheduleF scheduleF:scheFlist){
				if(scheduleF!=null){
					ScheduleFView schFView = new ScheduleFView();
					
					schFView.setId(scheduleF.getId());
					schFView.setSoftwareName(scheduleF.getSoftwareName());
					schFView.setLevel(scheduleF.getLevel());
					
					if(null!=scheduleF.getHwOwner()){
						schFView.setHwOwner(scheduleF.getHwOwner());
					}else{
						schFView.setHwOwner("");
					}
					if(null!=scheduleF.getHostname()){
						schFView.setHostName(scheduleF.getHostname());
					}else{
						schFView.setHostName("");
					}
					if(null!=scheduleF.getSerial()){
						schFView.setSerial(scheduleF.getSerial());
					}else{
						schFView.setSerial("");
					}
					if(null!=scheduleF.getMachineType()){
						schFView.setMachineType(scheduleF.getMachineType());
					}else{
						schFView.setMachineType("");
					}
					if(null!=scheduleF.getSoftwareTitle()){
						schFView.setSoftwareTitle(scheduleF.getSoftwareTitle());
					}else{
						schFView.setSoftwareTitle("");
					}
					if(null!=scheduleF.getManufacturer()){
						schFView.setManufacturer(scheduleF.getManufacturer());
					}else{
						schFView.setManufacturer("");
					}
					if(null!=scheduleF.getSWFinanceResp()){
						schFView.setSWFinanceResp(scheduleF.getSWFinanceResp());
					}else{
						schFView.setSWFinanceResp("");
					}
					
					if(null!=scheduleF.getSourceLocation()){
						schFView.setSourceLocation(scheduleF.getSourceLocation());
					}else{
						schFView.setSourceLocation("");
					}
					
					if(null != scheduleF.getScope() && null != scheduleF.getScope().getDescription()){
						schFView.setScopeDescription(scheduleF.getScope().getDescription());
					}else{
						schFView.setScopeDescription("");
					}
					if(null != scheduleF.getSource() && null !=scheduleF.getSource().getDescription()){
						schFView.setSourceDescription(scheduleF.getSource().getDescription());
					}else{
						schFView.setSourceDescription("");
					}
					if(null != scheduleF.getStatus() && null !=scheduleF.getStatus().getDescription()){
						schFView.setStatusDescription(scheduleF.getStatus().getDescription());
					}else{
						schFView.setStatusDescription("");
					}
					if(null != scheduleF.getAccount() && null!=scheduleF.getAccount().getSoftwareComplianceManagement()){
						schFView.setSoftwareComplianceManagement(scheduleF.getAccount().getSoftwareComplianceManagement());
					}else{
						schFView.setSoftwareComplianceManagement("");
					}
					
					scheFViewList.add(schFView);
				}
			}
		}
		return scheFViewList;
	}
	
	public AccountService getAccountService() {
		return accountService;
	}

	public void setAccountService(AccountService accountService) {
		this.accountService = accountService;
	}

	public ScheduleFService getScheduleFService() {
		return scheduleFService;
	}

	public void setScheduleFService(ScheduleFService scheduleFService) {
		this.scheduleFService = scheduleFService;
	}
	
	public ReportService getReportService() {
		return reportService;
	}

	public void setReportService(ReportService reportService) {
		this.reportService = reportService;
	}
}
