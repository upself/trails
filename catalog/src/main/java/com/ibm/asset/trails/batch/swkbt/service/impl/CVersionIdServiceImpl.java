package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.CVersionIdType;
import com.ibm.asset.swkbt.schema.PlatformsEnum;
import com.ibm.asset.trails.batch.swkbt.service.CVersionIdService;
import com.ibm.asset.trails.batch.swkbt.service.PlatformService;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.dao.CVersionIdDao;
import com.ibm.asset.trails.domain.CVersionId;

@Service
public class CVersionIdServiceImpl extends
		GenericService<CVersionId, CVersionIdType, Long> implements
		CVersionIdService {

	@Autowired
	private CVersionIdDao dao;
	@Autowired
	private PlatformService platformService;

	public void save(CVersionIdType xmlEntity) {
		CVersionId existing = findByNaturalKey(xmlEntity.getPlatformName(),
				xmlEntity.getCVersionId());
		if (existing == null) {
			existing = new CVersionId();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public CVersionId update(CVersionId existing, CVersionIdType xmlEntity) {
		existing.setcVersionId(xmlEntity.getCVersionId());
		Long platform = platformService.findIdByNaturalKey(PlatformsEnum
				.fromValue(xmlEntity.getPlatformName()));
		existing.setPlatform(platform);
		return existing;
	}

	public Set<CVersionId> findFromXmlSet(List<CVersionIdType> cVersionIds) {
		Set<CVersionId> newCVersionIds = new HashSet<CVersionId>();
		for (CVersionIdType cVersionIdType : cVersionIds) {
			CVersionId cVersionId = findByNaturalKey(
					cVersionIdType.getPlatformName(),
					cVersionIdType.getCVersionId());
			if (cVersionId != null) {
				newCVersionIds.add(cVersionId);
			}
		}
		return newCVersionIds;
	}

	@Override
	public BaseDao<CVersionId, Long> getDao() {
		return dao;
	}

}
