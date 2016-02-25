package com.ibm.asset.trails.dao.jpa;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.InstalledSoftwareDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.ScheduleF;

@Repository
public class InstalledSoftwareDAOJpa extends AbstractGenericEntityDAOJpa<InstalledSoftware, Long>
		implements InstalledSoftwareDAO {
	
	@SuppressWarnings("unchecked")
	public List<InstalledSoftware> installedSoftwareList(Long softwareLparId, Long softwareId) {
		
		List<InstalledSoftware> InstalledSwList =  entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.software where a.softwareLpar.id = :softwareLparId and a.status = 'ACTIVE' and a.software.id != :softwareId and a.status = 'ACTIVE' and a.software.level = 'LICENSABLE' and a.discrepancyType.name != 'INVALID' and a.discrepancyType.name != 'FALSE HIT' ORDER BY a.software.softwareName")
		.setParameter("softwareLparId", softwareLparId)
		.setParameter("softwareId", softwareId)
		.getResultList();
		
		return InstalledSwList;
	}

	public InstalledSoftware getInstalledSoftware(Long installedSoftwareId) {
		return (InstalledSoftware) entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.software where a.id = :installedSoftwareId")
		.setParameter("installedSoftwareId", installedSoftwareId)
		.getSingleResult();
	}


}
