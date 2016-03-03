package com.ibm.asset.trails.ws;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import javax.ws.rs.GET;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

public class LicenseServiceEndpoint {

	@Autowired
	private LicenseService licenseService;

	@GET
	@Path("/license/all")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllLicenseByAccount(@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize, @FormParam("sort") String sort, @FormParam("dir") String dir,
			@FormParam("accountId") Long accountId) {
		
		List<License> liclist = new ArrayList<License>();
//		List<ScheduleFView> schFViewList = new ArrayList<ScheduleFView>();
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
			liclist = getLicenseService().paginatedList(accountId,
					Integer.valueOf(startIndex), Integer.valueOf(pageSize),
					sort, dir);
			if(liclist!=null && !liclist.isEmpty()){
				total=Long.valueOf(liclist.size());
			}
		}

		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(liclist);
		return WSMsg.successMessage("SUCCESS", page);
	}

	public LicenseService getLicenseService() {
		return licenseService;
	}

	public void setLicenseService(LicenseService licenseService) {
		this.licenseService = licenseService;
	}
}
