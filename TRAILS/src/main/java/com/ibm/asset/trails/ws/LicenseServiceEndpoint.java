package com.ibm.asset.trails.ws;

import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.ws.common.WSMsg;

public class LicenseServiceEndpoint {

	@Autowired
	private LicenseService licenseService;

	@Autowired
	private AccountService accountService;

	@POST
	@Path("/license/all/")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllLicenseByAccount(
			@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort, @FormParam("dir") String dir,
			@FormParam("accountId") Long accountId) {

		return null;
	}

	@POST
	@Path("/license/{id}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getLicenseById(@PathParam("id") Long id,
			@FormParam("accountId") Long accountId) {
		License licenseResult = getLicenseService().getLicenseDetails(id);
		Account account = accountService.getAccount(accountId);
		if (licenseResult == null) {
			return WSMsg
					.failMessage("No License item found for id = " + id + "!");
		} else {
			if (licenseResult.getAccount().getId().longValue() != accountId
					.longValue()) {
				return WSMsg.failMessage(
						"Seems you are not loading the License item for current account !");
			}
			return WSMsg
					.successMessage("The License item found for id = " + id);
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
