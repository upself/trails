package com.ibm.asset.trails.ws;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.DataExceptionHistory;
import com.ibm.asset.trails.domain.DataExceptionHistoryView;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLparView;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/exceptions")
public class DataExceptionServiceEndpoint {
	@Autowired
	private @Qualifier("alertSwlparService") DataExceptionService dataExpSoftwareLparService;
	
	@Autowired
	private @Qualifier("alertHwlparService")DataExceptionService dataExpHardwareLparService;
	
	@Autowired
	private AccountService accountService;
	
	@Autowired
	private DataExceptionHistoryDao alertHistoryDao;
	
	private final String SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST = "/NULLTIME/NOCUST/NOLP/NOOS/ZEROPROC/NOSW/";
	private final String HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST = "/HWNCHP/HWNPRC/NCPMDL/NPRCTYP/";
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
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
		}
		else{
			Account account = accountService.getAccount(accountId);
			if(null == account){
				return WSMsg.failMessage("Account doesn't exist");
			}else{
				int startIndex = (currentPage-1) * pageSize;
				
				Long total = null;
				List list = null;
				AlertType alertType = null;
				dataExpType = dataExpType.trim().toUpperCase();
				
				if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
				   dataExpSoftwareLparService.setAlertTypeCode(dataExpType);
				   alertType = dataExpSoftwareLparService.getAlertType();
				   total = new Long(dataExpSoftwareLparService.getAlertListSize(account, alertType));
				   list = dataExpSoftwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
				   list = this.swLparDataExpsTransformer(list);
				}
				else if(HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Hardware Lpar Data Exception Type
				   dataExpHardwareLparService.setAlertTypeCode(dataExpType);
				   alertType = dataExpHardwareLparService.getAlertType();
				   total = new Long(dataExpHardwareLparService.getAlertListSize(account, alertType));
				   list = dataExpHardwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
				}
				else{
				  return WSMsg.failMessage("Data Exception Type {"+dataExpType+"} doesn't exist");
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
		else if(null == assignIds || "".equals(assignIds.trim())){
			return WSMsg.failMessage("Assign Ids List is required");	
		}
		else if(null == comments || "".equals(comments.trim())){
			return WSMsg.failMessage("Comment is required");	
		}
		else{
			try{
				List<Long> assignList = new ArrayList<Long>();
				for(String idStr : assignIds.split(",")){
					assignList.add(Long.valueOf(idStr));
				}
				
				dataExpType = dataExpType.trim().toUpperCase();
				if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
					dataExpSoftwareLparService.assign(assignList, request.getRemoteUser(), comments);	  
				}
				else if(HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Hardware Lpar Data Exception Type
					dataExpHardwareLparService.assign(assignList, request.getRemoteUser(), comments);
				}
				else{
					return WSMsg.failMessage("Data Exception Type {"+dataExpType+"} doesn't exist");	
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
		else if(null == unassignIds || "".equals(unassignIds.trim())){
			return WSMsg.failMessage("Unassign Ids List is required");	
		}
		else if(null == comments || "".equals(comments.trim())){
			return WSMsg.failMessage("Comment is required");	
		}
		else{
			try{
				List<Long> unassignList = new ArrayList<Long>();
				for(String idStr : unassignIds.split(",")){
					unassignList.add(Long.valueOf(idStr.trim()));
				}
				
				dataExpType = dataExpType.trim().toUpperCase();
				if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
					dataExpSoftwareLparService.unassign(unassignList, request.getRemoteUser(), comments);	  
				}
				else if(HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Hardware Lpar Data Exception Type
					dataExpHardwareLparService.unassign(unassignList, request.getRemoteUser(), comments);
				}
				else{
					return WSMsg.failMessage("Data Exception Type {"+dataExpType+"} doesn't exist");	
				}
				
				return WSMsg.successMessage("Unassign success");
			}catch(Exception e){
				e.printStackTrace();
				return WSMsg.failMessage("Unassign failed");
			}
		}	
 }
	
	@POST
	@Path("/{dataExpType}/assignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg assignAllDataExceptionDataList(@PathParam("dataExpType") String dataExpType,
			@FormParam("accountId") Long accountId,
			@FormParam("comments") String comments,
			@Context HttpServletRequest request){
		
		if(null == dataExpType || "".equals(dataExpType.trim())){
		  return WSMsg.failMessage("Data Exception Type is required"); 	
		}
		else if(null == accountId){
		  return WSMsg.failMessage("Account ID is required");
		}
		else if(null == comments || "".equals(comments.trim())){
		  return WSMsg.failMessage("Comment is required");	
		}
		else{
			try{
				Account account = accountService.getAccount(accountId);
				if(null == account){
					return WSMsg.failMessage("Account doesn't exist");
				}
				else
				{
					Long customerId = account.getId();
					dataExpType = dataExpType.trim().toUpperCase();
					if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
						dataExpSoftwareLparService.assignAll(customerId ,dataExpType, request.getRemoteUser(), comments);	  
					}
					else if(HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Hardware Lpar Data Exception Type
						dataExpHardwareLparService.assignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					}
					else{
						return WSMsg.failMessage("Data Exception Type {"+dataExpType+"} doesn't exist");	
					}
					
					return WSMsg.successMessage("Assign success");
				}
			}catch(Exception e){
				e.printStackTrace();
				return WSMsg.failMessage("Assign failed");
			}
		}
	}
	
	
	@POST
	@Path("/{dataExpType}/unassignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg unassignAllDataExceptionDataList(@PathParam("dataExpType") String dataExpType,
			@FormParam("accountId") Long accountId,
			@FormParam("comments") String comments,
			@Context HttpServletRequest request){
		
		if(null == dataExpType || "".equals(dataExpType.trim())){
		  return WSMsg.failMessage("Data Exception Type is required"); 	
		}
		else if(null == accountId){
		  return WSMsg.failMessage("Account ID is required");
		}
		else if(null == comments || "".equals(comments.trim())){
		  return WSMsg.failMessage("Comment is required");	
		}
		else{
			try{
				Account account = accountService.getAccount(accountId);
				if(null == account){
					return WSMsg.failMessage("Account doesn't exist");
				}
				else
				{
					Long customerId = account.getId();
					dataExpType = dataExpType.trim().toUpperCase();
					if(SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Software Lpar Data Exception Type
						dataExpSoftwareLparService.unassignAll(customerId ,dataExpType, request.getRemoteUser(), comments);	  
					}
					else if(HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType)!=-1){//Hardware Lpar Data Exception Type
						dataExpHardwareLparService.unassignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					}
					else{
						return WSMsg.failMessage("Data Exception Type {"+dataExpType+"} doesn't exist");	
					}
					
					return WSMsg.successMessage("Unassign success");
				}
			}catch(Exception e){
				e.printStackTrace();
				return WSMsg.failMessage("Unassign failed");
			}
		}
	}
	
	@GET
	@Path("/{dataExpType}/history/{exceptionId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getDataException(@PathParam("dataExpType") String dataExpType,
			@PathParam("exceptionId") Long exceptionId){
		
		if(null == dataExpType || "".equals(dataExpType.trim())){
		  return WSMsg.failMessage("Data Exception Type is required"); 	
		}
		else if(null == exceptionId){
		  return WSMsg.failMessage("Exception ID is required");
		}
		else{
			List<DataExceptionHistory> dataExpHistoryList = alertHistoryDao.getByAlertId(exceptionId);
			List<DataExceptionHistoryView> dataExpHistoryTransformList = this.dataExpHistoryTransformer(dataExpHistoryList);
			return WSMsg.successMessage("SUCCESS", dataExpHistoryTransformList);	
		}
	}

	private List<DataExceptionHistoryView> dataExpHistoryTransformer(List<DataExceptionHistory> dataExpHistoryList){
		 List<DataExceptionHistoryView> dataExpHistoryTransformList = new ArrayList<DataExceptionHistoryView>();
		 for(DataExceptionHistory dataExpHistory : dataExpHistoryList){
			 DataExceptionHistoryView  dataExpHistoryView = new DataExceptionHistoryView();
			 dataExpHistoryView.setCustomerId(dataExpHistory.getAccount().getId());
			 dataExpHistoryView.setAccountNumber(dataExpHistory.getAccount().getAccount());
			 dataExpHistoryView.setDataExpHistoryId(dataExpHistory.getId());
			 dataExpHistoryView.setDataExpId(dataExpHistory.getAlert().getId());
			 dataExpHistoryView.setDataExpTypeId(dataExpHistory.getAlertType().getId());
			 dataExpHistoryView.setDataExpTypeName(dataExpHistory.getAlertType().getName());
			 dataExpHistoryView.setCreationTime(dataExpHistory.getCreationTime());
			 dataExpHistoryView.setRecordTime(dataExpHistory.getRecordTime());
			 dataExpHistoryView.setRemoteUser(dataExpHistory.getRemoteUser());
			 if(dataExpHistory.getAssignee()!=null){
				 dataExpHistoryView.setAssignee(dataExpHistory.getAssignee());
			 }
			 else{
				 dataExpHistoryView.setAssignee("");
			 }
			 dataExpHistoryView.setComment(dataExpHistory.getComment());
			 dataExpHistoryTransformList.add(dataExpHistoryView);
		 }
		 
		 return dataExpHistoryTransformList;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private List swLparDataExpsTransformer(List<DataExceptionSoftwareLpar> swLparDataExpsList){
	  List swLparDataExpsTransformList = new ArrayList();
	  for(DataExceptionSoftwareLpar swLparDataExp : swLparDataExpsList){
		  DataExceptionSoftwareLparView swLparDataExpView = new DataExceptionSoftwareLparView();
		  swLparDataExpView.setDataExpId(swLparDataExp.getId());
		  swLparDataExpView.setDataExpType(swLparDataExp.getAlertType().getCode());
		  swLparDataExpView.setDataExpCreationTime(swLparDataExp.getCreationTime());
		  if(swLparDataExp.getAssignee()!=null){
		    swLparDataExpView.setDataExpAssignee(swLparDataExp.getAssignee());
		  }
		  else{
			swLparDataExpView.setDataExpAssignee("");  
		  }
	
		  swLparDataExpView.setSwLparId(swLparDataExp.getSoftwareLpar().getId());
		  
		  if(swLparDataExp.getSoftwareLpar().getName()!=null){
		    swLparDataExpView.setSwLparName(swLparDataExp.getSoftwareLpar().getName());
		  }
		  else{
			swLparDataExpView.setSwLparName("");  
		  }
		  
		  if(swLparDataExp.getSoftwareLpar().getOsName()!=null){
		    swLparDataExpView.setSwLparOSName(swLparDataExp.getSoftwareLpar().getOsName());
		  }
		  else{
			swLparDataExpView.setSwLparOSName("");  
		  }
		  
		  swLparDataExpView.setSwLparScanTime(swLparDataExp.getSoftwareLpar().getScanTime());
		  
		  if(swLparDataExp.getSoftwareLpar().getSerial()!=null){
		    swLparDataExpView.setSwLparSerial(swLparDataExp.getSoftwareLpar().getSerial());
		  }
		  else{
			swLparDataExpView.setSwLparSerial("");  
		  }
		  
		  swLparDataExpView.setSwLparAccountNumber(swLparDataExp.getSoftwareLpar().getAccount().getAccount());
		  swLparDataExpsTransformList.add(swLparDataExpView);
	  }
	  return swLparDataExpsTransformList;
	}
}
