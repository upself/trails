package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.ibm.asset.swkbt.schema.MainframeFeatureType;
import com.ibm.asset.trails.batch.swkbt.service.MainframeFeatureService;
import com.ibm.asset.trails.batch.swkbt.service.MainframeVersionService;
import com.ibm.asset.trails.dao.MainframeFeatureDao;
import com.ibm.asset.trails.dao.SoftwareItemDao;
import com.ibm.asset.trails.domain.MainframeFeature;
import com.ibm.asset.trails.domain.ProductInfo;

@Service
public class MainframeFeatureServiceImpl extends
		SoftwareItemServiceImpl<MainframeFeature, MainframeFeatureType, Long>
		implements MainframeFeatureService {
	private static final Log log = LogFactory
			.getLog(MainframeProductInfoServiceImpl.class);

	@Autowired
	private MainframeFeatureDao dao;
	@Autowired
	private MainframeVersionService mfVersionService;

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	public void save(MainframeFeatureType xmlEntity) {
		MainframeFeature existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new MainframeFeature();
			existing = update(existing, xmlEntity);
		} else {
			existing = super.update(existing, xmlEntity);
		}
		merge(existing);
	}

	@Override
	public MainframeFeature update(MainframeFeature existing,
			MainframeFeatureType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.seteId(xmlEntity.getEID());
		existing.setIbmCustomerAgreement(xmlEntity.isIbmCustomerAgreement());
		existing.setSoftwarePricingType(xmlEntity.getSoftwarePricingType());
		existing.setSseNId(xmlEntity.getSSEnId());
		existing.setVue(xmlEntity.getVUE());
		Long versionId = mfVersionService.findIdByNaturalKey(xmlEntity
				.getVersionGuid());
		if (versionId == null) {
			log.debug("Version is  null " + xmlEntity.getVersionGuid());
		} else {
			log.debug("Version_id is " + versionId.toString());
		}
		// versionId = 0L;
		existing.setVersion(versionId);

		if (existing.getMainframeFeatureProductInfo() == null) {
			existing.setMainframeFeatureProductInfo(this.buildProductInfo());
		}

		return existing;
	}

	private ProductInfo buildProductInfo() {

		ProductInfo productInfo = new ProductInfo();
		productInfo.setSoftwareCategoryId(1000L);
		productInfo.setPriority(1);
		productInfo.setLicensable(true);
		productInfo.setChangeJustification("New add");
		productInfo.setRemoteUser("TADZMainframe");
		productInfo.setRecordTime(new Date());

		return productInfo;
	}

	@Override
	public SoftwareItemDao<MainframeFeature, Long> getDao() {
		return dao;
	}

}