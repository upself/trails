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
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFH;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.domain.ScheduleFView;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ManufacturerService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

public class ScheduleFServiceEndpoint {
	@Autowired
	private ScheduleFService scheduleFService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private ReportService reportService;
    
	@Autowired
	private ManufacturerService manufactuerService;

	@GET
	@Path("/scheduleF/scopes")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg scopes() {
		List<Scope> scopeList = new ArrayList<Scope>();
		scopeList = getScheduleFService().getScopeList();
		return WSMsg.successMessage("SUCCESS", scopeList);
	}

	@GET
	@Path("/scheduleF/sources")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg sources() {
		List<Source> scourceList = new ArrayList<Source>();
		scourceList = getScheduleFService().getSourceList();
		return WSMsg.successMessage("SUCCESS", scourceList);
	}

	@GET
	@Path("/scheduleF/status")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg status() {
		List<Status> statusList = new ArrayList<Status>();
		statusList = getScheduleFService().getStatusList();
		return WSMsg.successMessage("SUCCESS", statusList);
	}

	@POST
	@Path("/scheduleF/{id}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getScheduleFViewById(@PathParam("id") Long id,
			@FormParam("accountId") Long accountId) {
		ArrayList<ScheduleF> schfList = new ArrayList<ScheduleF>();
		List<ScheduleFView> schFViewList = new ArrayList<ScheduleFView>();
		ScheduleF result = getScheduleFService().getScheduleFDetails(id);
		Account account = accountService.getAccount(accountId);
		if (result == null) {
			return WSMsg.failMessage("No ScheduleF item found for id = " + id
					+ "!");
		} else {
			if (result.getAccount().getId().longValue() != accountId
					.longValue()) {
				return WSMsg
						.failMessage("Seems you are not loading the scheduleF item for current account !");
			}
			schfList.add(result);
			schFViewList = scheduleFtransformer(schfList);
			ScheduleFView sfView = schFViewList.get(0);
			
			if (!sfView.getLevel().equals(
					ScheduleFLevelEnumeration.MANUFACTURER
					.toString()) && !getScheduleFService().findSoftwareBySoftwareName(
					result.getSoftwareName().toString()).isEmpty() && getScheduleFService()
					.findSoftwareBySoftwareName(
							result.getSoftwareName().toString()).get(0)
					.getStatus().equalsIgnoreCase("ACTIVE")) {
				sfView.setSoftwareStatus(false);

			} else if (sfView.getLevel().equals(
					ScheduleFLevelEnumeration.MANUFACTURER
					.toString())){
				if(manufactuerService
				.findManufacturerByName(sfView.getManufacturer()) == null){
					sfView.setSoftwareStatus(true);
				}
			} else {
				sfView.setSoftwareStatus(true);
			}
			
			if (account.getSoftwareFinancialManagement() != null) {
				sfView.setSoftwareComplianceManagement(account
						.getSoftwareFinancialManagement().equalsIgnoreCase(
								"YES") ? "YES" : "NO");
			} else {
				sfView.setSoftwareComplianceManagement("NO");
			}
			return WSMsg.successMessage("The ScheduleF item found for id = "
					+ id + ".", sfView);
		}
	}

