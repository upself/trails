package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.PvuInfo;

public interface PVUInfoDAO extends BaseEntityDAO<PvuInfo,Long> {

	List<PvuInfo> find(Long pvuId, int cores);

	List<PvuInfo> find(Long pvuId);

}
