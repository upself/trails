package com.ibm.asset.trails.dao;

import java.util.List;
import java.util.Map;

import com.ibm.asset.trails.domain.ReconcileType;

public interface ReconcileTypeDAO extends BaseEntityDAO<ReconcileType,Long> {

	List<Map<String, Object>> reconcileTypeActions();

	List<ReconcileType> reconcileTypes(boolean isManual);

}
