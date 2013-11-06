package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.AlertCause;

public interface DataExceptionCauseDao {

	void add(AlertCause pacAdd);

	AlertCause find(Long plId);

	AlertCause find(String psName);

	AlertCause find(String psName, Long plId);

	List<AlertCause> getAlertCauseListByIdList(List<Long> plAlertCauseId);

	List<AlertCause> getAvailableAlertCauseList(List<Long> plId);

	List<AlertCause> list();

	void update(AlertCause pacUpdate);
}
