package com.ibm.asset.trails.dao;
import com.ibm.asset.trails.domain.Status;

public interface StatusDAO extends BaseEntityDAO<Status, Long> {

	public Status findStatusByDesc(String desc);
}
