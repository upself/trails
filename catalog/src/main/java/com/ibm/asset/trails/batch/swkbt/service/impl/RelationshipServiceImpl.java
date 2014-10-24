package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.RelationshipType;
import com.ibm.asset.trails.batch.swkbt.service.MainframeFeatureService;
import com.ibm.asset.trails.batch.swkbt.service.MainframeVersionService;
import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.RelationshipService;
import com.ibm.asset.trails.batch.swkbt.service.ReleaseService;
import com.ibm.asset.trails.batch.swkbt.service.VersionService;
import com.ibm.asset.trails.dao.KbDefinitionDao;
import com.ibm.asset.trails.dao.RelationshipDao;
import com.ibm.asset.trails.domain.Relationship;

@Service
public class RelationshipServiceImpl extends
		KbDefinitionServiceImpl<Relationship, RelationshipType, Long> implements
		RelationshipService {
	private static final Log log = LogFactory
			.getLog(RelationshipServiceImpl.class);

	@Autowired
	private RelationshipDao dao;
	@Autowired
	private ProductInfoService productInfoService;
	@Autowired
	private VersionService versionService;
	@Autowired
	private ReleaseService releaseService;
	@Autowired
	private MainframeVersionService mfVersionService;
	@Autowired
	private MainframeFeatureService mfFeatureService;

	public void save(RelationshipType xmlEntity) {
		Relationship existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new Relationship();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Relationship update(Relationship existing, RelationshipType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setType(xmlEntity.getType());
		Long sink = findSoftwareItemId(xmlEntity.getSink());
		Long source = findSoftwareItemId(xmlEntity.getSource());
		existing.setSinkSoftwareItemType(sink);
		existing.setSourceSoftwareItemType(source);
		return existing;
	}

	private Long findSoftwareItemId(String key) {
		Long softwareItem = productInfoService.findIdByNaturalKey(key);
		log.info("softwareItem: " + softwareItem);
		if (softwareItem == null) {
			softwareItem = versionService.findIdByNaturalKey(key);
			log.info("softwareItem: " + softwareItem);
		}
		if (softwareItem == null) {
			softwareItem = releaseService.findIdByNaturalKey(key);
			log.info("softwareItem: " + softwareItem);
		}
		if (softwareItem == null) {
			softwareItem = mfVersionService.findIdByNaturalKey(key);
			log.info("softwareItem:" + softwareItem);
		}
		if (softwareItem == null) {
			softwareItem = mfFeatureService.findIdByNaturalKey(key);
			log.info("softwareItem:" + softwareItem);
		}
		return softwareItem;
	}

	@Override
	public KbDefinitionDao<Relationship, Long> getDao() {
		return dao;
	}

}
