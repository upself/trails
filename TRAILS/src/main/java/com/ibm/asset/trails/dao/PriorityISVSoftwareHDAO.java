package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.PriorityISVSoftwareH;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;

public interface PriorityISVSoftwareHDAO extends
		BaseEntityDAO<PriorityISVSoftwareH, Long> {
	public List<PriorityISVSoftwareHDisplay> findPriorityISVSoftwareHDisplaysByISVSoftwareId(Long priorityISVSoftwareId,Integer startIndex, Integer pageSize);
}
