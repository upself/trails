package com.ibm.asset.trails.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ProductInfo;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.tap.trails.framework.DisplayTagList;

public interface ScheduleFService {

	ScheduleF findScheduleF(Account pAccount, ProductInfo pProductInfo);

	ScheduleF findScheduleF(Long plScheduleFId, Account pAccount,
			ProductInfo pProductInfo);

	ArrayList<ProductInfo> findProductInfoBySoftwareName(String psSoftwareName);

	ScheduleF getScheduleFDetails(Long plScheduleFId);

	ArrayList<Scope> getScopeList();

	ArrayList<Source> getSourceList();

	ArrayList<Status> getStatusList();

	ByteArrayOutputStream loadSpreadsheet(File file, String remoteUser)
			throws IOException;

	void paginatedList(DisplayTagList pdtlData, Account pAccount,
			int piStartIndex, int piObjectsPerPage, String psSort, String psDir);

	void saveScheduleF(ScheduleF psfSave, String psRemoteUser);
}
