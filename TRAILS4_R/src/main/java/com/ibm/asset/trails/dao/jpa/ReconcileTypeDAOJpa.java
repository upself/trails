package com.ibm.asset.trails.dao.jpa;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.criterion.Example;
import org.hibernate.criterion.Order;
import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ReconcileTypeDAO;
import com.ibm.asset.trails.domain.ReconcileType;

@Repository
public class ReconcileTypeDAOJpa extends AbstractGenericEntityDAOJpa<ReconcileType, Long>
		implements ReconcileTypeDAO {

	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> reconcileTypeActions() {
		return entityManager
		.createQuery(
				"select new map(rt.id as id, rt.name as name, rt.manual) FROM ReconcileType rt WHERE rt.name != 'Assign' AND rt.name != 'Unassign' ORDER BY rt.id ASC").setHint("org.hibernate.cacheable", Boolean.TRUE)
		.getResultList();
	}

	@SuppressWarnings("unchecked")
	public List<ReconcileType> reconcileTypes(boolean isManual) {
		ReconcileType rt = new ReconcileType();
		rt.setManual(isManual);
		Example exampleRt = Example.create(rt);
		Criteria criteria = getHibernateSessionCriteria();
		criteria.add(exampleRt).addOrder(Order.desc("id")).setCacheable(true).list();
		return criteria.list();
	}

}
