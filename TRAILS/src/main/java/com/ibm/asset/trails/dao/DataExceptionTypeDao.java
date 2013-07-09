package com.ibm.asset.trails.dao;

import java.util.List;
import java.util.Map;

import com.ibm.asset.trails.domain.DataExceptionType;

public interface DataExceptionTypeDao extends BaseEntityDAO<DataExceptionType, Long>{

	DataExceptionType findWithCauses(Long plId);

	DataExceptionType getAlertTypeByCode(String code);

	List<DataExceptionType> list();

	List<Map<String, String>> summary(Long accountId, String alertTypeType);
}
