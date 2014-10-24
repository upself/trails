package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.HashSet;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.PartNumberType;
import com.ibm.asset.trails.batch.swkbt.service.PartNumberService;
import com.ibm.asset.trails.batch.swkbt.service.PidService;
import com.ibm.asset.trails.dao.KbDefinitionDao;
import com.ibm.asset.trails.dao.PartNumberDao;
import com.ibm.asset.trails.domain.PartNumber;
import com.ibm.asset.trails.domain.Pid;

@Service
public class PartNumberServiceImpl extends
		KbDefinitionServiceImpl<PartNumber, PartNumberType, Long> implements
		PartNumberService {
	private static final Logger logger = Logger
			.getLogger(PartNumberServiceImpl.class);

	@Autowired
	private PartNumberDao dao;
	@Autowired
	private PidService pidService;

	public void save(PartNumberType xmlEntity) {
		PartNumber existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			logger.debug("new saving" + xmlEntity.toString());
			existing = new PartNumber();
			save(existing, xmlEntity);
		} else {
			logger.debug("existing saving " + xmlEntity.toString());
			save(existing, xmlEntity);
		}
	}

	@Override
	public PartNumber update(PartNumber existing, PartNumberType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setIsPVU(xmlEntity.isIsPVU());
		existing.setIsSubCap(xmlEntity.isIsSubCap());
		existing.setName(xmlEntity.getName());
		existing.setPartNumber(xmlEntity.getPartNumber());
		existing.setReadOnly(xmlEntity.isReadOnly());
		Set<Pid> pids = new HashSet<Pid>();
		if (xmlEntity.isDeleted() == null || !xmlEntity.isDeleted()) {
			pids = pidService.findFromXmlSet(xmlEntity.getProductIds());
		}
		existing.getPids().retainAll(pids);
		existing.getPids().addAll(pids);
		return existing;
	}

	@Override
	public KbDefinitionDao<PartNumber, Long> getDao() {
		return dao;
	}

}
