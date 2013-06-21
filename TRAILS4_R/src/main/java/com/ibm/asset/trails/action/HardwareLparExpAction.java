package com.ibm.asset.trails.action;

import com.ibm.asset.trails.domain.DataExceptionType;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.ibm.tap.trails.framework.DisplayTagList;
import com.opensymphony.xwork2.Action;

public class HardwareLparExpAction extends AccountBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private DataExceptionService alertHardwareLparService;
	private String alertTypeCode;
	public String getAlertTypeCode() {
		return alertTypeCode;
	}
	
	public void setAlertTypeCode(String alertTypeCode)
	{
		this.alertTypeCode = alertTypeCode;
		alertHardwareLparService.setAlertTypeCode(alertTypeCode);
	}
	
	public void setHardwareLparExpService(DataExceptionService alertHardwareLparService) {
		this.alertHardwareLparService = alertHardwareLparService;
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
			setSort("hardwareLpar.name");
		}

		data.setList(alertHardwareLparService.paginatedList(getAccount(),
				startIndex, data.getObjectsPerPage(), getSort(), getDir()));

		data.setFullListSize((int) alertHardwareLparService.getAlertListSize(
				getAccount(), getAlertType()));

	}

	private DataExceptionType getAlertType() {
		return alertHardwareLparService.getAlertType();
	}

	@Override
	public String input() {
		return Action.INPUT;
	}

}