	@POST
	@Path("/scheduleF/save")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg saveUpdateScheduleF(
			@FormParam("accountId") Long accountId,
			@FormParam("id") String id,
			@FormParam("softwareName") String softwareName,
			@FormParam("level") String level,
			@FormParam("hwOwner") String hwOwner,
			@FormParam("hostName") String hostName,
			@FormParam("serial") String serial,
			@FormParam("machineType") String machineType,
			@FormParam("softwareTitle") String softwareTitle,
			@FormParam("manufacturer") String manufacturer,
			@FormParam("scopeDescription") String scopeDescription,
			@FormParam("sourceLocation") String sourceLocation,
			@FormParam("statusDescription") String statusDescription,
			@FormParam("softwareComplianceManagement") String softwareComplianceManagement,
			@FormParam("softwareStatus") Boolean softwareStatus,
			@FormParam("swfinanceResp") String swfinanceResp,
			@FormParam("sourceDescription") String sourceDescription,
			@FormParam("businessJustification") String businessJustification,
			@Context HttpServletRequest request) {

		ScheduleFView scheduleFView = new ScheduleFView();
		scheduleFView.setSoftwareName(softwareName);
		scheduleFView.setLevel(level);
		scheduleFView.setHwOwner(hwOwner);
		scheduleFView.setHostName(hostName);
		scheduleFView.setSerial(serial);
		scheduleFView.setMachineType(machineType);
		scheduleFView.setSoftwareTitle(softwareTitle);
		scheduleFView.setManufacturer(manufacturer);
		scheduleFView.setScopeDescription(scopeDescription);
		scheduleFView.setSourceLocation(sourceLocation);
		scheduleFView.setStatusDescription(statusDescription);
		scheduleFView
				.setSoftwareComplianceManagement(softwareComplianceManagement);
		scheduleFView.setSoftwareStatus(softwareStatus);
		scheduleFView.setSWFinanceResp(swfinanceResp);
		scheduleFView.setSourceDescription(sourceDescription);
		scheduleFView.setBusinessJustification(businessJustification);

		ArrayList<Software> laSoftware = getScheduleFService()
				.findSoftwareBySoftwareName(scheduleFView.getSoftwareName());
		Manufacturer manufacturer1 = manufactuerService
				.findManufacturerByName(manufacturer);
		Status status = findStatusInList(statusDescription,getScheduleFService().getStatusList());
		List<ScheduleF> lsfExists = null;
		Long llScheduleFId = null;
		ScheduleF sfoExists = null;
		ScheduleF sfiExists = null;
		ScheduleF bjScheduleF = null;
		Account account = accountService.getAccount(accountId);
		if (id != null && StringUtils.isNotEmpty(id) && id != "") {
			llScheduleFId = Long.parseLong(id);
			bjScheduleF = getScheduleFService().getScheduleFDetails(
					llScheduleFId);
		} else {
			bjScheduleF = new ScheduleF();
		}

		if ((scheduleFView.getLevel().equals(
				ScheduleFLevelEnumeration.MANUFACTURER
				.toString()) && manufacturer1 == null) || (!scheduleFView.getLevel().equals(
						ScheduleFLevelEnumeration.MANUFACTURER
						.toString()) && laSoftware.size() == 0)) {
			if (status.getId() != 1) {
				if (manufacturer1 == null
						&& scheduleFView.getLevel().equals(
								ScheduleFLevelEnumeration.MANUFACTURER
										.toString())) {
					return WSMsg.failMessage("Manufacturer does not exist in catalog. It may already been removed in SWKB Toolkit.");
				}
				if (laSoftware.size() == 0
						&& !scheduleFView.getLevel().equals(
								ScheduleFLevelEnumeration.MANUFACTURER
										.toString())) {
					return WSMsg.failMessage("Software does not exist in catalog. It may already been removed in SWKB Toolkit.");
				}
			} else {
					bjScheduleF.setStatus(status);
			}
		} else {

			if (!scheduleFView.getLevel().equals(
					ScheduleFLevelEnumeration.MANUFACTURER
					.toString())){
			lsfExists = getScheduleFService().findScheduleF(account,
					laSoftware.get(0).getSoftwareName(), 
					scheduleFView.getLevel());
			}
			if (scheduleFView.getLevel().equals(
					ScheduleFLevelEnumeration.MANUFACTURER
					.toString())){
			lsfExists = getScheduleFService().findScheduleFbyManufacturer(account,
					scheduleFView.getManufacturer(), 
					scheduleFView.getLevel());
			}
			if (lsfExists != null) {
				sfoExists = findSfInExistsList(lsfExists, scheduleFView);
			}
			if (llScheduleFId != null) {
				sfiExists = getScheduleFService().findScheduleF(llScheduleFId);
			}

		}
		bjScheduleF.setSoftwareTitle(scheduleFView.getSoftwareTitle());
		bjScheduleF.setSoftwareName(scheduleFView.getSoftwareName());
		if (laSoftware.size() != 0 ){ bjScheduleF.setSoftware(laSoftware.get(0));}
		bjScheduleF.setLevel(scheduleFView.getLevel());
		if (scheduleFView.getLevel().equals(
				ScheduleFLevelEnumeration.HWOWNER.toString())) {

			if (StringUtils.isEmpty(scheduleFView.getHwOwner())) {
				return WSMsg.failMessage("HW owner field is empty");
			} else {
				bjScheduleF.setHwOwner(scheduleFView.getHwOwner());
				bjScheduleF.setSerial(null);
				bjScheduleF.setMachineType(null);
				bjScheduleF.setHostname(null);
			}

		} else if (scheduleFView.getLevel().equals(
				ScheduleFLevelEnumeration.HWBOX.toString())) {

			if (StringUtils.isEmpty(scheduleFView.getSerial())
					|| StringUtils.isEmpty(scheduleFView.getMachineType())) {
				return WSMsg.failMessage("HW box properties are empty");
			} else {
				bjScheduleF.setSerial(scheduleFView.getSerial());
				bjScheduleF.setMachineType(scheduleFView.getMachineType());
				bjScheduleF.setHwOwner(null);
				bjScheduleF.setHostname(null);
			}

		} else if (scheduleFView.getLevel().equals(
				ScheduleFLevelEnumeration.HOSTNAME.toString())) {
			if (StringUtils.isEmpty(scheduleFView.getHostName())) {
				return WSMsg.failMessage("Hostname field is empty");
			} else {
				bjScheduleF.setHostname(scheduleFView.getHostName());
				bjScheduleF.setHwOwner(null);
				bjScheduleF.setSerial(null);
				bjScheduleF.setMachineType(null);
			}

		} else if (scheduleFView.getLevel().equals(
				ScheduleFLevelEnumeration.MANUFACTURER.toString())) {
			if (StringUtils.isEmpty(scheduleFView.getManufacturer())) {
				return WSMsg.failMessage("MANUFACTURER field is empty");
			} else {
				bjScheduleF.setHostname(scheduleFView.getHostName());
				bjScheduleF.setHwOwner(null);
				bjScheduleF.setSerial(null);
				bjScheduleF.setMachineType(null);
				bjScheduleF.setSoftware(null);
				bjScheduleF.setSoftwareTitle(null);
				bjScheduleF.setSoftwareName(null);
				if (manufacturer1 == null) {
					bjScheduleF.setStatus(findStatusInList("INACTIVE",
							getScheduleFService().getStatusList()));
				} else {
					bjScheduleF.setStatus(status);
				}
			}

		} else {
			bjScheduleF.setHostname(null);
			bjScheduleF.setHwOwner(null);
			bjScheduleF.setSerial(null);
			bjScheduleF.setMachineType(null);
		}

		bjScheduleF.setAccount(account);
		bjScheduleF.setManufacturer(scheduleFView.getManufacturer());
		bjScheduleF.setManufacturerName(scheduleFView.getManufacturer());

		Scope sfScope = findScopeInList(scheduleFView.getScopeDescription(),
				getScheduleFService().getScopeList());
		String[] sfDescParts = sfScope.getDescription().split(",");

		if (scheduleFView.getLevel().equals(
				ScheduleFLevelEnumeration.HWOWNER.toString())) {
			if (((sfDescParts[0].contains("IBM owned")) && scheduleFView
					.getHwOwner().toString().equals("IBM"))
					|| ((sfDescParts[0].contains("Customer owned")) && scheduleFView
							.getHwOwner().toString().equals("CUSTO"))) {
				bjScheduleF.setScope(sfScope);
			} else {
				return WSMsg
						.failMessage("hwowner is not matched to the selected scope");
			}

		} else {
			bjScheduleF.setScope(findScopeInList(scheduleFView
					.getScopeDescription(), getScheduleFService()
					.getScopeList()));
		}

		bjScheduleF
				.setSource(findSourceInList(
						scheduleFView.getSourceDescription(),
						getScheduleFService().getSourceList()));

		// AB added
		String sfr = scheduleFView.getSWFinanceResp();
		if (sfr == null || sfr.equals("")) {
			return WSMsg.failMessage("SW Financial Resp can't be blank.");
		} else if (sfDescParts[0].contains("IBM owned")
				&& !sfr.equalsIgnoreCase("IBM")) {
			return WSMsg
					.failMessage("IBM Owned Scope only accept to IBM SW Financial Resp.");
		} else if (!sfScope.getDescription().contains(
				"Customer owned, Customer managed")
				&& sfr.equalsIgnoreCase("N/A")) {
			return WSMsg
					.failMessage("Only CUSTOMER OWNED CUSTOMER MANAGED Scope can accept N/A SW Financial Resp.");
		} else {
			bjScheduleF.setSWFinanceResp(sfr);
		}

		bjScheduleF.setSourceLocation(scheduleFView.getSourceLocation());
		if (!bjScheduleF.getLevel().equals(
				ScheduleFLevelEnumeration.MANUFACTURER.toString())){
		if (bjScheduleF.getStatus() == null
				&& (laSoftware.size() == 0 || laSoftware.get(0).getStatus()
						.equalsIgnoreCase("INACTIVE"))) {
			bjScheduleF.setStatus(findStatusInList("INACTIVE",
					getScheduleFService().getStatusList()));
		} else {
			bjScheduleF.setStatus(status);
		}
		}
		bjScheduleF.setBusinessJustification(scheduleFView
				.getBusinessJustification());
        if (bjScheduleF.getStatus().getDescription().equalsIgnoreCase("ACTIVE")){
		if ((sfiExists != null  && sfiExists.equals(bjScheduleF)) 
				|| (sfoExists != null && null == bjScheduleF.getId()  && sfoExists.Keyquals(bjScheduleF)) 
				|| (sfoExists != null && null != bjScheduleF.getId() && bjScheduleF.getId().longValue() != sfoExists.getId().longValue()  && sfoExists.Keyquals(bjScheduleF))){
			if (bjScheduleF.getLevel().equals(
				ScheduleFLevelEnumeration.MANUFACTURER.toString())){
			return WSMsg
					.failMessage("Same entry with the given manufacturer name already exists.");
			} else {
			return WSMsg
					.failMessage("Same entry with the given software name already exists.");
			}
		}
		}
		try {
			getScheduleFService().saveScheduleF(bjScheduleF,
					request.getRemoteUser());
		} catch (Exception e) {
			return WSMsg
					.failMessage("Encounter Exception while updating Schedule F ");
		}
		return WSMsg.successMessage("Add/Update Schedule F success");
	}

