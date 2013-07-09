package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.DataExceptionType;

public interface DataExceptionTypeService extends BaseEntityService<DataExceptionType, Long>{

	DataExceptionType findWithAlertCauses(Long plId);

	List<DataExceptionType> list();
}
