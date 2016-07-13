package com.ibm.asset.trails.action;

import java.util.List;

import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.service.AlertService;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class ApplyManualRecon extends AccountBaseAction {

	private static final long serialVersionUID = 1L;

	private ReconWorkspaceService reconWorkspaceService;

	private AlertService alertService;

	private Recon recon;
	
	private String gotoV17e;

	@UserRole(userRole = UserRoleType.READER)
	public String cancel() {
		return "cancel";
	}

	@Override
	@UserRole(userRole = UserRoleType.READER)
	public String execute() {
		//bug fix for #166. recon may null under multi-threads. 
		if (recon == null || recon.getReconcileType() == null) {
			return "cancel";
		}

		if (recon.getReconcileType().getId().intValue() == 1) {
			getReconWorkspaceService().manualRecon(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon);
		} else if (recon.getReconcileType().getId().intValue() == 2) {
			getReconWorkspaceService().reconCustomerOwned(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon.getList(), recon,
					recon.getRunon(), recon.isAutomated(), recon.isManual(),
					recon.getComments());
		} else if (recon.getReconcileType().getId().intValue() == 3) {
			getReconWorkspaceService().reconCustomerOwned(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon.getList(), recon,
					recon.getRunon(), recon.isAutomated(), recon.isManual(),
					recon.getComments());
		} else if (recon.getReconcileType().getId().intValue() == 4) {
			getReconWorkspaceService().reconIncluded(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon.getList(), recon,
					recon.getInstalledSoftware());
		} else if (recon.getReconcileType().getId().intValue() == 9) {
			getReconWorkspaceService().breakManualRecon(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon.getList(),
					recon.getReconcileType(), recon.getRunon());
		} else if (recon.getReconcileType().getId().intValue() == 10) {
			getAlertService().assign(
					getReconWorkspaceService()
							.findAffectedAlertUnlicensedSwList(
									getUserSession().getAccount(),
									recon.getList(), recon.getRunon()),
					getUserSession().getRemoteUser(), recon.getComments());
		} else if (recon.getReconcileType().getId().intValue() == 11) {
			getAlertService().unassign(
					getReconWorkspaceService()
							.findAffectedAlertUnlicensedSwList(
									getUserSession().getAccount(),
									recon.getList(), recon.getRunon()),
					getUserSession().getRemoteUser(), recon.getComments());
		} else if (recon.getReconcileType().getId().intValue() == 12) {
			getReconWorkspaceService().breakLicenseRecon(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon.getList(),
					recon.getReconcileType());
		} else if (recon.getReconcileType().getId().intValue() == 13) {
			getReconWorkspaceService().reconCustomerOwned(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon.getList(), recon,
					recon.getRunon(), recon.isAutomated(), recon.isManual(),
					recon.getComments());
		} else if (recon.getReconcileType().getId().intValue() == 14) {
			getReconWorkspaceService().reconCustomerOwned(
					getUserSession().getAccount(),
					getUserSession().getRemoteUser(), recon.getList(), recon,
					recon.getRunon(), recon.isAutomated(), recon.isManual(),
					recon.getComments());
		}

//AB added
		/*
		 * for manual recon action, the software instance need schedule F defined, so get the validation result for 
		 * reconWorkspaceService and set it to userSession for next action to use
		 */
		if (recon.getReconcileType().getId().intValue() == 1
				|| recon.getReconcileType().getId().intValue() == 2
				|| recon.getReconcileType().getId().intValue() == 3
				|| recon.getReconcileType().getId().intValue() == 4
				|| recon.getReconcileType().getId().intValue() == 13) {
			//Story 26012
			List<String> resultList = getReconWorkspaceService().getScheduleFValResult();
				getUserSession().setSchedulefDefValResult(resultList);;

		}
		return SUCCESS;
	}
	
	@Override
	public void validate() {

	}

	public ReconWorkspaceService getReconWorkspaceService() {
		return reconWorkspaceService;
	}

	public void setReconWorkspaceService(
			ReconWorkspaceService reconWorkspaceService) {
		this.reconWorkspaceService = reconWorkspaceService;
	}

	public Recon getRecon() {
		return recon;
	}

	public void setRecon(Recon recon) {
		this.recon = recon;
	}

	public String getGotoV17e() {
		return gotoV17e;
	}

	public void setGotoV17e(String gotoV17e) {
		this.gotoV17e = gotoV17e;
	}
	
	public String getV17eParam(){
		if(null != this.gotoV17e && this.gotoV17e.equalsIgnoreCase("y")){
			return "?gotoV17e=y";
		}else{
			return null;
		}
	}

	public AlertService getAlertService() {
		return alertService;
	}

	public void setAlertService(AlertService alertService) {
		this.alertService = alertService;
	}
}
