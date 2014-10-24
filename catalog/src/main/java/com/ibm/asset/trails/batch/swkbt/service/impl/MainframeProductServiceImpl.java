package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.Serializable;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.swkbt.schema.DistributedProductType;
import com.ibm.asset.swkbt.schema.MainframeProductType;
import com.ibm.asset.trails.batch.swkbt.service.AliasService;
import com.ibm.asset.trails.batch.swkbt.service.MainframeProductService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.ProductService;
import com.ibm.asset.trails.domain.Alias;
import com.ibm.asset.trails.domain.Product;

public abstract class MainframeProductServiceImpl<E extends Product, X extends MainframeProductType, I extends Serializable>
		extends SoftwareItemServiceImpl<E, X, I> implements
		MainframeProductService<E, X, I> {

	@Autowired
	private AliasService aliasService;
	@Autowired
	private ManufacturerService manufacturerService;

	@Override
	public E update(E existing, final X xmlEntity) {
		existing = super.update(existing, xmlEntity);
//		existing.setIpla(xmlEntity.getIPLA());
//		existing.setPvu(xmlEntity.isPVU());
//		existing.setFunction(xmlEntity.getFunction());
//		existing.setLicenseType(xmlEntity.getLicenseType());
//		existing.setSubCapacityLicensing(xmlEntity.isSubCapacityLicensing());
		Long manufacturer = manufacturerService.findIdByNaturalKey(xmlEntity
				.getManufacturer());
		existing.setManufacturer(manufacturer);
		Set<Alias> alias = aliasService.findFromXmlSet(xmlEntity.getAlias());
		existing.getAlias().retainAll(alias);
		existing.getAlias().addAll(alias);
		return existing;
	}

}
