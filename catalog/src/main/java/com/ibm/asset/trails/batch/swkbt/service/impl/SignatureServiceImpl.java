package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.Serializable;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.swkbt.schema.SignatureType;
import com.ibm.asset.trails.batch.swkbt.service.PlatformService;
import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.ReleaseService;
import com.ibm.asset.trails.batch.swkbt.service.SignatureService;
import com.ibm.asset.trails.batch.swkbt.service.VersionService;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.Signature;

public abstract class SignatureServiceImpl<E extends Signature, X extends SignatureType, I extends Serializable>
		extends KbDefinitionServiceImpl<E, X, I> implements
		SignatureService<E, X, I> {

	@Autowired
	private PlatformService platformService;
	@Autowired
	private ProductInfoService productInfoService;
	@Autowired
	private VersionService versionService;
	@Autowired
	private ReleaseService releaseService;

	@Override
	protected abstract SignatureDao<E, I> getDao();

	@Override
	public E update(E existing, X xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setConfidenceLevel(xmlEntity.getConfidenceLevel());
		if (xmlEntity.getCVersionPlatform() != null) {
			Long platformCVersion = platformService
					.findIdByNaturalKey(xmlEntity.getCVersionPlatform());
			existing.setPlatformCVersion(platformCVersion);
		}
		Long platform = platformService
				.findIdBySwkbtId(xmlEntity.getPlatform());
		existing.setPlatformType(platform);

		Long softwareItem = productInfoService.findIdByNaturalKey(xmlEntity
				.getDiscoveredItem());
		if (softwareItem == null) {
			softwareItem = versionService.findIdByNaturalKey(xmlEntity
					.getDiscoveredItem());
		}
		if (softwareItem == null) {
			softwareItem = releaseService.findIdByNaturalKey(xmlEntity
					.getDiscoveredItem());
		}
		existing.setSoftwareItem(softwareItem);
		return existing;
	}

}