package com.ibm.asset.trails.ws;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.fasterxml.jackson.jaxrs.json.JacksonJaxbJsonProvider;
import com.ibm.asset.trails.action.AccountAction;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.AlertService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/alertWithDefinedContractScope")
public class AlertWithDefinedContractScopeServiceEndpoint {
	@Autowired
	private @Qualifier("alertWithDefinedContractScopeService") AlertService alertService;
	
	@Autowired
	private AccountService accountService;
	
	@Autowired
	private ReportService reportService;
	
	
	@POST
	@Path("/search")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAlertWithDefinedContractScopeList(@FormParam("accountId") Long accountId,
			@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort,
			@FormParam("dir") String dir){
		
		System.out.println("getAlertWithDefinedContractScopeList run");
		
		if(null == accountId){
			return WSMsg.failMessage("Account ID is required");
		}else{
			Account account = accountService.getAccount(accountId);
			if(null == account){
				return WSMsg.failMessage("Account doesn't exist");
			}else{
				int startIndex = 99999;
				try {
					startIndex = (currentPage-1) * pageSize;
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				Long total = alertService.total(account);
				System.out.println("total is : " + total);
				System.out.println("account is : " + account.getAccountStr());
				System.out.println("startIndex is : " + startIndex); 
				System.out.println("pageSize is : " + pageSize); 
				System.out.println("sort is : " + sort);
				System.out.println("dir is : " + dir);
								
				List<?> list = null;
				try {
					list = alertService.paginatedList(account, startIndex, pageSize, sort, dir);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					e.getMessage();
					e.getCause();
				}
				
				for (int i = 0; i < list.size(); i++) {
					System.out.println("List entry number " + i
							+ list.get(i).toString());
				}
				
				Pagination page = new Pagination();
				page.setPageSize(pageSize.longValue());
				page.setTotal(total);
				page.setCurrentPage(currentPage.longValue());
				page.setList(list);
				return WSMsg.successMessage("SUCCESS", page);	
			}
		}
	}
	
//	@POST
//	@Path("/assign/ids")
//	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
//	public WSMsg assignAlertWithDefinedContractScopeList(@FormParam("comments") String comments,
//			@FormParam("assignIds") String assignIds,
//			@Context HttpServletRequest request){
//		try{
//			List<Long> assignList = new ArrayList<Long>();
//			for(String idStr : assignIds.split(",")){
//				assignList.add(Long.valueOf(idStr));
//			}
//			alertService.assign(assignList, request.getRemoteUser(), comments);
//			return WSMsg.successMessage("Assign success");
//		}catch(Exception e){
//			e.printStackTrace();
//			return WSMsg.failMessage("Assign failed");
//		}
//	}
//	
//	@POST
//	@Path("/assign/all")
//	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
//	public WSMsg assignAlertWithDefinedContractScopeList(@FormParam("accountId") Long accountId, @FormParam("comments") String comments,
//			@Context HttpServletRequest request){
//		try{
//			Account account = accountService.getAccount(accountId);
//			if(null == account){
//				return WSMsg.failMessage("Account doesn't exist");
//			}else{
//				alertService.assignAll(account, request.getRemoteUser(), comments);
//				return WSMsg.successMessage("Assign success");
//			}
//		}catch(Exception e){
//			e.printStackTrace();
//			return WSMsg.failMessage("Assign failed");
//		}
//	}
//	
//	@POST
//	@Path("/unassign/ids")
//	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
//	public WSMsg unassignAlertWithDefinedContractScopeList(@FormParam("unassignIds") String unassignIds, @FormParam("comments") String comments,
//			@Context HttpServletRequest request){
//		try{
//			List<Long> unassignList = new ArrayList<Long>();
//			for(String idStr : unassignIds.split(",")){
//				unassignList.add(Long.valueOf(idStr));
//			}
//			alertService.unassign(unassignList, request.getRemoteUser(), comments);
//			return WSMsg.successMessage("Unassign success");
//		}catch(Exception e){
//			e.printStackTrace();
//			return WSMsg.failMessage("Unassign failed");
//		}
//	}
//	
//	@POST
//	@Path("/unassign/all")
//	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
//	public WSMsg unassignAlertWithDefinedContractScopeList(@FormParam("accountId") Long accountId, @FormParam("comments") String comments,
//			@Context HttpServletRequest request){
//		try{
//			Account account = accountService.getAccount(accountId);
//			if(null == account){
//				return WSMsg.failMessage("Account doesn't exist");
//			}else{
//				alertService.unassignAll(account, request.getRemoteUser(), comments);
//				return WSMsg.successMessage("Unassign success");
//			}
//			
//			
//		}catch(Exception e){
//			e.printStackTrace();
//			return WSMsg.failMessage("Unassign failed");
//		}
//	}
	
	@GET
	@Path("/download/{accountId}")
	public Response download(@PathParam("accountId") Long accountId,@Context HttpServletRequest request,@Context HttpServletResponse response) throws IOException {
		
		try{
			
			HSSFWorkbook hwb=new HSSFWorkbook();
			Account account = accountService.getAccount(accountId);
			
			response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-Disposition","attachment; filename=alertContractScopeCNDBID.xls");
			reportService.getAlertWithDefinedContractScopeReport(account, request.getRemoteUser(), null, hwb, response.getOutputStream());
			
		}catch(Exception e){
			e.printStackTrace();
		}


		ResponseBuilder responseBuilder = Response.ok(response.getOutputStream());
		return responseBuilder.build();
	}
}
