package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;

public interface NonInstanceService {
	
	public List<NonInstanceDisplay> findNonInstanceDisplays(NonInstanceDisplay nonInstanceDisplay);
	public NonInstance findNonInstancesDisplayById(Long id);
	
	public List<NonInstanceHDisplay> findNonInstanceHDisplays(Long nonInstanceId);
	
	public List<NonInstance> findNonInstancesByRestriction(String restriction);
	public List<NonInstance> findNonInstancesBySoftwareId(long softwareId);
	public List<NonInstance> findNonInstancesByManufacturerId(Long manufacturerId);
	public void removeNonInsanceById(Long id);
}
