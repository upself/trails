package com.ibm.asset.trails.dao.jpa;

import java.util.List;
import java.util.Map;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.InstalledFilterDao;
import com.ibm.asset.trails.domain.InstalledFilter;

@Repository
public class InstalledFilterDaoJpa extends DaoJpa<InstalledFilter, Long>
		implements InstalledFilterDao {

	public Map<String, InstalledFilter> findAllMap() {
		return null;
	}

	public Long hitCount(Long id) {
		Long count = 0L;
		Query q = getEntityManager()
				.createQuery(
						"select count(if.id) from InstalledFilter if where if.softwareFilterId = :filId")
				.setParameter("filId", id);
		@SuppressWarnings("unchecked")
		List<Long> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return count;
		}
		return list.get(0);
	}

	public Boolean filterExists(String filterName, String softwareVersion) {
		Query q = getEntityManager()
				.createQuery(
						"select 1 from FilterSignature fs where fs.packageName = :filterName and fs.packageVersion = :softwareVersion")
				.setParameter("filterName", filterName)
				.setParameter("softwareVersion", softwareVersion);
		@SuppressWarnings("unchecked")
		List<Long> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return false;
		}
		return true;
	}

	public InstalledFilter findByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

	public Long findIdByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

}
