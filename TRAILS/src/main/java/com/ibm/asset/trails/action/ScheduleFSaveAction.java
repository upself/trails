package com.ibm.asset.trails.action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.validation.SkipValidation;

import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.form.ScheduleFForm;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.ActionSupport;

@Controller
@ParentPackage("trails-struts-default")
@Namespace("/admin/scheduleF")
@Results({
		@Result(name = ActionSupport.INPUT, location = "tiles.admin.scheduleF.manage", type = "tiles"),
		@Result(name = ActionSupport.ERROR, location = "tiles.home", type = "tiles"),
		@Result(name = ActionSupport.SUCCESS, location = "list", type = "redirectAction") })
public class ScheduleFSaveAction extends AccountBaseAction {
	private static final long serialVersionUID = 1L;

	private ScheduleFForm scheduleFForm;

	private Long scheduleFId;

	@SkipValidation
	@UserRole(userRole = UserRoleType.READER)
	@Action("manage")
	public String manage() {
		return INPUT;
	}

	@SkipValidation
	@Override
	public void prepare() {
		super.prepare();

		if (getScheduleFForm() == null) {
			ScheduleFForm lsffManage = new ScheduleFForm();
			lsffManage.setScheduleFId(getScheduleFId());
			setScheduleFForm(lsffManage);
		}

	}

	public ScheduleFForm getScheduleFForm() {
		return scheduleFForm;
	}

	public void setScheduleFForm(ScheduleFForm scheduleFForm) {
		this.scheduleFForm = scheduleFForm;
	}

	public Long getScheduleFId() {
		return scheduleFId;
	}

	public void setScheduleFId(Long scheduleFId) {
		this.scheduleFId = scheduleFId;
	}

}
