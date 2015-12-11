package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.swkbt.schema.DistributedProductType;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.ReconService;
import com.ibm.asset.trails.dao.ProductDao;
import com.ibm.asset.trails.dao.ProductInfoDao;
import com.ibm.asset.trails.domain.DomainEntity;
import com.ibm.asset.trails.domain.ProductInfo;
import com.ibm.asset.trails.domain.Recon;

@Service
public class ProductInfoServiceImpl extends
		ProductServiceImpl<ProductInfo, DistributedProductType, Long> implements
		ProductInfoService, InitializingBean {
	private static final Log log = LogFactory
			.getLog(ProductInfoServiceImpl.class);

	@Autowired
	private ProductInfoDao dao;
	@Autowired
	private ManufacturerService manufacturerService;
	@Autowired
	private  ReconService<?, ?> reconService;
	@Autowired
	private InputStream guidFileInputStream;
	private static final List<String> licGuids = new ArrayList<String>();

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	public void save(DistributedProductType xmlEntity) {
		ProductInfo existing = findByNaturalKey(xmlEntity.getGuid());
		if ( xmlEntity.getManufacturer() == null ) {
			log.error("Manufacturer is NULL skipping record -- " + xmlEntity.toString());
			return;
		} else {
			log.debug("Manufacturer is " + xmlEntity.getManufacturer());
		}
		if (existing == null) {
			existing = new ProductInfo();
			existing = update(existing, xmlEntity);
			recon(existing, xmlEntity);
		} else {
			log.debug("Have existing record -- " + existing.toString());
			recon(existing, xmlEntity);
			existing = super.update(existing, xmlEntity);
		}
		merge(existing);
	}

	@Override
	public ProductInfo update(ProductInfo existing,
			DistributedProductType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setSoftwareCategoryId(1000L);
		existing.setPriority(1);
		existing.setLicensable(false);
		existing.setChangeJustification("New add");
		existing.setRemoteUser("SWKBT");
		existing.setRecordTime(new Date());
		return existing;
	}

	protected void recon(ProductInfo existing, DistributedProductType xmlEntity) {
		boolean recon = false;
		if (manufacturerChange(existing, xmlEntity)) {
			log.debug("manufacturer changed!");
			recon = true;
		}
		if (softwareNameChange(existing, xmlEntity)) {
			log.debug("software name changed!");
			recon = true;
		}
		if (licenseTypeChange(existing, xmlEntity)) {
			log.debug("license type changed!");
			recon = true;
		} else if (deletedChange(existing, xmlEntity)) {
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
		Recon existing = (Recon) reconService.findByNaturalKey(newEntity.getId());
		if (existing == null){
		log.debug(" Recon doesn't exist");
		Recon recon = new Recon();
		recon.setAction("UPDATE");
		recon.setRecordTime(new Date());
		recon.setRemoteUser("SWKBT");
		recon.setProductInfo(newEntity);
		newEntity.setRecon(recon);
		} else {
			log.debug(" Recon exists");
		newEntity.setRecon(existing);
		}
	}

	private boolean vendorManagedChange(ProductInfo existing,
			DistributedProductType xmlEntity) {
		Boolean existingVM = new Boolean(existing.getVendorManaged());
		Boolean newVM = new Boolean(xmlEntity.getCustomField2());

		if (existingVM.equals(newVM)) {
			return false;
		} else {
			return true;
		}
	}

	private boolean deletedChange(ProductInfo existing,
			DistributedProductType xmlEntity) {
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
		} else if (existing.getDeleted().equals(xmlEntity.isDeleted())) {
			log.debug("existing equals xmlentity");
			return false;
		}
		log.debug("nothing...reconning");
		return true;
	}

	private boolean licenseTypeChange(ProductInfo existing,
			DistributedProductType xmlEntity) {
		boolean override = licensableOverrideExists(xmlEntity.getGuid());
		if ( override == true ) {
			log.debug("Must flip licensable -- " + xmlEntity.getGuid() );			
		}
		boolean licensable = false;
		boolean existingLicensable = existing.getLicensable();
		if (  manufacturerService.isIBMManufacturer(xmlEntity.getManufacturer())  ) {
			if ( override ) {
					existing.setLicensable(true);
					return (existingLicensable == true)? false:true ;
			}
			return false;
		} else if (xmlEntity.getLicenseType() != null && xmlEntity.getLicenseType().intValue() == 1) {
				existing.setLicensable(true);
				return (true == existingLicensable)? false:true ;		
		} else {
			licensable = (override == true) ? true : false;			
				existing.setLicensable(licensable);
				return (licensable == existingLicensable)? false:true ;
		}
	}

	public boolean licensableOverrideExists(String guid) {
		boolean override;
		log.debug("Checking to flip -- " + guid);
		if (licGuids.contains(guid)) {
			override = true;
			log.debug("Found guid for licensable flip -- " + guid);
		} else {
			override = false;
		}
		return override;
	}

	private boolean manufacturerChange(ProductInfo existing,
			DistributedProductType xmlEntity) {
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
			DistributedProductType xmlEntity) {

		if (!existing.getName().equals(xmlEntity.getName())) {
			return true;
		}
		return false;
	}
	
	public void afterPropertiesSet() throws Exception {
		String line;
		try {
			BufferedReader r1 = new BufferedReader(new InputStreamReader(
					guidFileInputStream, "UTF-8"));
			while ((line = r1.readLine()) != null) {
				licGuids.add(line.trim());
//				log.debug("Will flip guid -- " + line.trim() );
			}
		} finally {
			guidFileInputStream.close();
		}
	}

	@Override
	public ProductDao<ProductInfo, Long> getDao() {
		return dao;
	}

}
