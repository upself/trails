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
	public List<InstalledSoftware> installedSoftwareList(Long softwareLparId, Long softwareId, Account account, Long scopeId) {
		
		List<InstalledSoftware> result = new ArrayList<InstalledSoftware>();
		
		//search all installed software from the same software lpar
		List<InstalledSoftware> InstalledSwList =  entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.software where a.softwareLpar.id = :softwareLparId and a.status = 'ACTIVE' and a.software.id != :softwareId and a.status = 'ACTIVE' and a.software.level = 'LICENSABLE' and a.discrepancyType.name != 'INVALID' and a.discrepancyType.name != 'FALSE HIT' ORDER BY a.software.softwareName")
		.setParameter("softwareLparId", softwareLparId)
		.setParameter("softwareId", softwareId)
		.getResultList();
		
		//filter socpe
		for(InstalledSoftware insw : InstalledSwList){
			@SuppressWarnings("unchecked")
			List<ScheduleF> scheduleFList = entityManager.createQuery(
							" from ScheduleF a where a.status.description='ACTIVE' and a.account =:account and a.softwareName =:swname and a.level =:level")
					.setParameter("account", account)
					.setParameter("swname", insw.getSoftware().getSoftwareName())
					.setParameter("level", "HOSTNAME").getResultList();
			
			for(ScheduleF scheduleF : scheduleFList){
				if(scheduleF.getScope().getId().equals(scopeId)){
					result.add(insw);
					break;
				}
			}
		}
		
		return result;
	}

	public InstalledSoftware getInstalledSoftware(Long installedSoftwareId) {
		return (InstalledSoftware) entityManager
		.createQuery(
				"from InstalledSoftware a join fetch a.software where a.id = :installedSoftwareId")
		.setParameter("installedSoftwareId", installedSoftwareId)
		.getSingleResult();
	}


}
