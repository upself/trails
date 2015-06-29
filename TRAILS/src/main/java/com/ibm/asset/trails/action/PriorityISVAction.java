package com.ibm.asset.trails.action;

import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class PriorityISVAction extends AccountBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1366278014947818495L;
	
	private Long priorityISVSoftwareId;

	@UserRole(userRole = UserRoleType.READER)
	public String reader() throws Exception {
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.ADMIN)
	public String admin() throws Exception {
		return SUCCESS;
	}

	public Long getPriorityISVSoftwareId() {
		return priorityISVSoftwareId;
	}

	public void setPriorityISVSoftwareId(Long priorityISVSoftwareId) {
		this.priorityISVSoftwareId = priorityISVSoftwareId;
	}

}
