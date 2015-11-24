package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ibm.asset.trails.domain.ReconSetting;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.ibm.tap.trails.framework.UserSession;

public class ReconSettingAction extends AccountBaseAction {

	private static final long serialVersionUID = 1L;

	private ReconWorkspaceService reconWorkspaceService;

	private List<Map<String, Object>> reconcileTypes = new ArrayList<Map<String,Object>>();

	private ReconSetting reconSetting;

	private String reconcileTypeName;

	private String productInfoName;
	
	private Long total;

	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {
		super.prepare();

		// Need to populate the lists
		reconcileTypes = getReconWorkspaceService().reconcileTypeActions();

		// TODO look into possibility of populating the other lists
		// such as hardware country
	}

	@UserRole(userRole = UserRoleType.READER)
	public String input() {

		if (getUserSession().getReconSetting() != null) {
			reconSetting = getUserSession().getReconSetting();
		}

		return INPUT;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String update() {

		UserSession user = getUserSession();
		user.setReconSetting(reconSetting);
		setUserSession(user);

		for (Map<String,Object> map : reconcileTypes) {
			Long id = (Long) map.get("id");
			if (id.equals(reconSetting.getReconcileType())) {
				reconcileTypeName = (String) map.get("name");
			}
		}

		reconSetting = getUserSession().getReconSetting();
		if (reconSetting != null) {
			total = getReconWorkspaceService().total(getUserSession().getAccount(), reconSetting);
        }
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String execute() {
		reconSetting = new ReconSetting();
		String[] softwareNames = new String[1];
		softwareNames[0] = productInfoName;
		reconSetting.setProductInfoNames(softwareNames);
		reconSetting.setAlertStatus("OPEN");

		UserSession user = getUserSession();
		user.setReconSetting(reconSetting);
		setUserSession(user);

		return "workspace";
	}

	public ReconWorkspaceService getReconWorkspaceService() {
		return reconWorkspaceService;
	}

	public void setReconWorkspaceService(
			ReconWorkspaceService reconWorkspaceService) {
		this.reconWorkspaceService = reconWorkspaceService;
	}

	public List<Map<String,Object>> getReconcileTypes() {
		return reconcileTypes;
	}

	public void setReconcileTypes(List<Map<String,Object>> reconcileTypes) {
		this.reconcileTypes = reconcileTypes;
	}

	public ReconSetting getReconSetting() {
		return reconSetting;
	}

	public void setReconSetting(ReconSetting reconSetting) {
		this.reconSetting = reconSetting;
	}

	public String getReconcileTypeName() {
		return reconcileTypeName;
	}

	public void setReconcileTypeName(String reconcileTypeName) {
		this.reconcileTypeName = reconcileTypeName;
	}

	public String getProductInfoName() {
		return productInfoName;
	}

	public void setProductInfoName(String productInfoName) {
		this.productInfoName = productInfoName;
	}

	public Long getTotal() {
		return total;
	}	
}
