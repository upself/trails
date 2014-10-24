package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.VariationType;
import com.ibm.asset.trails.batch.swkbt.service.ReleaseService;
import com.ibm.asset.trails.batch.swkbt.service.VariationService;
import com.ibm.asset.trails.dao.KbDefinitionDao;
import com.ibm.asset.trails.dao.VariationDao;
import com.ibm.asset.trails.domain.Variation;

@Service
public class VariationServiceImpl extends
		KbDefinitionServiceImpl<Variation, VariationType, Long> implements
		VariationService {

	@Autowired
	private VariationDao dao;
	@Autowired
	private ReleaseService releaseService;

	public void save(VariationType xmlEntity) {
		Variation existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new Variation();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Variation update(Variation existing, VariationType xmlEntity) {
		super.update(existing, xmlEntity);
		existing.setActivationDate(convertXMLGregorianCalendar(xmlEntity
				.getActivationDate()));
		existing.setVariation(xmlEntity.getVariation());
		Long release = releaseService
				.findIdByNaturalKey(xmlEntity.getRelease());
		existing.setRelease(release);
		return existing;
	}

	@Override
	public KbDefinitionDao<Variation, Long> getDao() {
		return dao;
	}

}
