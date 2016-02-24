package com.ibm.asset.trails.ws;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.ListIterator;

import javax.activation.DataHandler;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.apache.commons.lang.StringUtils;
import org.apache.cxf.jaxrs.ext.multipart.Attachment;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.domain.ScheduleFView;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

public class ScheduleFServiceEndpoint {
	@Autowired
	private ScheduleFService scheduleFService;
	
	private Long scheduleFId;
	
	@Autowired
	private AccountService accountService;
	
	@Autowired
	private ReportService reportService;
	
	private ArrayList<Scope> scopeArrayList;

	private ArrayList<Source> sourceArrayList;

	private ArrayList<Status> statusArrayList;

	private ArrayList<String> levelArrayList;
	
	@POST
	@Path("/saveOrUpdate")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg saveUpdateScheduleF(@FormParam("id") Long id,
			@FormParam("softwareTitle") String softwareTitle,
			@FormParam("softwareName") String softwareName,
			@FormParam("manufacturer") String manufacturer,
			@FormParam("level") String level,
			@FormParam("hwOwner") String hwOwner,
			@FormParam("scope") Scope scope,
			@FormParam("sWFinanceResp") String sWFinanceResp,
			@FormParam("source") Source source,
			@FormParam("sourceLocation") String sourceLocation,
			@FormParam("status") Status status,
			@FormParam("businessJustification") String businessJustification
			/*@Context HttpServletRequest request*/) {
		
		ScheduleF scheduleFOBject = new ScheduleF();
		scheduleFOBject.setSoftwareTitle(softwareTitle);
		scheduleFOBject.setSoftwareName(softwareName);
		scheduleFOBject.setManufacturer(manufacturer);
		scheduleFOBject.setLevel(level);
		scheduleFOBject.setHwOwner(hwOwner);
		scheduleFOBject.setScope(scope);
		scheduleFOBject.setSWFinanceResp(sWFinanceResp);
		scheduleFOBject.setSource(source);
		scheduleFOBject.setSourceLocation(sourceLocation);
		scheduleFOBject.setStatus(status);
		scheduleFOBject.setBusinessJustification(businessJustification);
		
		
		ArrayList<Software> laSoftware = getScheduleFService()
				.findSoftwareBySoftwareName(
						scheduleFOBject.getSoftwareName());
		Long llScheduleFId = getScheduleF().getId();
		List<ScheduleF> lsfExists = null;
		ScheduleF sfoExists = null;
		ScheduleF sfiExists = null;
		Long statusId = scheduleFOBject.getId();
		
		if (laSoftware.size() == 0 ) {
			if(statusId != 1){
			addFieldError(
					"scheduleFForm.softwareName",
					"Software does not exist in catalog. It may already been removed in SWKB Toolkit.");
			return INPUT;
			} else {
				if (llScheduleFId != null) {			
					sfiExists = getScheduleFService().getScheduleFDetails(llScheduleFId);
				}
				    sfiExists.setStatus(findStatusInList(scheduleFOBject.getId(),
						getStatusArrayList()));
				try {
					getScheduleFService().saveScheduleF(sfiExists,
							getUserSession().getRemoteUser());
					return SUCCESS;
				} catch (Exception e) {
					System.out.println(e.getCause());
					return INPUT;
				}
			}
		} else {
			
				lsfExists = getScheduleFService().findScheduleF(
						getUserSession().getAccount(), laSoftware.get(0), scheduleFOBject.getLevel());
			if (lsfExists != null) {sfoExists = findSfInExistsList(lsfExists);}
			if (llScheduleFId != null) {			
				sfiExists = getScheduleFService().findScheduleF(llScheduleFId,
						getUserSession().getAccount(), laSoftware.get(0));
			}

		}
		getScheduleF().setLevel(scheduleFOBject.getLevel());
		if (scheduleFOBject.getLevel().equals(
				ScheduleFLevelEnumeration.HWOWNER.toString())) {

			if (StringUtils.isEmpty(scheduleFOBject.getHwOwner())) {
				addFieldError("scheduleFForm.hwowner",
						"HW owner field is empty");
				return INPUT;
			} else {
				getScheduleF().setHwOwner(scheduleFOBject.getHwOwner());
				getScheduleF().setSerial(null);
				getScheduleF().setMachineType(null);
				getScheduleF().setHostname(null);
			}

		} else if (scheduleFOBject.getLevel().equals(
				ScheduleFLevelEnumeration.HWBOX.toString())) {

			if (StringUtils.isEmpty(scheduleFOBject.getSerial())
					|| StringUtils.isEmpty(scheduleFOBject.getMachineType())) {
				addFieldError("scheduleFForm.hwbox",
						"HW box properties are empty");
				return INPUT;
			} else {
				getScheduleF().setSerial(scheduleFOBject.getSerial());
				getScheduleF().setMachineType(
						scheduleFOBject.getMachineType());
				getScheduleF().setHwOwner(null);
				getScheduleF().setHostname(null);
			}

		} else if (scheduleFOBject.getLevel().equals(
				ScheduleFLevelEnumeration.HOSTNAME.toString())) {
			if (StringUtils.isEmpty(scheduleFOBject.getHostname())) {
				addFieldError("scheduleFForm.hostname",
						"Hostname field is empty");
				return INPUT;
			} else {
				getScheduleF().setHostname(scheduleFOBject.getHostname());
				getScheduleF().setHwOwner(null);
				getScheduleF().setSerial(null);
				getScheduleF().setMachineType(null);
			}

		} else {
			getScheduleF().setHostname(null);
			getScheduleF().setHwOwner(null);
			getScheduleF().setSerial(null);
			getScheduleF().setMachineType(null);
		}

		getScheduleF().setAccount(getUserSession().getAccount());
		getScheduleF().setSoftware(laSoftware.get(0));
		getScheduleF().setSoftwareTitle(scheduleFOBject.getSoftwareTitle());
		getScheduleF().setSoftwareName(scheduleFOBject.getSoftwareName());
		getScheduleF().setManufacturer(scheduleFOBject.getManufacturer());
		
		Scope sfScope = findScopeInList(scheduleFOBject.getScope().getId(),getScopeArrayList());
		String[] sfDescParts = sfScope.getDescription().split(",");
		
		if (scheduleFOBject.getLevel().equals(
				ScheduleFLevelEnumeration.HWOWNER.toString())) {
			if ((( sfDescParts[0].contains("IBM owned"))
					&& scheduleFOBject.getHwOwner().toString().equals("IBM"))
					|| ((sfDescParts[0].contains("Customer owned") )
							&& scheduleFOBject.getHwOwner().toString().equals("CUSTO"))){
				getScheduleF().setScope(sfScope);
			} else {
				addFieldError("scheduleFForm.hwowner",
						"hwowner is not matched to the selected scope");
				return INPUT;
			}
			
		} else {
			getScheduleF().setScope(
					findScopeInList(scheduleFOBject.getScope().getId(),
							getScopeArrayList()));
		}
		
		getScheduleF().setSource(
				findSourceInList(scheduleFOBject.getSource().getId(),
						getSourceArrayList()));
		
		   //AB added
		String sfr =scheduleFOBject.getSWFinanceResp();
		if(sfr==null || sfr.equals("")){
			addFieldError("scheduleFForm.swFinanResp","SW Financial Resp can't be blank.");
			return INPUT;					
		} else if ( sfDescParts[0].contains("IBM owned") && !sfr.equalsIgnoreCase("IBM")){
			addFieldError("scheduleFForm.swFinanResp","\"IBM Owned\" Scope only accept to \"IBM\" SW Financial Resp.");
			return INPUT;
		} else if(!sfScope.getDescription().contains("Customer owned, Customer managed") && sfr.equalsIgnoreCase("N/A")){
			addFieldError("scheduleFForm.swFinanResp","Only CUSTOMER OWNED CUSTOMER MANAGED Scope can accept N/A SW Financial Resp.");
			return INPUT;					
		}else{
			getScheduleF().setSWFinanceResp(sfr);
		}
				
		getScheduleF()
				.setSourceLocation(scheduleFOBject.getSourceLocation());
		if (laSoftware.get(0).getStatus().equalsIgnoreCase("INACTIVE")){
			getScheduleF().setStatus(findStatusInList((long) 1,getStatusArrayList()));
		} else {
		getScheduleF().setStatus(
				findStatusInList(scheduleFOBject.getStatus().getId(),
						getStatusArrayList()));
		}
		getScheduleF().setBusinessJustification(
				scheduleFOBject.getBusinessJustification());

		if (sfiExists != null && sfiExists.equals(getScheduleF())){
			addFieldError("scheduleFForm.softwareName",
					"Same entry with the given software name already exists.");
			return INPUT;
		}
		if (sfiExists == null && sfoExists != null && sfoExists.Keyquals(getScheduleF())) {
			addFieldError("scheduleFForm.softwareName",
					"Same entry with the given software name already exists.");
			return INPUT;
		}
		try {
			getScheduleFService().saveScheduleF(getScheduleF(),
					getUserSession().getRemoteUser());
		} catch (Exception e) {
			System.out.println(e.getCause());
			return INPUT;
		}
		return SUCCESS;
	}
	
