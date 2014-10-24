package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.FileSignatureDao;
import com.ibm.asset.trails.domain.FileSignature;

@Repository
public class FileSignatureDaoJpa extends SignatureDaoJpa<FileSignature, Long>
		implements FileSignatureDao {

	public FileSignature findByNaturalKey(String key) {
		@SuppressWarnings("unchecked")
		List<FileSignature> list = getEntityManager()
				.createQuery(
						"SELECT h FROM FileSignature h left join fetch h.files where h.guid = :key")
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
