package com.ibm.asset.trails.action;

import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.ibm.tap.trails.framework.DisplayTagList;
import com.opensymphony.xwork2.Action;

public class SoftwareLparExpAction extends AccountBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private DataExceptionService alertSoftwareLparService;
	private String alertTypeCode;
	public String getAlertTypeCode() {
		return alertTypeCode;
	}
	
	public void setAlertTypeCode(String alertTypeCode)
	{
		this.alertTypeCode = alertTypeCode;
		alertSoftwareLparService.setAlertTypeCode(alertTypeCode);
	}
	
	public void setSoftwareLparExpService(DataExceptionService alertSoftwareLparService) {
		this.alertSoftwareLparService = alertSoftwareLparService;
	}

	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {
		super.prepare();

		DisplayTagList data = getData();
		int pageNumber = data.getPageNumber();

		// set the index zero start.
		pageNumber = pageNumber < 0 ? 0 : --pageNumber;
		int startIndex = pageNumber * data.getObjectsPerPage();

		if (getSort() == null) {
			setSort("softwareLpar.name");
		}

		data.setList(alertSoftwareLparService.paginatedList(getAccount(),
				startIndex, data.getObjectsPerPage(), getSort(), getDir()));

		data.setFullListSize((int) alertSoftwareLparService.getAlertListSize(
				getAccount(), getAlertType()));

	}

	private AlertType getAlertType() {
		return alertSoftwareLparService.getAlertType();
	}

	@Override
	public String input() {
		return Action.INPUT;
	}

}
