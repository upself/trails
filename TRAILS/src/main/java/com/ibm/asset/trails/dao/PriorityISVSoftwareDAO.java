package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;

public interface PriorityISVSoftwareDAO extends
		BaseEntityDAO<PriorityISVSoftware, Long> {
	public PriorityISVSoftwareDisplay findPriorityISVSoftwareDisplayById(Long id);
	public PriorityISVSoftware findPriorityISVSoftwareByUniqueKeys(String level, Long manufacturerId, Long customerId);
	public List<PriorityISVSoftwareDisplay> getAllPriorityISVSoftwareDisplays();
}
