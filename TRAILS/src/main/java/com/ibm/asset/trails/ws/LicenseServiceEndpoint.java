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
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.LicenseDisplay;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/license")
public class LicenseServiceEndpoint {

	@Autowired
	private LicenseService licenseService;

	@GET
	@Path("/all")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllLicenseByAccount(@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize, @FormParam("sort") String sort, @FormParam("dir") String dir,
			@FormParam("accountId") Long accountId) {

		List liclist = new ArrayList<License>();
		List<LicenseDisplay> licDList = null;
		// List<ScheduleFView> schFViewList = new ArrayList<ScheduleFView>();
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
			liclist = getLicenseService().paginatedList(accountId, Integer.valueOf(startIndex),
					Integer.valueOf(pageSize), sort, dir);
			
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

	private List<LicenseDisplay> licTransformer(List<Map<String, Object>> licList) {

		List<LicenseDisplay> licViewList = new ArrayList<LicenseDisplay>();
		if (licList != null && licList.size() > 0) {

			for (Map<String, Object> licmap : licList) {
				LicenseDisplay lisd = new LicenseDisplay();
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

	public LicenseService getLicenseService() {
		return licenseService;
	}

	public void setLicenseService(LicenseService licenseService) {
		this.licenseService = licenseService;
	}
}
