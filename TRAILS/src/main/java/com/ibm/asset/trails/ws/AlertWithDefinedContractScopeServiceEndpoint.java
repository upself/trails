package com.ibm.asset.trails.ws;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.AlertService;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/alertWithDefinedContractScope")
public class AlertWithDefinedContractScopeServiceEndpoint {
	@Autowired
	private @Qualifier("alertWithDefinedContractScopeService") AlertService alertService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private ReportService reportService;

	@POST
	@Path("/search")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAlertWithDefinedContractScopeList(
			@FormParam("accountId") Long accountId,
			@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort, @FormParam("dir") String dir) {

		if (null == accountId) {
			return WSMsg.failMessage("Account ID is required");
		} else {
			Account account = accountService.getAccount(accountId);
			if (null == account) {
				return WSMsg.failMessage("Account doesn't exist");
			} else {
				int startIndex = 99999;
				try {
					startIndex = (currentPage - 1) * pageSize;
				} catch (Exception e) {
					e.printStackTrace();
				}

				Long total = alertService.total(account);

				List<?> list = alertService.paginatedList(account, startIndex,
						pageSize, sort, dir);

				Pagination page = new Pagination();
				page.setPageSize(pageSize.longValue());
				page.setTotal(total);
				page.setCurrentPage(currentPage.longValue());
				page.setList(list);
				return WSMsg.successMessage("SUCCESS", page);
			}
		}
	}


	@GET
	@Path("/download/{accountId}")
	public Response download(@PathParam("accountId") Long accountId,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws IOException {

		try {

			HSSFWorkbook hwb = new HSSFWorkbook();
			Account account = accountService.getAccount(accountId);

			response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-Disposition",
					"attachment; filename=alertContractScope" + account.getAccount() + ".xls");
			reportService.getAlertUnlicensed(account,
					request.getRemoteUser(), null, hwb,
					response.getOutputStream(),"SWISCOPE","SWISCOPE","SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE");

		} catch (Exception e) {
			e.printStackTrace();
		}

		ResponseBuilder responseBuilder = Response.ok(response
				.getOutputStream());
		return responseBuilder.build();
	}
}