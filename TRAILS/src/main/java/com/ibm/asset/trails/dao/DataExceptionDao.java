package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.AlertType;

public interface DataExceptionDao {

	void update(DataException alert);

	void save(DataException alert);

	DataException getById(Long id);

	List<? extends DataException> paginatedList(Account account, int firstResult,
			int maxResults, String sortBy, String sortDirection);

	Long getAlertQtyByAccountAlertType(Account account, AlertType alertType);
	
	void setAlertTypeCode(String alertTypeCode);
	String getAlertTypeCode();
	
	List<Long> getOpenAlertIdsByCustomerIdAndAlertTypeId(Long customerId, Long alertTypeId);
}
