package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.InstalledFilter;

public interface InstalledFilterDao extends BaseDao<InstalledFilter, Long> {

	Long hitCount(Long id);

	Boolean filterExists(String filterName, String softwareVersion);
}
