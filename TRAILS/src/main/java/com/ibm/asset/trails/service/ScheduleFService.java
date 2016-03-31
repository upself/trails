package com.ibm.asset.trails.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFH;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.tap.trails.framework.DisplayTagList;

public interface ScheduleFService {

	ScheduleF findScheduleF(Account pAccount, Software pSoftware);
	ScheduleF findScheduleF(Long plScheduleFId);
	ScheduleF findScheduleF(Long plScheduleFId, Account pAccount, Software pSoftware);
	List<ScheduleF> findScheduleF(Account pAccount, String softwareName, String level);
	List<ScheduleF> findScheduleFbyManufacturer(Account pAccount, String manufacturerName, String level);

	ArrayList<Software> findSoftwareBySoftwareName(String psSoftwareName);

	ScheduleF getScheduleFDetails(Long plScheduleFId);

	ArrayList<Scope> getScopeList();

	ArrayList<Source> getSourceList();

	ArrayList<Status> getStatusList();
	
	ArrayList<String> getLevelList();

	ByteArrayOutputStream loadSpreadsheet(File file, String remoteUser) throws IOException;

	void paginatedList(DisplayTagList pdtlData, Account pAccount, int piStartIndex, int piObjectsPerPage, String psSort, String psDir);

	void saveScheduleF(ScheduleF psfSave, String psRemoteUser);

	List<MachineType> findMachineTypebyName(String string);
	
	List<ScheduleF> paginatedList(Account pAccount,int piStartIndex, int piObjectsPerPage, String psSort, String psDir);
	List<ScheduleFH> paginatedList(Long scheduleFId,int piStartIndex, int piObjectsPerPage, String psSort, String psDir);
	Long getAllScheduleFSize(Account pAccount);
	Long getScheduleFHSize(ScheduleF scheduleF);
}
