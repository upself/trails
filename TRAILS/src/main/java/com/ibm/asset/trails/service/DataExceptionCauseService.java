package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.AlertCause;
import com.opensymphony.xwork2.validator.ValidationException;

public interface DataExceptionCauseService {

	AlertCause find(Long plId);

	List<AlertCause> getAlertCauseListByIdList(List<Long> plAlertCauseId);

	List<AlertCause> getAvailableAlertCauseList(List<Long> plId);

	List<AlertCause> list();

	String save(Long plId, String psName) throws ValidationException;
}
