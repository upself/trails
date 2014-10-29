package com.ibm.asset.trails.service;

import java.util.Map;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;

public interface ReconService {

    public void reconcileByAlert(Long alertId,
            InstalledSoftware parentInstalledSoftware, Recon pRecon,
            String remoteUser, String comments, Account account);

    public Long manualReconcileByAlert(Long alertId,
            InstalledSoftware parentInstalledSoftware, Recon pRecon,
            String remoteUser, String comments, Account account,
            Map<License, Integer> pmLicenseApplied, String psMethod,int owner);

    public AlertUnlicensedSw breakReconcileByAlert(Long alertId,
            Account account, String remoteUser);
    public int validateScheduleFowner(AlertUnlicensedSw alert);
}
