package com.ibm.asset.trails.ws;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
import com.ibm.asset.trails.domain.DataExceptionHardwareLpar;
import com.ibm.asset.trails.domain.DataExceptionHardwareLparView;
import com.ibm.asset.trails.domain.DataExceptionHistory;
import com.ibm.asset.trails.domain.DataExceptionHistoryView;
import com.ibm.asset.trails.domain.DataExceptionInstalledSw;
import com.ibm.asset.trails.domain.DataExceptionInstalledSwView;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLparView;
import com.ibm.asset.trails.form.DataExceptionReportActionForm;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/exceptions")
public class DataExceptionServiceEndpoint {
	@Autowired
	private @Qualifier("alertSwlparService") DataExceptionService dataExpSoftwareLparService;

	@Autowired
	private @Qualifier("alertHwlparService") DataExceptionService dataExpHardwareLparService;

	@Autowired
	private @Qualifier("alertInstalledSwService") DataExceptionService dataExpInstalledSwService;

	@Autowired
	private DataExceptionReportService dataExceptionReportService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private DataExceptionHistoryDao alertHistoryDao;

	public enum SW_LPAR {
		NULLTIME, NOCUST, NOLP, NOOS, ZEROPROC, NOWS
	}
	
	public enum HW_LPAR {
		HWNCHP, HWNPRC, NCPMDL, NPRCTYP
	}
	
	public enum INSTALLED_SW {
		SWDSCEXP
	}

	public final Set<String> SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST = new HashSet<String>(Arrays.asList("NULLTIME", "NOCUST", "NOLP", "NOOS", "ZEROPROC", "NOSW"));
	public final Set<String> HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST = new HashSet<String>(Arrays.asList("HWNCHP", "HWNPRC", "NCPMDL", "NPRCTYP"));
	public final Set<String> INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST = new HashSet<String>(Arrays.asList("SWDSCEXP"));

