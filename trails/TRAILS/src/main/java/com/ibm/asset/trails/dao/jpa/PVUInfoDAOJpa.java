package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.PVUInfoDAO;
import com.ibm.asset.trails.domain.PvuInfo;

@Repository
public class PVUInfoDAOJpa extends AbstractGenericEntityDAOJpa<PvuInfo, Long>
		implements PVUInfoDAO {

	@SuppressWarnings("unchecked")
	public List<PvuInfo> find(Long pvuId, int cores) {
		Criteria criteria = getHibernateSessionCriteria();

		criteria.add(Restrictions.eq("pvuId", pvuId));
		if (cores == 1) {
			criteria.add(Restrictions.or(Restrictions.eq("processorType",
					"SINGLE-CORE"), Restrictions.like("processorType", "ONE",
					MatchMode.ANYWHERE)));
		} else if (cores == 2) {
			criteria.add(Restrictions.eq("processorType", "DUAL-CORE"));
		} else if (cores == 4) {
			criteria.add(Restrictions.like("processorType", "QUAD-CORE",
					MatchMode.ANYWHERE));
		}
		return criteria.list();
	}

	@SuppressWarnings("unchecked")
	public List<PvuInfo> find(Long pvuId) {
		Criteria criteria = getHibernateSessionCriteria();
		criteria.add(Restrictions.eq("pvuId",
				pvuId));
		criteria.add(Restrictions.like(
				"processorType", "MULTI-CORE",
				MatchMode.ANYWHERE));
		return criteria.list();
	}

}
