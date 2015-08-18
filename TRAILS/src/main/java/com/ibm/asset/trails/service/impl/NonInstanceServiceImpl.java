package com.ibm.asset.trails.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;




import javax.servlet.http.HttpServletRequest;





import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;





import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.CapacityType_;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Manufacturer_;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceH;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.NonInstance_;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Software_;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.domain.Status_;
import com.ibm.asset.trails.service.NonInstanceService;

@Service
public class NonInstanceServiceImpl implements NonInstanceService{

	private EntityManager em;
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public NonInstanceDisplay findNonInstanceDisplayById(Long Id) {
		// TODO Auto-generated method stub
		CriteriaBuilder cb = getEntityManager().getCriteriaBuilder();
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
		
		TypedQuery<NonInstanceDisplay> typedQuery = getEntityManager().createQuery(q);
		List<NonInstanceDisplay> result = typedQuery.getResultList();

		if(null != result){
			return result.get(0);
		}else{
			return null;
		}
	}

	@Override
	public Long total(NonInstanceDisplay nonInstanceDisplay) {
		// TODO Auto-generated method stub
		String hql = "Select COUNT(*) From NonInstance non "
				+ " Join non.software "
				+ " Join non.manufacturer"
				+ " Join non.capacityType"
				+ " Join non.status"
				+ " Where 1=1";
		
		if(nonInstanceDisplay.getId() != null){
			hql += " and non.id = " + nonInstanceDisplay.getId();
		}
		
		if(nonInstanceDisplay.getSoftwareId() != null){
			hql += " and non.software.softwareId = " + nonInstanceDisplay.getSoftwareId();
		}
		
		if(nonInstanceDisplay.getSoftwareName() != null && !"".equals(nonInstanceDisplay.getSoftwareName())){
			hql += " and UCASE(non.software.softwareName) like UCASE('%" + nonInstanceDisplay.getSoftwareName() + "%')";
		}
		
		if(nonInstanceDisplay.getManufacturerName() != null && !"".equals(nonInstanceDisplay.getManufacturerName())){
			hql += " and UCASE(non.manufacturer.manufacturerName) like UCASE('%" + nonInstanceDisplay.getManufacturerName() + "%')";
		}
		
		if(nonInstanceDisplay.getRestriction() != null && !"".equals(nonInstanceDisplay.getRestriction())){
			hql += " and UCASE(non.restriction) like UCASE('%" + nonInstanceDisplay.getRestriction() + "%')";
		}
		
		if(nonInstanceDisplay.getCapacityCode() != null){
			hql += " and non.capacityType.code = " + nonInstanceDisplay.getCapacityCode();
		}
		
		if(nonInstanceDisplay.getCapacityDesc() != null  && !"".equals(nonInstanceDisplay.getCapacityDesc())){
			hql += " and UCASE(non.capacityType.description) like UCASE('%" + nonInstanceDisplay.getCapacityDesc() + "%')";
		}
		
		
		if(nonInstanceDisplay.getBaseOnly() != null){
			hql += " and non.baseOnly =" + nonInstanceDisplay.getBaseOnly();
		}
		
		if(nonInstanceDisplay.getStatusId() != null){
			hql += " and non.status.id =" + nonInstanceDisplay.getStatusId();
		}
		
		if(nonInstanceDisplay.getStatusDesc() != null && !"".equals(nonInstanceDisplay.getStatusDesc())){
			hql += " and UCASE(non.status.description) like UCASE('%" + nonInstanceDisplay.getStatusDesc() + "%')";
		}
		
		if(nonInstanceDisplay.getRemoteUser() != null && !"".equals(nonInstanceDisplay.getRemoteUser())){
			hql += " and UCASE(non.remoteUser) like UCASE('%" + nonInstanceDisplay.getRemoteUser() + "%')";
		}
		
		Long total =  (Long)getEntityManager().createQuery(hql).getSingleResult();


		return total;
	}


