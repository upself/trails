package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.DataExceptionCause;

public interface DataExceptionCauseDao {

	void add(DataExceptionCause pacAdd);

	DataExceptionCause find(Long plId);

	DataExceptionCause find(String psName);

	DataExceptionCause find(String psName, Long plId);

	List<DataExceptionCause> getAlertCauseListByIdList(List<Long> plAlertCauseId);

	List<DataExceptionCause> getAvailableAlertCauseList(List<Long> plId);

	List<DataExceptionCause> list();

	void update(DataExceptionCause pacUpdate);
}
