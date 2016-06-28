package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ProductInfoDao;
import com.ibm.asset.trails.domain.ProductInfo;

@Repository
public class ProductInfoDaoJpa extends ProductDaoJpa<ProductInfo, Long>
		implements ProductInfoDao {

	public ProductInfo findByNaturalKey(String key) {
		@SuppressWarnings("unchecked")
		List<ProductInfo> list = getEntityManager()
				.createQuery(
						"SELECT h from ProductInfo h left join fetch h.alias left join fetch h.pids left join fetch h.recon where h.guid = :guid")
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
