package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ReconSetting;
import com.ibm.asset.trails.domain.VSoftwareLpar;
import com.ibm.tap.trails.framework.DisplayTagList;

public interface VSoftwareLparDAO extends BaseEntityDAO<VSoftwareLpar,Long> {

	Long total(Account account, ReconSetting reconSetting);
	void paginatedList(DisplayTagList data, Account account,
			ReconSetting reconSetting, int startIndex, int objectsPerPage,
			String sort, String dir);


}
