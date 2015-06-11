package com.ibm.asset.trails.ws;

import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;
import org.springframework.beans.factory.annotation.Autowired;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.service.NonInstanceService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/noninstance")
public class NonInstanceServiceEndpoint {
	@Autowired
	private NonInstanceService nonInstanceService;
	
	@Autowired
	private ReportService reportService;
	
	@GET
	@Path("/search")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg search(@QueryParam("softwareName") String softwareName,
			@QueryParam("manufacturerName") String manufacturerName,
			@QueryParam("restriction") String restriction,
			@QueryParam("capacityDesc") String capacityDesc,
			@QueryParam("baseOnly") Integer baseOnly,
			@QueryParam("statusId") Long statusId) {

		NonInstanceDisplay searchObj = new NonInstanceDisplay();
		searchObj.setSoftwareName(softwareName);
		searchObj.setManufacturerName(manufacturerName);
		searchObj.setRestriction(restriction);
		searchObj.setCapacityDesc(capacityDesc);
		searchObj.setBaseOnly(baseOnly);
		searchObj.setStatusId(statusId);

		
		List<NonInstanceDisplay> nonList = nonInstanceService.findNonInstanceDisplays(searchObj);
		
		if(null == nonList || nonList.size() <= 0){
			return WSMsg.failMessage("No data found");
		}else{
			return WSMsg.successMessage("", nonList);
		}
	}
	
	@GET
	@Path("/history/{nonInstanceId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg history(@PathParam("nonInstanceId") Long nonInstanceId) {


		List<NonInstanceHDisplay> nonHList = nonInstanceService.findNonInstanceHDisplays(nonInstanceId);
		
		if(null == nonHList || nonHList.size() == 0){
			return WSMsg.failMessage("No data found");
		}else{
			return WSMsg.successMessage("", nonHList);
		}
		
	}
	
	@POST
	@Path("/saveOrUpdate")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getNonInstanceById(
			@FormParam("id") Long id,
			@FormParam("softwareName") String softwareName,
			@FormParam("manufacturerName") String manufacturerName,
			@FormParam("restriction") String restriction,
			@FormParam("capacityDesc") String capacityDesc,
			@FormParam("baseOnly") Integer baseOnly,
			@FormParam("statusId") Long statusId, @Context HttpServletRequest request) {

		//validation
		if(null == softwareName || "".equals(softwareName)){
			return WSMsg.failMessage("Software name is required");
			
		} else if(null == manufacturerName || "".equals(manufacturerName)){
			return WSMsg.failMessage("Manufacturer name is required");
			
		} else if(null == restriction || "".equals(restriction)){
			return WSMsg.failMessage("Restriction is required");
			
		} else if(null == capacityDesc || "".equals(capacityDesc)){
			return WSMsg.failMessage("Capacity description is required");
			
		} else if(null == baseOnly){
			return WSMsg.failMessage("Non instance based only is required");
			
		} else if(null == statusId){
			return WSMsg.failMessage("Status is required");
		} else {
			
		}
		
		List<Software> swList = nonInstanceService.findSoftwareBySoftwareName(softwareName);
		if(null == swList || swList.size() <= 0){
			return WSMsg.failMessage("Sotware not found");
		}
		
		List<Manufacturer> mfList = nonInstanceService.findManufacturerByName(manufacturerName);
		if(null == mfList || mfList.size() <=0){
			return WSMsg.failMessage("Manufacturer not found");
		}
		
		List<CapacityType> ctList = nonInstanceService.findCapacityTypeByDesc(capacityDesc);
		if(null == ctList || ctList.size() <=0){
			return WSMsg.failMessage("CapacityType not found");
		}
		
		Software sw = swList.get(0);
		Manufacturer mf = mfList.get(0);
		CapacityType ct =  ctList.get(0);
		com.ibm.asset.trails.domain.Status st = new com.ibm.asset.trails.domain.Status();
		st.setId(statusId);

		if(null != id){
			//update
			List<NonInstance> nonInstanceList = nonInstanceService.findNonInstanceByswIdAndCapacityCodeNotEqId(sw.getSoftwareId(), ct.getCode(), id);
			if(null != nonInstanceList && nonInstanceList.size() >0){
				return WSMsg.failMessage("Non Instance is already exist for [Software = " + softwareName +", Capacity Type = " + capacityDesc+"]" );
			}else{
				NonInstance nonInstance = new NonInstance();
				nonInstance.setId(id);
				nonInstance.setSoftware(sw);
				nonInstance.setManufacturer(mf);
				nonInstance.setRestriction(restriction);
				nonInstance.setCapacityType(ct);
				nonInstance.setBaseOnly(baseOnly);
				nonInstance.setStatus(st);
				nonInstance.setRemoteUser(request.getRemoteUser());
				nonInstance.setRecordTime(new Date());
				nonInstanceService.updateNonInstance(nonInstance);
				return WSMsg.successMessage("Update non instance success");
			}
		}else{
			List<NonInstance> nonInstanceList = nonInstanceService.findNonInstanceByswIdAndCapacityCode(sw.getSoftwareId(), ct.getCode());
			if(null != nonInstanceList && nonInstanceList.size() >0){
				return WSMsg.failMessage("Non Instance is already exist for [Software = " + softwareName +", Capacity Type = " + capacityDesc+"]" );
			}else{
				NonInstance nonInstance = new NonInstance();
				nonInstance.setSoftware(sw);
				nonInstance.setManufacturer(mf);
				nonInstance.setRestriction(restriction);
				nonInstance.setCapacityType(ct);
				nonInstance.setBaseOnly(baseOnly);
				nonInstance.setStatus(st);
				nonInstance.setRemoteUser(request.getRemoteUser());
				nonInstance.setRecordTime(new Date());
				nonInstanceService.saveNonInstance(nonInstance);
				return WSMsg.successMessage("Save non instance success");
			}
		}
	}
}
