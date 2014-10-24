package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.DistributedVersionType;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.VersionService;
import com.ibm.asset.trails.dao.SoftwareItemDao;
import com.ibm.asset.trails.dao.VersionDao;
import com.ibm.asset.trails.domain.Version;

@Service
public class VersionServiceImpl extends
		SoftwareItemServiceImpl<Version, DistributedVersionType, Long>
		implements VersionService {

	private static final Log LOG = LogFactory.getLog(VersionServiceImpl.class);

	@Autowired
	private VersionDao dao;
	@Autowired
	private ManufacturerService manufacturerService;
	@Autowired
	private ProductInfoService productInfoService;

	public void save(DistributedVersionType xmlEntity) {
		Version existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new Version();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Version update(Version existing, DistributedVersionType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setIdentifier(xmlEntity.getIdentifier());
		existing.setVersion(xmlEntity.getVersion());
		Long manufacturer = manufacturerService.findIdByNaturalKey(xmlEntity
				.getManufacturer());
		// TODO: This is hiding the problem -- loader really needs to log and skip this
		// record as a bad record
		if ( manufacturer == null ) {
			LOG.error("Manufacturer could not be found -- setting to 0L");
			manufacturer = 0L;
		}
		existing.setManufacturer(manufacturer);
		Long productInfo = productInfoService.findIdByNaturalKey(xmlEntity
				.getProduct());
		existing.setProductInfo(productInfo);
		return existing;
	}

	@Override
	public SoftwareItemDao<Version, Long> getDao() {
		return dao;
	}
}
