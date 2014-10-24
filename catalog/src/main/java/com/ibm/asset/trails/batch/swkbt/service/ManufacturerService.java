package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.ManufacturerType;
import com.ibm.asset.trails.domain.Manufacturer;

public interface ManufacturerService extends
		KbDefinitionService<Manufacturer, ManufacturerType, Long> {

	boolean isIBMManufacturer(Long manufacturer);

	boolean isIBMManufacturer(String manufacturer);

}
