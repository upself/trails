package com.ibm.asset.trails.dao;

import java.util.List;
import java.util.Map;

import com.ibm.asset.trails.domain.AlertType;

public interface DataExceptionTypeDao extends BaseEntityDAO<AlertType, Long>{

	AlertType findWithCauses(Long plId);

	AlertType getAlertTypeByCode(String code);

	List<AlertType> list();

	List<Map<String, String>> summary(Long accountId, String alertTypeType);
}
