package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.RegistrySignatureDao;
import com.ibm.asset.trails.domain.RegistrySignature;

@Repository
public class RegistrySignatureDaoJpa extends
		SignatureDaoJpa<RegistrySignature, Long> implements
		RegistrySignatureDao {

	public RegistrySignature findByNaturalKey(String key) {
		@SuppressWarnings("unchecked")
		List<RegistrySignature> list = getEntityManager()
				.createQuery(
						"SELECT h FROM RegistrySignature h left join fetch h.registry where guid = :key")
				.setParameter("guid", key)
				.setHint("org.hibernate.cacheable", Boolean.TRUE)
				.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

}
