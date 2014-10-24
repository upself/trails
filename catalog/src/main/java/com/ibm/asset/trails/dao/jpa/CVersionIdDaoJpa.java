package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ibm.asset.swkbt.schema.PlatformsEnum;
import com.ibm.asset.trails.dao.CVersionIdDao;
import com.ibm.asset.trails.dao.PlatformDao;
import com.ibm.asset.trails.domain.CVersionId;
import com.ibm.asset.trails.domain.Platform;

@Repository
public class CVersionIdDaoJpa extends DaoJpa<CVersionId, Long> implements
		CVersionIdDao {

	@Autowired
	private PlatformDao platformDao;

	public CVersionId findByNaturalKey(Object... key) {
		Platform platform = platformDao.findByName(PlatformsEnum
				.fromValue((String) key[0]));
		Query q;
		if (platform == null && key[1] == null) {
			q = getEntityManager()
					.createQuery(
							"SELECT h FROM CVersionId h where h.platform is null and h.cVersionId is null")
					.setParameter("cVersionId", key[1]);
		} else if (platform == null) {
			q = getEntityManager()
					.createQuery(
							"SELECT h FROM CVersionId h where h.platform is null and h.cVersionId = :cVersionId")
					.setParameter("cVersionId", key[1]);
		} else if (key[1] == null) {
			q = getEntityManager()
					.createQuery(
							"SELECT h FROM CVersionId h where h.platform = :platform and h.cVersionId is null")
					.setParameter("platform", platform.getId());
		} else {
			q = getEntityManager()
					.createQuery(
							"SELECT h FROM CVersionId h where h.platform = :platform and h.cVersionId = :cVersionId")
					.setParameter("platform", platform.getId())
					.setParameter("cVersionId", key[1]);
		}
		q.setHint("org.hibernate.cacheable", Boolean.TRUE);
		@SuppressWarnings("unchecked")
		List<CVersionId> list = q.getResultList();
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
