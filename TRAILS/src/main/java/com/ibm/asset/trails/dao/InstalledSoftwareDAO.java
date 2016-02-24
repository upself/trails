package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.InstalledSoftware;

public interface InstalledSoftwareDAO extends
        BaseEntityDAO<InstalledSoftware, Long> {

    List<InstalledSoftware> installedSoftwareList(Long softwareLparId, Long softwareId, String hostname, Account account, Long scopeId);

    InstalledSoftware getInstalledSoftware(Long installedSoftwareId);

}