	@POST
	@Path("/scheduleF/all/")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllScheduleFByAccount(
			@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort, @FormParam("dir") String dir,
			@FormParam("accountId") Long accountId) {

		List<ScheduleF> schFlist = new ArrayList<ScheduleF>();
		List<ScheduleFView> schFViewList = new ArrayList<ScheduleFView>();
		Long total = Long.valueOf(0);

		if (null == accountId) {
			return WSMsg.failMessage("Account ID is required");
		} else if (null == currentPage) {
			return WSMsg.failMessage("Current Page Parameter is required");
		} else if (null == pageSize) {
			return WSMsg.failMessage("Page Size Parameter is required");
		} else if (null == sort || "".equals(sort.trim())) {
			return WSMsg.failMessage("Sort Column Parameter is required");
		} else if (null == dir || "".equals(dir.trim())) {
			return WSMsg.failMessage("Sort Direction Parameter is required");
		} else {
			Account account = accountService.getAccount(accountId);
			if (null == account) {
				return WSMsg.failMessage("Account doesn't exist");
			}
			int startIndex = (currentPage - 1) * pageSize;
			total = getScheduleFService().getAllScheduleFSize(account);
			schFlist = getScheduleFService().paginatedList(account,
					Integer.valueOf(startIndex), Integer.valueOf(pageSize),
					sort, dir);
			schFViewList = scheduleFtransformer(schFlist);
		}

		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(schFViewList);
		return WSMsg.successMessage("SUCCESS", page);
	}

