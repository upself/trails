package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.DistributedReleaseType;
import com.ibm.asset.trails.batch.swkbt.service.CVersionIdService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.ReleaseService;
import com.ibm.asset.trails.batch.swkbt.service.VersionService;
import com.ibm.asset.trails.dao.ReleaseDao;
import com.ibm.asset.trails.dao.SoftwareItemDao;
import com.ibm.asset.trails.domain.CVersionId;
import com.ibm.asset.trails.domain.Release;

@Service
public class ReleaseServiceImpl extends
		SoftwareItemServiceImpl<Release, DistributedReleaseType, Long>
		implements ReleaseService {

	private static final Log log = LogFactory.getLog(ReleaseServiceImpl.class);
	@Autowired
	private ReleaseDao dao;
	@Autowired
	private VersionService versionService;
	@Autowired
	private ManufacturerService manufacturerService;
	@Autowired
	private CVersionIdService cVersionIdService;

	public void save(DistributedReleaseType xmlEntity) {
		Release existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new Release();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Release update(Release existing, DistributedReleaseType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setIdentifier(xmlEntity.getIdentifier());
		existing.setRelease(xmlEntity.getRelease());
		Long manufacturer = manufacturerService.findIdByNaturalKey(xmlEntity
				.getManufacturer());
		// TODO: This hides the problem -- loader really need
		// to log and skip the record if it cannot find a manufacturer
		if ( manufacturer == null ) {
			log.error("manufacturer could not be found setting to 0L");
			manufacturer = 0L;
		}
		existing.setManufacturer(manufacturer);
		Long version = versionService
				.findIdByNaturalKey(xmlEntity.getVersion());
		existing.setVersion(version);
		Set<CVersionId> newCVersionIds = cVersionIdService
				.findFromXmlSet(xmlEntity.getCVersionId());
		existing.getcVersionId().retainAll(newCVersionIds);
		existing.getcVersionId().addAll(newCVersionIds);
		log.debug("Set cversionids");
		return existing;
	}

	@Override
	public SoftwareItemDao<Release, Long> getDao() {
		return dao;
	}
}
