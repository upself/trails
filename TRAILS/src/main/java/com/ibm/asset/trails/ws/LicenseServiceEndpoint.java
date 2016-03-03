package com.ibm.asset.trails.ws;

import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.ws.common.WSMsg;

public class LicenseServiceEndpoint {

	@Autowired
	private LicenseService licenseService;

	@POST
	@Path("/license/all/")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllLicenseByAccount(@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize, @FormParam("sort") String sort, @FormParam("dir") String dir,
			@FormParam("accountId") Long accountId) {

		return null;
	}

	public LicenseService getLicenseService() {
		return licenseService;
	}

	public void setLicenseService(LicenseService licenseService) {
		this.licenseService = licenseService;
	}
}
