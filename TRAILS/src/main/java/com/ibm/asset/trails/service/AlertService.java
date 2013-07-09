package com.ibm.asset.trails.service;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.Account;

public interface AlertService {

	ArrayList paginatedList(Account account, int startIndex,
			int objectsPerPage, String sort, String dir);

	Long total(Account account);

	ArrayList paginatedList(String remoteUser, int startIndex,
			int objectsPerPage, String sort, String dir);

	Long total(String remoteUser);

	void assign(List<Long> list, String remoteUser, String comments);

	ArrayList getAlertHistory(Long id);

	void assignAll(Account pAccount, String psRemoteUser, String psComments);

	void unassignAll(Account pAccount, String psRemoteUser, String psComments);

	void updateAll(Account pAccount, String psRemoteUser, String psComments,
			int piMode);

	int getAlertsProcessed();

	void setAlertsProcessed(int piAlertsProcessed);

	int getAlertsTotal();

	void setAlertsTotal(int piAlertsTotal);

	void unassign(List<Long> alertIds, String remoteUser, String comments);
}
