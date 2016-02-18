package com.ibm.asset.trails.ws;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ScheduleFService;
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
		
		return null;
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
