package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.domain.AlertTypeCause;
import com.opensymphony.xwork2.validator.ValidationException;

public interface DataExceptionCauseService {

	AlertCause find(Long plId);

	List<AlertTypeCause> getAlertCauseListByIdList(List<Long> plAlertCauseId);

	List<AlertTypeCause> getAvailableAlertCauseList(List<Long> plId);

	List<AlertTypeCause> list();

	List<AlertTypeCause> listWithTypeJoin();

	String save(Long plId, String psName) throws ValidationException;

	AlertCause findByName(String alertCauseName);

	AlertCause findByNameResposibility(String alertCauseName,
			AlertCauseResponsibility responsibility);

	void save(AlertCause alertCause);

	void update(AlertCause alertCause);
}
