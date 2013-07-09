package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.ReconWorkspace;

public interface AlertUnlicensedSoftwareDAO extends
        BaseEntityDAO<AlertUnlicensedSw, Long> {

    List<Long> findAffectedAlertList(Long accountId, Long productInfoId,
            boolean overwriteAuto, boolean overwriteManual, String owner,
            boolean includeOpenAlerts);

    List<Long> findAffectedAlertList(List<ReconWorkspace> reconWorkspaces,
            boolean overwriteAuto, boolean overwriteManual);

    List<Long> findAffectedAlertList(Account pAccount,
            List<Long> llProductInfoId);

    List<Long> findAffectedAlertList(Account pAccount,
            List<Long> llProductInfoId, String psRunOn);

    List<Long> findAffectedLicenseAlertList(Long accountId, Long alertId);

    List<Long> findAffectedAlertList(List<Long> alertId);

    List<Long> findMachineLevelAffected(Long productInfoId, Long hardwareId);

}