	@Override
	public Long totalHistory(Long nonInstanceId) {
		// TODO Auto-generated method stub		
		Long total =  (Long)getEntityManager()
				.createNamedQuery("nonInstanceHTotalById")
				.setParameter("nonInstanceId", nonInstanceId)
				.getSingleResult();

		return total;
	}


	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstances(
			NonInstanceDisplay nonInstanceDisplay, Integer startIndex, Integer pageSize) {
		// TODO Auto-generated method stub
		String hql = "From NonInstance non "
				+ " Join Fetch non.software "
				+ " Join Fetch non.manufacturer"
				+ " Join Fetch non.capacityType"
				+ " Join Fetch non.status"
				+ " Where 1=1";
		
		if(nonInstanceDisplay.getId() != null){
			hql += " and non.id = " + nonInstanceDisplay.getId();
		}
		
		if(nonInstanceDisplay.getSoftwareId() != null){
			hql += " and non.software.softwareId = " + nonInstanceDisplay.getSoftwareId();
		}
		
		if(nonInstanceDisplay.getSoftwareName() != null && !"".equals(nonInstanceDisplay.getSoftwareName())){
			hql += " and UCASE(non.software.softwareName) like UCASE('%" + nonInstanceDisplay.getSoftwareName() + "%')";
		}
		
		if(nonInstanceDisplay.getManufacturerName() != null && !"".equals(nonInstanceDisplay.getManufacturerName())){
			hql += " and UCASE(non.manufacturer.manufacturerName) like UCASE('%" + nonInstanceDisplay.getManufacturerName() + "%')";
		}
		
		if(nonInstanceDisplay.getRestriction() != null && !"".equals(nonInstanceDisplay.getRestriction())){
			hql += " and UCASE(non.restriction) like UCASE('%" + nonInstanceDisplay.getRestriction() + "%')";
		}
		
		if(nonInstanceDisplay.getCapacityCode() != null){
			hql += " and non.capacityType.code = " + nonInstanceDisplay.getCapacityCode();
		}
		
		if(nonInstanceDisplay.getCapacityDesc() != null  && !"".equals(nonInstanceDisplay.getCapacityDesc())){
			hql += " and UCASE(non.capacityType.description) like UCASE('%" + nonInstanceDisplay.getCapacityDesc() + "%')";
		}
		
		
		if(nonInstanceDisplay.getBaseOnly() != null){
			hql += " and non.baseOnly =" + nonInstanceDisplay.getBaseOnly();
		}
		
		if(nonInstanceDisplay.getStatusId() != null){
			hql += " and non.status.id =" + nonInstanceDisplay.getStatusId();
		}
		
		if(nonInstanceDisplay.getStatusDesc() != null && !"".equals(nonInstanceDisplay.getStatusDesc())){
			hql += " and UCASE(non.status.description) like UCASE('%" + nonInstanceDisplay.getStatusDesc() + "%')";
		}
		
		if(nonInstanceDisplay.getRemoteUser() != null && !"".equals(nonInstanceDisplay.getRemoteUser())){
			hql += " and UCASE(non.remoteUser) like UCASE('%" + nonInstanceDisplay.getRemoteUser() + "%')";
		}
		
		List<NonInstance> list =  getEntityManager().createQuery(hql).setFirstResult(startIndex).setMaxResults(pageSize).getResultList();

		return list;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceH> findNonInstanceHs(Long nonInstanceId,Integer startIndex, Integer pageSize) {
		
		String hql = "From NonInstanceH non "
				+ " Join Fetch non.software "
				+ " Join Fetch non.manufacturer"
				+ " Join Fetch non.capacityType"
				+ " Join Fetch non.status"
				+ " Where non.nonInstanceId = :nonInstanceId";
		
		List<NonInstanceH> list = getEntityManager().createQuery(hql)
		.setParameter("nonInstanceId", nonInstanceId)
		.getResultList();
		
		return list;
	}
	
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateNonInstance(NonInstance nonInstance) {
		// TODO Auto-generated method stub
		NonInstance dbNonInstance = (NonInstance)getEntityManager()
				.createNamedQuery("findNonInstancesById")
				.setParameter("id", nonInstance.getId())
				.getResultList().get(0);
		
		if(null != dbNonInstance){
			NonInstanceH nonInstanceH = new NonInstanceH();
			nonInstanceH.setNonInstanceId(dbNonInstance.getId());
			nonInstanceH.setSoftware(dbNonInstance.getSoftware());
			nonInstanceH.setManufacturer(dbNonInstance.getManufacturer());
			nonInstanceH.setRestriction(dbNonInstance.getRestriction());
			nonInstanceH.setCapacityType(dbNonInstance.getCapacityType());
			nonInstanceH.setBaseOnly(dbNonInstance.getBaseOnly());
			nonInstanceH.setStatus(dbNonInstance.getStatus());
			nonInstanceH.setRemoteUser(dbNonInstance.getRemoteUser());
			nonInstanceH.setRecordTime(dbNonInstance.getRecordTime());
			getEntityManager().persist(nonInstanceH);
		
			
			dbNonInstance.setSoftware(nonInstance.getSoftware());
			dbNonInstance.setManufacturer(nonInstance.getManufacturer());
			dbNonInstance.setRestriction(nonInstance.getRestriction());
			dbNonInstance.setCapacityType(nonInstance.getCapacityType());
			dbNonInstance.setBaseOnly(nonInstance.getBaseOnly());
			dbNonInstance.setStatus(nonInstance.getStatus());
			dbNonInstance.setRemoteUser(nonInstance.getRemoteUser());
			dbNonInstance.setRecordTime(nonInstance.getRecordTime());
			getEntityManager().merge(dbNonInstance);
		}
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveNonInstance(NonInstance nonInstance) {
		// TODO Auto-generated method stub
			getEntityManager().persist(nonInstance);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Software> findSoftwareBySoftwareName(String softwareName) {
		// TODO Auto-generated method stub
		List<Software>  results = getEntityManager()
				.createNamedQuery("softwareBySoftwareName")
				.setParameter("name", softwareName.toUpperCase())
				.getResultList();
		if (results == null || results.isEmpty() ) {
			results = null;
		} else {
			return results;
		}
		return results;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Manufacturer> findManufacturerByName(String manufacturerName) {
		// TODO Auto-generated method stub
		List<Manufacturer> results = getEntityManager()
				.createNamedQuery("manufacturerByName")
				.setParameter("name", manufacturerName.toUpperCase())
				.getResultList();
		if (results == null || results.isEmpty() ) {
			results = null;
		} else {
			return results;
		}
		return results;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Software> findSoftwareBySoftwareNameLike(String softwareName,Integer maxResult) {
		// TODO Auto-generated method stub
		
		if(null == maxResult){
			return getEntityManager()
					.createNamedQuery("softwareBySoftwareNameLike")
					.setParameter("name", "%" + softwareName.toUpperCase() + "%")
					.getResultList();
		}else{
			return getEntityManager()
					.createNamedQuery("softwareBySoftwareNameLike")
					.setParameter("name", "%" + softwareName.toUpperCase() + "%")
					.setMaxResults(maxResult)
					.getResultList();
		}
		
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Manufacturer> findManufacturerByNameLike(String manufacturerName,Integer maxResult) {
		// TODO Auto-generated method stub
		
		if(null == maxResult){
			return getEntityManager()
					.createNamedQuery("manufacturerByNameLike")
					.setParameter("name", "%" + manufacturerName.toUpperCase() + "%")
					.getResultList();
		}else{
			return getEntityManager()
					.createNamedQuery("manufacturerByNameLike")
					.setParameter("name", "%" + manufacturerName.toUpperCase() + "%")
					.setMaxResults(maxResult)
					.getResultList();
		}
		
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<CapacityType> findCapacityTypeByDesc(String desc) {
		// TODO Auto-generated method stub
		List<CapacityType> results = getEntityManager()
				.createNamedQuery("capacityTypeByDesc")
				.setParameter("desc", desc)
				.getResultList();
		if (results == null || results.isEmpty() ) {
			results = null;
		} else {
			return results;
		}
		return results;
	}
	
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<CapacityType> findCapacityTypeByCode(Integer code) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("capacityTypeByCode")
				.setParameter("code", code)
				.getResultList();
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<CapacityType> findAllCapacityType() {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("capacityTypeList")
				.getResultList();
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstanceByswIdAndCapacityCode(
			Long softwareId, Integer capacityCode) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("findNonInstancesBySwIdAndCapacityCode")
				.setParameter("softwareId", softwareId)
				.setParameter("code", capacityCode)
				.getResultList();
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstanceByswIdAndCapacityCodeNotEqId(
			Long softwareId, Integer capacityCode, Long id) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("findNonInstancesBySwIdAndCapacityCodeNotEqId")
				.setParameter("softwareId", softwareId)
				.setParameter("code", capacityCode)
				.setParameter("id", id)
				.getResultList();
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Status> findStatusByDesc(String StatusDesc) {
		List<Status> results =  getEntityManager()
				.createNamedQuery("statusDetails")
				.setParameter(
						"description", StatusDesc)
						.getResultList();
		if (results == null || results.isEmpty()) {
			results = null;
		} else {
			return results;
		}
		return results;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findBySoftwareNameAndCapacityCode(String softwareName, Integer capacityCode){
		// TODO Auto-generated method stub
		List<NonInstance> results =  getEntityManager()
				.createNamedQuery("findNonInstancesBySwNameAndCapacityCode")
				.setParameter("softwareName", softwareName)
				.setParameter("code", capacityCode)
				.getResultList();
		if (results == null || results.isEmpty() ) {
			results = null;
		} else {
			return results;
		}
		return results;
	}

	@PersistenceContext(unitName="trailspd")
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    private EntityManager getEntityManager() {
        return em;
    }
}
