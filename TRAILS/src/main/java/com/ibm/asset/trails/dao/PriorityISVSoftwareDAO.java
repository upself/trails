package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;

public interface PriorityISVSoftwareDAO extends
		BaseEntityDAO<PriorityISVSoftware, Long> {
	public PriorityISVSoftwareDisplay findPriorityISVSoftwareDisplayById(Long id);
	public PriorityISVSoftware findPriorityISVSoftwareByUniqueKeys(String level, Long manufacturerId, Long customerId);
	public Long total();
	public Long totalHistory(Long priorityISVSoftwareId);
	public List<PriorityISVSoftwareDisplay> getAllPriorityISVSoftwareDisplays(Integer startIndex, Integer pageSize);
}
