package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

import org.apache.struts2.interceptor.validation.SkipValidation;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.DataExceptionCause;
import com.ibm.asset.trails.domain.DataExceptionType;
import com.ibm.asset.trails.form.DataExceptionTypeCauseMappingForm;
import com.ibm.asset.trails.service.DataExceptionCauseService;
import com.ibm.asset.trails.service.DataExceptionTypeService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.Preparable;

public class DataExceptionTypeCauseMappingAction extends BaseActionWithSession
		implements Preparable {
	private static final long serialVersionUID = -2746874419315812071L;
	private final String SAVE_MESSAGE_SESSION_KEY = "alertTypeCauseMappingMessage";
	private DataExceptionCauseService alertCauseService;
	private DataExceptionTypeCauseMappingForm alertTypeCauseMappingForm;
	private Long alertTypeId;
	private List<DataExceptionType> alertTypeList;
	
	@Autowired
	private DataExceptionTypeService alertTypeService;

	public void prepare() throws Exception {
		// Retrieve the save message string from session
		if (getSession().containsKey(SAVE_MESSAGE_SESSION_KEY)) {
			addActionMessage((String) getSession().get(SAVE_MESSAGE_SESSION_KEY));
			getSession().remove(SAVE_MESSAGE_SESSION_KEY);
		}
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String cancel() {
		return Action.SUCCESS;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String listAlertType() {
		setAlertTypeList(alertTypeService.list());

		return Action.SUCCESS;
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.ADMIN)
	public String map() {
		DataExceptionType latMap = alertTypeService.findWithAlertCauses(
				getAlertTypeId());
		List<Long> llMappedAlertCauseId = new ArrayList<Long>();

		setAlertTypeCauseMappingForm(new DataExceptionTypeCauseMappingForm());
		getAlertTypeCauseMappingForm().setAlertTypeName(latMap.getName());
		getAlertTypeCauseMappingForm().setMappedAlertCauseList(
				new ArrayList<DataExceptionCause>(latMap.getAlertCauseSet()));
		for (DataExceptionCause lacMap : getAlertTypeCauseMappingForm().getMappedAlertCauseList()) {
			llMappedAlertCauseId.add(lacMap.getId());
		}
		getAlertTypeCauseMappingForm()
				.setAvailableAlertCauseList(
						getAlertCauseService().getAvailableAlertCauseList(
								llMappedAlertCauseId));

		return Action.SUCCESS;
	}

	@UserRole(userRole = UserRoleType.ADMIN)
	public String save() {
		DataExceptionType latSave = alertTypeService.findById(getAlertTypeId());

		if (getAlertTypeCauseMappingForm() != null
				&& getAlertTypeCauseMappingForm().getMappedAlertCauseIdArray() != null) {
			latSave.setAlertCauseSet(new HashSet<DataExceptionCause>(getAlertCauseService()
					.getAlertCauseListByIdList(
							Arrays.asList(getAlertTypeCauseMappingForm()
									.getMappedAlertCauseIdArray()))));
		} else {
			latSave.setAlertCauseSet(new HashSet<DataExceptionCause>());
		}
		alertTypeService.update(latSave);
		getSession().put(SAVE_MESSAGE_SESSION_KEY,
				"The alert type/cause code mapping was saved successfully.");

		return Action.SUCCESS;
	}

	public DataExceptionCauseService getAlertCauseService() {
		return alertCauseService;
	}

	public void setAlertCauseService(DataExceptionCauseService alertCauseService) {
		this.alertCauseService = alertCauseService;
	}

	public DataExceptionTypeCauseMappingForm getAlertTypeCauseMappingForm() {
		return alertTypeCauseMappingForm;
	}

	public void setAlertTypeCauseMappingForm(
			DataExceptionTypeCauseMappingForm alertTypeCauseMappingForm) {
		this.alertTypeCauseMappingForm = alertTypeCauseMappingForm;
	}

	public Long getAlertTypeId() {
		return alertTypeId;
	}

	public void setAlertTypeId(Long alertTypeId) {
		this.alertTypeId = alertTypeId;
	}

	public List<DataExceptionType> getAlertTypeList() {
		return alertTypeList;
	}

	public void setAlertTypeList(List<DataExceptionType> alertTypeList) {
		this.alertTypeList = alertTypeList;
	}
}
