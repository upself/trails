package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.action.ShowQuestion.LicenseFilter;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.License;
import com.ibm.tap.trails.framework.DisplayTagList;

public interface LicenseService extends BaseEntityService<License, Long> {

	void freePoolWithParentPaginatedList(DisplayTagList list, Account pAccount,
			int piStartIndex, int piObjectsPerPage, String psSort,
			String psDir, List<LicenseFilter> filter);

	void freePoolWithoutParentPaginatedList(DisplayTagList list,
			Account pAccount, int piStartIndex, int piObjectsPerPage,
			String psSort, String psDir);

	List<CapacityType> getCapacityTypeList();

	License getLicenseDetails(Long id);

	void paginatedList(DisplayTagList list, Account pAccount, int piStartIndex,
			int piObjectsPerPage, String psSort, String psDir);

	List<String> getProductNameByAccount(Account pAccount, String key);

	List<String> getManufacturerNameByAccount(Account pAccount, String key);
	List<License> paginatedList(Long accountId,
			int piStartIndex, int piObjectsPerPage, String psSort, String psDir);
}
