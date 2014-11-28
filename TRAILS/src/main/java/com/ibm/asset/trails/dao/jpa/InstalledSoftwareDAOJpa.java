package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.InstalledSoftwareDAO;
import com.ibm.asset.trails.domain.InstalledSoftware;

@Repository
public class InstalledSoftwareDAOJpa extends AbstractGenericEntityDAOJpa<InstalledSoftware, Long>
		implements InstalledSoftwareDAO {

	@SuppressWarnings("unchecked")
	public List<InstalledSoftware> installedSoftwareList(Long softwareLparId, Long productInfoId) {
		return entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.productInfo where a.softwareLpar.id = :softwareLparId and a.status = 'ACTIVE' and a.productInfo.id != :productInfoId and a.status = 'ACTIVE' and a.productInfo.licensable = 1 and a.discrepancyType.name != 'INVALID' and a.discrepancyType.name != 'FALSE HIT' ORDER BY a.productInfo.name")
		.setParameter("softwareLparId", softwareLparId)
		.setParameter("productInfoId", productInfoId)
		.getResultList();
	}

	public InstalledSoftware getInstalledSoftware(Long installedSoftwareId) {
		return (InstalledSoftware) entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.productInfo where a.id = :installedSoftwareId")
		.setParameter("installedSoftwareId", installedSoftwareId)
		.getSingleResult();
	}


}
