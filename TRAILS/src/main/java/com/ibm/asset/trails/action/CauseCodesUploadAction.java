package com.ibm.asset.trails.action;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.validation.SkipValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.service.CauseCodeService;
import com.opensymphony.xwork2.ActionSupport;

@Controller
@ParentPackage("trails-struts-default")
@Namespace("/account/causecodes")
@Results({
		@Result(name = ActionSupport.SUCCESS, type = "stream", params = {
				"contentType", "application/vnd.ms-excel",
				"contentDisposition", "attachment;filename=results.xls",
				"bufferSize", "1024" }),
		@Result(name = ActionSupport.INPUT, location = "tiles.account.causecodes.upload", type = "tiles") })
public class CauseCodesUploadAction extends FileUploadAction implements
		ServletRequestAware {

	private static final long serialVersionUID = 8762282414570070793L;

	@Autowired
	private CauseCodeService causeCodeService;
	private HttpServletRequest request;

	@Override
	@Action("upload")
	public String execute() throws Exception {
		return SUCCESS;
	}

	@Action("home")
	@SkipValidation
	public String home() {
		return INPUT;
	}

	public InputStream getInputStream() throws IOException {
		return new ByteArrayInputStream(getCauseCodeService().loadSpreadsheet(
				getUpload(), request.getRemoteUser()).toByteArray());
	}

	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}

	public HttpServletRequest getRequest() {
		return this.request;
	}

	public CauseCodeService getCauseCodeService() {
		return causeCodeService;
	}

	public void setCauseCodeService(CauseCodeService causeCodeService) {
		this.causeCodeService = causeCodeService;
	}

}
