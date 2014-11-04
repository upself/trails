package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.swkbt.schema.MainframeVersionType;
import com.ibm.asset.trails.batch.swkbt.service.MainframeVersionService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;
import com.ibm.asset.trails.dao.MainframeVersionDao;
import com.ibm.asset.trails.dao.SoftwareItemDao;
import com.ibm.asset.trails.domain.MainframeVersion;
import com.ibm.asset.trails.domain.ProductInfo;

@Service
public class MainframeVersionServiceImpl extends
		SoftwareItemServiceImpl<MainframeVersion, MainframeVersionType, Long>
		implements MainframeVersionService {

	@Autowired
	private MainframeVersionDao dao;
	@Autowired
	private ManufacturerService manufacturerService;
	@Autowired
	private ProductInfoService productService;
	private Long manufacturer;

	private static final Log logger = LogFactory.getLog(GenericService.class);

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	public void save(MainframeVersionType xmlEntity) {
		MainframeVersion existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new MainframeVersion();
			existing = update(existing, xmlEntity);
		} else {
			existing = super.update(existing, xmlEntity);
		}
		merge(existing);
	}

	@Override
	public MainframeVersion update(MainframeVersion existing,
			MainframeVersionType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setIbmCustomerAgreement(xmlEntity.isIbmCustomerAgreement());
		existing.setIdentifier(xmlEntity.getIdentifier());
		existing.setServiceSupportId(xmlEntity.getSS());
		existing.setSoftwarePricingType(xmlEntity.getSoftwarePricingType());
		existing.setVersion(xmlEntity.getVersion());
		existing.setVue(xmlEntity.getVUE());
		logger.debug("xmlEntity manufacturer " + xmlEntity.getManufacturer());
		Long productId = productService.findIdByNaturalKey(xmlEntity
				.getProduct());
		existing.setProductInfo(productId);
		if (xmlEntity.getManufacturer() == null) {
			ProductInfo productInfo = productService.findById(productId);
			manufacturer = productInfo.getManufacturer();
			logger.debug("Find manufacturer id by product_info " + manufacturer);
		} else {
			manufacturer = manufacturerService.findIdByNaturalKey(xmlEntity
					.getManufacturer());
			logger.debug("Find manufacturer id by guid " + manufacturer);
		}
		existing.setManufacturer(manufacturer);

		if (existing.getMainframeVersionProductInfo() == null) {
			existing.setMainframeVersionProductInfo(this.buildProductInfo());
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
	protected SoftwareItemDao<MainframeVersion, Long> getDao() {
		return dao;
	}

}
