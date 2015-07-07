package com.ibm.asset.trails.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ibm.asset.trails.dao.StatusDAO;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.service.StatusService;

@Service
public class StatusServiceImpl implements StatusService{

	@Autowired
	private StatusDAO statusDAO;

	@Override
	public Status findStatusByDesc(String desc) {
		// TODO Auto-generated method stub
		return statusDAO.findStatusByDesc(desc);
	}
	

}
