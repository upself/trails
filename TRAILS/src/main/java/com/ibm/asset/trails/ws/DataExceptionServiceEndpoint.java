package com.ibm.asset.trails.ws;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/exceptions")
public class DataExceptionServiceEndpoint {
	@Autowired
	private DataExceptionService alertSoftwareLparService;
	
	@Autowired
	private DataExceptionService alertHardwareLparService;
	
	@Autowired
	private AccountService accountService;
	
	private final String SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST = "/NULLTIME/NOCUST/NOLP/NOOS/ZEROPROC/NOSW/";
	private final String HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST = "/HWNCHP/HWNPRC/NCPMDL/NPRCTYP/";
	
	@SuppressWarnings("rawtypes")
	@POST
	@Path("/{dataExpType}/search")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getDataExceptionDataList(@PathParam("dataExpType") String dataExpType,
			@FormParam("accountId") Long accountId,
			@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort,
			@FormParam("dir") String dir){
		
		if(null == dataExpType || "".equals(dataExpType.trim())){
		  return WSMsg.failMessage("Data Exception Type is required"); 	
		}
		else if(null == accountId){
		  return WSMsg.failMessage("Account ID is required");
		}else{
			Account account = accountService.getAccount(accountId);
			if(null == account){
				return WSMsg.failMessage("Account doesn't exist");
			}else{
				int startIndex = (currentPage-1) * pageSize;
				
				Long total = null;
				List list = null;
				dataExpType = dataExpType.trim();
				AlertType alertType = null;
				
				if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
				   alertSoftwareLparService.setAlertTypeCode(dataExpType);
				   alertType = alertSoftwareLparService.getAlertType();
				   total = new Long(alertSoftwareLparService.getAlertListSize(account, alertType));
				   list = alertSoftwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
				}
				else{//Hardware Lpar Data Exception Type
				   alertHardwareLparService.setAlertTypeCode(dataExpType);
				   alertType = alertHardwareLparService.getAlertType();
				   total = new Long(alertHardwareLparService.getAlertListSize(account, alertType));
				   list = alertHardwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
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
	
	@POST
	@Path("/{dataExpType}/assign")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg assignDataExceptionDataList(@PathParam("dataExpType") String dataExpType,
			@FormParam("comments") String comments,
			@FormParam("assignIds") String assignIds,
			@Context HttpServletRequest request){
		
		if(null == dataExpType || "".equals(dataExpType.trim())){
			  return WSMsg.failMessage("Data Exception Type is required"); 	
			}
		else{
			try{
				List<Long> assignList = new ArrayList<Long>();
				for(String idStr : assignIds.split(",")){
					assignList.add(Long.valueOf(idStr));
				}
				if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
					alertSoftwareLparService.assign(assignList, request.getRemoteUser(), comments);	  
				}
				else{//Hardware Lpar Data Exception Type
					alertHardwareLparService.assign(assignList, request.getRemoteUser(), comments);
				}
				return WSMsg.successMessage("Assign success");
			}catch(Exception e){
				e.printStackTrace();
				return WSMsg.failMessage("Assign failed");
			}
		}	
	}

	@POST
	@Path("/{dataExpType}/unassign")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg unassignDataExceptionDataList(@PathParam("dataExpType") String dataExpType,
			@FormParam("unassignIds") String unassignIds,
			@FormParam("comments") String comments,
			@Context HttpServletRequest request){
		
		if(null == dataExpType || "".equals(dataExpType.trim())){
			  return WSMsg.failMessage("Data Exception Type is required"); 	
			}
		else{
			try{
				List<Long> unassignList = new ArrayList<Long>();
				for(String idStr : unassignIds.split(",")){
					unassignList.add(Long.valueOf(idStr));
				}
				if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
					alertSoftwareLparService.unassign(unassignList, request.getRemoteUser(), comments);	  
				}
				else{//Hardware Lpar Data Exception Type
					alertHardwareLparService.unassign(unassignList, request.getRemoteUser(), comments);
				}
				return WSMsg.successMessage("Unassign success");
			}catch(Exception e){
				e.printStackTrace();
				return WSMsg.failMessage("Unassign failed");
			}
		}	
 }
	
	/*@POST
	@Path("/{dataExpType}/assignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg assignAllAlertHardwareConfigCNDBIDList(@FormParam("accountId") Long accountId, @FormParam("comments") String comments,
			@Context HttpServletRequest request){
		try{
			Account account = accountService.getAccount(accountId);
			if(null == account){
				return WSMsg.failMessage("Account doesn't exist");
			}else{
				alertService.assignAll(account, request.getRemoteUser(), comments);
				return WSMsg.successMessage("Assign success");
			}
		}catch(Exception e){
			e.printStackTrace();
			return WSMsg.failMessage("Assign failed");
		}
	}
	
	@POST
	@Path("/{dataExpType}/unassignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg unassignAllAlertHardwareConfigCNDBIDList(@FormParam("accountId") Long accountId, @FormParam("comments") String comments,
			@Context HttpServletRequest request){
		try{
			Account account = accountService.getAccount(accountId);
			if(null == account){
				return WSMsg.failMessage("Account doesn't exist");
			}else{
				alertService.unassignAll(account, request.getRemoteUser(), comments);
				return WSMsg.successMessage("Unassign success");
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
			return WSMsg.failMessage("Unassign failed");
		}
	}*/
}