	@GET
	@Path("/overview/{accountId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg exceptionOverview(@PathParam("accountId") Long accountId) {
		if (null == accountId) {
			return WSMsg.failMessage("Account ID is required");
		} else {
			Account account = accountService.getAccount(accountId);
			if (null == account) {
				return WSMsg.failMessage("Account doesn't exist");
			} else {
				List<DataExceptionReportActionForm> dataList = dataExceptionReportService.getAlertsOverview(account);
				return WSMsg.successMessage("SUCCESS", dataList);
			}
		}

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@POST
	@Path("/{dataExpType}/search")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("accountId") Long accountId,
			@FormParam("currentPage") Integer currentPage, @FormParam("pageSize") Integer pageSize, @FormParam("sort") String sort,
			@FormParam("dir") String dir) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == accountId) {
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
			} else {
				int startIndex = (currentPage - 1) * pageSize;

				Long total = null;
				List list = null;
				AlertType alertType = null;
				dataExpType = dataExpType.trim().toUpperCase();					
				if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {
					dataExpSoftwareLparService.setAlertTypeCode(dataExpType);
					alertType = dataExpSoftwareLparService.getAlertType();
					total = new Long(dataExpSoftwareLparService.getAlertListSize(account, alertType));
					list = dataExpSoftwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.swLparDataExpsTransformer(list);
				} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {
					dataExpHardwareLparService.setAlertTypeCode(dataExpType);
					alertType = dataExpHardwareLparService.getAlertType();
					total = new Long(dataExpHardwareLparService.getAlertListSize(account, alertType));
					list = dataExpHardwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.hwLparDataExpsTransformer(list);
				} else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {
					dataExpInstalledSwService.setAlertTypeCode(dataExpType);
					alertType = dataExpInstalledSwService.getAlertType();
					total = new Long(dataExpInstalledSwService.getAlertListSize(account, alertType));
					list = dataExpInstalledSwService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.installedSwDataExpsTransformer(list);
				} else {
					return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
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
	public WSMsg assignDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("comments") String comments,
			@FormParam("assignIds") String assignIds, @Context HttpServletRequest request) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == assignIds || "".equals(assignIds.trim())) {
			return WSMsg.failMessage("Assign Ids List is required");
		} else if (null == comments || "".equals(comments.trim())) {
			return WSMsg.failMessage("Comment is required");
		} else {
			try {
				List<Long> assignList = new ArrayList<Long>();
				for (String idStr : assignIds.split(",")) {
					assignList.add(Long.valueOf(idStr));
				}

				dataExpType = dataExpType.trim().toUpperCase();
				if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Software
																						// Lpar
																						// Data
																						// Exception
																						// Type
					dataExpSoftwareLparService.assign(assignList, request.getRemoteUser(), comments);
				} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Hardware
																								// Lpar
																								// Data
																								// Exception
																								// Type
					dataExpHardwareLparService.assign(assignList, request.getRemoteUser(), comments);
				} else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Installed Software Data Exception 
					
					dataExpInstalledSwService.assign(assignList, request.getRemoteUser(), comments);
                } else {
					return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
				}

				return WSMsg.successMessage("Assign success");
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Assign failed");
			}
		}
	}

	@POST
	@Path("/{dataExpType}/unassign")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg unassignDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("unassignIds") String unassignIds,
			@FormParam("comments") String comments, @Context HttpServletRequest request) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == unassignIds || "".equals(unassignIds.trim())) {
			return WSMsg.failMessage("Unassign Ids List is required");
		} else if (null == comments || "".equals(comments.trim())) {
			return WSMsg.failMessage("Comment is required");
		} else {
			try {
				List<Long> unassignList = new ArrayList<Long>();
				for (String idStr : unassignIds.split(",")) {
					unassignList.add(Long.valueOf(idStr.trim()));
				}

				dataExpType = dataExpType.trim().toUpperCase();
				if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Software
																						// Lpar
																						// Data
																						// Exception
																						// Type
					dataExpSoftwareLparService.unassign(unassignList, request.getRemoteUser(), comments);
				} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Hardware
																								// Lpar
																								// Data
																								// Exception
																								// Type
					dataExpHardwareLparService.unassign(unassignList, request.getRemoteUser(), comments);
				}  else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Installed Software Data Exception 
					
					dataExpInstalledSwService.unassign(unassignList, request.getRemoteUser(), comments);
                } else {
					return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
				}

				return WSMsg.successMessage("Unassign success");
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Unassign failed");
			}
		}
	}

	@POST
	@Path("/{dataExpType}/assignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg assignAllDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("accountId") Long accountId,
			@FormParam("comments") String comments, @Context HttpServletRequest request) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == accountId) {
			return WSMsg.failMessage("Account ID is required");
		} else if (null == comments || "".equals(comments.trim())) {
			return WSMsg.failMessage("Comment is required");
		} else {
			try {
				Account account = accountService.getAccount(accountId);
				if (null == account) {
					return WSMsg.failMessage("Account doesn't exist");
				} else {
					Long customerId = account.getId();
					dataExpType = dataExpType.trim().toUpperCase();
					if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Software
																							// Lpar
																							// Data
																							// Exception
																							// Type
						dataExpSoftwareLparService.assignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Hardware
																									// Lpar
																									// Data
																									// Exception
																									// Type
						dataExpHardwareLparService.assignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					} else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Installed Software Data Exception 
						
						dataExpInstalledSwService.assignAll(customerId, dataExpType, request.getRemoteUser(), comments);
	                } else {
						return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
					}

					return WSMsg.successMessage("Assign success");
				}
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Assign failed");
			}
		}
	}

	@POST
	@Path("/{dataExpType}/unassignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg unassignAllDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("accountId") Long accountId,
			@FormParam("comments") String comments, @Context HttpServletRequest request) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == accountId) {
			return WSMsg.failMessage("Account ID is required");
		} else if (null == comments || "".equals(comments.trim())) {
			return WSMsg.failMessage("Comment is required");
		} else {
			try {
				Account account = accountService.getAccount(accountId);
				if (null == account) {
					return WSMsg.failMessage("Account doesn't exist");
				} else {
					Long customerId = account.getId();
					dataExpType = dataExpType.trim().toUpperCase();
					if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Software
																							// Lpar
																							// Data
																							// Exception
																							// Type
						dataExpSoftwareLparService.unassignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Hardware
																									// Lpar
																									// Data
																									// Exception
																									// Type
						dataExpHardwareLparService.unassignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					}  else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Installed Software Data Exception 
						
						dataExpInstalledSwService.unassignAll(customerId, dataExpType, request.getRemoteUser(), comments);
	                } else {
						return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
					}

					return WSMsg.successMessage("Unassign success");
				}
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Unassign failed");
			}
		}
	}

	@GET
	@Path("/{dataExpType}/history/{exceptionId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getDataException(@PathParam("dataExpType") String dataExpType, @PathParam("exceptionId") Long exceptionId) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == exceptionId) {
			return WSMsg.failMessage("Exception ID is required");
		} else {
			List<DataExceptionHistory> dataExpHistoryList = alertHistoryDao.getByAlertId(exceptionId);
			List<DataExceptionHistoryView> dataExpHistoryTransformList = this.dataExpHistoryTransformer(dataExpHistoryList);
			return WSMsg.successMessage("SUCCESS", dataExpHistoryTransformList);
		}
	}

	private List<DataExceptionHistoryView> dataExpHistoryTransformer(List<DataExceptionHistory> dataExpHistoryList) {
		List<DataExceptionHistoryView> dataExpHistoryTransformList = new ArrayList<DataExceptionHistoryView>();
		for (DataExceptionHistory dataExpHistory : dataExpHistoryList) {
			DataExceptionHistoryView dataExpHistoryView = new DataExceptionHistoryView();
			dataExpHistoryView.setCustomerId(dataExpHistory.getAccount().getId());
			dataExpHistoryView.setAccountNumber(dataExpHistory.getAccount().getAccountAsLong());
			dataExpHistoryView.setDataExpHistoryId(dataExpHistory.getId());
			dataExpHistoryView.setDataExpId(dataExpHistory.getAlert().getId());
			dataExpHistoryView.setDataExpTypeId(dataExpHistory.getAlertType().getId());
			dataExpHistoryView.setDataExpTypeName(dataExpHistory.getAlertType().getName());
			dataExpHistoryView.setCreationTime(dataExpHistory.getCreationTime());
			dataExpHistoryView.setRecordTime(dataExpHistory.getRecordTime());
			dataExpHistoryView.setRemoteUser(dataExpHistory.getRemoteUser());
			if (dataExpHistory.getAssignee() != null) {
				dataExpHistoryView.setAssignee(dataExpHistory.getAssignee());
			} else {
				dataExpHistoryView.setAssignee("");
			}
			dataExpHistoryView.setComment(dataExpHistory.getComment());
			dataExpHistoryTransformList.add(dataExpHistoryView);
		}

		return dataExpHistoryTransformList;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private List swLparDataExpsTransformer(List<DataExceptionSoftwareLpar> swLparDataExpsList) {

		List swLparDataExpsTransformList = new ArrayList();
		for (DataExceptionSoftwareLpar swLparDataExp : swLparDataExpsList) {
			DataExceptionSoftwareLparView swLparDataExpView = new DataExceptionSoftwareLparView();
			swLparDataExpView.setDataExpId(swLparDataExp.getId());
			swLparDataExpView.setDataExpType(swLparDataExp.getAlertType().getCode());
			swLparDataExpView.setDataExpCreationTime(swLparDataExp.getCreationTime());
			if (swLparDataExp.getAssignee() != null) {
				swLparDataExpView.setDataExpAssignee(swLparDataExp.getAssignee());
			} else {
				swLparDataExpView.setDataExpAssignee("");
			}

			swLparDataExpView.setSwLparId(swLparDataExp.getSoftwareLpar().getId());

			if (swLparDataExp.getSoftwareLpar().getName() != null) {
				swLparDataExpView.setSwLparName(swLparDataExp.getSoftwareLpar().getName());
			} else {
				swLparDataExpView.setSwLparName("");
			}

			if (swLparDataExp.getSoftwareLpar().getOsName() != null) {
				swLparDataExpView.setSwLparOSName(swLparDataExp.getSoftwareLpar().getOsName());
			} else {
				swLparDataExpView.setSwLparOSName("");
			}

			swLparDataExpView.setSwLparScanTime(swLparDataExp.getSoftwareLpar().getScanTime());

			if (swLparDataExp.getSoftwareLpar().getSerial() != null) {
				swLparDataExpView.setSwLparSerial(swLparDataExp.getSoftwareLpar().getSerial());
			} else {
				swLparDataExpView.setSwLparSerial("");
			}

			swLparDataExpView.setSwLparAccountNumber(swLparDataExp.getSoftwareLpar().getAccount().getAccountAsLong());
			swLparDataExpsTransformList.add(swLparDataExpView);
		}
		return swLparDataExpsTransformList;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private List hwLparDataExpsTransformer(List<DataExceptionHardwareLpar> hwLparDataExpsList) {
		List hwLparDataExpsTransformList = new ArrayList();

		for (DataExceptionHardwareLpar hwLparDataExp : hwLparDataExpsList) {

			DataExceptionHardwareLparView hwLparDataExpView = new DataExceptionHardwareLparView();

			hwLparDataExpView.setDataExpId(hwLparDataExp.getId());
			hwLparDataExpView.setDataExpType(hwLparDataExp.getAlertType().getCode());
			hwLparDataExpView.setDataExpCreationTime(hwLparDataExp.getCreationTime());

			if (hwLparDataExp.getAssignee() != null) {
				hwLparDataExpView.setDataExpAssignee(hwLparDataExp.getAssignee());
			} else {
				hwLparDataExpView.setDataExpAssignee("");
			}

			hwLparDataExpView.setHwLparId(hwLparDataExp.getHardwareLpar().getId());

			if (hwLparDataExp.getHardwareLpar().getName() != null) {
				hwLparDataExpView.setHwLparName(hwLparDataExp.getHardwareLpar().getName());
			} else {
				hwLparDataExpView.setHwLparName("");
			}

			if (hwLparDataExp.getHardwareLpar().getHardware().getSerial() != null) {
				hwLparDataExpView.setHwSerial(hwLparDataExp.getHardwareLpar().getHardware().getSerial());
			} else {
				hwLparDataExpView.setHwSerial("");
			}

			if (hwLparDataExp.getHardwareLpar().getExtId() != null) {
				hwLparDataExpView.setHwLparExtId(hwLparDataExp.getHardwareLpar().getExtId());
			} else {
				hwLparDataExpView.setHwLparExtId("");
			}

			if (hwLparDataExp.getHardwareLpar().getHardware().getChips() != null) {
				hwLparDataExpView.setHwChips(String.valueOf(hwLparDataExp.getHardwareLpar().getHardware().getChips()));
			} else {
				hwLparDataExpView.setHwChips("");
			}
			if (hwLparDataExp.getHardwareLpar().getHardware().getProcessorCount() != null) {
				hwLparDataExpView.setHwProcessors(String.valueOf(hwLparDataExp.getHardwareLpar().getHardware().getProcessorCount()));
			} else {
				hwLparDataExpView.setHwProcessors("");
			}
			hwLparDataExpView.setHwLparAccountNumber(hwLparDataExp.getHardwareLpar().getAccount().getAccountAsLong());
			hwLparDataExpsTransformList.add(hwLparDataExpView);
		}
		return hwLparDataExpsTransformList;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private List installedSwDataExpsTransformer(List<DataExceptionInstalledSw> installedSwDataExpsList) {
		List installedSwDataExpsTransformList = new ArrayList();

		for (DataExceptionInstalledSw installedSwDataException : installedSwDataExpsList) {

			DataExceptionInstalledSwView installedSwDataExpView = new DataExceptionInstalledSwView();

			installedSwDataExpView.setDataExpId(installedSwDataException.getId());
			installedSwDataExpView.setDataExpType(installedSwDataException.getAlertType().getCode());

			if (installedSwDataException.getAssignee() != null) {
				installedSwDataExpView.setDataExpAssignee(installedSwDataException.getAssignee());
			} else {
				installedSwDataExpView.setDataExpAssignee("");
			}

			installedSwDataExpView.setDataExpCreationTime(installedSwDataException.getCreationTime());

			if (installedSwDataException.getInstalledSw().getSoftwareLpar().getName() != null) {
				installedSwDataExpView.setSwLparName(installedSwDataException.getInstalledSw().getSoftwareLpar().getName());
			} else {
				installedSwDataExpView.setSwLparName("");
			}

			installedSwDataExpView.setDiscrepancyRecordTime(installedSwDataException.getInstalledSw().getRecordTime());

			if (installedSwDataException.getInstalledSw().getSoftware().getSoftwareName() != null) {
				installedSwDataExpView.setSwComponentName(installedSwDataException.getInstalledSw().getSoftware().getSoftwareName());
			} else {
				installedSwDataExpView.setSwComponentName("");
			}
			if (installedSwDataException.getInstalledSw().getId() != null) {
				installedSwDataExpView.setInstalledSwId(installedSwDataException.getInstalledSw().getId());
			} else {
				installedSwDataExpView.setInstalledSwId(null);
			}
			installedSwDataExpsTransformList.add(installedSwDataExpView);
		}
		return installedSwDataExpsTransformList;
	}
}
