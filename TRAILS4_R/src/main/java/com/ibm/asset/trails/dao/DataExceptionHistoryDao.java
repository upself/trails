package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.DataExceptionHistory;

public interface DataExceptionHistoryDao {

	void save(DataExceptionHistory history);

	List<DataExceptionHistory> getByAlertId(Long id);

}
