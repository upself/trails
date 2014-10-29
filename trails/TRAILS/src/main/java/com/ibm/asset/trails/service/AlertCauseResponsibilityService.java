package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.AlertCauseResponsibility;

public interface AlertCauseResponsibilityService extends
		BaseEntityService<AlertCauseResponsibility, Long> {

	List<AlertCauseResponsibility> list();
}
