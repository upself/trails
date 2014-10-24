package com.ibm.asset.trails.dao.jpa;

import java.util.List;
import java.util.Map;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.InstalledSignatureDao;
import com.ibm.asset.trails.domain.InstalledSignature;

@Repository
public class InstalledSignatureDaoJpa extends DaoJpa<InstalledSignature, Long>
		implements InstalledSignatureDao {

	public Map<String, InstalledSignature> findAllMap() {
		return null;
	}

	public Long hitCount(Long id) {
		Long count = 0L;
		Query q = getEntityManager()
				.createQuery(
						"select count(instSig.id) from InstalledSignature instSig where instSig.softwareSignatureId = :sigId")
				.setParameter("sigId", id);
		@SuppressWarnings("unchecked")
		List<Long> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return count;
		}
		return list.get(0);
	}

	public Boolean signatureExists(String fileName, Integer fileSize) {
		Query q = getEntityManager()
				.createQuery(
						"select 1 from File f where f.name = :fileName and f.size = :fileSize")
				.setParameter("fileName", fileName)
				.setParameter("fileSize", fileSize);
		@SuppressWarnings("unchecked")
		List<Long> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return false;
		}
		return true;
	}

	public InstalledSignature findByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

	public Long findIdByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

}
