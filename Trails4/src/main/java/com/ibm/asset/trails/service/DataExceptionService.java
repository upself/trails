package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.DataExceptionType;

public interface DataExceptionService {

	List<? extends DataException> paginatedList(Account account, int firstResult,
			int maxResults, String sortBy, String sortDirection);

	long getAlertListSize(Account account, DataExceptionType alertType);

	void updateAssignment(DataException alert, String sessionUser, String comments,
			boolean assign);

	DataException getById(long id);

	DataExceptionType getAlertType();
	
	void setAlertTypeCode(String alertTypeCode);

}
