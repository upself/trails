package com.ibm.asset.trails.dao.jpa;
import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.PriorityISVSoftwareDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.Account_;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Manufacturer_;
import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftware_;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.domain.Status_;

@Repository
public class PriorityISVSoftwareDAOJap extends
		AbstractGenericEntityDAOJpa<PriorityISVSoftware, Long> implements
		PriorityISVSoftwareDAO {

	@Override
	public PriorityISVSoftwareDisplay findPriorityISVSoftwareDisplayById(Long id) {
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<PriorityISVSoftwareDisplay> q = cb.createQuery(PriorityISVSoftwareDisplay.class);
		Root<PriorityISVSoftware> priorityISVSoftware = q.from(PriorityISVSoftware.class);
		//Inner Join Manufacturer Object for MANUFACTURER DB Table
		Join<PriorityISVSoftware, Manufacturer> manufacturer = priorityISVSoftware.join(PriorityISVSoftware_.manufacturer, JoinType.INNER);
		//Inner Join Status Object for STATUS DB Table
		Join<PriorityISVSoftware, Status> status = priorityISVSoftware.join(PriorityISVSoftware_.status, JoinType.INNER);
		//Left Outer Join Account Object for CUSTOMER DB Table
		Join<PriorityISVSoftware, Account> account = priorityISVSoftware.join(PriorityISVSoftware_.account, JoinType.LEFT);
				
		
		q.where(cb.equal(priorityISVSoftware.get(PriorityISVSoftware_.id), id));
		
		q.multiselect(
				priorityISVSoftware.get(PriorityISVSoftware_.id).alias("id"),
				priorityISVSoftware.get(PriorityISVSoftware_.level).alias("level"),
				account.get(Account_.id).alias("customerId"),
				account.get(Account_.name).alias("accountName"),
				account.get(Account_.account).alias("accountNumber"),
				manufacturer.get(Manufacturer_.id).alias("manufacturerId"),
				manufacturer.get(Manufacturer_.manufacturerName).alias("manufacturerName"),
				priorityISVSoftware.get(PriorityISVSoftware_.evidenceLocation).alias("evidenceLocation"),
				status.get(Status_.id).alias("statusId"),
				status.get(Status_.description).alias("statusDesc"),
				priorityISVSoftware.get(PriorityISVSoftware_.businessJustification).alias("businessJustification"),
				priorityISVSoftware.get(PriorityISVSoftware_.remoteUser).alias("remoteUser"),
				priorityISVSoftware.get(PriorityISVSoftware_.recordTime).alias("recordTime"));
		
		TypedQuery<PriorityISVSoftwareDisplay> typedQuery = entityManager.createQuery(q);
		List<PriorityISVSoftwareDisplay> results = typedQuery.getResultList();

		if(null != results && !results.isEmpty()){
			return results.get(0);
		}else{
			return null;
		}
	}

	@Override
	@SuppressWarnings("unchecked")
	public PriorityISVSoftware findPriorityISVSoftwareByUniqueKeys(
			String level, Long manufacturerId, Long customerId) {
		
		List<PriorityISVSoftware> results = entityManager
	                .createNamedQuery("findPriorityISVSoftwareByUniqueKeys")
	                .setParameter("level", level)
	                .setParameter("manufacturerId", manufacturerId)
	                .setParameter("customerId", customerId).getResultList();
	        
		    PriorityISVSoftware result;
	        if (results == null || results.isEmpty()) {
	            result = null;
	        } else {
	            result = results.get(0);
	        }
	        return result;
	    }

	@Override
	public List<PriorityISVSoftwareDisplay> getAllPriorityISVSoftwareDisplays() {
        	
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<PriorityISVSoftwareDisplay> q = cb.createQuery(PriorityISVSoftwareDisplay.class);
		Root<PriorityISVSoftware> priorityISVSoftware = q.from(PriorityISVSoftware.class);
		//Inner Join Manufacturer Object for MANUFACTURER DB Table
		Join<PriorityISVSoftware, Manufacturer> manufacturer = priorityISVSoftware.join(PriorityISVSoftware_.manufacturer, JoinType.INNER);
		//Inner Join Status Object for STATUS DB Table
		Join<PriorityISVSoftware, Status> status = priorityISVSoftware.join(PriorityISVSoftware_.status, JoinType.INNER);
		//Left Outer Join Account Object for CUSTOMER DB Table
		Join<PriorityISVSoftware, Account> account = priorityISVSoftware.join(PriorityISVSoftware_.account, JoinType.LEFT);
		
		q.multiselect(
				priorityISVSoftware.get(PriorityISVSoftware_.id).alias("id"),
				priorityISVSoftware.get(PriorityISVSoftware_.level).alias("level"),
				account.get(Account_.id).alias("customerId"),
				account.get(Account_.name).alias("accountName"),
				account.get(Account_.account).alias("accountNumber"),
				manufacturer.get(Manufacturer_.id).alias("manufacturerId"),
				manufacturer.get(Manufacturer_.manufacturerName).alias("manufacturerName"),
				priorityISVSoftware.get(PriorityISVSoftware_.evidenceLocation).alias("evidenceLocation"),
				status.get(Status_.id).alias("statusId"),
				status.get(Status_.description).alias("statusDesc"),
				priorityISVSoftware.get(PriorityISVSoftware_.businessJustification).alias("businessJustification"),
				priorityISVSoftware.get(PriorityISVSoftware_.remoteUser).alias("remoteUser"),
				priorityISVSoftware.get(PriorityISVSoftware_.recordTime).alias("recordTime"));
		
		TypedQuery<PriorityISVSoftwareDisplay> typedQuery = entityManager.createQuery(q);
		List<PriorityISVSoftwareDisplay> results = typedQuery.getResultList();

		if(null != results && !results.isEmpty()){
			return results;
		}else{
			return null;
		}
	}
}
