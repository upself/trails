package com.ibm.asset.trails.dao.jpa;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Root;

import org.hibernate.criterion.Order;
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
		List<PriorityISVSoftware> results;
		 
		if(customerId == null){
	       results = entityManager
		                .createNamedQuery("findPriorityISVSoftwareByUniqueKeys2")
		                .setParameter("level", level)
		                .setParameter("manufacturerId", manufacturerId).getResultList();
	       if (results == null || results.isEmpty()){
	    	   results = entityManager
		                .createNamedQuery("findPriorityISVSoftwareBymanufacturerId")
		                .setParameter("manufacturerId", manufacturerId).getResultList();
	       }
		}
		else{
		   results = entityManager
	                .createNamedQuery("findPriorityISVSoftwareByUniqueKeys1")
	                .setParameter("level", level)
	                .setParameter("manufacturerId", manufacturerId)
	                .setParameter("customerId", customerId).getResultList();
		   if (results == null || results.isEmpty()){
	    	   results = entityManager
		                .createNamedQuery("findPriorityISVSoftwareByUniqueKeys2")
		                .setParameter("level", "GLOBAL")
		                .setParameter("manufacturerId", manufacturerId).getResultList();
	       }
		}
		
		    PriorityISVSoftware result;
	        if (results == null || results.isEmpty()) {
	            result = null;
	        } else {
	            result = results.get(0);
	        }
	        return result;
	    }

	
	@Override
	public Long total() {
		// TODO Auto-generated method stub
		Long total = (Long)entityManager.createNamedQuery("findPriorityISVTotal").getSingleResult();
		return total;
	}

	@Override
	public Long totalHistory(Long priorityISVSoftwareId) {
		// TODO Auto-generated method stub
		Long total = (Long)entityManager.createNamedQuery("findPriorityISVHTotalById")
				.setParameter("priorityISVSoftwareId", priorityISVSoftwareId)
				.getSingleResult();
		return total;
	}

	@Override
	public List<PriorityISVSoftwareDisplay> getAllPriorityISVSoftwareDisplays(Integer startIndex, Integer pageSize, String sort, String dir) {
        	
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
		
		if(null != sort && !"".equals(sort.trim()) && null != dir && !"".equals(dir.trim())){
			if(dir.equalsIgnoreCase("asc")){
				if(sort.equalsIgnoreCase("manufacturerName")){
					q.orderBy(cb.asc(manufacturer.get(Manufacturer_.manufacturerName)));
				} else if(sort.equalsIgnoreCase("level")){
					q.orderBy(cb.asc(priorityISVSoftware.get(PriorityISVSoftware_.level)));
				} else if(sort.equalsIgnoreCase("accountName")){
					q.orderBy(cb.asc(account.get(Account_.name)));
				} else if(sort.equalsIgnoreCase("accountNumber")){
					q.orderBy(cb.asc(account.get(Account_.account)));
				} else if(sort.equalsIgnoreCase("evidenceLocation")){
					q.orderBy(cb.asc(priorityISVSoftware.get(PriorityISVSoftware_.evidenceLocation)));
				} else if(sort.equalsIgnoreCase("statusDesc")){
					q.orderBy(cb.asc(status.get(Status_.description)));
				} else if(sort.equalsIgnoreCase("businessJustification")){
					q.orderBy(cb.asc(priorityISVSoftware.get(PriorityISVSoftware_.businessJustification)));
				} else if(sort.equalsIgnoreCase("remoteUser")){
					q.orderBy(cb.asc(priorityISVSoftware.get(PriorityISVSoftware_.remoteUser)));
				}else if(sort.equalsIgnoreCase("recordTime")){
					q.orderBy(cb.asc(priorityISVSoftware.get(PriorityISVSoftware_.recordTime)));
				}else if(sort.equalsIgnoreCase("id")){
					q.orderBy(cb.asc(priorityISVSoftware.get(PriorityISVSoftware_.id)));
				}else{
					
				}
			}
			
			if(dir.equalsIgnoreCase("desc")){
				if(sort.equalsIgnoreCase("manufacturerName")){
					q.orderBy(cb.desc(manufacturer.get(Manufacturer_.manufacturerName)));
				} else if(sort.equalsIgnoreCase("level")){
					q.orderBy(cb.desc(priorityISVSoftware.get(PriorityISVSoftware_.level)));
				} else if(sort.equalsIgnoreCase("accountName")){
					q.orderBy(cb.desc(account.get(Account_.name)));
				} else if(sort.equalsIgnoreCase("accountNumber")){
					q.orderBy(cb.desc(account.get(Account_.account)));
				} else if(sort.equalsIgnoreCase("evidenceLocation")){
					q.orderBy(cb.desc(priorityISVSoftware.get(PriorityISVSoftware_.evidenceLocation)));
				} else if(sort.equalsIgnoreCase("statusDesc")){
					q.orderBy(cb.desc(status.get(Status_.description)));
				} else if(sort.equalsIgnoreCase("businessJustification")){
					q.orderBy(cb.desc(priorityISVSoftware.get(PriorityISVSoftware_.businessJustification)));
				} else if(sort.equalsIgnoreCase("remoteUser")){
					q.orderBy(cb.desc(priorityISVSoftware.get(PriorityISVSoftware_.remoteUser)));
				}else if(sort.equalsIgnoreCase("recordTime")){
					q.orderBy(cb.desc(priorityISVSoftware.get(PriorityISVSoftware_.recordTime)));
				}else if(sort.equalsIgnoreCase("id")){
					q.orderBy(cb.desc(priorityISVSoftware.get(PriorityISVSoftware_.id)));
				}else{
					
				}
			}
			
		}
		
		TypedQuery<PriorityISVSoftwareDisplay> typedQuery = entityManager.createQuery(q);
		List<PriorityISVSoftwareDisplay> results = typedQuery.setFirstResult(startIndex).setMaxResults(pageSize).getResultList();

		if(null != results && !results.isEmpty()){
			return results;
		}else{
			return null;
		}
	}
}
