package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ReconDao;
import com.ibm.asset.trails.domain.Recon;

@Repository
public class ReconJpaDao extends DaoJpa<Recon, Long> implements ReconDao {

	public Long findIdByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

	public Recon findByNaturalKey(Object... key) {
		Query q = getEntityManager()
				.createQuery(
						"SELECT h FROM " + entityClass.getName()
								+ " h left join fetch h.productInfo p where p.id = :key")
				.setParameter("key", key[0])
				.setHint("org.hibernate.cacheable", Boolean.TRUE);
		@SuppressWarnings("unchecked")
		List<Recon> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}
}
