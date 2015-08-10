package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.ReconPriorityISVSoftware;

public interface ReconPriorityISVSoftwareDAO extends
		BaseEntityDAO<ReconPriorityISVSoftware, Long> {
	public ReconPriorityISVSoftware findReconPriorityISVSoftwareByUniqueKeys(Long manufacturerId, Long customerId);
}
