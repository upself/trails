package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.NonInstanceH;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.Software;

public interface NonInstanceService {
	
	public NonInstanceDisplay findNonInstanceDisplayById(Long Id);
	public Long total(NonInstanceDisplay nonInstanceDisplay);
	public Long totalHistory(Long nonInstanceId);
	public List<NonInstance> findNonInstances(NonInstanceDisplay nonInstanceDisplay,Integer startIndex, Integer pageSize);
	public List<NonInstanceH> findNonInstanceHs(Long nonInstanceId,Integer startIndex, Integer pageSize);
	
	public void updateNonInstance(NonInstance nonInstance);
	public void saveNonInstance(NonInstance nonInstance);
    
	public List<Software> findSoftwareBySoftwareName(String softwareName);
	public List<Manufacturer> findManufacturerByName(String manufacturerName);
	
	public List<Software> findSoftwareBySoftwareNameLike(String softwareName,Integer maxResult);
	public List<Manufacturer> findManufacturerByNameLike(String manufacturerName, Integer maxResult);
	
	public List<CapacityType> findCapacityTypeByDesc(String desc);
	public List<CapacityType> findCapacityTypeByCode(Integer code);
	public List<CapacityType> findAllCapacityType();

	public List<NonInstance> findNonInstanceByswIdAndCapacityCode(Long softwareId, Integer capacityCode);
	public List<NonInstance> findNonInstanceByswIdAndCapacityCodeNotEqId(Long softwareId, Integer capacityCode, Long id);
	public List<Status> findStatusByDesc(String trim);
	public List<NonInstance> findBySoftwareNameAndCapacityCode(
			String softwareName, Integer code);

}
