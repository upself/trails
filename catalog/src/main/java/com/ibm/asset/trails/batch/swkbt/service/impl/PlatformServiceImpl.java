package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.PlatformType;
import com.ibm.asset.trails.batch.swkbt.service.PlatformService;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.dao.PlatformDao;
import com.ibm.asset.trails.domain.Platform;

@Service
public class PlatformServiceImpl extends
		GenericService<Platform, PlatformType, Long> implements PlatformService {

	@Autowired
	private PlatformDao dao;

	public void save(PlatformType xmlEntity) {
		Platform existing = findByNaturalKey(xmlEntity.getId());
		if (existing == null) {
			existing = new Platform();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Platform update(Platform existing, PlatformType xmlEntity) {
		existing.setName(xmlEntity.getName());
		existing.setSwkbtId(xmlEntity.getId());
		return existing;
	}

	@Override
	public BaseDao<Platform, Long> getDao() {
		return dao;
	}

	public Long findIdBySwkbtId(int swkbtId) {
		return dao.findIdBySwkbtId(swkbtId);
	}

}
