package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.action.ShowQuestion.LicenseFilter;
import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.dao.LicenseDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.tap.trails.framework.DisplayTagList;

@Service
public class LicenseServiceImpl extends
		AbstractGenericEntityService<License, Long> implements LicenseService {

	@Autowired
	private LicenseDAO dao;

	@Override
	protected BaseEntityDAO<License, Long> getDao() {
		return dao;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public void freePoolWithoutParentPaginatedList(DisplayTagList data,
			Account account, int startIndex, int objectsPerPage, String sort,
			String dir) {
		dao.freePoolWithoutParentPaginatedList(data, account.getId(),
				startIndex, objectsPerPage, sort, dir);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public void freePoolWithParentPaginatedList(DisplayTagList data,
			Account account, int startIndex, int objectsPerPage, String sort,
			String dir, List<LicenseFilter> filter) {
		dao.freePoolWithParentPaginatedList(data, account.getId(), startIndex,
				objectsPerPage, sort, dir, filter);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<CapacityType> getCapacityTypeList() {
		return dao.getCapacityTypeList();
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public License getLicenseDetails(Long id) {
		System.out.println("===LicenseServiceImpl - getLicenseDetails init");
		System.out.println("===LicenseServiceImpl - getLicenseDetails id: " + id);
		System.out.println("===LicenseServiceImpl - dao.getLicenseDetails(id): "
				+ dao.getLicenseDetails(id));
		
		return dao.getLicenseDetails(id);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public void paginatedList(DisplayTagList data, Account pAccount,
			int piStartIndex, int piObjectsPerPage, String psSort, String psDir) {
		dao.paginatedList(data, pAccount.getId(), piStartIndex,
				piObjectsPerPage, psSort, psDir);
	}

	public List<String> getProductNameByAccount(Account pAccount, String key) {
		return dao.getProductNameByAccount(pAccount.getId(), key);
	}

	public List<String> getManufacturerNameByAccount(Account pAccount,
			String key) {
		return dao.getManufacturerNameByAccount(pAccount.getId(), key);
	}
}