	@POST
	@Path("/scheduleF/all/")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllScheduleFByAccount(@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort,
			@FormParam("dir") String dir,
			@FormParam("accountId") Long accountId){
		
			List<ScheduleF> schFlist = new ArrayList<ScheduleF>();
			List<ScheduleFView> schFViewList =new ArrayList<ScheduleFView>();
			Long total = Long.valueOf(0);
			
			if(null == accountId){
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
			}else{
				Account account = accountService.getAccount(accountId);
				if(null == account){
					return WSMsg.failMessage("Account doesn't exist");
				}
				int startIndex = (currentPage-1)*pageSize;
				total=getScheduleFService().getAllScheduleFSize(account);
				schFlist = getScheduleFService().paginatedList(account, Integer.valueOf(startIndex), Integer.valueOf(pageSize), sort,dir);
				schFViewList = scheduleFtransformer(schFlist);
			}
		
		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(schFViewList);
		return WSMsg.successMessage("SUCCESS", page);
	}
	
	@GET
	@Path("/scheduleF/download/{accountId}")
	public Response downloadScheduleFReport(@PathParam("accountId") Long accountId) throws IOException {

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		PrintWriter pw = new PrintWriter(new OutputStreamWriter(bos, "utf-8"), true);
		Account account = accountService.getAccount(accountId);
		getReportService().getScheduleFReport(account,pw);

		ResponseBuilder responseBuilder = Response.ok(bos.toByteArray());
		responseBuilder.header("Content-Type",
				"application/vnd.ms-excel;charset=UTF-8");
		responseBuilder.header("Content-Disposition",
				"attachment; filename=ScheduleF_View.xls");

		return responseBuilder.build();
	}
	
	
	public List<ScheduleFView> scheduleFtransformer(List<ScheduleF> scheFlist){
		List<ScheduleFView> scheFViewList = new ArrayList<ScheduleFView>();
		if(scheFlist!=null && scheFlist.size()>0){
			for(ScheduleF scheduleF:scheFlist){
				if(scheduleF!=null){
					ScheduleFView schFView = new ScheduleFView();
					
					schFView.setId(scheduleF.getId());
					schFView.setSoftwareName(scheduleF.getSoftwareName());
					schFView.setLevel(scheduleF.getLevel());
					
					if(null!=scheduleF.getHwOwner()){
						schFView.setHwOwner(scheduleF.getHwOwner());
					}else{
						schFView.setHwOwner("");
					}
					if(null!=scheduleF.getHostname()){
						schFView.setHostName(scheduleF.getHostname());
					}else{
						schFView.setHostName("");
					}
					if(null!=scheduleF.getSerial()){
						schFView.setSerial(scheduleF.getSerial());
					}else{
						schFView.setSerial("");
					}
					if(null!=scheduleF.getMachineType()){
						schFView.setMachineType(scheduleF.getMachineType());
					}else{
						schFView.setMachineType("");
					}
					if(null!=scheduleF.getSoftwareTitle()){
						schFView.setSoftwareTitle(scheduleF.getSoftwareTitle());
					}else{
						schFView.setSoftwareTitle("");
					}
					if(null!=scheduleF.getManufacturer()){
						schFView.setManufacturer(scheduleF.getManufacturer());
					}else{
						schFView.setManufacturer("");
					}
					if(null!=scheduleF.getSWFinanceResp()){
						schFView.setSWFinanceResp(scheduleF.getSWFinanceResp());
					}else{
						schFView.setSWFinanceResp("");
					}
					
					if(null!=scheduleF.getSourceLocation()){
						schFView.setSourceLocation(scheduleF.getSourceLocation());
					}else{
						schFView.setSourceLocation("");
					}
					
					if(null != scheduleF.getScope() && null != scheduleF.getScope().getDescription()){
						schFView.setScopeDescription(scheduleF.getScope().getDescription());
					}else{
						schFView.setScopeDescription("");
					}
					if(null != scheduleF.getSource() && null !=scheduleF.getSource().getDescription()){
						schFView.setSourceDescription(scheduleF.getSource().getDescription());
					}else{
						schFView.setSourceDescription("");
					}
					if(null != scheduleF.getStatus() && null !=scheduleF.getStatus().getDescription()){
						schFView.setStatusDescription(scheduleF.getStatus().getDescription());
					}else{
						schFView.setStatusDescription("");
					}
					if(null != scheduleF.getAccount() && null!=scheduleF.getAccount().getSoftwareComplianceManagement()){
						schFView.setSoftwareComplianceManagement(scheduleF.getAccount().getSoftwareComplianceManagement());
					}else{
						schFView.setSoftwareComplianceManagement("");
					}
					
					scheFViewList.add(schFView);
				}
			}
		}
		return scheFViewList;
	}
	
