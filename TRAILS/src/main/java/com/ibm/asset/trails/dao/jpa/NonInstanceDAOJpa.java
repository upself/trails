package com.ibm.asset.trails.dao.jpa;

import java.util.List;
import org.springframework.stereotype.Repository;
import com.ibm.asset.trails.dao.NonInstanceDAO;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;

@Repository
public class NonInstanceDAOJpa extends
		AbstractGenericEntityDAOJpa<NonInstance, Long> implements
		NonInstanceDAO {

	public List<NonInstanceDisplay> findNonInstanceDisplays(
			NonInstanceDisplay nonInstanceDisplay) {
		// TODO Auto-generated method stub
		String hql = "select new com.ibm.asset.trails.domain.NonInstanceDisplay(non.id, non.software.softwareId, non.software.softwareName, "
				+ "non.manufacturer.manufacturerName, non.restriction, non.capacityType.code, non.capacityType.description, "
				+ "non.baseOnly, non.status.id, non.status.description) from NonInstance as non where 1=1";
		if(nonInstanceDisplay.getId() != null){
			hql += " and non.id = " + nonInstanceDisplay.getId();
		}
		
		if(nonInstanceDisplay.getSoftwareName() != null && !"".equals(nonInstanceDisplay.getSoftwareName())){
			hql += " and non.software.softwareName like '%" + nonInstanceDisplay.getSoftwareName() + "%'";
		}
		
		if(nonInstanceDisplay.getManufacturerName() != null && !"".equals(nonInstanceDisplay.getManufacturerName())){
			hql += " and non.manufacturer.manufacturerName like '%" + nonInstanceDisplay.getManufacturerName() + "%'";
		}
		
		if(nonInstanceDisplay.getRestriction() != null && !"".equals(nonInstanceDisplay.getRestriction())){
			hql += " and non.restriction like '%" + nonInstanceDisplay.getRestriction() + "%'";
		}
		
		if(nonInstanceDisplay.getCapacityDesc() != null  && !"".equals(nonInstanceDisplay.getCapacityDesc())){
			hql += " and non.capacityType.description like '%" + nonInstanceDisplay.getCapacityDesc() + "%'";
		}
		
		if(nonInstanceDisplay.getBaseOnly() != null){
			hql += " and non.baseOnly =" + nonInstanceDisplay.getBaseOnly();
		}
		
		if(nonInstanceDisplay.getStatusId() != null){
			hql += " and non.status.id =" + nonInstanceDisplay.getSoftwareId();
		}
		
		List<NonInstanceDisplay> list =  entityManager.createQuery(hql).getResultList();

		return list;
	}

	public NonInstance findNonInstancesDisplayById(Long id) {
		// TODO Auto-generated method stub
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<NonInstance> findNonInstancesByRestriction(String restriction) {
		return entityManager
			   .createNamedQuery("findNonInstancesByRestriction")
			   .setParameter("restriction", restriction).getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<NonInstance> findNonInstancesBySoftwareId(long softwareId) {
		return entityManager
			   .createNamedQuery("findNonInstancesBySoftwareId")
			   .setParameter("softwareId", softwareId).getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<NonInstance> findNonInstancesByManufacturerId(Long manufacturerId) {
		return entityManager
			   .createNamedQuery("findNonInstancesByManufacturerId")
			   .setParameter("manufacturerId", manufacturerId).getResultList();
	}

	public void removeNonInsanceById(Long id) {
		entityManager
		   .createNamedQuery("removeNonInstanceById")
		   .setParameter("id", id).executeUpdate();
	}
}
