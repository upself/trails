package com.ibm.asset.trails.action;

import java.util.List;
import java.util.Map;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.service.AccountDataExceptionService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.ActionSupport;

@Controller
@Namespace("/account/alert")
@Action("summary")
@Results({ @Result(name = ActionSupport.SUCCESS, location = "/WEB-INF/jsp/sidebar/alertCountSummary.jsp") })
public class AccountAlertSummaryAction extends AccountBaseAction {
	private static final long serialVersionUID = 5954033489173701145L;

	@Autowired
	private transient AccountDataExceptionService service;
	private transient List<Map<String, String>> alertSummary;
	private transient String type;

	@Override
	@UserRole(userRole = UserRoleType.READER)
	public String execute() {
		alertSummary = service.getAlertTypeSummary(getUserSession()
				.getAccount().getId(), type);
		return SUCCESS;
	}

	public List<Map<String, String>> getAlertSummary() {
		return alertSummary;
	}

	public void setType(final String type) {
		this.type = type;
	}
}
