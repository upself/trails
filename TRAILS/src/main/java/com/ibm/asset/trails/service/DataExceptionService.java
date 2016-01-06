package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.AlertType;

public interface DataExceptionService {

	List<? extends DataException> paginatedList(Account account, int firstResult,
			int maxResults, String sortBy, String sortDirection);

	long getAlertListSize(Account account, AlertType alertType);

	void updateAssignment(DataException alert, String sessionUser, String comments,
			boolean assign);
	
	void updateAssignmentAndCreateHistory(DataException alert, String sessionUser, String comments,
			boolean assign);

	DataException getById(long id);

	AlertType getAlertType();
	
	void setAlertTypeCode(String alertTypeCode);
	
	void assign(List<Long> dataExpIds, String remoteUser, String comments);
	
	void unassign(List<Long> dataExpIds, String remoteUser, String comments);
	
	void assignAll(Long customerId, String dataExpTypeCode, String remoteUser, String comments);
	
	void unassignAll(Long customerId, String dataExpTypeCode, String remoteUser, String comments);
}
