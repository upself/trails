package com.ibm.asset.trails.ws;


import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.util.List;

import javax.activation.DataHandler;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;

import java.util.Date;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;


import org.apache.cxf.jaxrs.ext.multipart.Attachment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.NonInstanceDAO;

import com.ibm.asset.trails.domain.CapacityType;

import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.service.NonInstanceService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.ws.common.WSMsg;


@Path("/noninstance")
public class NonInstanceServiceEndpoint {
	@Autowired
	private NonInstanceService nonInstanceService;
	
	@Autowired
	private ReportService reportService;
	@Autowired
	private NonInstanceDAO nonInstanceDAO;
	
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

	@PUT
	@Path("/updateNonInstanceByForm")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public Response updateNonInstanceByForm(@FormParam("id") String id,
			@FormParam("softwareId") String softwareId,
			@FormParam("manufacturerId") String manufacturerId,
			@FormParam("restriction") String restriction,
			@FormParam("capacityTypeCode") String capacityTypeCode,
			@FormParam("baseOnly") String baseOnly,
			@FormParam("statusId") String statusId) {

		if (id == null || id.trim().length() == 0) {
			return Response
					.status(Status.BAD_REQUEST)
					.entity("The Update NonInsance record must have id value for it!")
					.build();
		}

		NonInstance nonInstance = nonInstanceDAO.findById(new Long(id));
		if (nonInstance == null) {
			return Response
					.status(Status.BAD_REQUEST)
					.entity("The NonInsance record with id {" + id
							+ "} has not existed in the DB!").build();
		}

		try {
			// Set new values for non instance object
			Software software = new Software();// set software object
			software.setSoftwareId(new Long(softwareId).longValue());
			nonInstance.setSoftware(software);

			Manufacturer manufacturer = new Manufacturer();// set manufacturer
															// object
			manufacturer.setId(new Long(manufacturerId));
			nonInstance.setManufacturer(manufacturer);

			nonInstance.setRestriction(restriction);// set restriction

			CapacityType capacityType = new CapacityType();
			capacityType.setCode(new Integer(capacityTypeCode));
			nonInstance.setCapacityType(capacityType);// set capacityType object

			nonInstance.setBaseOnly(new Integer(baseOnly));// set base only

			com.ibm.asset.trails.domain.Status status = new com.ibm.asset.trails.domain.Status();
			status.setId(new Long(statusId));
			nonInstance.setStatus(status);

			// Persist Non Instance Object into DB
			nonInstanceDAO.merge(nonInstance);
			return Response
					.status(Status.OK)
					.entity("The NonInsance record has been updated in the DB successfully!")
					.build();
		} catch (Exception e) {
			return Response
					.status(Status.BAD_REQUEST)
					.entity("The NonInsance record has been updated in the DB failed!")
					.build();
		}
	}
	
	@POST
    @Path("/upload")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response uploadFile(List<Attachment> attachments,@Context HttpServletRequest request) {
		 ByteArrayOutputStream bos = null;
		for(Attachment attr : attachments) {
            DataHandler handler = attr.getDataHandler();
            try {
            	FileInputStream fin = (FileInputStream) handler.getInputStream();
                MultivaluedMap<String, String> map = attr.getHeaders();

                 bos = nonInstanceService.parserUpload(fin);
        		 
            } catch(Exception e) {
              e.printStackTrace();
            }
        }
     
        ResponseBuilder responseBuilder = Response.ok((Object) bos);
        responseBuilder.header("Content-Disposition" ,
        		"attachment; filename=results.xls");
        return responseBuilder.build();
    }

}
