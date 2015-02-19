package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.InstalledSoftwareDAO;
import com.ibm.asset.trails.domain.InstalledSoftware;

@Repository
public class InstalledSoftwareDAOJpa extends AbstractGenericEntityDAOJpa<InstalledSoftware, Long>
		implements InstalledSoftwareDAO {

	@SuppressWarnings("unchecked")
	public List<InstalledSoftware> installedSoftwareList(Long softwareLparId, Long softwareId) {
		return entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.software where a.softwareLpar.id = :softwareLparId and a.status = 'ACTIVE' and a.software.id != :softwareId and a.status = 'ACTIVE' and a.software.level = 'LICENSABLE' and a.discrepancyType.name != 'INVALID' and a.discrepancyType.name != 'FALSE HIT' ORDER BY a.software.softwareName")
		.setParameter("softwareLparId", softwareLparId)
		.setParameter("softwareId", softwareId)
		.getResultList();
	}

	public InstalledSoftware getInstalledSoftware(Long installedSoftwareId) {
		return (InstalledSoftware) entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.software where a.id = :installedSoftwareId")
		.setParameter("installedSoftwareId", installedSoftwareId)
		.getSingleResult();
	}


}
