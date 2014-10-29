package com.ibm.asset.trails.service;

import com.ibm.asset.trails.domain.AlertTypeCause;

public interface AlertTypeCauseService extends
		BaseEntityService<AlertTypeCause, Long> {

	AlertTypeCause getByTypeCauseId(Long alertTypeId, Long alertCauseId);

	void add(AlertTypeCause alertTypeCause);

}
