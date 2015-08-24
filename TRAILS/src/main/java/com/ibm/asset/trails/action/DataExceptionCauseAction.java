package com.ibm.asset.trails.action;

import java.util.List;

import org.apache.struts2.interceptor.validation.SkipValidation;

import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.AlertTypeCause;
import com.ibm.asset.trails.form.DataExceptionCauseForm;
import com.ibm.asset.trails.service.AlertCauseResponsibilityService;
import com.ibm.asset.trails.service.AlertTypeCauseService;
import com.ibm.asset.trails.service.DataExceptionCauseService;
import com.ibm.asset.trails.service.DataExceptionTypeService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.Preparable;
import com.opensymphony.xwork2.validator.ValidationException;
import com.opensymphony.xwork2.validator.annotations.Validations;
import com.opensymphony.xwork2.validator.annotations.VisitorFieldValidator;

public class DataExceptionCauseAction extends BaseActionWithSession implements
		Preparable {
	private static final long serialVersionUID = 1L;
	private final String SAVE_MESSAGE_SESSION_KEY = "alertCauseSaveMessage";
	private List<AlertCause> alertCauseList;
	private List<AlertTypeCause> alertTypeCausesList;
	private Long alertCauseId;
	private Long alertTypeId;
	private DataExceptionCauseService alertCauseService;
	private DataExceptionTypeService alertTypeService;
	private AlertCauseResponsibilityService alertCauseResponsibilityService;
	private AlertTypeCauseService alertTypeCauseService;
	private DataExceptionCauseForm alertCauseForm;

	public void prepare() throws Exception {
		// Retrieve the save message string from session
		if (getSession().containsKey(SAVE_MESSAGE_SESSION_KEY)) {
			addActionMessage((String) getSession()
					.get(SAVE_MESSAGE_SESSION_KEY));
			getSession().remove(SAVE_MESSAGE_SESSION_KEY);
		}
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String add() {
		return Action.SUCCESS;
	}

	private void initAddPageParameters() {
		setAlertCauseForm(new DataExceptionCauseForm());
		getAlertCauseForm().setAlertCauseResponsibilities(
				alertCauseResponsibilityService.list());
		getAlertCauseForm().setAlertTypes(alertTypeService.list());
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String save() {
		Long responsibilityId = getAlertCauseForm()
				.getAlertCauseResponsibilityId();
		Long alertTypeId = getAlertCauseForm().getAlertTypeId();
		String alertCauseName = getAlertCauseForm().getAlertCauseName().trim();
		String alertTypeCauseStatus = getAlertCauseForm().getState();

		if (null == alertCauseName || "".equals(alertCauseName)) {
			addActionError("Name is required");
			initAddPageParameters();
			return Action.INPUT;
		}

		AlertCause alertCause = alertCauseService.findByName(alertCauseName);
		AlertCauseResponsibility alertCauseResponsibility = alertCauseResponsibilityService
				.findById(responsibilityId);
		if (alertCause == null
				|| !alertCause.getAlertCauseResponsibility().equals(
						alertCauseResponsibility)) {
			alertCause = new AlertCause();
			alertCause.setName(alertCauseName);
			alertCause.setShowInGui(true);
			alertCause.setAlertCauseResponsibility(alertCauseResponsibility);
			alertCauseService.save(alertCause);

			AlertTypeCause alertTypeCause = new AlertTypeCause();
			alertTypeCause.setStatus(alertTypeCauseStatus);
			alertTypeCause.getPk().setAlertCause(alertCause);
			AlertType alertType = alertTypeService.findById(alertTypeId);
			alertTypeCause.getPk().setAlertType(alertType);
			alertTypeCauseService.add(alertTypeCause);
			return Action.SUCCESS;
		}

		AlertTypeCause exists = alertTypeCauseService.getByTypeCauseId(
				alertTypeId, alertCause.getId());
		if (exists == null) {
			AlertTypeCause alertTypeCause = new AlertTypeCause();
			alertTypeCause.setStatus(alertTypeCauseStatus);
			alertTypeCause.getPk().setAlertCause(alertCause);
			AlertType alertType = alertTypeService.findById(alertTypeId);
			alertTypeCause.getPk().setAlertType(alertType);
			alertTypeCauseService.add(alertTypeCause);

			return Action.SUCCESS;
		}

		addActionError("Cause code already exists");
		initAddPageParameters();
		return Action.INPUT;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String cancel() {
		return Action.SUCCESS;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String list() {
    	return Action.SUCCESS;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String update() throws ValidationException {

		String alertCauseName = alertCauseForm.getAlertCauseName().trim();
		if (alertCauseName == null || "".equals(alertCauseName)) {
			addActionError("Name is requried");
			initEditPageParam();
			return Action.INPUT;
		}

		AlertCause alertCause = alertCauseService.find(getAlertCauseId());
		AlertCauseResponsibility alertCauseResponsibility = alertCauseResponsibilityService
				.findById(alertCauseForm.getAlertCauseResponsibilityId());

		boolean changed = false;
		if (!alertCause.getName().equalsIgnoreCase(alertCauseName)
				|| !alertCause.getAlertCauseResponsibility().equals(
						alertCauseResponsibility)) {

			AlertCause exists = alertCauseService.findByNameResposibility(
					alertCauseName, alertCauseResponsibility);

			if (exists == null) {
				alertCause.setName(alertCauseName);
				alertCause
						.setAlertCauseResponsibility(alertCauseResponsibility);
				alertCauseService.update(alertCause);
				changed = true;
			} else {
				addActionError("Cause code name and responsibily pair already exists");
				initEditPageParam();
				return Action.INPUT;
			}
		}

		AlertTypeCause alertTypeCause = alertTypeCauseService.getByTypeCauseId(
				getAlertTypeId(), getAlertCauseId());

		if (!alertTypeCause.getStatus().equals(alertCauseForm.getState())) {
			alertTypeCause.setStatus(alertCauseForm.getState());
			alertTypeCauseService.update(alertTypeCause);
			changed = true;
		}

		if (changed) {
			return Action.SUCCESS;
		}

		addActionError("Nothing changed");
		initEditPageParam();
		return Action.INPUT;

	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String edit() {
		initEditPageParam();
		return Action.SUCCESS;
	}

	private void initEditPageParam() {
		setAlertCauseForm(new DataExceptionCauseForm());

		getAlertCauseForm().setAlertCauseResponsibilities(
				alertCauseResponsibilityService.list());
		getAlertCauseForm().setAlertCauseName(
				alertCauseService.find(getAlertCauseId()).getName());
		getAlertCauseForm().setAlertTypes(alertTypeService.list());

		AlertTypeCause alertTypeCause = alertTypeCauseService.getByTypeCauseId(
				this.alertTypeId, this.alertCauseId);
		getAlertCauseForm().setAlertTypeCause(alertTypeCause);

		getAlertCauseForm().init();
	}

	public DataExceptionCauseForm getAlertCauseForm() {
		return alertCauseForm;
	}

	public void setAlertCauseForm(DataExceptionCauseForm alertCauseForm) {
		this.alertCauseForm = alertCauseForm;
	}

	public Long getAlertCauseId() {
		return alertCauseId;
	}

	public void setAlertCauseId(Long alertCauseId) {
		this.alertCauseId = alertCauseId;
	}

	public Long getAlertTypeId() {
		return alertTypeId;
	}

	public void setAlertTypeId(Long alertTypeId) {
		this.alertTypeId = alertTypeId;
	}

	public List<AlertCause> getAlertCauseList() {
		return alertCauseList;
	}

	public void setAlertCauseList(List<AlertCause> alertCauseList) {
		this.alertCauseList = alertCauseList;
	}

	public DataExceptionCauseService getAlertCauseService() {
		return alertCauseService;
	}

	public void setAlertCauseService(DataExceptionCauseService alertCauseService) {
		this.alertCauseService = alertCauseService;
	}

	public List<AlertTypeCause> getAlertTypeCausesList() {
		return alertTypeCausesList;
	}

	public void setAlertTypeCausesList(List<AlertTypeCause> alertTypeCausesList) {
		this.alertTypeCausesList = alertTypeCausesList;
	}

	public DataExceptionTypeService getAlertTypeService() {
		return alertTypeService;
	}

	public void setAlertTypeService(DataExceptionTypeService alertTypeService) {
		this.alertTypeService = alertTypeService;
	}

	public AlertCauseResponsibilityService getAlertCauseResponsibilityService() {
		return alertCauseResponsibilityService;
	}

	public void setAlertCauseResponsibilityService(
			AlertCauseResponsibilityService alertCauseResponsibilityService) {
		this.alertCauseResponsibilityService = alertCauseResponsibilityService;
	}

	public AlertTypeCauseService getAlertTypeCauseService() {
		return alertTypeCauseService;
	}

	public void setAlertTypeCauseService(
			AlertTypeCauseService alertTypeCauseService) {
		this.alertTypeCauseService = alertTypeCauseService;
	}

}
