package com.ibm.asset.trails.batch.swkbt.service;

import java.util.Set;

import com.ibm.asset.trails.domain.Pid;

public interface PidService {

	Set<Pid> findFromXmlSet(String productIds);

}
