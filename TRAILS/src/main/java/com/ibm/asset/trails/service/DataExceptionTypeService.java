package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.AlertType;

public interface DataExceptionTypeService extends BaseEntityService<AlertType, Long>{

	AlertType findWithAlertCauses(Long plId);

	List<AlertType> list();
	
	List<AlertType> getAlertTypeForSOMs();
}
