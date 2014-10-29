package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.AlertTypeCause;

public interface AlertTypeCauseDao extends BaseEntityDAO<AlertTypeCause, Long> {

	AlertTypeCause getByTypeCauseId(Long alertTypeId, Long alertCauseId);

	AlertTypeCause update(AlertTypeCause entity);

}
