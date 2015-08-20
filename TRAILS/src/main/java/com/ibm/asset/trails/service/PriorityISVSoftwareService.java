package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;

public interface PriorityISVSoftwareService {
	
	public PriorityISVSoftwareDisplay findPriorityISVSoftwareDisplayById(Long id);
	public void updatePriorityISVSoftware(PriorityISVSoftware priorityISVSoftware);
	public void addPriorityISVSoftware(PriorityISVSoftware priorityISVSoftware);
	public PriorityISVSoftware findPriorityISVSoftwareByUniqueKeys(String level, Long manufacturerId, Long customerId);
	public Long total();
	public Long totalHistory(Long priorityISVSoftwareId);
	public List<PriorityISVSoftwareDisplay> getAllPriorityISVSoftwareDisplays(Integer startIndex, Integer pageSize);
	public List<PriorityISVSoftwareHDisplay> findPriorityISVSoftwareHDisplaysByISVSoftwareId(Long priorityISVSoftwareId,Integer startIndex, Integer pageSize);
}
