package com.ibm.asset.trails.action;

import com.ibm.asset.trails.service.impl.AlertExpiredMaintServiceImpl;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class AlertExpiredMaintAction extends AlertAssignment {
	private static final long serialVersionUID = 1L;

	private AlertExpiredMaintServiceImpl alertExpiredMaintServiceImpl;

	@SuppressWarnings("unchecked")
	@UserRole(userRole = UserRoleType.READER)
	public String accept() {
		getAlertExpiredMaintServiceImpl().accept(getList(),
				getUserSession().getRemoteUser(), getComments());

		return SUCCESS;
	}

	public AlertExpiredMaintServiceImpl getAlertExpiredMaintServiceImpl() {
		return alertExpiredMaintServiceImpl;
	}

	public void setAlertExpiredMaintServiceImpl(
			AlertExpiredMaintServiceImpl alertExpiredMaintServiceImpl) {
		this.alertExpiredMaintServiceImpl = alertExpiredMaintServiceImpl;
	}
}
