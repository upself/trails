package com.ibm.asset.trails.action;

import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class AdminAction extends BaseAction {

	@UserRole(userRole = UserRoleType.READER)
	public String execute() {
		return SUCCESS;
	}
}
