package com.ibm.asset.trails.ws;

import java.io.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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

import org.apache.cxf.jaxrs.ext.multipart.Attachment;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Row;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceH;
import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ManufacturerService;
import com.ibm.asset.trails.service.PriorityISVSoftwareService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.service.StatusService;
import com.ibm.asset.trails.ws.common.Pagination;
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
	
	@Autowired
	private StatusService statusService;

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
	public WSMsg getAllPriorityISVSoftwareDisplays(@QueryParam("currentPage") Integer currentPage,
			@QueryParam("pageSize") Integer pageSize,
			@QueryParam("sort") String sort,
			@QueryParam("dir") String dir){
	

		List<PriorityISVSoftwareDisplay> results = null;
		int startIndex = (currentPage-1) * pageSize;
		Long total = this.priorityISVSoftwareService.total();
		if(total > 0){
			results = this.priorityISVSoftwareService.getAllPriorityISVSoftwareDisplays(startIndex, pageSize, sort, dir);
		}
		
		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(results);
		return WSMsg.successMessage("SUCCESS", page);
	}
	
	@GET
	@Path("/isvh/{isvid}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getPriorityISVSoftwareHDisplaysByISVSoftwareId(@PathParam("isvid") Long priorityISVSoftwareId,
			@QueryParam("currentPage") Integer currentPage,
			@QueryParam("pageSize") Integer pageSize,
			@QueryParam("sort") String sort,
			@QueryParam("dir") String dir){
		
		List<PriorityISVSoftwareHDisplay> priISVSwHList = null;
		int startIndex = (currentPage-1) * pageSize;
		Long total = this.priorityISVSoftwareService.totalHistory(priorityISVSoftwareId);
		if(total > 0){
			priISVSwHList = this.priorityISVSoftwareService.findPriorityISVSoftwareHDisplaysByISVSoftwareId(priorityISVSoftwareId,startIndex,pageSize, sort, dir);
		}
		

		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(priISVSwHList);
		return WSMsg.successMessage("SUCCESS", page);
	}
	
	
	@GET
	@Path("/isv")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getPriorityISVSoftwareDisplaysByUniqueKeys(@QueryParam("manufacturerId") Long manufacturerId
			                                              , @QueryParam("level") String level
			                                              , @QueryParam("customerId") Long customerId){
	  
	  if(null == level || "".equals(level.trim())) {//GLOBAL or ACCOUNT
			return WSMsg.failMessage("Level is required!");
	  }
	  else{
		 if("ACCOUNT".equals(level.trim().toUpperCase()) && (null == customerId)){//If level is ACCOUNT, then the customer id value is needed
		     return WSMsg.failMessage("Customer Id is required!");  	   
		  }	
	  }
	  
	  if(null == manufacturerId){
		  return WSMsg.failMessage("Manufacturer Id is required!");
	  }
		
	  PriorityISVSoftware dbPISVSW = this.priorityISVSoftwareService.findPriorityISVSoftwareByUniqueKeys(level.trim().toUpperCase(), manufacturerId, customerId); 
	  
	  if (null != dbPISVSW) {
		  PriorityISVSoftwareDisplay returnISV = new PriorityISVSoftwareDisplay();
		  returnISV.setId(dbPISVSW.getId());
		  returnISV.setLevel(dbPISVSW.getLevel().trim().toUpperCase());
		  if(dbPISVSW.getAccount()!=null){
			 returnISV.setCustomerId(dbPISVSW.getAccount().getId());
			 returnISV.setAccountName(dbPISVSW.getAccount().getName());
			 returnISV.setAccountNumber(dbPISVSW.getAccount().getAccount());
		  }
		  returnISV.setManufacturerId(dbPISVSW.getManufacturer().getId());
		  returnISV.setManufacturerName(dbPISVSW.getManufacturer().getManufacturerName());
		  returnISV.setEvidenceLocation(dbPISVSW.getEvidenceLocation());
		  returnISV.setBusinessJustification(dbPISVSW.getBusinessJustification());
		  returnISV.setRemoteUser(dbPISVSW.getRemoteUser());
		  returnISV.setStatusId(dbPISVSW.getStatus().getId());
		  returnISV.setStatusDesc(dbPISVSW.getStatus().getDescription());
		  returnISV.setRecordTime(dbPISVSW.getRecordTime());
		  
		  return WSMsg.successMessage("Priority ISV Software exists.",returnISV);
		}
	  else{
		  if(null == customerId){
			  return WSMsg
					.failMessage(WSMsg.NOT_FOUND,"Priority ISV Software doesn't exist for [Level = "
							+ level
							+ ", Manufacturer Id = "
							+ manufacturerId + "]");
			}
		  else{
			  return WSMsg
						.failMessage(WSMsg.NOT_FOUND,"Priority ISV Software doesn't existed for [Level = "
								+ level
								+ ", Customer Id = "
								+customerId
								+ ", Manufacturer Id = "
								+ manufacturerId + "]");
		  }
	  }
	}
		
	@PUT
	@Path("/isv")
	@Consumes(MediaType.APPLICATION_JSON) 
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg addPriorityISVSoftware(PriorityISVSoftwareDisplay addISV,
			@Context HttpServletRequest request) {
		
		 String level = addISV.getLevel();
		 Long customerId = addISV.getCustomerId();
		 Long manufacturerId = addISV.getManufacturerId();
		 String evidenceLocation = addISV.getEvidenceLocation();
		 Long statusId = addISV.getStatusId();
		 String businessJustification = addISV.getBusinessJustification();
		 Account customer = null;
		
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
		
        if("ACCOUNT".equals(level.trim().toUpperCase())){
			customer = this.accountService.getAccount(customerId);
			if(null == customer){
			  return WSMsg.failMessage("No Customer has been found for Customer Id: "+customerId+"!");	
			}
        }
		
		Manufacturer manufacturer = this.manufacturerService.findManufacturerById(manufacturerId);
		if(manufacturer == null){
	      return WSMsg.failMessage("No Manufacturer has been found for Manufacturer Id:"+manufacturerId+"!");	
		}
		
		com.ibm.asset.trails.domain.Status status = new com.ibm.asset.trails.domain.Status();
		status.setId(statusId);

		PriorityISVSoftware dbPISVSW = this.priorityISVSoftwareService.findPriorityISVSoftwareByUniqueKeys(level.trim().toUpperCase(), manufacturerId, customerId); 

		if (null != dbPISVSW) {
			  return WSMsg
						.failMessage("Priority ISV Software already exists for [Level = "
								+ level
								+ ", Customer Id = "
								+customerId
								+ ", Manufacturer Id = "
								+ manufacturerId + "]");		  
		} else {
			PriorityISVSoftware addISVSW = new PriorityISVSoftware();
			addISVSW.setLevel(level.trim().toUpperCase());
			addISVSW.setAccount(customer);
			addISVSW.setManufacturer(manufacturer);
			addISVSW.setEvidenceLocation(evidenceLocation);
			addISVSW.setStatus(status);
			addISVSW.setBusinessJustification(businessJustification);
			if(null != request.getRemoteUser()){
			  addISVSW.setRemoteUser(request.getRemoteUser());
			}
			else{
				if(null!=addISV.getRemoteUser()){
				  addISVSW.setRemoteUser(addISV.getRemoteUser());
				}
				else{
					addISVSW.setRemoteUser("");	
				}
			}
			addISVSW.setRecordTime(new Date());
			this.priorityISVSoftwareService.addPriorityISVSoftware(addISVSW);
			return WSMsg.successMessage("The Priority ISV has been added successfully.");
		}
	}

	@PUT
	@Path("/isv/{id}")
	@Consumes(MediaType.APPLICATION_JSON) 
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
		 Account customer = null;
		
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
		
		if("ACCOUNT".equals(level.trim().toUpperCase())){
			customer = this.accountService.getAccount(customerId);
			if(null == customer){
			  return WSMsg.failMessage("No Customer has been found for Customer Id: "+customerId+"!");	
			}
		}
		
		Manufacturer manufacturer = this.manufacturerService.findManufacturerById(manufacturerId);
		if(manufacturer == null){
	      return WSMsg.failMessage("No Manufacturer has been found for Manufacturer Id:"+manufacturerId+"!");	
		}
		
		com.ibm.asset.trails.domain.Status status = new com.ibm.asset.trails.domain.Status();
		status.setId(statusId);
			
		PriorityISVSoftware dbPISVSW = this.priorityISVSoftwareService.findPriorityISVSoftwareByUniqueKeys(level.trim().toUpperCase(), manufacturerId, customerId); 

		if (null != dbPISVSW && !id.equals(dbPISVSW.getId())) {	
				return WSMsg
						.failMessage("Priority ISV Software already exists for [Level = "
								+ level
								+ ", Customer Id = "
								+customerId
								+ ", Manufacturer Id = "
								+ manufacturerId + "]");
		} else {
			PriorityISVSoftware updateISVSW = new PriorityISVSoftware();
			updateISVSW.setId(id);
			updateISVSW.setLevel(level.trim().toUpperCase());
			updateISVSW.setAccount(customer);
			updateISVSW.setManufacturer(manufacturer);
			updateISVSW.setEvidenceLocation(evidenceLocation);
			updateISVSW.setStatus(status);
			updateISVSW.setBusinessJustification(businessJustification);
			if(null!=request.getRemoteUser()){
				updateISVSW.setRemoteUser(request.getRemoteUser());
			}
			else{
				if(null!=updateISV.getRemoteUser()){
					updateISVSW.setRemoteUser(updateISV.getRemoteUser());
				}
				else{
					updateISVSW.setRemoteUser("");
				}
			}
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
	
	@POST
	@Path("/isv/upload")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces("application/vnd.ms-excel")
	public Response uploadFile(List<Attachment> attachments,
			@Context HttpServletRequest request) {
		ByteArrayOutputStream bos = null;
		File f = null;
		FileInputStream fin = null;
		Boolean error = false;
		for (Attachment attr : attachments) {
			DataHandler handler = attr.getDataHandler();
			try {
				InputStream stream = handler.getInputStream();
				MultivaluedMap<String, String> map = attr.getHeaders();
				String filename = getFileName(map);
				String extension = filename
						.substring(filename.lastIndexOf('.'));
				if (!(extension.toLowerCase().equals(".xls")
						|| extension.toLowerCase().equals(".cvs") || extension
						.toLowerCase().equals(".xlsx"))) {
					error = true;
				}
				f = new File("/tmp/" + filename);
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
					error = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (!error) {
			try {
				bos = parserUpload(fin, request);
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (fin != null)
						fin.close();
					if (f != null)
						f.delete();
				} catch (IOException ex) {
					ex.printStackTrace();
				}
			}
		} else {
			try {
				bos = new ByteArrayOutputStream();
				PrintWriter pw = new PrintWriter(new OutputStreamWriter(bos,
						"UTF-8"), true);
				pw.println("SEEMS YOU ARE LOADING A FILE WITH NOT ACCEPTABLE FORMAT!");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
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
		Iterator<Row> liRow = null;
		HSSFRow row = null;
		PriorityISVSoftware priorityISV = null;
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
			error = false;
			lbHeaderRow = false;
			lsbErrorMessage = new StringBuffer();
			
			//deal with row
			if(row.getRowNum() == 0){
				lbHeaderRow  = true;
			}else{
				//parse data row into priorityISV
				String errorMessage = "";
				try{
					Map<PriorityISVSoftware, String> psMap = parseRow(row);
					
					priorityISV = psMap.entrySet().iterator().next().getKey();
					errorMessage = psMap.entrySet().iterator().next().getValue();
				
				}catch(Exception e){
					e.printStackTrace();
					errorMessage += e.getMessage();
				}
				
				
				if(null != errorMessage && !"".equals(errorMessage)){
					lsbErrorMessage.append(errorMessage);
					error = true;
				}
			}

			//deal with result
			if (!lbHeaderRow) {
				if (error) {
					cell = row.createCell(7);
					cell.setCellStyle(lcsError);
					cell.setCellValue(new HSSFRichTextString(lsbErrorMessage.toString()));
				} else if (priorityISV.getLevel() != null
						&& priorityISV.getManufacturer() != null) {
					priorityISV.setRemoteUser(request.getRemoteUser());
					priorityISV.setRecordTime(new Date());
					
					PriorityISVSoftware tempPriorityISV = null;
					if(null == priorityISV.getAccount()){
						tempPriorityISV = priorityISVSoftwareService
								.findPriorityISVSoftwareByUniqueKeys(priorityISV
										.getLevel(), priorityISV.getManufacturer()
										.getId(), null);
					}else{
						tempPriorityISV = priorityISVSoftwareService
								.findPriorityISVSoftwareByUniqueKeys(priorityISV
										.getLevel(), priorityISV.getManufacturer()
										.getId(), priorityISV.getAccount().getId());
					}
					
					if (tempPriorityISV != null) {
						priorityISV.setId(tempPriorityISV.getId());
						priorityISVSoftwareService
								.updatePriorityISVSoftware(priorityISV);
					} else {
						priorityISVSoftwareService
								.addPriorityISVSoftware(priorityISV);
					}
					cell = row.createCell(7);
					cell.setCellStyle(lcsMessage);
					cell.setCellValue(new StringBuffer("YOUR TEMPLATE UPLOAD SUCCESSFULLY").toString());
				}
			}
		}
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);

		return bos;
	}

	private Map<PriorityISVSoftware, String> parseRow(HSSFRow row) {
		// TODO Auto-generated method stub
		
		Map<PriorityISVSoftware, String> resultMap = new HashMap<PriorityISVSoftware, String>();
		
		int nullFlag = 0;
		String errorMsg = "";
		
		String level = null;
		String cndbName = null;
		Long cndbId = null;
		
		PriorityISVSoftware priorityISV  = new PriorityISVSoftware();
		
		
		//Manufacturer
		HSSFCell mfCell = row.getCell(0);
		if(null == mfCell){
			errorMsg += "Manufacturer Name is required. ";
			nullFlag++;
		}else if (mfCell.getCellType() != HSSFCell.CELL_TYPE_STRING){
			errorMsg += "Manufacturer Name is required a string. ";
		}else{
			Manufacturer manufacturer = manufacturerService
					.findManufacturerByName(mfCell.getRichStringCellValue()
							.getString().trim());
			if (null == manufacturer) {
				errorMsg += "Manufacturer doesn't exist. ";
			} else {
				priorityISV.setManufacturer(manufacturer);
			}
		}
		
		// Level
		HSSFCell levelCell = row.getCell(1);
		if(null == levelCell){
			errorMsg += "Level is required. ";
			nullFlag++;
		}else if (levelCell.getCellType() != HSSFCell.CELL_TYPE_STRING){
			errorMsg += "Level is required a string. ";
		}else if(!levelCell.getRichStringCellValue().getString().trim().equalsIgnoreCase("GLOBAL")
				&& !levelCell.getRichStringCellValue().getString().trim().equalsIgnoreCase("ACCOUNT")){
			errorMsg += "Level must be 'GLOBAL' or 'ACCOUNT'. ";
		}else {
			level = levelCell.getRichStringCellValue().getString().trim();
			priorityISV.setLevel(level.toUpperCase());
		}
		
		if(null != level && !"".equals(level) && !level.equalsIgnoreCase("GLOBAL")){
			//cndb name
			HSSFCell cndbNameCell = row.getCell(2);
			if(null == cndbNameCell){
				errorMsg += "CNDB Name is required. ";
				nullFlag++;
			}else if (cndbNameCell.getCellType() != HSSFCell.CELL_TYPE_STRING){
				errorMsg += "CNDB Name is required a string. ";
			}else{
				cndbName = cndbNameCell.getRichStringCellValue().getString().trim();
			}
			
			//cndbId
			HSSFCell cndbIdCell = row.getCell(3);
			if(null == cndbIdCell){
				errorMsg += "CNDB ID is required. ";
				nullFlag++;
			}else if (cndbIdCell.getCellType() != HSSFCell.CELL_TYPE_NUMERIC){
				errorMsg += "CNDB ID is required a numeric. ";
			}else{
				cndbId = (new Double(cndbIdCell.getNumericCellValue())).longValue();
			}
		}else{
			nullFlag+=2;
		}
		
		// Evidence location
		HSSFCell eviCell = row.getCell(4);
		if(null == eviCell){
			errorMsg += "Evidence location is required. ";
			nullFlag++;
		}else if (eviCell.getCellType() != HSSFCell.CELL_TYPE_STRING){
			errorMsg += "Evidence location is required a string. ";
		}else{
			priorityISV.setEvidenceLocation(eviCell.getRichStringCellValue().getString().trim());
		}
		
		// STATUS
		HSSFCell statusCell = row.getCell(5);
		if(null == statusCell){
			errorMsg += "Status is required. ";
			nullFlag++;
		}else if (statusCell.getCellType() != HSSFCell.CELL_TYPE_STRING){
			errorMsg += "Status is required a string. ";
		}else{
			Status st = statusService.findStatusByDesc(statusCell.getRichStringCellValue().getString().trim());
			if(null == st){
				errorMsg += "Status doesn't exist. ";
			}else{
				priorityISV.setStatus(st);
			}
		}
		
		// Business justification
		HSSFCell busCell = row.getCell(6);
		if(null == busCell){
			errorMsg += "Business justification is required. ";
			nullFlag++;
		}else if (busCell.getCellType() != HSSFCell.CELL_TYPE_STRING){
			errorMsg += "Business justification is required a string. ";
		}else{
			priorityISV.setBusinessJustification(busCell.getRichStringCellValue().getString().trim());
		}
		
		
		if(null != priorityISV.getLevel() && priorityISV.getLevel().equalsIgnoreCase("account")){
			Account account = accountService.getAccountByCustomerNameAndAccountNumber(cndbName, cndbId);
			if(null != account){
				priorityISV.setAccount(account);
			}else{
				errorMsg += "Account doesn't exist. ";
			}
		}
		
		if(nullFlag == 7){
			errorMsg = "No other data need to deal with";
		}
		
		resultMap.put(priorityISV, errorMsg);
		
		return resultMap;
	}
}