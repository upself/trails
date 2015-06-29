package com.ibm.asset.trails.ws;

import java.io.*;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;

import java.util.Date;

import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ManufacturerService;
import com.ibm.asset.trails.service.PriorityISVSoftwareService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/priorityISV")
public class PriorityISVSoftwareServiceEndpoint {
	
	@Autowired
	private PriorityISVSoftwareService priorityISVSoftwareService;
	
	@Autowired
	private AccountService accountService;
	
	@Autowired
	private ManufacturerService manufacturerService;
	
	@Autowired
	private ReportService reportService;

	@GET
	@Path("/isv/{id}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getPriorityISVSoftwareDisplayById(@PathParam("id") Long id){
		
	  PriorityISVSoftwareDisplay result = this.priorityISVSoftwareService.findPriorityISVSoftwareDisplayById(id);
	  if(result == null){
		return WSMsg.failMessage("No Priority ISV Software Data has been found for id = "+id+"!");
	  }
	  else{
	    return WSMsg.successMessage("The Priority ISV Software Data has been found for id = "+id+".",result);
	  }
	}
	
	@GET
	@Path("/isv/all")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllPriorityISVSoftwareDisplays(){
		
	  List<PriorityISVSoftwareDisplay> results = this.priorityISVSoftwareService.getAllPriorityISVSoftwareDisplays();
	  if(results == null){
		return WSMsg.failMessage("No Priority ISV Software Data has been returned!");
	  }
	  else{
	    return WSMsg.successMessage("All Priority ISV Software Data have been returned.",results);
	  }
	}
	
	@GET
	@Path("/isvh/{isvid}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getPriorityISVSoftwareHDisplaysByISVSoftwareId(@PathParam("isvid") Long priorityISVSoftwareId){
		
	  List<PriorityISVSoftwareHDisplay> results = this.priorityISVSoftwareService.findPriorityISVSoftwareHDisplaysByISVSoftwareId(priorityISVSoftwareId);
	  
	  if(results == null){
		return WSMsg.failMessage("No Priority ISV Software History Data has been found for priorityISVSoftwareId = "+priorityISVSoftwareId+"!");
	  }
	  else{
	    return WSMsg.successMessage("The Priority ISV Software History Data has been found for priorityISVSoftwareId = "+priorityISVSoftwareId+".",results);
	  }
	}
		
	@PUT
	@Path("/isv")
	@Consumes("application/json") 
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg addPriorityISVSoftware(PriorityISVSoftwareDisplay addISV,
			@Context HttpServletRequest request) {
		
		 String level = addISV.getLevel();
		 Long customerId = addISV.getCustomerId();
		 Long manufacturerId = addISV.getManufacturerId();
		 String evidenceLocation = addISV.getEvidenceLocation();
		 Long statusId = addISV.getStatusId();
		 String businessJustification = addISV.getBusinessJustification();
		
		//validation
		if (null == level || "".equals(level.trim())) {//GLOBAL or ACCOUNT
			return WSMsg.failMessage("Level is required!");
		}
		else{
		   if("ACCOUNT".equals(level.trim().toUpperCase()) && (null == customerId)){//If level is ACCOUNT, then the customer id value is needed
		     return WSMsg.failMessage("Customer Id is required!");  	   
		   }	
		}
		
		if(null == manufacturerId) {
			return WSMsg.failMessage("Manufacturer Id is required!");
		} else if (null == evidenceLocation || "".equals(evidenceLocation.trim())) {
			return WSMsg.failMessage("Evidence Location is required!");
		} else if (null == statusId) {
			return WSMsg.failMessage("Status Id is required!");
		} else if (null == businessJustification || "".equals(businessJustification.trim())) {
			return WSMsg.failMessage("Business Justification is required!");
		}
		
		Account customer = this.accountService.getAccount(customerId);
		if(customer == null){
		  return WSMsg.failMessage("No Customer has been found for Customer Id: "+customerId+"!");	
		}
		
		Manufacturer manufacturer = this.manufacturerService.findManufacturerById(manufacturerId);
		if(manufacturer == null){
	      return WSMsg.failMessage("No Manufacturer has been found for Manufacturer Id:"+manufacturerId+"!");	
		}
		
		com.ibm.asset.trails.domain.Status status = new com.ibm.asset.trails.domain.Status();
		status.setId(statusId);

		PriorityISVSoftware dbPISVSW = this.priorityISVSoftwareService.findPriorityISVSoftwareByUniqueKeys(level, manufacturerId, customerId); 

		if (null != dbPISVSW) {
			return WSMsg
					.failMessage("Priority ISV Software has already existed for [Level = "
							+ level
							+ ", Customer Id = "
							+customerId
							+ ", Manufacturer Id = "
							+ manufacturerId + "]");
		} else {
			PriorityISVSoftware addISVSW = new PriorityISVSoftware();
			addISVSW.setLevel(level);
			addISVSW.setAccount(customer);
			addISVSW.setManufacturer(manufacturer);
			addISVSW.setEvidenceLocation(evidenceLocation);
			addISVSW.setStatus(status);
			addISVSW.setBusinessJustification(businessJustification);
			addISVSW.setRemoteUser(request.getRemoteUser());
			addISVSW.setRecordTime(new Date());
			this.priorityISVSoftwareService.addPriorityISVSoftware(addISVSW);
			return WSMsg.successMessage("The Priority ISV has been added successfully.");
		}
	}