	@POST
	@Path("/scheduleF/history/{shfid}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getScheduleFHBySchId(@PathParam("shfid") Long shfid,
			@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort, @FormParam("dir") String dir) {

		List<ScheduleFH> schFHlist = new ArrayList<ScheduleFH>();
		List<ScheduleFView> schFViewList = new ArrayList<ScheduleFView>();
		Long total = Long.valueOf(0);

		if (null == shfid) {
			return WSMsg.failMessage("ScheduleF ID is required");
		} else if (null == currentPage) {
			return WSMsg.failMessage("Current Page Parameter is required");
		} else if (null == pageSize) {
			return WSMsg.failMessage("Page Size Parameter is required");
		} else if (null == sort || "".equals(sort.trim())) {
			return WSMsg.failMessage("Sort Column Parameter is required");
		} else if (null == dir || "".equals(dir.trim())) {
			return WSMsg.failMessage("Sort Direction Parameter is required");
		} else {
			ScheduleF schedulF = getScheduleFService().getScheduleFDetails(
					shfid);
			if (null == schedulF) {
				return WSMsg.failMessage("SchedulF doesn't exist any more");
			}
			int startIndex = (currentPage - 1) * pageSize;
			total = getScheduleFService().getScheduleFHSize(schedulF);
			schFHlist = getScheduleFService().paginatedList(shfid,
					Integer.valueOf(startIndex), Integer.valueOf(pageSize),
					sort, dir);
			schFViewList = scheduleFHtransformer(schFHlist);
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
	public Response downloadScheduleFReport(
			@PathParam("accountId") Long accountId) throws IOException {

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		PrintWriter pw = new PrintWriter(new OutputStreamWriter(bos, "utf-8"),
				true);
		Account account = accountService.getAccount(accountId);
		getReportService().getScheduleFReport(account, pw);

		ResponseBuilder responseBuilder = Response.ok(bos.toByteArray());
		responseBuilder.header("Content-Type",
				"application/vnd.ms-excel;charset=UTF-8");
		responseBuilder.header("Content-Disposition",
				"attachment; filename=ScheduleF_View.xls");

		return responseBuilder.build();
	}

	public List<ScheduleFView> scheduleFtransformer(List<ScheduleF> scheFlist) {
		List<ScheduleFView> scheFViewList = new ArrayList<ScheduleFView>();
		if (scheFlist != null && scheFlist.size() > 0) {
			for (ScheduleF scheduleF : scheFlist) {
				if (scheduleF != null) {
					ScheduleFView schFView = new ScheduleFView();

					schFView.setId(scheduleF.getId());
					schFView.setLevel(scheduleF.getLevel());
					
					if (null != scheduleF.getSoftwareName()) {
						schFView.setSoftwareName(scheduleF.getSoftwareName());
					} else {
						schFView.setSoftwareName("");
					}
					if (null != scheduleF.getHwOwner()) {
						schFView.setHwOwner(scheduleF.getHwOwner());
					} else {
						schFView.setHwOwner("");
					}
					if (null != scheduleF.getHostname()) {
						schFView.setHostName(scheduleF.getHostname());
					} else {
						schFView.setHostName("");
					}
					if (null != scheduleF.getSerial()) {
						schFView.setSerial(scheduleF.getSerial());
					} else {
						schFView.setSerial("");
					}
					if (null != scheduleF.getMachineType()) {
						schFView.setMachineType(scheduleF.getMachineType());
					} else {
						schFView.setMachineType("");
					}
					if (null != scheduleF.getSoftwareTitle()) {
						schFView.setSoftwareTitle(scheduleF.getSoftwareTitle());
					} else {
						schFView.setSoftwareTitle("");
					}
					if (null != scheduleF.getManufacturer()) {
						schFView.setManufacturer(scheduleF.getManufacturer());
					} else {
						schFView.setManufacturer("");
					}
					if (null != scheduleF.getSWFinanceResp()) {
						schFView.setSWFinanceResp(scheduleF.getSWFinanceResp());
					} else {
						schFView.setSWFinanceResp("");
					}
					if (null != scheduleF.getBusinessJustification()) {
						schFView.setBusinessJustification(scheduleF
								.getBusinessJustification());
					} else {
						schFView.setBusinessJustification("");
					}
					if (null != scheduleF.getSourceLocation()) {
						schFView.setSourceLocation(scheduleF
								.getSourceLocation());
					} else {
						schFView.setSourceLocation("");
					}
					if (null != scheduleF.getScope()
							&& null != scheduleF.getScope().getDescription()) {
						schFView.setScopeDescription(scheduleF.getScope()
								.getDescription());
					} else {
						schFView.setScopeDescription("");
					}
					if (null != scheduleF.getSource()
							&& null != scheduleF.getSource().getDescription()) {
						schFView.setSourceDescription(scheduleF.getSource()
								.getDescription());
					} else {
						schFView.setSourceDescription("");
					}
					if (null != scheduleF.getStatus()
							&& null != scheduleF.getStatus().getDescription()) {
						schFView.setStatusDescription(scheduleF.getStatus()
								.getDescription());
					} else {
						schFView.setStatusDescription("");
					}
					if (null != scheduleF.getAccount()
							&& null != scheduleF.getAccount()
									.getSoftwareComplianceManagement()) {
						schFView.setSoftwareComplianceManagement(scheduleF
								.getAccount().getSoftwareComplianceManagement());
					} else {
						schFView.setSoftwareComplianceManagement("");
					}

					scheFViewList.add(schFView);
				}
			}
		}
		return scheFViewList;
	}

	public List<ScheduleFView> scheduleFHtransformer(List<ScheduleFH> scheFhlist) {
		List<ScheduleFView> scheFViewList = new ArrayList<ScheduleFView>();
		if (scheFhlist != null && scheFhlist.size() > 0) {
			for (ScheduleFH scheduleFH : scheFhlist) {
				if (scheduleFH != null) {
					ScheduleFView schFView = new ScheduleFView();

					schFView.setId(scheduleFH.getId());
					
					schFView.setLevel(scheduleFH.getLevel());

					if (null != scheduleFH.getSoftwareName()) {
						schFView.setSoftwareName(scheduleFH.getSoftwareName());
					} else {
						schFView.setSoftwareName("");
					}
					if (null != scheduleFH.getHwOwner()) {
						schFView.setHwOwner(scheduleFH.getHwOwner());
					} else {
						schFView.setHwOwner("");
					}
					if (null != scheduleFH.getHostname()) {
						schFView.setHostName(scheduleFH.getHostname());
					} else {
						schFView.setHostName("");
					}
					if (null != scheduleFH.getSerial()) {
						schFView.setSerial(scheduleFH.getSerial());
					} else {
						schFView.setSerial("");
					}
					if (null != scheduleFH.getMachineType()) {
						schFView.setMachineType(scheduleFH.getMachineType());
					} else {
						schFView.setMachineType("");
					}
					if (null != scheduleFH.getSoftwareTitle()) {
						schFView.setSoftwareTitle(scheduleFH.getSoftwareTitle());
					} else {
						schFView.setSoftwareTitle("");
					}
					if (null != scheduleFH.getManufacturer()) {
						schFView.setManufacturer(scheduleFH.getManufacturer());
					} else {
						schFView.setManufacturer("");
					}
					if (null != scheduleFH.getSWFinanceResp()) {
						schFView.setSWFinanceResp(scheduleFH.getSWFinanceResp());
					} else {
						schFView.setSWFinanceResp("");
					}
					if (null != scheduleFH.getBusinessJustification()) {
						schFView.setBusinessJustification(scheduleFH
								.getBusinessJustification());
					} else {
						schFView.setBusinessJustification("");
					}
					if (null != scheduleFH.getSourceLocation()) {
						schFView.setSourceLocation(scheduleFH
								.getSourceLocation());
					} else {
						schFView.setSourceLocation("");
					}

					if (null != scheduleFH.getScope()
							&& null != scheduleFH.getScope().getDescription()) {
						schFView.setScopeDescription(scheduleFH.getScope()
								.getDescription());
					} else {
						schFView.setScopeDescription("");
					}
					if (null != scheduleFH.getSource()
							&& null != scheduleFH.getSource().getDescription()) {
						schFView.setSourceDescription(scheduleFH.getSource()
								.getDescription());
					} else {
						schFView.setSourceDescription("");
					}
					if (null != scheduleFH.getStatus()
							&& null != scheduleFH.getStatus().getDescription()) {
						schFView.setStatusDescription(scheduleFH.getStatus()
								.getDescription());
					} else {
						schFView.setStatusDescription("");
					}
					if (null != scheduleFH.getRemoteUser()) {
						schFView.setRemoteUser(scheduleFH.getRemoteUser());
					} else {
						schFView.setRemoteUser("");
					}
					schFView.setRecordTime(scheduleFH.getRecordTime());
					scheFViewList.add(schFView);
				}
			}
		}
		return scheFViewList;
	}

	@POST
	@Path("/schedulef/upload")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces("application/vnd.ms-excel")
	public Response uploadFile(Attachment attachment,
			@Context HttpServletRequest request) {
		ByteArrayOutputStream bos = null;
		File file = null;
		Boolean error = false;

		// resolve file
		DataHandler handler = attachment.getDataHandler();
		try {
			InputStream stream = handler.getInputStream();

			// check file name
			MultivaluedMap<String, String> map = attachment.getHeaders();
			String filename = getFileName(map);
			String extension = filename.substring(filename.lastIndexOf('.'));
			if (!(extension.toLowerCase().equals(".xls")
					|| extension.toLowerCase().equals(".cvs") || extension
					.toLowerCase().equals(".xlsx"))) {
				error = true;
			}

			// save a tmp file
			file = new File("/tmp/" + filename);
			if (file.exists()) {
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

			// if save tmp file failed, set error flag
			if (!file.exists()) {
				error = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// parse scheduleF from file
		if (!error) {
			try {
				bos = scheduleFService.loadSpreadsheet(file,
						request.getRemoteUser());
			} catch (IOException e) {
				e.printStackTrace();
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

		// delete uploaded file
		if (file.exists()) {
			file.delete();
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

	private Status findStatusInList(String plStatusDesc, ArrayList<Status> plFind) {
		ListIterator<Status> lliFind = plFind.listIterator();
		Status lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getDescription().equalsIgnoreCase(plStatusDesc.toString())) {
				break;
			}
		}

		return lsFind;
	}

	private ScheduleF findSfInExistsList(List<ScheduleF> lsfExists,
			ScheduleFView scheduleFView) {
		ListIterator<ScheduleF> lliFind = lsfExists.listIterator();
		ScheduleF lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();
			if (scheduleFView.getLevel().toString()
					.equals(ScheduleFLevelEnumeration.PRODUCT.toString())) {
				break;
			} else if ((scheduleFView.getLevel().toString()
					.equals(ScheduleFLevelEnumeration.MANUFACTURER.toString()) && scheduleFView
					.getManufacturer().equals(lsFind.getManufacturer()))
					|| (scheduleFView
							.getLevel()
							.toString()
							.equals(ScheduleFLevelEnumeration.HWOWNER
									.toString()) && scheduleFView.getHwOwner()
							.equals(lsFind.getHwOwner()))
					|| (scheduleFView
							.getLevel()
							.toString()
							.equals(ScheduleFLevelEnumeration.HOSTNAME
									.toString()) && scheduleFView.getHostName()
							.equals(lsFind.getHostname()))
					|| (scheduleFView.getLevel().toString()
							.equals(ScheduleFLevelEnumeration.HWBOX.toString())
							&& scheduleFView.getMachineType().equals(
									lsFind.getMachineType()) && scheduleFView
							.getSerial().equals(lsFind.getSerial()))) {
				break;
			}

		}

		return lsFind;
	}

	private Scope findScopeInList(String plScopeDes, ArrayList<Scope> plFind) {
		ListIterator<Scope> lliFind = plFind.listIterator();
		Scope lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getDescription().equalsIgnoreCase(plScopeDes)) {
				break;
			}
		}

		return lsFind;
	}

	private Source findSourceInList(String plSourceDes, ArrayList<Source> plFind) {
		ListIterator<Source> lliFind = plFind.listIterator();
		Source lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getDescription().equalsIgnoreCase(plSourceDes)) {
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
}
