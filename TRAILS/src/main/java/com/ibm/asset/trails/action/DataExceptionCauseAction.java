package com.ibm.asset.trails.action;

import java.util.List;

import org.apache.struts2.interceptor.validation.SkipValidation;

import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.form.DataExceptionCauseForm;
import com.ibm.asset.trails.service.DataExceptionCauseService;
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
	private Long alertCauseId;
	private DataExceptionCauseService alertCauseService;
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
		setAlertCauseList(alertCauseService.list());

		return Action.SUCCESS;
	}

	@Validations(visitorFields = { @VisitorFieldValidator(fieldName = "alertCauseForm", appendPrefix = false) })
	@UserRole(userRole = UserRoleType.ADMIN)
	public String save() throws ValidationException {
		try {
			getSession().put(
					SAVE_MESSAGE_SESSION_KEY,
					alertCauseService.save(getAlertCauseId(),
							getAlertCauseForm().getAlertCauseName()));
		} catch (ValidationException ve) {
			addActionError(ve.getMessage());

			return Action.INPUT;
		}

		return Action.SUCCESS;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String update() {
		setAlertCauseForm(new DataExceptionCauseForm());
		getAlertCauseForm().setAlertCauseName(
				alertCauseService.find(getAlertCauseId()).getName());

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
}
