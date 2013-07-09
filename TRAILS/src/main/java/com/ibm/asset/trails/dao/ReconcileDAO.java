package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.Reconcile;

public interface ReconcileDAO extends BaseEntityDAO<Reconcile,Long> {

	Reconcile reconcileDetail(Long id);


}
