package com.ibm.asset.trails.action;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class AccountDataExceptionAction extends AccountBaseAction {
	private static final long serialVersionUID = 1L;

	@UserRole(userRole = UserRoleType.READER)
	public String doOverview() throws Exception {
		return Action.SUCCESS;
	}
}
