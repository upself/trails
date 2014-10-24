package com.ibm.asset.trails.dao.jpa;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.FileDao;
import com.ibm.asset.trails.domain.File;

@Repository
public class FileDaoJpa extends DaoJpa<File, Long> implements FileDao {

	@SuppressWarnings("unchecked")
	public File findByNaturalKey(Object... key) {
		List<File> list = new ArrayList<File>();
		if (key[1] == null) {
			list = entityManager
					.createQuery(
							"from File where name = :name and size is null")
					.setParameter("name", key[0])
					.setHint("org.hibernate.cacheable", Boolean.TRUE)
					.getResultList();
		} else {
			list = entityManager
					.createQuery(
							"from File where name = :name and size = :size")
					.setParameter("name", key[0]).setParameter("size", key[1])
					.setHint("org.hibernate.cacheable", Boolean.TRUE)
					.getResultList();
		}
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

	public Long findIdByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}
}
