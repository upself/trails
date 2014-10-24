package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.Pid;

public interface PidDao extends BaseDao<Pid, Long> {

	Pid findByNaturalKey(String pid);
}
