package com.ibm.asset.trails.service;

import java.util.List;
import java.util.Map;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconSetting;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.domain.Reconcile;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.tap.trails.framework.DisplayTagList;

public interface ReconWorkspaceService extends BaseService {

	public List<ReconcileType> reconcileTypes(boolean isManual);

	public Long total(Account account, ReconSetting reconSetting);
	
	public void paginatedList(DisplayTagList list, Account account,
			ReconSetting reconSetting, int startIndex, int objectsPerPage,
			String sort, String dir);

	public void reconCustomerOwned(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, Recon pRecon, String runon,
			boolean automated, boolean manual, String comments);

	public ReconcileType findReconcileType(Long id);

	public List<InstalledSoftware> installedSoftwareList(Long installedSoftwareId, Account account, String hostName, String hwOwner, String machineType, String serial, Long scopeId);

	public InstalledSoftware getInstalledSoftware(Long installedSoftwareId);

	public void reconIncluded(Account account, String remoteUser,
			List<ReconWorkspace> list, Recon pRecon,
			InstalledSoftware installedSoftware);

	public void breakManualRecon(Account account, String remoteUser,
			List<ReconWorkspace> list, ReconcileType reconcileType,
			String runon);

	public List<Map<String, Object>> reconcileTypeActions();

	public void manualRecon(Account account, String remoteUser, Recon recon);

	public Reconcile reconcileDetail(Long id);

	public void breakLicenseRecon(Account pAccount, String psRemoteUser,
			List<ReconWorkspace> plReconWorkspace, ReconcileType pReconcileType);

	int getAlertsProcessed();

	void setAlertsProcessed(int piAlertsProcessed);

	int getAlertsTotal();

	void setAlertsTotal(int piAlertsTotal);

	List<Long> findAffectedAlertUnlicensedSwList(Account pAccount,
			List<ReconWorkspace> plReconWorkspace, String psRunOn);
	
	//Story 26012
	public List<String> getScheduleFValResult();
	
	//defect 27747
	public String getProcWarnMsg();
	public void setProcWarnMsg(String procWarnMsg);
}
