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

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String cancel() {
		return Action.SUCCESS;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String list() {
		setAlertTypeCausesList(alertCauseService.listWithTypeJoin());

		return Action.SUCCESS;
	}

	@Validations(visitorFields = { @VisitorFieldValidator(fieldName = "alertCauseForm", appendPrefix = false) })
	@UserRole(userRole = UserRoleType.ADMIN)
	public String save() throws ValidationException {

		StringBuffer resultMsg = new StringBuffer();

		// Find the changes on alert_cause side.
		AlertCauseResponsibility alertCauseResponsibility = alertCauseResponsibilityService
				.findById(alertCauseForm.getAlertCauseResponsibilityId());

		String alertCauseName = alertCauseForm.getAlertCauseName();
		AlertCause alertCause = alertCauseService.findByName(alertCauseName);
		if (alertCause == null) {
			alertCause = new AlertCause();
			alertCause.setName(alertCauseName);
			alertCause.setShowInGui(true);
			alertCause.setAlertCauseResponsibility(alertCauseResponsibility);
			alertCauseService.save(alertCause);

			resultMsg.append("New Cause code name created,");
		} else {
			long id = alertCause.getAlertCauseResponsibility().getId();
			if (id != alertCauseResponsibility.getId()) {
				alertCause
						.setAlertCauseResponsibility(alertCauseResponsibility);
				alertCauseService.update(alertCause);

				resultMsg.append("The Responsibility updated,");
			}
		}

		// Find the changes on mapping table. alert_type_cause.
		AlertType alertType = alertTypeService.findById(alertCauseForm
				.getAlertTypeId());

		AlertTypeCause alertTypeCause = alertTypeCauseService.getByTypeCauseId(
				alertType.getId(), alertCause.getId());
		String status = alertCauseForm.getState();

		if (alertTypeCause == null) {
			alertTypeCause = new AlertTypeCause();
			alertTypeCause.getPk().setAlertCause(alertCause);
			alertTypeCause.getPk().setAlertType(alertType);
			alertTypeCause.setStatus(status);

			alertTypeCauseService.add(alertTypeCause);

			resultMsg
					.append(" New alert type&cause mapping was added successfully.");
		} else {
			if (!status.equals(alertTypeCause.getStatus())) {
				alertTypeCause.setStatus(status);
				alertTypeCauseService.update(alertTypeCause);
			}
			resultMsg.append(" Status updated successfully.");
		}

		if (resultMsg.length() == 0) {
			resultMsg.append("No change found");
		}
		getSession().put(SAVE_MESSAGE_SESSION_KEY, resultMsg.toString());

		return Action.SUCCESS;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String update() {

		setAlertCauseForm(new DataExceptionCauseForm());

		getAlertCauseForm().setAlertCauseResponsibilities(
				alertCauseResponsibilityService.list());

		getAlertCauseForm().setAlertTypes(alertTypeService.list());

		getAlertCauseForm().setAlertCauseName(
				alertCauseService.find(getAlertCauseId()).getName());

		getAlertCauseForm().setAlertTypeCause(
				alertTypeCauseService.getByTypeCauseId(this.alertTypeId,
						this.alertCauseId));

		getAlertCauseForm().init();

		return Action.SUCCESS;
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
