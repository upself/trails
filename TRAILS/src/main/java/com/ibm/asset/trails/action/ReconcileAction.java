package com.ibm.asset.trails.action;

import com.ibm.asset.trails.domain.Reconcile;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class ReconcileAction extends BaseAction {

	private static final long serialVersionUID = 1L;

	private ReconWorkspaceService reconWorkspaceService;

	private Reconcile reconcile;

	private Long id;

	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {

	}

	@UserRole(userRole = UserRoleType.READER)
	public String details() {

		reconcile = getReconWorkspaceService().reconcileDetail(id);

		return SUCCESS;
	}

	public ReconWorkspaceService getReconWorkspaceService() {
		return reconWorkspaceService;
	}

	public void setReconWorkspaceService(
			ReconWorkspaceService reconWorkspaceService) {
		this.reconWorkspaceService = reconWorkspaceService;
	}

	public Reconcile getReconcile() {
		return reconcile;
	}

	public void setReconcile(Reconcile reconcile) {
		this.reconcile = reconcile;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
}
