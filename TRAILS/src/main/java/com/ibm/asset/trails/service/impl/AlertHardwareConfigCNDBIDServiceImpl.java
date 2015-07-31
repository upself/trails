package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.AlertService;

public class AlertHardwareConfigCNDBIDServiceImpl extends BaseAlertServiceImpl implements AlertService{

	@Override
	public ArrayList paginatedList(Account account, int startIndex,
			int objectsPerPage, String sort, String dir) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long total(Account account) {
		// TODO Auto-generated method stub
		return 0L;
	}

	@Override
	public ArrayList paginatedList(String remoteUser, int startIndex,
			int objectsPerPage, String sort, String dir) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long total(String remoteUser) {
		// TODO Auto-generated method stub
		return 0L;
	}

	@Override
	public void assign(List<Long> list, String remoteUser, String comments) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public ArrayList getAlertHistory(Long id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void unassign(List<Long> alertIds, String remoteUser, String comments) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateAll(Account pAccount, String psRemoteUser,
			String psComments, int piMode) {
		// TODO Auto-generated method stub
		
	}

}
