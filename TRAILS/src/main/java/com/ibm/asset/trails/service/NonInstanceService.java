package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.Software;

public interface NonInstanceService {
	
	public NonInstanceDisplay findNonInstanceDisplayById(Long Id);
	public List<NonInstanceDisplay> findNonInstanceDisplays(NonInstanceDisplay nonInstanceDisplay);
	public List<NonInstanceHDisplay> findNonInstanceHDisplays(Long nonInstanceId);
}
