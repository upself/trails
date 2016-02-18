package com.ibm.asset.trails.ws;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

public class ScheduleFServiceEndpoint {
	@Autowired
	private ScheduleFService scheduleFService;
	
	@Autowired
	private AccountService accountService;
	
	@POST
	@Path("/scheduleF/all/{accountId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllScheduleFByAccount(@QueryParam("currentPage") Integer currentPage,
			@QueryParam("pageSize") Integer pageSize,
			@QueryParam("sort") String sort,
			@QueryParam("dir") String dir,
			@PathParam("accountId") Long accountId){
		
			List<ScheduleF> schFlist = new ArrayList<ScheduleF>();
			Long total = null;
			
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
				schFlist = getScheduleFService().paginatedList(account, Integer.valueOf(currentPage), Integer.valueOf(pageSize), sort,dir);
				
				total = Long.valueOf(schFlist.size());
			}
		
		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(schFlist);
		return WSMsg.successMessage("SUCCESS", page);
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
}
