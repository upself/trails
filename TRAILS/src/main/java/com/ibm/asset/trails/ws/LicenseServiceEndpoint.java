package com.ibm.asset.trails.ws;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.LicenseBaselineDisplay;
import com.ibm.asset.trails.domain.LicenseDisplay;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/license")
public class LicenseServiceEndpoint {
	
	@Autowired
	private LicenseService licenseService;

	@Autowired
	private AccountService accountService;

	@GET
	@Path("/all/licenseBaseline")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllLicenseByAccount(
			@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort, @FormParam("dir") String dir,
			@FormParam("accountId") Long accountId) {

		List liclist = new ArrayList();
		List<LicenseBaselineDisplay> licDList = null;
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
			int startIndex = (currentPage - 1) * pageSize;
				liclist = getLicenseService().paginatedList(accountId, Integer.valueOf(startIndex), Integer.valueOf(pageSize), sort, dir);
				licDList = licTransformer(liclist);
				if (licDList != null && !licDList.isEmpty()) {
					total = Long.valueOf(getLicenseService().getLicBaselineSize(accountId));
				}	
		}

		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(licDList);
		return WSMsg.successMessage("SUCCESS", page);
	}
	
	@GET
	@Path("/all/licenseFreePool")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllLicenseFreePoolByAccount(@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize, @FormParam("sort") String sort, @FormParam("dir") String dir,
			@FormParam("accountId") Long accountId) {

		List liclist = new ArrayList();
		List<LicenseBaselineDisplay> licDList = null;
		Long total = Long.valueOf(0);
		Pagination page = new Pagination();
		
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
			int startIndex = (currentPage - 1) * pageSize;
				liclist = getLicenseService().freePoolWithParentPaginatedList(accountId, Integer.valueOf(startIndex), Integer.valueOf(pageSize), sort, dir,null);
				licDList = licDTransformer(liclist);
				if (licDList != null && !licDList.isEmpty()) {
					total = Long.valueOf(getLicenseService().getLicFreePoolSizeWithoutFilters(accountId));
				}	
		}

		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(licDList);
		return WSMsg.successMessage("SUCCESS", page);
	}
	
	private List<LicenseBaselineDisplay> licDTransformer(List<LicenseDisplay> licList){
		List<LicenseBaselineDisplay> licViewList = new ArrayList<LicenseBaselineDisplay>();
		if (licList != null && licList.size() > 0) {
			for(LicenseDisplay licD:licList){
				LicenseBaselineDisplay lisd = new LicenseBaselineDisplay();
				
				if (licD.getLicenseId() != null) {
					lisd.setLicenseId(licD.getLicenseId());
				} else {
					lisd.setLicenseId(Long.valueOf(0));
				}

				if (licD.getAvailableQty()!= null) {
					lisd.setAvailableQty(licD.getAvailableQty());
				} else {
					lisd.setAvailableQty(0);
				}
				
				if (licD.getFullDesc() != null) {
					lisd.setFullDesc(licD.getFullDesc());
				} else {
					lisd.setFullDesc("");
				}
				
				if (licD.getProductName() != null) {
					lisd.setProductName(licD.getProductName());
				} else {
					lisd.setProductName("");
				}
				
				if (licD.getCatalogMatch() != null) {
					if(licD.getCatalogMatch().equalsIgnoreCase("Yes")){
						lisd.setCatalogMatch("Y");
					}else{
						lisd.setCatalogMatch("N");
					}
				} else {
					lisd.setCatalogMatch("N");
				}
				
				if (licD.getExtSrcId() != null) {
					lisd.setExtSrcId(licD.getExtSrcId());
				} else {
					lisd.setExtSrcId("");
				}
				
				if (licD.getCpuSerial() != null) {
					lisd.setCpuSerial(licD.getCpuSerial());
				} else {
					lisd.setCpuSerial("");
				}
				
				if (licD.getCapTypeDesc() != null) {
					lisd.setCapTypeDesc(licD.getCapTypeDesc());
				} else {
					lisd.setCapTypeDesc("");
				}
				
				if (licD.getSwproPID() != null) {
					lisd.setSwproPID(licD.getSwproPID());
				} else {
					lisd.setSwproPID("");
				}

				if (licD.getCapTypeCode() != null) {
					lisd.setCapTypeCode(licD.getCapTypeCode());
				} else {
					lisd.setCapTypeCode(0);
				}
				
				if (licD.getQuantity() != null) {
					lisd.setQuantity(licD.getQuantity());
				} else {
					lisd.setQuantity(0);
				}
				
				if (licD.getExpireDate() != null) {
//					String expDate = licmap.get("expireDate").toString();
//					DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
//					format.setLenient(false);
//					Date date=null;
//					try {
//						date = format.parse(expDate);
//					} catch (ParseException e) {
//						e.printStackTrace();
//					}
					lisd.setExpireDate(licD.getExpireDate());
				} else {
					lisd.setExpireDate(null);
				}
				
				licViewList.add(lisd);				
			}
		}
		return licViewList;
	}
	
	private List<LicenseBaselineDisplay> licTransformer(List<Map<String, Object>> licList) {

		List<LicenseBaselineDisplay> licViewList = new ArrayList<LicenseBaselineDisplay>();
		if (licList != null && licList.size() > 0) {

			for (Map<String, Object> licmap : licList) {
				LicenseBaselineDisplay lisd = new LicenseBaselineDisplay();
				if (licmap.get("licenseId") != null) {
					lisd.setLicenseId(Long.valueOf(licmap.get("licenseId").toString()));
				} else {
					lisd.setLicenseId(Long.valueOf(0));
				}

				if (licmap.get("availableQty") != null) {
					lisd.setAvailableQty(Integer.valueOf(licmap.get("availableQty").toString()));
				} else {
					lisd.setAvailableQty(0);
				}
				
				if (licmap.get("fullDesc") != null) {
					lisd.setFullDesc(licmap.get("fullDesc").toString());
				} else {
					lisd.setFullDesc("");
				}
				
				if (licmap.get("productName") != null) {
					lisd.setProductName(licmap.get("productName").toString());
				} else {
					lisd.setProductName("");
				}
				
				if (licmap.get("catalogMatch") != null) {
					if(licmap.get("catalogMatch").toString().equalsIgnoreCase("Yes")){
						lisd.setCatalogMatch("Y");
					}else{
						lisd.setCatalogMatch("N");
					}
				} else {
					lisd.setCatalogMatch("");
				}
				
				if (licmap.get("extSrcId") != null) {
					lisd.setExtSrcId(licmap.get("extSrcId").toString());
				} else {
					lisd.setExtSrcId("");
				}
				
				if (licmap.get("cpuSerial") != null) {
					lisd.setCpuSerial(licmap.get("cpuSerial").toString());
				} else {
					lisd.setCpuSerial("");
				}
				
				if (licmap.get("capTypeDesc") != null) {
					lisd.setCapTypeDesc(licmap.get("capTypeDesc").toString());
				} else {
					lisd.setCapTypeDesc("");
				}
				
				if (licmap.get("swproPID") != null) {
					lisd.setSwproPID(licmap.get("swproPID").toString());
				} else {
					lisd.setSwproPID("");
				}

				if (licmap.get("capTypeCode") != null) {
					lisd.setCapTypeCode(Integer.valueOf(licmap.get("capTypeCode").toString()));
				} else {
					lisd.setCapTypeCode(0);
				}
				
				if (licmap.get("quantity") != null) {
					lisd.setQuantity(Integer.valueOf(licmap.get("quantity").toString()));
				} else {
					lisd.setQuantity(0);
				}
				
				if (licmap.get("expireDate") != null) {
					String expDate = licmap.get("expireDate").toString();
					DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
					format.setLenient(false);
					Date date=null;
					try {
						date = format.parse(expDate);
					} catch (ParseException e) {
						e.printStackTrace();
					}
					lisd.setExpireDate(date);
				} else {
					lisd.setExpireDate(null);
				}
				
				licViewList.add(lisd);
				lisd=null;
			}
			return licViewList;
		}
		return null;
	}

	@GET
	@Path("/detail/{id}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getLicenseById(@PathParam("id") Long id) {
		License licenseResult = getLicenseService().getLicenseDetails(id);		
		if (licenseResult == null) {
			return WSMsg
					.failMessage("No License item found for id = " + id + "!");
		} else {
			return WSMsg
					.successMessage("The License item found for id = " + id, licenseResult);
		}
	}

	public LicenseService getLicenseService() {
		return licenseService;
	}

	public void setLicenseService(LicenseService licenseService) {
		this.licenseService = licenseService;
	}

	public AccountService getAccountService() {
		return accountService;
	}

	public void setAccountService(AccountService accountService) {
		this.accountService = accountService;
	}
}
