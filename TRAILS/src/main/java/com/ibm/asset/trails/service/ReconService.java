package com.ibm.asset.trails.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.AllocationMethodology;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.UsedLicenseHistory;
import com.ibm.asset.trails.form.BreakResult;

public interface ReconService {

	public void reconcileByAlert(Long alertId,
			InstalledSoftware parentInstalledSoftware, Recon pRecon,
			String remoteUser, String comments, Account account);

	public Long manualReconcileByAlert(Long alertId,
			InstalledSoftware parentInstalledSoftware, Recon pRecon,
			String remoteUser, String comments, Account account,
			Map<License, Integer> pmLicenseApplied, String psMethod, int owner);
	
	public AlertUnlicensedSw breakReconcileByAlert(Long alertId,
			Account account, String remoteUser, Set<UsedLicenseHistory> usedLicHis);
	
	public BreakResult breakReconcileByAlertWithoutQueue(Long alertId,String remoteUser, Set<UsedLicenseHistory> usedLicHis);
	
	public void breakResultToQueue(List<BreakResult> breakResultList);

	// AB added2
	public int validateScheduleFowner(AlertUnlicensedSw alert, Recon precon);

	// AB added
	// Story 26012
	public List<String> getScheduleFDefInRecon();

	public boolean isAllocateByHardware(Recon pRecon);
	
	public AllocationMethodology getAllocationMethodology(String per);
}
