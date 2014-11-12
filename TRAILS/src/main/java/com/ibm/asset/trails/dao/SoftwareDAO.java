package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.Software;

public interface SoftwareDAO extends BaseEntityDAO<Software, Long> {

	Software getSoftwareDetails(Long softwareId);
	
	List<Software> findSoftwareBySoftwareName(String softwareName);
	
	List<Software> findInactiveSoftwareBySoftwareName(String softwareName);
	
}
