package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.swkbt.schema.MainframeProductType;
import com.ibm.asset.trails.batch.swkbt.service.MainframeProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.ReconService;
import com.ibm.asset.trails.dao.ProductDao;
import com.ibm.asset.trails.dao.ProductInfoDao;
import com.ibm.asset.trails.domain.ProductInfo;
import com.ibm.asset.trails.domain.Recon;

@Service
public class MainframeProductInfoServiceImpl extends
		MainframeProductServiceImpl<ProductInfo, MainframeProductType, Long> implements
		MainframeProductInfoService {
	private static final Log log = LogFactory
			.getLog(MainframeProductInfoServiceImpl.class);

	@Autowired
	private ProductInfoDao dao;
	@Autowired
	private ManufacturerService manufacturerService;
	@Autowired
	private ReconService<?, ?> reconService;

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	public void save(MainframeProductType xmlEntity) {
		ProductInfo existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new ProductInfo();
			existing = update(existing, xmlEntity);
//     We are not reconcile mainframe product due to not reporting alerts			
			recon(existing, xmlEntity);
		} else {
			log.debug("have existing " + existing.toString());
//     We are not reconcile mainframe product due to not reporting alerts
		    recon(existing, xmlEntity);
			existing = super.update(existing, xmlEntity);
		}
		merge(existing);
	}

	@Override
	public ProductInfo update(ProductInfo existing,
			MainframeProductType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setSoftwareCategoryId(1000L);
		existing.setPriority(1);
		existing.setLicensable(true);
		existing.setChangeJustification("New add");
		existing.setRemoteUser("TADZMainframe");
		existing.setRecordTime(new Date());
		return existing;
	}

	protected void recon(ProductInfo existing, MainframeProductType xmlEntity) {
		boolean recon = false;
		log.debug("Trying to add recon");
		if (manufacturerChange(existing, xmlEntity)) {
			log.debug("manufacturer changed!");
			recon = true;
		}
		if (softwareNameChange(existing, xmlEntity)) {
			log.debug("software name changed!");
			recon = true;
		}
        if (deletedChange(existing, xmlEntity)) {
			log.debug("deleted changed!");
			recon = true;
		} else if (vendorManagedChange(existing, xmlEntity)) {
			log.debug("vendor managed changed!");
			recon = true;
		}
		if (recon) {
			log.debug("add her to the queue!");
			addToRecon(existing);
		}
	}

	public void addToRecon(ProductInfo newEntity) {
		log.debug(" Trying to add recon");
		Recon existing = (Recon) reconService.findByNaturalKey(newEntity.getId());
		if (existing == null){
		log.debug(" Recon doesn't exist");
		Recon recon = new Recon();
		recon.setAction("UPDATE");
		recon.setRecordTime(new Date());
		recon.setRemoteUser("TADZMainframe");
		recon.setProductInfo(newEntity);
		newEntity.setRecon(recon);
		} else {
		log.debug(" Recon exists");
		newEntity.setRecon(existing);
		}
	}

	private boolean vendorManagedChange(ProductInfo existing,
			MainframeProductType xmlEntity) {
		Boolean existingVM = new Boolean(existing.getVendorManaged());
		Boolean newVM = new Boolean(xmlEntity.getCustomField2());

		if (existingVM.equals(newVM)) {
			return false;
		} else {
			return true;
		}
	}

	private boolean deletedChange(ProductInfo existing,
			MainframeProductType xmlEntity) {
		if (existing == null) {
			log.debug("existing is null");
			if (xmlEntity == null) {
				log.debug("xmlEnity is null");
				return false;
			} else if (xmlEntity.isDeleted() == Boolean.FALSE) {
				log.debug("xmlentity is false");
				return true;
			} else {
				log.debug("xmlentity is true");
				return false;
			}
		} else if (xmlEntity == null) {
			log.debug("2 xmlentity is null");
			if (existing.getDeleted() == Boolean.FALSE) {
				log.debug("existing is false");
				return true;
			} else if (existing.getDeleted() == Boolean.TRUE) {
				log.debug("existing is true");
				return false;
			}
		} else if (existing.getDeleted() == null || xmlEntity.isDeleted() == null)
		    {    
			      log.debug("both deleted are null");
			      return false;
		} else if((existing.getDeleted() != null || xmlEntity.isDeleted() != null) &&
				(existing.getDeleted().equals(xmlEntity.isDeleted()))) {
			log.debug("Deleted are not null,existing equals xmlentity");
			return false;
		}
		log.debug("nothing...reconning");
		return true;
	}

	private boolean manufacturerChange(ProductInfo existing,
			MainframeProductType xmlEntity) {
		boolean isExistingIBM = manufacturerService.isIBMManufacturer(existing
				.getManufacturer());
		boolean isNewIBM = manufacturerService.isIBMManufacturer(xmlEntity
				.getManufacturer());
		if (isNewIBM != isExistingIBM) {
			return true;
		}
		return false;
	}
	
	private boolean softwareNameChange(ProductInfo existing,
			MainframeProductType xmlEntity) {

		if (!existing.getName().equals(xmlEntity.getName())) {
			return true;
		}
		return false;
	}

	@Override
	public ProductDao<ProductInfo, Long> getDao() {
		return dao;
	}

}
