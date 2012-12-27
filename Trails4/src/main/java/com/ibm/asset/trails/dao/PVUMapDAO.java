package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.PvuMap;

public interface PVUMapDAO extends BaseEntityDAO<PvuMap,Long> {

	PvuMap getPvuMapByBrandAndModelAndMachineTypeId(String lsProcessorBrand,
			String lsProcessorModel, MachineType lmtAlert);


}
