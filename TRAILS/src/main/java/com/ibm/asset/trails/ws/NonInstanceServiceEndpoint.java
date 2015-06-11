package com.ibm.asset.trails.ws;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.activation.DataHandler;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.CookieParam;
import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;

import org.apache.commons.lang.StringUtils;
import org.apache.cxf.jaxrs.ext.multipart.Attachment;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.NonInstanceDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.MachineType;
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
import com.ibm.asset.trails.service.impl.ECauseCodeReport;
import com.ibm.ea.common.State;
import com.ibm.ea.common.State.EStatus;

@Path("/noninstance")
public class NonInstanceServiceEndpoint {

	@Autowired
	private NonInstanceDAO nonInstanceDAO;

	@Autowired
	private NonInstanceService nonInstanceService;
	
	@Autowired
	private ReportService reportService;

	@GET
	@Path("/search")
	@Produces({ MediaType.APPLICATION_JSON })
	public List<NonInstanceDisplay> search(@QueryParam("softwareName") String softwareName,
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

		List<NonInstanceDisplay> nonList = nonInstanceService
				.findNonInstanceDisplays(searchObj);
		return nonList;
	}
	
	@GET
	@Path("/history/{nonInstanceId}")
	@Produces({ MediaType.APPLICATION_JSON })
	public List<NonInstanceHDisplay> history(@PathParam("nonInstanceId") Long nonInstanceId) {


		List<NonInstanceHDisplay> nonHList = nonInstanceService.findNonInstanceHDisplays(nonInstanceId);
		
		if(null == nonHList || nonHList.size() == 0){
			ResponseBuilder builder = Response.status(Status.BAD_REQUEST);
			builder.type(MediaType.APPLICATION_JSON);
			builder.entity("There is no any NonInsance history record which has not been found!");
			throw new WebApplicationException(builder.build());
		}else{
			return nonHList;
		}
		
	}
	
	@GET
	@Path("/getById/{id}/info")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public NonInstance getNonInstanceById(@PathParam("id") String id) {
		NonInstance nonInstanceObject = nonInstanceDAO.findById(new Long(id));

		if (nonInstanceObject == null) {
			ResponseBuilder builder = Response.status(Status.BAD_REQUEST);
			builder.type(MediaType.APPLICATION_JSON);
			builder.entity("There is no any NonInsance record which has not been found with id {"
					+ id + "}!");
			throw new WebApplicationException(builder.build());
		} else {
			return nonInstanceObject;
		}
	}

	@GET
	@Path("/getBySoftwareId/{softwareId}/info")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public List<NonInstance> getNonInstancesBySoftwareId(
			@PathParam("softwareId") String softwareId) {
		List<NonInstance> allNonInstancesBySoftwareId = nonInstanceDAO
				.findNonInstancesBySoftwareId(new Long(softwareId).longValue());
		if (allNonInstancesBySoftwareId == null
				|| allNonInstancesBySoftwareId.size() == 0) {
			ResponseBuilder builder = Response.status(Status.BAD_REQUEST);
			builder.type(MediaType.APPLICATION_JSON);
			builder.entity("There is no any NonInsance record which has not been found with softwareId {"
					+ softwareId + "}!");
			throw new WebApplicationException(builder.build());
		} else {
			return allNonInstancesBySoftwareId;
		}
	}

	@GET
	@Path("/getByManufacturerId/{manufacturerId}/info")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public List<NonInstance> getNonInstanceByManufacturerId(
			@PathParam("manufacturerId") String manufacturerId) {
		List<NonInstance> allNonInstancesByManufacturerId = nonInstanceDAO
				.findNonInstancesByManufacturerId(new Long(manufacturerId));
		if (allNonInstancesByManufacturerId == null
				|| allNonInstancesByManufacturerId.size() == 0) {
			ResponseBuilder builder = Response.status(Status.BAD_REQUEST);
			builder.type(MediaType.APPLICATION_JSON);
			builder.entity("There is no any NonInsance record which has not been found with manufacturerId {"
					+ manufacturerId + "}!");
			throw new WebApplicationException(builder.build());
		} else {
			return allNonInstancesByManufacturerId;
		}
	}