	@PUT
	@Path("/isv/{id}")
	@Consumes("application/json") 
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg updatePriorityISVSoftware(@PathParam("id") Long id,
			PriorityISVSoftwareDisplay updateISV,
			@Context HttpServletRequest request) {
		 
		 String level = updateISV.getLevel();
		 Long customerId = updateISV.getCustomerId();
		 Long manufacturerId = updateISV.getManufacturerId();
		 String evidenceLocation = updateISV.getEvidenceLocation();
		 Long statusId = updateISV.getStatusId();
		 String businessJustification = updateISV.getBusinessJustification();
		
		//validation
		if (null == level || "".equals(level.trim())) {//GLOBAL or ACCOUNT
			return WSMsg.failMessage("Level is required!");
		}
		else{
		   if("ACCOUNT".equals(level.trim().toUpperCase()) && (null == customerId)){//If level is ACCOUNT, then the customer id value is needed
		     return WSMsg.failMessage("Customer Id is required!");  	   
		   }	
		}
		
		if(null == id){
		    return WSMsg.failMessage("ISV Id is required for update operation!");	
		}
		else if(null == manufacturerId) {
			return WSMsg.failMessage("Manufacturer Id is required!");
		} else if (null == evidenceLocation || "".equals(evidenceLocation.trim())) {
			return WSMsg.failMessage("Evidence Location is required!");
		} else if (null == statusId) {
			return WSMsg.failMessage("Status Id is required!");
		} else if (null == businessJustification || "".equals(businessJustification.trim())) {
			return WSMsg.failMessage("Business Justification is required!");
		}
		
		Account customer = this.accountService.getAccount(customerId);
		if(customer == null){
		  return WSMsg.failMessage("No Customer has been found for Customer Id: "+customerId+"!");	
		}
		
		Manufacturer manufacturer = this.manufacturerService.findManufacturerById(manufacturerId);
		if(manufacturer == null){
	      return WSMsg.failMessage("No Manufacturer has been found for Manufacturer Id:"+manufacturerId+"!");	
		}
		
		com.ibm.asset.trails.domain.Status status = new com.ibm.asset.trails.domain.Status();
		status.setId(statusId);
			
		PriorityISVSoftware dbPISVSW = this.priorityISVSoftwareService.findPriorityISVSoftwareByUniqueKeys(level, manufacturerId, customerId); 

		if (null != dbPISVSW) {
			return WSMsg
					.failMessage("Priority ISV Software has already existed for [Level = "
							+ level
							+ ", Customer Id = "
							+customerId
							+ ", Manufacturer Id = "
							+ manufacturerId + "]");
		} else {
			PriorityISVSoftware updateISVSW = new PriorityISVSoftware();
			updateISVSW.setId(id);
			updateISVSW.setLevel(level);
			updateISVSW.setAccount(customer);
			updateISVSW.setManufacturer(manufacturer);
			updateISVSW.setEvidenceLocation(evidenceLocation);
			updateISVSW.setStatus(status);
			updateISVSW.setBusinessJustification(businessJustification);
			updateISVSW.setRemoteUser(request.getRemoteUser());
			updateISVSW.setRecordTime(new Date());
			this.priorityISVSoftwareService.updatePriorityISVSoftware(updateISVSW);
			return WSMsg.successMessage("The Priority ISV has been updated successfully.");
		}
	}
	
	@GET
	@Path("/isv/alldatafile")
	public Response downloadISVAllDataFile() throws IOException {

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		PrintWriter pw = new PrintWriter(new OutputStreamWriter(bos, "utf-8"),
				true);

		reportService.getPriorityISVSWReport(pw);

		ResponseBuilder responseBuilder = Response.ok(bos.toByteArray());
		responseBuilder.header("Content-Type",
				"application/vnd.ms-excel;charset=UTF-8");
		responseBuilder.header("Content-Disposition",
				"attachment; filename=priorityISVSWReport.xls");

		return responseBuilder.build();
	}
}