package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.AliasDao;
import com.ibm.asset.trails.domain.Alias;
import com.ibm.asset.trails.domain.Alias_;

@Repository
public class AliasDaoJpa extends DaoJpa<Alias, Long> implements AliasDao {

	public Alias findByNaturalKey(Object... key) {
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<Alias> cq = cb.createQuery(Alias.class);
		Root<Alias> p = cq.from(Alias.class);
		Predicate condition = cb.equal(p.get(Alias_.name), key[0]);
		cq.where(condition);
		TypedQuery<Alias> q = entityManager.createQuery(cq).setHint(
				"org.hibernate.cacheable", Boolean.TRUE);
		List<Alias> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

	public Long findIdByNaturalKey(Object... key) {
		@SuppressWarnings("unchecked")
		List<Long> list = entityManager
				.createQuery("select id from alias a where a.name = :key")
				.setParameter("name", key[0])
				.setHint("org.hibernate.cacheable", Boolean.TRUE)
				.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}
}
