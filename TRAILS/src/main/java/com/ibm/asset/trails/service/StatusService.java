package com.ibm.asset.trails.service;

import com.ibm.asset.trails.domain.Status;

public interface StatusService {
	public Status findStatusByDesc(String desc);
}
