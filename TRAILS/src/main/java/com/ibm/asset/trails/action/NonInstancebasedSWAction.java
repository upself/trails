package com.ibm.asset.trails.action;

import com.ibm.asset.trails.service.NonInstanceService;


public class NonInstancebasedSWAction extends BaseAction {

	private Long nonInstanceId;
	private NonInstanceService nonInstanceService;
	
	@Override
	public String execute() throws Exception {
		// TODO Auto-generated method stub
		System.out.println("get non instance based SW");
		return SUCCESS;
	}
	
	public String history() throws Exception {
		System.out.println("Go to history page");
		return SUCCESS;
	}
	
	public Long getNonInstanceId() {
		return nonInstanceId;
	}

	public void setNonInstanceId(Long nonInstanceId) {
		this.nonInstanceId = nonInstanceId;
	}

	public NonInstanceService getNonInstanceService() {
		return nonInstanceService;
	}

	public void setNonInstanceService(NonInstanceService nonInstanceService) {
		this.nonInstanceService = nonInstanceService;
	}
}
