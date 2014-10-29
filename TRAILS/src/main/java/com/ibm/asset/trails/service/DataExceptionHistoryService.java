package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.DataExceptionHistory;

public interface DataExceptionHistoryService {

	List<DataExceptionHistory> getHistory(Long alertId);

	DataExceptionHistory transformToHistory(DataException alert);

	void save(DataExceptionHistory history);

}