	@POST
	@Path("/scheduleF/upload")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces("application/vnd.ms-excel")
	public Response uploadFile(Attachment attachment, @Context HttpServletRequest request) {
		ByteArrayOutputStream bos = null;
		File file = null;
		Boolean error = false;
	
		//resolve file
		DataHandler handler = attachment.getDataHandler();
		try {
			InputStream stream = handler.getInputStream();
			
			//check file name
			MultivaluedMap<String, String> map = attachment.getHeaders();
			String filename = getFileName(map);
			String extension = filename.substring(filename.lastIndexOf('.'));
			if (!(extension.toLowerCase().equals(".xls") || extension.toLowerCase().equals(".cvs") || extension.toLowerCase().equals(".xlsx"))) {
				error = true;
			}
			
			//save a tmp file
			file = new File("/tmp/" + filename);
			if(file.exists()){
				file.delete();
			}
			
			OutputStream out = new FileOutputStream(file);
			int read = 0;
			byte[] bytes = new byte[1024];
			while ((read = stream.read(bytes)) != -1) {
				out.write(bytes, 0, read);
			}
			stream.close();
			out.flush();
			out.close();
			
			//if save tmp file failed, set error flag
			if (!file.exists()) {
				error = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//parse scheduleF from file
		if (!error) {
			try {
				bos = scheduleFService.loadSpreadsheet(file, request.getRemoteUser());
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			try {
				bos = new ByteArrayOutputStream();
				PrintWriter pw = new PrintWriter(new OutputStreamWriter(bos,"UTF-8"), true);
				pw.println("SEEMS YOU ARE LOADING A FILE WITH NOT ACCEPTABLE FORMAT!");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		
		//delete uploaded file
		if(file.exists()){
			file.delete();
		}	
		
		ResponseBuilder responseBuilder = Response.ok((Object) bos.toByteArray());
		responseBuilder.type("application/vnd.ms-excel; charset=UTF-8");
		responseBuilder.header("Content-Disposition","attachment; filename=results.xls;");
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
	
	private Status findStatusInList(Long plStatusId, ArrayList<Status> plFind) {
		ListIterator<Status> lliFind = plFind.listIterator();
		Status lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getId().longValue() == plStatusId.longValue()) {
				break;
			}
		}

		return lsFind;
	}
	
	private ScheduleF findSfInExistsList( List<ScheduleF> lsfExists) {
		ListIterator<ScheduleF> lliFind = lsfExists.listIterator();
		ScheduleF lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();
			if (scheduleFOBject.getLevel().toString().equals(ScheduleFLevelEnumeration.PRODUCT.toString()) ){
				break;
			} else if((scheduleFOBject.getLevel().toString().equals(ScheduleFLevelEnumeration.HWOWNER.toString()) && scheduleFOBject.getHwOwner().equals(lsFind.getHwOwner()) )
					|| (scheduleFOBject.getLevel().toString().equals(ScheduleFLevelEnumeration.HOSTNAME.toString()) && scheduleFOBject.getHostname().equals(lsFind.getHostname()) )
					|| (scheduleFOBject.getLevel().toString().equals(ScheduleFLevelEnumeration.HWBOX.toString()) && scheduleFOBject.getMachineType().equals(lsFind.getMachineType()) && scheduleFOBject.getSerial().equals(lsFind.getSerial()) )) {
				break;
			}
		
		}

		return lsFind;
	}
	
	private Scope findScopeInList(Long plScopeId, ArrayList<Scope> plFind) {
		ListIterator<Scope> lliFind = plFind.listIterator();
		Scope lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getId().longValue() == plScopeId.longValue()) {
				break;
			}
		}

		return lsFind;
	}
	
	private Source findSourceInList(Long plSourceId, ArrayList<Source> plFind) {
		ListIterator<Source> lliFind = plFind.listIterator();
		Source lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getId().longValue() == plSourceId.longValue()) {
				break;
			}
		}

