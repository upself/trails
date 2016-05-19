package com.ibm.asset.trails.batch.swkbt.service;

import java.util.List;

import com.ibm.asset.trails.dao.ScheduleFDao;
import com.ibm.asset.trails.domain.ScheduleF;

public interface ScheduleFService {
	
	ScheduleFDao getDao();

	List<ScheduleF> findBySwId(Long id);

	void addToRecon(ScheduleF scheduleF);

	void merge(ScheduleF scheduleF);
}
