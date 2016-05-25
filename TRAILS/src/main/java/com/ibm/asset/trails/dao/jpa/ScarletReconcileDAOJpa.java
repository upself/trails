package com.ibm.asset.trails.dao.jpa;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ScarletReconcileDAO;
import com.ibm.asset.trails.domain.ScarletReconcile;

@Repository
public class ScarletReconcileDAOJpa extends
		AbstractGenericEntityDAOJpa<ScarletReconcile, Long> implements
		ScarletReconcileDAO {

	private static Logger LOG = LogManager
			.getLogger(ScarletReconcileDAOJpa.class);

	@Override
	public void remove(ScarletReconcile entity) {

		int affectedQty = entityManager
				.createNativeQuery("DELETE FROM SCARLET_RECONCILE WHERE ID = ?")
				.setParameter(1, entity.getId()).executeUpdate();

		LOG.debug(affectedQty + " record(s) had been deleted");

	}

}
