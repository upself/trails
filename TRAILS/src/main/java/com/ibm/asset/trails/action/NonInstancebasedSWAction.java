package com.ibm.asset.trails.action;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.service.NonInstanceService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;


public class NonInstancebasedSWAction extends AccountBaseAction {
	private static final long serialVersionUID = 1L;
	
	private String type;
	private Long nonInstanceId;
	private NonInstanceDisplay nonInstanceDisplay;
	private NonInstanceService nonInstanceService;
	
	private static final String REQUEST_ADD = "add";
	private static final String REQUEST_UPDATE = "update";
	
	
	@UserRole(userRole = UserRoleType.READER)
	public String list() throws Exception {
		// TODO Auto-generated method stub
		return SUCCESS;
	}
	
	@UserRole(userRole = UserRoleType.READER)
	public String history() throws Exception {
		return SUCCESS;
	}
	
	@UserRole(userRole = UserRoleType.ADMIN)
	public String manage() throws Exception {
		if(type.equals(REQUEST_ADD)){
			setNonInstanceId(null);
			setNonInstanceDisplay(null);
		} else if(type.equals(REQUEST_UPDATE)){
			nonInstanceDisplay = nonInstanceService.findNonInstanceDisplayById(nonInstanceId);
		} else{
			
		}
		
		return SUCCESS;
	}
	
	@UserRole(userRole = UserRoleType.ADMIN)
	public String doSave() throws Exception{
		return SUCCESS;
	}
	
	@UserRole(userRole = UserRoleType.ADMIN)
	public String doUpdate() throws Exception{
		return SUCCESS;
	}
	
	@UserRole(userRole = UserRoleType.ADMIN)
	public String doUpload() throws Exception{
		return SUCCESS;
	}
	
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Long getNonInstanceId() {
		return nonInstanceId;
	}

	public void setNonInstanceId(Long nonInstanceId) {
		this.nonInstanceId = nonInstanceId;
	}

	public NonInstanceDisplay getNonInstanceDisplay() {
		return nonInstanceDisplay;
	}

	public void setNonInstanceDisplay(NonInstanceDisplay nonInstanceDisplay) {
		this.nonInstanceDisplay = nonInstanceDisplay;
	}

	public NonInstanceService getNonInstanceService() {
		return nonInstanceService;
	}

	public void setNonInstanceService(NonInstanceService nonInstanceService) {
		this.nonInstanceService = nonInstanceService;
	}
}
