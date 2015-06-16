package com.ibm.asset.trails.ws;

import java.io.*;
import java.util.Iterator;
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

import org.apache.commons.lang.StringUtils;
import org.apache.cxf.jaxrs.ext.multipart.Attachment;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.NonInstanceDAO;
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
	@Autowired
	private NonInstanceDAO nonInstanceDAO;

	@GET
	@Path("/search")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg search(@QueryParam("softwareName") String softwareName,
			@QueryParam("manufacturerName") String manufacturerName,
			@QueryParam("restriction") String restriction,
			@QueryParam("capacityCode") Integer capacityCode,
			@QueryParam("baseOnly") Integer baseOnly,
			@QueryParam("statusId") Long statusId) {

		NonInstanceDisplay searchObj = new NonInstanceDisplay();
		searchObj.setSoftwareName(softwareName);
		searchObj.setManufacturerName(manufacturerName);
		searchObj.setRestriction(restriction);
		searchObj.setCapacityCode(capacityCode);
		searchObj.setBaseOnly(baseOnly);
		searchObj.setStatusId(statusId);

		List<NonInstanceDisplay> nonList = nonInstanceService
				.findNonInstanceDisplays(searchObj);

		if (null == nonList || nonList.size() <= 0) {
			return WSMsg.failMessage("No data found");
		} else {
			return WSMsg.successMessage("", nonList);
		}
	}

	@GET
	@Path("/history/{nonInstanceId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg history(@PathParam("nonInstanceId") Long nonInstanceId) {

		List<NonInstanceHDisplay> nonHList = nonInstanceService
				.findNonInstanceHDisplays(nonInstanceId);

		if (null == nonHList || nonHList.size() == 0) {
			return WSMsg.failMessage("No data found");
		} else {
			return WSMsg.successMessage("", nonHList);
		}

	}

	@POST
	@Path("/saveOrUpdate")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getNonInstanceById(@FormParam("id") Long id,
			@FormParam("softwareName") String softwareName,
			@FormParam("manufacturerName") String manufacturerName,
			@FormParam("restriction") String restriction,
			@FormParam("capacityCode") Integer capacityCode,
			@FormParam("baseOnly") Integer baseOnly,
			@FormParam("statusId") Long statusId,
			@Context HttpServletRequest request) {

		// validation
		if (null == softwareName || "".equals(softwareName)) {
			return WSMsg.failMessage("Software component is required");

		} else if (null == manufacturerName || "".equals(manufacturerName)) {
			return WSMsg.failMessage("Manufacturer name is required");

		} else if (null == restriction || "".equals(restriction)) {
			return WSMsg.failMessage("Restriction is required");

		} else if (null == capacityCode) {
			return WSMsg.failMessage("Non Instance capacity type is required");

		} else if (null == baseOnly) {
			return WSMsg.failMessage("Non instance based only is required");

		} else if (null == statusId) {
			return WSMsg.failMessage("Status is required");
		} else {

		}

		List<Software> swList = nonInstanceService
				.findSoftwareBySoftwareName(softwareName);
		if (null == swList || swList.size() <= 0) {
			return WSMsg.failMessage("Sotware not found");
		}

		List<Manufacturer> mfList = nonInstanceService
				.findManufacturerByName(manufacturerName);
		if (null == mfList || mfList.size() <= 0) {
			return WSMsg.failMessage("Manufacturer not found");
		}

		List<CapacityType> ctList = nonInstanceService
				.findCapacityTypeByCode(capacityCode);
		if (null == ctList || ctList.size() <= 0) {
			return WSMsg.failMessage("Non Instance capacity type not found");
		}

		Software sw = swList.get(0);
		Manufacturer mf = mfList.get(0);
		CapacityType ct = ctList.get(0);
		com.ibm.asset.trails.domain.Status st = new com.ibm.asset.trails.domain.Status();
		st.setId(statusId);

		if (null != id) {
			// update
			List<NonInstance> nonInstanceList = nonInstanceService
					.findNonInstanceByswIdAndCapacityCodeNotEqId(
							sw.getSoftwareId(), ct.getCode(), id);
			if (null != nonInstanceList && nonInstanceList.size() > 0) {
				return WSMsg
						.failMessage("Non Instance is already exist for [Software = "
								+ softwareName
								+ ", Capacity Type = "
								+ ct.getDescription() + "]");
			} else {
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
		} else {
			List<NonInstance> nonInstanceList = nonInstanceService
					.findNonInstanceByswIdAndCapacityCode(sw.getSoftwareId(),
							ct.getCode());
			if (null != nonInstanceList && nonInstanceList.size() > 0) {
				return WSMsg
						.failMessage("Non Instance is already exist for [Software = "
								+ softwareName
								+ ", Capacity Type = "
								+ ct.getDescription() + "]");
			} else {
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

	@GET
	@Path("/download")
	public Response download() throws IOException {

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		PrintWriter pw = new PrintWriter(new OutputStreamWriter(bos, "utf-8"),
				true);

		reportService.getNonInstanceBasedSWReport(pw);

		ResponseBuilder responseBuilder = Response.ok(bos.toByteArray());
		responseBuilder.header("Content-Type",
				"application/vnd.ms-excel;charset=UTF-8");
		responseBuilder.header("Content-Disposition",
				"attachment; filename=nonInstanceBasedSWReport.xls");

		return responseBuilder.build();
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
	@Produces("application/vnd.ms-excel")
	public Response uploadFile(List<Attachment> attachments,
			@Context HttpServletRequest request) {
		ByteArrayOutputStream bos = null;
		File f = null;
		FileInputStream fin = null;
		for (Attachment attr : attachments) {
			DataHandler handler = attr.getDataHandler();
			try {
				InputStream stream = handler.getInputStream();
				MultivaluedMap<String, String> map = attr.getHeaders();
				f = new File("/tmp/" + getFileName(map));
				OutputStream out = new FileOutputStream(f);
				int read = 0;
				byte[] bytes = new byte[1024];
				while ((read = stream.read(bytes)) != -1) {
					out.write(bytes, 0, read);
				}
				stream.close();
				out.flush();
				out.close();
				if (f.exists()) {
					fin = new FileInputStream(f);
				} else {
					return Response
							.status(Status.BAD_REQUEST)
							.entity("The file of NonInsance based upload failed!")
							.build();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		try {
			bos = parserUpload(fin, request);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (fin != null)
					fin.close();
				f.delete();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}

		ResponseBuilder responseBuilder = Response.ok((Object) bos
				.toByteArray());
		responseBuilder.type("application/vnd.ms-excel; charset=UTF-8");
		responseBuilder.header("Content-Disposition",
				"attachment; filename=results.xls;");
		return responseBuilder.build();
	}

	private String getFileName(MultivaluedMap<String, String> header) {
		String[] contentDisposition = header.getFirst("Content-Disposition")
				.split(";");
		for (String filename : contentDisposition) {
			if ((filename.trim().startsWith("filename"))) {
				String[] name = filename.split("=");
				String exactFileName = name[1].trim().replaceAll("\"", "");
				return exactFileName;
			}
		}
		return "unknown";
	}

	public ByteArrayOutputStream parserUpload(FileInputStream fileinput,
			HttpServletRequest request) throws IOException {
		HSSFWorkbook wb = new HSSFWorkbook(fileinput);
		HSSFSheet sheet = wb.getSheetAt(0);
		Iterator liRow = null;
		HSSFRow row = null;
		NonInstance ni = null;
		boolean error = false;
		StringBuffer lsbErrorMessage = null;
		HSSFCellStyle lcsError = wb.createCellStyle();
		HSSFCellStyle lcsNormal = wb.createCellStyle();
		HSSFCellStyle lcsMessage = wb.createCellStyle();
		HSSFCell cell = null;
		boolean lbHeaderRow = false;

		lcsError.setFillForegroundColor(HSSFColor.RED.index);
		lcsError.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		lcsNormal.setFillForegroundColor(HSSFColor.WHITE.index);
		lcsNormal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		lcsMessage.setFillForegroundColor(HSSFColor.YELLOW.index);
		lcsMessage.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

		for (liRow = sheet.rowIterator(); liRow.hasNext();) {
			row = (HSSFRow) liRow.next();
			ni = new NonInstance();
			error = false;
			lsbErrorMessage = new StringBuffer();
			lbHeaderRow = false;

			for (int i = 0; i <= 5; i++) {
				cell = row.getCell(i);
				if (cell == null) {
					cell = row.createCell(i);
					cell.setCellStyle(lcsError);
					lsbErrorMessage.append(error ? "\n" : "").append(
							getErrorMessage(i));
					error = true;
				} else {
					cell.setCellStyle(lcsNormal);

					try {
						if (row.getRowNum() == 0 && cell.getColumnIndex() == 0) {
							lbHeaderRow = true;
							break;
						} else {
							parseCell(cell, ni);
						}
					} catch (Exception e) {
						cell.setCellStyle(lcsError);
						// e.printStackTrace();
						lsbErrorMessage.append(error ? "\n" : "").append(
								e.getMessage());
						error = true;
					}
				}
			}

			if (!lbHeaderRow) {
				if (error) {
					cell = row.createCell(6);
					cell.setCellStyle(lcsError);
					cell.setCellValue(new HSSFRichTextString(lsbErrorMessage
							.toString()));
				} else if (ni.getSoftware() != null
						&& ni.getCapacityType() != null) {
					ni.setRemoteUser(request.getRemoteUser());
					ni.setRecordTime(new Date());
					List<NonInstance> ilExists = nonInstanceService
							.findBySoftwareNameAndCapacityCode(ni.getSoftware()
									.getSoftwareName(), ni.getCapacityType()
									.getCode());
					if (ilExists != null) {
						ni.setId(ilExists.get(0).getId());
						nonInstanceService.updateNonInstance(ni);
					} else {
						nonInstanceService.saveNonInstance(ni);
					}
					cell = row.createCell(6);
					cell.setCellStyle(lcsMessage);
					cell.setCellValue(new StringBuffer(
							"YOUR TEMPLATE UPLOAD SUCCESSFULLY").toString());
				}
			}
		}
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);

		return bos;
	}

	@SuppressWarnings("null")
	private void parseCell(HSSFCell cell, NonInstance ni) throws Exception {

		switch (cell.getColumnIndex()) {
		case 0: { // Software Name
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Software Name is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Software Name is required.");
			} else {
				List<Software> swlist = nonInstanceService
						.findSoftwareBySoftwareName(cell
								.getRichStringCellValue().getString().trim());
				ni.setSoftware(swlist.get(0));
			}

			break;
		}
		case 1: { // Manufacturer
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Manufacturer is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Manufacturer is required.");
			} else {
				List<Manufacturer> mlist = nonInstanceService
						.findManufacturerByName(cell.getRichStringCellValue()
								.getString().trim());
				if (mlist != null) {
					ni.setManufacturer(mlist.get(0));
				} else {
					throw new Exception("Manufacturer doesn't exist.");
				}
			}

			break;
		}
		case 2: { // RESTRICTION
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("RESTRICTION is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("RESTRICTION is required.");
			} else {
				ni.setRestriction(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		case 3: { // CAPACITY_TYPE
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("CAPACITY TYPE is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("CAPACITY TYPE is required.");
			} else {
				List<CapacityType> cplist = nonInstanceService
						.findCapacityTypeByDesc(cell.getRichStringCellValue()
								.getString().trim());
				if (cplist != null) {
					ni.setCapacityType(cplist.get(0));
				} else {
					throw new Exception("CAPACITY TYPE doesn't exist.");
				}
			}

			break;
		}
		case 4: { // BASE ONLY
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("BASE ONLY is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("BASE ONLY is required.");
			} else {
				String baseOnly = cell.getRichStringCellValue().getString()
						.trim();
				if (baseOnly.equalsIgnoreCase("YES")) {
					ni.setBaseOnly(1);
				} else {
					ni.setBaseOnly(0);
				}
			}

			break;
		}
		case 5: { // STATUS
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("STATUS is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("STATUS is required.");
			} else {
				List<com.ibm.asset.trails.domain.Status> statusList = nonInstanceService
						.findStatusByDesc(cell.getRichStringCellValue()
								.getString().trim());
				if (statusList == null || statusList.isEmpty()) {
					throw new Exception("Status is invalid.");
				} else {
					ni.setStatus(statusList.get(0));
				}
				break;
			}
		}
		}
	}

	private String getErrorMessage(int piCellIndex) {
		String lsErrorMessage = null;

		switch (piCellIndex) {
		case 0: { // Software Name
			lsErrorMessage = " Software Name is required.";

			break;
		}

		case 1: { // Manufacturer
			lsErrorMessage = "  Manufacturer is required.";

			break;
		}

		case 2: { // RESTRICTION
			lsErrorMessage = "RESTRICTION is required.";

			break;
		}

		case 3: { // CAPACITY_TYPE_CODE
			lsErrorMessage = " CAPACITY TYPE CODE is required.";

			break;
		}

		case 4: { // BASE_ONLY
			lsErrorMessage = " BASE ONLY is required.";

			break;
		}

		case 5: { // STATUS
			lsErrorMessage = "STATUS is required.";

			break;
		}
		}

		return lsErrorMessage;
	}

}
