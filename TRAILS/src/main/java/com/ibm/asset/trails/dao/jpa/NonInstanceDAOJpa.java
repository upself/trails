package com.ibm.asset.trails.dao.jpa;
import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.NonInstanceDAO;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.CapacityType_;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Manufacturer_;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.NonInstance_;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Software_;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.domain.Status_;

@Repository
public class NonInstanceDAOJpa extends
		AbstractGenericEntityDAOJpa<NonInstance, Long> implements
		NonInstanceDAO {

	
	@SuppressWarnings("unchecked")
	public NonInstanceDisplay findNonInstanceDisplayById(Long Id) {
		// TODO Auto-generated method stub
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<NonInstanceDisplay> q = cb.createQuery(NonInstanceDisplay.class);
		Root<NonInstance> nonInstance = q.from(NonInstance.class);
		
		Join<NonInstance, Software> software = nonInstance.join(NonInstance_.software, JoinType.LEFT);
		Join<NonInstance, Manufacturer> manufacturer = nonInstance.join(NonInstance_.manufacturer, JoinType.LEFT);
		Join<NonInstance, CapacityType> capacityType = nonInstance.join(NonInstance_.capacityType, JoinType.LEFT);
		Join<NonInstance, Status> status = nonInstance.join(NonInstance_.status, JoinType.LEFT);
		
		q.where(cb.equal(nonInstance.get(NonInstance_.id), Id));
		
		q.multiselect(
				nonInstance.get(NonInstance_.id).alias("id"),
				software.get(Software_.softwareId).alias("softwareId"),
				software.get(Software_.softwareName).alias("softwareName"),
				manufacturer.get(Manufacturer_.manufacturerName).alias("manufacturerName"),
				nonInstance.get(NonInstance_.restriction).alias("restriction"),
				capacityType.get(CapacityType_.code).alias("capacityCode"),
				capacityType.get(CapacityType_.description).alias("capacityDesc"),
				nonInstance.get(NonInstance_.baseOnly).alias("baseOnly"),
				status.get(Status_.id).alias("statusId"),
				status.get(Status_.description).alias("statusDesc"),
				nonInstance.get(NonInstance_.remoteUser).alias("remoteUser"),
				nonInstance.get(NonInstance_.recordTime).alias("recordTime"));
		
		TypedQuery<NonInstanceDisplay> typedQuery = entityManager.createQuery(q);
		List<NonInstanceDisplay> result = typedQuery.getResultList();

		if(null != result){
			return result.get(0);
		}else{
			return null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<NonInstanceDisplay> findNonInstanceDisplays(
			NonInstanceDisplay nonInstanceDisplay) {
		// TODO Auto-generated method stub
		String hql = "select new com.ibm.asset.trails.domain.NonInstanceDisplay(non.id, non.software.softwareId, non.software.softwareName, "
				+ "non.manufacturer.manufacturerName, non.restriction, non.capacityType.code, non.capacityType.description, "
				+ "non.baseOnly, non.status.id, non.status.description, non.remoteUser, non.recordTime) from NonInstance as non where 1=1";
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

	@SuppressWarnings("unchecked")
	public List<NonInstanceHDisplay> findNonInstanceHDisplays(Long nonInstanceId) {
		// TODO Auto-generated method stub
		String hql = "select new com.ibm.asset.trails.domain.NonInstanceHDisplay(non.id,non.nonInstanceId, "
				+ "non.software.softwareId, non.software.softwareName, "
				+ "non.manufacturer.manufacturerName, non.restriction, non.capacityType.code, "
				+ "non.capacityType.description, non.baseOnly, non.status.id, non.status.description,"
				+ "non.remoteUser, non.recordTime) from NonInstanceH as non where nonInstanceId = " + nonInstanceId;
		
		List<NonInstanceHDisplay> list =  entityManager.createQuery(hql).getResultList();

		return list;
	}
}
