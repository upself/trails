package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.PriorityISVSoftwareHDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.Account_;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Manufacturer_;
import com.ibm.asset.trails.domain.PriorityISVSoftwareH;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftwareH_;
import com.ibm.asset.trails.domain.PriorityISVSoftware_;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.domain.Status_;

@Repository
public class PriorityISVSoftwareHDAOJap extends
		AbstractGenericEntityDAOJpa<PriorityISVSoftwareH, Long> implements
		PriorityISVSoftwareHDAO {

	@Override
	public List<PriorityISVSoftwareHDisplay> findPriorityISVSoftwareHDisplaysByISVSoftwareId(
			Long priorityISVSoftwareId,Integer startIndex, Integer pageSize, String sort, String dir) {
		
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<PriorityISVSoftwareHDisplay> q = cb.createQuery(PriorityISVSoftwareHDisplay.class);
		Root<PriorityISVSoftwareH> priorityISVSoftwareH = q.from(PriorityISVSoftwareH.class);
		//Inner Join Manufacturer Object for MANUFACTURER DB Table
		Join<PriorityISVSoftwareH, Manufacturer> manufacturer = priorityISVSoftwareH.join(PriorityISVSoftwareH_.manufacturer, JoinType.INNER);
		//Inner Join Status Object for STATUS DB Table
		Join<PriorityISVSoftwareH, Status> status = priorityISVSoftwareH.join(PriorityISVSoftwareH_.status, JoinType.INNER);
		//Left Outer Join Account Object for CUSTOMER DB Table
		Join<PriorityISVSoftwareH, Account> account = priorityISVSoftwareH.join(PriorityISVSoftwareH_.account, JoinType.LEFT);
		
		q.where(cb.equal(priorityISVSoftwareH.get(PriorityISVSoftwareH_.priorityISVSoftwareId), priorityISVSoftwareId));
		
		q.multiselect(
				priorityISVSoftwareH.get(PriorityISVSoftwareH_.id).alias("id"),
				priorityISVSoftwareH.get(PriorityISVSoftwareH_.priorityISVSoftwareId).alias("priorityISVSoftwareId"),
				priorityISVSoftwareH.get(PriorityISVSoftwareH_.level).alias("level"),
				account.get(Account_.id).alias("customerId"),
				account.get(Account_.name).alias("accountName"),
				account.get(Account_.account).alias("accountNumber"),
				manufacturer.get(Manufacturer_.id).alias("manufacturerId"),
				manufacturer.get(Manufacturer_.manufacturerName).alias("manufacturerName"),
				priorityISVSoftwareH.get(PriorityISVSoftwareH_.evidenceLocation).alias("evidenceLocation"),
				status.get(Status_.id).alias("statusId"),
				status.get(Status_.description).alias("statusDesc"),
				priorityISVSoftwareH.get(PriorityISVSoftwareH_.businessJustification).alias("businessJustification"),
				priorityISVSoftwareH.get(PriorityISVSoftwareH_.remoteUser).alias("remoteUser"),
				priorityISVSoftwareH.get(PriorityISVSoftwareH_.recordTime).alias("recordTime"));
		
		if(null != sort && !"".equals(sort.trim()) && null != dir && !"".equals(dir.trim())){
			if(dir.equalsIgnoreCase("asc")){
				if(sort.equalsIgnoreCase("manufacturerName")){
					q.orderBy(cb.asc(manufacturer.get(Manufacturer_.manufacturerName)));
				} else if(sort.equalsIgnoreCase("level")){
					q.orderBy(cb.asc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.level)));
				} else if(sort.equalsIgnoreCase("accountName")){
					q.orderBy(cb.asc(account.get(Account_.name)));
				} else if(sort.equalsIgnoreCase("accountNumber")){
					q.orderBy(cb.asc(account.get(Account_.account)));
				} else if(sort.equalsIgnoreCase("evidenceLocation")){
					q.orderBy(cb.asc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.evidenceLocation)));
				} else if(sort.equalsIgnoreCase("statusDesc")){
					q.orderBy(cb.asc(status.get(Status_.description)));
				} else if(sort.equalsIgnoreCase("businessJustification")){
					q.orderBy(cb.asc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.businessJustification)));
				} else if(sort.equalsIgnoreCase("remoteUser")){
					q.orderBy(cb.asc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.remoteUser)));
				}else if(sort.equalsIgnoreCase("recordTime")){
					q.orderBy(cb.asc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.recordTime)));
				}else if(sort.equalsIgnoreCase("id")){
					q.orderBy(cb.asc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.id)));
				}else{
					
				}
			}
			
			if(dir.equalsIgnoreCase("desc")){
				if(sort.equalsIgnoreCase("manufacturerName")){
					q.orderBy(cb.desc(manufacturer.get(Manufacturer_.manufacturerName)));
				} else if(sort.equalsIgnoreCase("level")){
					q.orderBy(cb.desc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.level)));
				} else if(sort.equalsIgnoreCase("accountName")){
					q.orderBy(cb.desc(account.get(Account_.name)));
				} else if(sort.equalsIgnoreCase("accountNumber")){
					q.orderBy(cb.desc(account.get(Account_.account)));
				} else if(sort.equalsIgnoreCase("evidenceLocation")){
					q.orderBy(cb.desc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.evidenceLocation)));
				} else if(sort.equalsIgnoreCase("statusDesc")){
					q.orderBy(cb.desc(status.get(Status_.description)));
				} else if(sort.equalsIgnoreCase("businessJustification")){
					q.orderBy(cb.desc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.businessJustification)));
				} else if(sort.equalsIgnoreCase("remoteUser")){
					q.orderBy(cb.desc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.remoteUser)));
				}else if(sort.equalsIgnoreCase("recordTime")){
					q.orderBy(cb.desc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.recordTime)));
				}else if(sort.equalsIgnoreCase("id")){
					q.orderBy(cb.desc(priorityISVSoftwareH.get(PriorityISVSoftwareH_.id)));
				}else{
					
				}
			}
			
		}
		
		TypedQuery<PriorityISVSoftwareHDisplay> typedQuery = entityManager.createQuery(q);
		List<PriorityISVSoftwareHDisplay> results = typedQuery.setFirstResult(startIndex).setMaxResults(pageSize).getResultList();

		if(null != results && !results.isEmpty()){
			return results;
		}else{
			return null;
		}
	}
}
