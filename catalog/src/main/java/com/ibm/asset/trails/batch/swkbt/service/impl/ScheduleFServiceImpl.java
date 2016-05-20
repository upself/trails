package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.batch.swkbt.service.ScheduleFService;
import com.ibm.asset.trails.dao.ScheduleFDao;
import com.ibm.asset.trails.domain.ScheduleF;

@Service
public class ScheduleFServiceImpl implements ScheduleFService {
    
	@Autowired
	private ScheduleFDao dao;
	
	public List<ScheduleF> findBySwId(Long id) {
		return getDao().findBySwId(id);
	}

	public void addToRecon(ScheduleF scheduleF) {
		// TODO Auto-generated method stub

	}

	public ScheduleFDao getDao() {
		return dao;
	}

	public void merge(ScheduleF scheduleF) {
		 getDao().merge(scheduleF);
	}

}
