package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.AlertCauseResponsibility;

public interface AlertCauseResponsibilityDao extends
		BaseEntityDAO<AlertCauseResponsibility, Long> {

	List<AlertCauseResponsibility> list();

}