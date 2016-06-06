package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.ScheduleF;

public interface ScheduleFDao{

	List<ScheduleF> findBySwId(Long id);
	
	 void merge(ScheduleF entity) ;

	void findswByNaturalKey(Long id);
}