		return lsFind;
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
	
	public ReportService getReportService() {
		return reportService;
	}

	public void setReportService(ReportService reportService) {
		this.reportService = reportService;
	}

	public Long getScheduleFId() {
		return scheduleFId;
	}

	public void setScheduleFId(Long scheduleFId) {
		this.scheduleFId = scheduleFId;
	}
	
	public ScheduleF getScheduleF() {
		return (ScheduleF) getSession().get("scheduleF");
	}

	public void setScheduleF(ScheduleF scheduleF) {
		getSession().put("scheduleF", scheduleF);
	}

	public ArrayList<Scope> getScopeArrayList() {
		return scopeArrayList;
	}

	public void setScopeArrayList(ArrayList<Scope> scopeArrayList) {
		this.scopeArrayList = scopeArrayList;
	}

	public ArrayList<Source> getSourceArrayList() {
		return sourceArrayList;
	}

	public void setSourceArrayList(ArrayList<Source> sourceArrayList) {
		this.sourceArrayList = sourceArrayList;
	}

	public ArrayList<Status> getStatusArrayList() {
		return statusArrayList;
	}

	public void setStatusArrayList(ArrayList<Status> statusArrayList) {
		this.statusArrayList = statusArrayList;
	}

	public ArrayList<String> getLevelArrayList() {
		return levelArrayList;
	}

	public void setLevelArrayList(ArrayList<String> levelArrayList) {
		this.levelArrayList = levelArrayList;
	}
}