	@GET
	@Path("/getByRestriction/{restriction}/info")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public List<NonInstance> getNonInstancesByRestriction(
			@PathParam("restriction") String restriction) {
		List<NonInstance> allNonInstancesByRestriction = nonInstanceDAO
				.findNonInstancesByRestriction(restriction.toUpperCase());
		if (allNonInstancesByRestriction == null
				|| allNonInstancesByRestriction.size() == 0) {
			ResponseBuilder builder = Response.status(Status.BAD_REQUEST);
			builder.type(MediaType.APPLICATION_JSON);
			builder.entity("There is no any NonInsance record which has not been found with restrction {"
					+ restriction + "}!");
			throw new WebApplicationException(builder.build());
		} else {
			return allNonInstancesByRestriction;
		}
	}

	@DELETE
	@Path("/removeById/{id}")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public Response removeNonInstanesById(@PathParam("id") String id) {
		NonInstance NonInstance = nonInstanceDAO.findById(new Long(id));
		if (NonInstance == null) {
			return Response
					.status(Status.BAD_REQUEST)
					.entity("There is no any NonInsance record which has not been found with id {"
							+ id + "}!").build();
		} else {
			try {
				nonInstanceDAO.removeNonInsanceById(new Long(id));
				return Response
						.status(Status.OK)
						.entity("The NonInsance record with id {" + id
								+ "} has removed successfully!").build();
			} catch (Exception e) {
				return Response
						.status(Status.BAD_REQUEST)
						.entity("The NonInsance record with id {" + id
								+ "} has removed failed!").build();
			}
		}
	}

	@POST
	@Path("/addNonInstanceByObject")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public Response addNonInstance(NonInstance nonInstance) {
		if (nonInstance.getId() != null) {
			return Response
					.status(Status.BAD_REQUEST)
					.entity("The NonInstance Id cannot be set due that DB will generate Id value!")
					.build();
		} else {
			try {
				nonInstanceDAO.persist(nonInstance);
				return Response
						.status(Status.OK)
						.entity("The NonInsance record has been added in the DB successfully!")
						.build();
			} catch (Exception e) {
				return Response
						.status(Status.BAD_REQUEST)
						.entity("The NonInsance record has been added in the DB failed!")
						.build();
			}
		}
	}

	@POST
	@Path("/addNonInstanceByForm")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public Response addNonInstanceByForm(
			@FormParam("softwareId") String softwareId,
			@FormParam("manufacturerId") String manufacturerId,
			@FormParam("restriction") String restriction,
			@FormParam("capacityTypeCode") String capacityTypeCode,
			@FormParam("baseOnly") String baseOnly,
			@FormParam("statusId") String statusId) {

		try {
			// Generate Non Instance Object with necessary information values
			NonInstance nonInstance = new NonInstance();

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
			nonInstanceDAO.persist(nonInstance);
			return Response
					.status(Status.OK)
					.entity("The NonInsance record has been added in the DB successfully!")
					.build();
		} catch (Exception e) {
			return Response
					.status(Status.BAD_REQUEST)
					.entity("The NonInsance record has been added in the DB failed!")
					.build();
		}
	}

	@PUT
	@Path("/udpateNonInstanceByObject")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public Response updateNonInstance(NonInstance nonInstance) {
		NonInstance NonInstanceObject = nonInstanceDAO.findById(nonInstance
				.getId());
		if (NonInstanceObject == null) {
			return Response
					.status(Status.BAD_REQUEST)
					.entity("The NonInsance record with id {"
							+ nonInstance.getId()
							+ "} has not existed in the DB!").build();
		} else {
			try {
				nonInstanceDAO.merge(nonInstance);
				return Response
						.status(Status.OK)
						.entity("The NonInsance record with id {"
								+ nonInstance.getId()
								+ "} has been updated in the DB successfully!")
						.build();
			} catch (Exception e) {
				return Response
						.status(Status.BAD_REQUEST)
						.entity("The NonInsance record with id {"
								+ nonInstance.getId()
								+ "} has been updated in the DB failed!")
						.build();
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
    @Path("/file")
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
