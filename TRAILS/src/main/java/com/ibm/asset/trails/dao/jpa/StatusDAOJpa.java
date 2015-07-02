package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.StatusDAO;
import com.ibm.asset.trails.domain.Status;

@Repository
public class StatusDAOJpa extends AbstractGenericEntityDAOJpa<Status, Long> implements StatusDAO{

	@Override
	public Status findStatusByDesc(String desc) {
		// TODO Auto-generated method stub
		@SuppressWarnings("unchecked")
		List<Status> list = entityManager
				.createNamedQuery("statusDetails")
				.setParameter("description", desc.toUpperCase()).getResultList();

		if (list.size() == 0) {
			return null;
		}

		return list.get(0);
	}

}
