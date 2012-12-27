package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.DataExceptionCause;
import com.opensymphony.xwork2.validator.ValidationException;

public interface DataExceptionCauseService {

	DataExceptionCause find(Long plId);

	List<DataExceptionCause> getAlertCauseListByIdList(List<Long> plAlertCauseId);

	List<DataExceptionCause> getAvailableAlertCauseList(List<Long> plId);

	List<DataExceptionCause> list();

	String save(Long plId, String psName) throws ValidationException;
}
