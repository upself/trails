package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.domain.AlertTypeCause;

public interface DataExceptionCauseDao {

	void add(AlertCause pacAdd);

	AlertCause find(Long plId);

	AlertCause find(String psName);

	AlertCause find(String psName, Long plId);

	List<AlertTypeCause> getAlertCauseListByIdList(List<Long> plAlertCauseId);

	List<AlertTypeCause> getAvailableAlertCauseList(List<Long> plId);

	List<AlertTypeCause> list();

	List<AlertTypeCause> listWithTypeJoin();

	void update(AlertCause pacUpdate);
}
