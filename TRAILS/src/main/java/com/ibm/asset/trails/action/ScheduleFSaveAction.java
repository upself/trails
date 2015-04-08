package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.validation.SkipValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.form.ScheduleFForm;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.validator.annotations.Validations;
import com.opensymphony.xwork2.validator.annotations.VisitorFieldValidator;

@Controller
@ParentPackage("trails-struts-default")
@Namespace("/admin/scheduleF")
@Results({
		@Result(name = ActionSupport.INPUT, location = "tiles.admin.scheduleF.manage", type = "tiles"),
		@Result(name = ActionSupport.ERROR, location = "tiles.home", type = "tiles"),
		@Result(name = ActionSupport.SUCCESS, location = "list", type = "redirectAction") })
public class ScheduleFSaveAction extends AccountBaseAction {
	private static final long serialVersionUID = 1L;

	private ScheduleFForm scheduleFForm;

	@Autowired
	private ScheduleFService scheduleFService;

	private Long scheduleFId;

	private ArrayList<Scope> scopeArrayList;

	private ArrayList<Source> sourceArrayList;

	private ArrayList<Status> statusArrayList;

	private ArrayList<String> levelArrayList;

	@SkipValidation
	@UserRole(userRole = UserRoleType.READER)
	@Action("manage")
	public String manage() {
		return INPUT;
	}

	@Action("save")
	@Validations(visitorFields = { @VisitorFieldValidator(fieldName = "scheduleFForm", appendPrefix = false) })
	public String doSave() {	
        if (getAccount() == null){return ERROR;}
		ArrayList<Software> laSoftware = getScheduleFService()
				.findSoftwareBySoftwareName(
						getScheduleFForm().getSoftwareName());
		Long llScheduleFId = getScheduleF().getId();
		List<ScheduleF> lsfExists = null;
		ScheduleF sfoExists = null;
		ScheduleF sfiExists = null;
		Long statusId = getScheduleFForm().getStatusId();
		
		if (laSoftware.size() == 0 ) {
			if(statusId != 1){
			addFieldError(
					"scheduleFForm.softwareName",
					"Software does not exist in catalog. It may already been removed in SWKB Toolkit.");
			return INPUT;
			} else {
				if (llScheduleFId != null) {			
					sfiExists = getScheduleFService().getScheduleFDetails(llScheduleFId);
				}
				    sfiExists.setStatus(findStatusInList(getScheduleFForm().getStatusId(),
						getStatusArrayList()));
				try {
					getScheduleFService().saveScheduleF(sfiExists,
							getUserSession().getRemoteUser());
					return SUCCESS;
				} catch (Exception e) {
					System.out.println(e.getCause());
					return INPUT;
				}
			}
		} else {
			
				lsfExists = getScheduleFService().findScheduleF(
						getUserSession().getAccount(), laSoftware.get(0), getScheduleFForm().getLevel());
			if (lsfExists != null) {sfoExists = findSfInExistsList(lsfExists);}
			if (llScheduleFId != null) {			
				sfiExists = getScheduleFService().findScheduleF(llScheduleFId,
						getUserSession().getAccount(), laSoftware.get(0));
			}

		}
		getScheduleF().setLevel(getScheduleFForm().getLevel());
		if (getScheduleFForm().getLevel().equals(
				ScheduleFLevelEnumeration.HWOWNER.toString())) {

			if (StringUtils.isEmpty(getScheduleFForm().getHwowner())) {
				addFieldError("scheduleFForm.hwowner",
						"HW owner field is empty");
				return INPUT;
			} else {
				getScheduleF().setHwOwner(getScheduleFForm().getHwowner());
				getScheduleF().setSerial(null);
				getScheduleF().setMachineType(null);
				getScheduleF().setHostname(null);
			}

		} else if (getScheduleFForm().getLevel().equals(
				ScheduleFLevelEnumeration.HWBOX.toString())) {

			if (StringUtils.isEmpty(getScheduleFForm().getSerial())
					|| StringUtils.isEmpty(getScheduleFForm().getMachineType())) {
				addFieldError("scheduleFForm.hwbox",
						"HW box properties are empty");
				return INPUT;
			} else {
				getScheduleF().setSerial(getScheduleFForm().getSerial());
				getScheduleF().setMachineType(
						getScheduleFForm().getMachineType());
				getScheduleF().setHwOwner(null);
				getScheduleF().setHostname(null);
			}

		} else if (getScheduleFForm().getLevel().equals(
				ScheduleFLevelEnumeration.HOSTNAME.toString())) {
			if (StringUtils.isEmpty(getScheduleFForm().getHostname())) {
				addFieldError("scheduleFForm.hostname",
						"Hostname field is empty");
				return INPUT;
			} else {
				getScheduleF().setHostname(getScheduleFForm().getHostname());
				getScheduleF().setHwOwner(null);
				getScheduleF().setSerial(null);
				getScheduleF().setMachineType(null);
			}

		} else {
			getScheduleF().setHostname(null);
			getScheduleF().setHwOwner(null);
			getScheduleF().setSerial(null);
			getScheduleF().setMachineType(null);
		}

		getScheduleF().setAccount(getUserSession().getAccount());
		getScheduleF().setSoftware(laSoftware.get(0));
		getScheduleF().setSoftwareTitle(getScheduleFForm().getSoftwareTitle());
		getScheduleF().setSoftwareName(getScheduleFForm().getSoftwareName());
		getScheduleF().setManufacturer(getScheduleFForm().getManufacturer());
		
		Scope sfScope = findScopeInList(getScheduleFForm().getScopeId(),getScopeArrayList());
		String[] sfDescParts = sfScope.getDescription().split(",");
		
		if (getScheduleFForm().getLevel().equals(
				ScheduleFLevelEnumeration.HWOWNER.toString())) {
			if ((( sfDescParts[0].contains("IBM owned"))
					&& getScheduleFForm().getHwowner().toString().equals("IBM"))
					|| ((sfDescParts[0].contains("Customer owned") )
							&& getScheduleFForm().getHwowner().toString().equals("CUSTO"))){
				getScheduleF().setScope(sfScope);
			} else {
				addFieldError("scheduleFForm.hwowner",
						"hwowner is not matched to the selected scope");
				return INPUT;
			}
			
		} else {
			getScheduleF().setScope(
					findScopeInList(getScheduleFForm().getScopeId(),
							getScopeArrayList()));
		}
		
		getScheduleF().setSource(
				findSourceInList(getScheduleFForm().getSourceId(),
						getSourceArrayList()));
		
		   //AB added
		String sfr =getScheduleFForm().getSwFinanResp();
		if(sfr==null || sfr.equals("")){
			addFieldError("scheduleFForm.swFinanResp","SW Financial Resp can't be blank.");
			return INPUT;					
		} else if ( sfDescParts[0].contains("IBM owned") && !sfr.equalsIgnoreCase("IBM")){
			addFieldError("scheduleFForm.swFinanResp","\"IBM Owned\" Scope only accept to \"IBM\" SW Financial Resp.");
			return INPUT;
		} else if(!sfScope.getDescription().contains("Customer owned, Customer managed") && sfr.equalsIgnoreCase("N/A")){
			addFieldError("scheduleFForm.swFinanResp","Only CUSTOMER OWNED CUSTOMER MANAGED Scope can accept N/A SW Financial Resp.");
			return INPUT;					
		}else{
			getScheduleF().setSWFinanceResp(sfr);
		}
				
		getScheduleF()
				.setSourceLocation(getScheduleFForm().getSourceLocation());
		if (laSoftware.get(0).getStatus().equalsIgnoreCase("INACTIVE")){
			getScheduleF().setStatus(findStatusInList((long) 1,getStatusArrayList()));
		} else {
		getScheduleF().setStatus(
				findStatusInList(getScheduleFForm().getStatusId(),
						getStatusArrayList()));
		}
		getScheduleF().setBusinessJustification(
				getScheduleFForm().getBusinessJustification());

		if (sfiExists != null && sfiExists.equals(getScheduleF())){
			addFieldError("scheduleFForm.softwareName",
					"Same entry with the given software name already exists.");
			return INPUT;
		}
		if (sfoExists != null && sfoExists.equals(getScheduleF())) {
			addFieldError("scheduleFForm.softwareName",
					"Same entry with the given software name already exists.");
			return INPUT;
		}
		try {
			getScheduleFService().saveScheduleF(getScheduleF(),
					getUserSession().getRemoteUser());
		} catch (Exception e) {
			System.out.println(e.getCause());
			return INPUT;
		}
		return SUCCESS;
	}

	@SkipValidation
	public String doCancel() {
		return SUCCESS;
	}

	@SkipValidation
	@Override
	public void prepare() {
		super.prepare();

		if (getScheduleFForm() == null) {
			ScheduleFForm lsffManage = new ScheduleFForm();

			if (getScheduleFId() == null) {
				setScheduleF(new ScheduleF());
			} else {
				setScheduleF(getScheduleFService().getScheduleFDetails(
						getScheduleFId()));
				lsffManage.setSoftwareTitle(getScheduleF().getSoftwareTitle());
				lsffManage.setSoftwareName(getScheduleF().getSoftwareName());
				lsffManage.setManufacturer(getScheduleF().getManufacturer());
				lsffManage.setScopeId(getScheduleF().getScope().getId());
				lsffManage.setSourceId(getScheduleF().getSource().getId());
				//AB added 
				lsffManage.setSwFinanResp(getScheduleF().getSWFinanceResp());
				lsffManage
						.setSourceLocation(getScheduleF().getSourceLocation());
				if(!getScheduleFService().findSoftwareBySoftwareName(getScheduleF().getSoftwareName().toString()).isEmpty()){
				if (getScheduleFService().findSoftwareBySoftwareName(getScheduleF().getSoftwareName().toString()).get(0).getStatus().equalsIgnoreCase("ACTIVE")){
				lsffManage.setSoftwareStatus(false);
				lsffManage.setStatusId(getScheduleF().getStatus().getId());
				}else {
				lsffManage.setSoftwareStatus(true);
				lsffManage.setStatusId((long) 1);
				}

				}else {
					lsffManage.setSoftwareStatus(true);
					lsffManage.setStatusId((long) 1);
				}
				lsffManage.setLevel(getScheduleF().getLevel());
				lsffManage.setHwowner(getScheduleF().getHwOwner());
				lsffManage.setSerial(getScheduleF().getSerial());
				lsffManage.setMachineType(getScheduleF().getMachineType());
				lsffManage.setHostname(getScheduleF().getHostname());
			}
		if (getAccount().getSoftwareFinancialManagement() != null){
			lsffManage
					.setComplianceReporting(getAccount()
							.getSoftwareFinancialManagement().equalsIgnoreCase(
									"YES") ? "YES" : "NO");
		} else {
			lsffManage.setComplianceReporting("NO");
		}
			setScheduleFForm(lsffManage);
		}

		if (getScopeArrayList() == null) {
			setScopeArrayList(getScheduleFService().getScopeList());
		}
		if (getSourceArrayList() == null) {
			setSourceArrayList(getScheduleFService().getSourceList());
		}
		if (getStatusArrayList() == null) {
			setStatusArrayList(getScheduleFService().getStatusList());
		}
//		if (getLevelArrayList() == null) {
//			setLevelArrayList(getScheduleFService().getLevelList());
//		}
	}

	private Scope findScopeInList(Long plScopeId, ArrayList<Scope> plFind) {
		ListIterator<Scope> lliFind = plFind.listIterator();
		Scope lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getId().longValue() == plScopeId.longValue()) {
				break;
			}
		}

		return lsFind;
	}

	private Source findSourceInList(Long plSourceId, ArrayList<Source> plFind) {
		ListIterator<Source> lliFind = plFind.listIterator();
		Source lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getId().longValue() == plSourceId.longValue()) {
				break;
			}
		}

		return lsFind;
	}

	private Status findStatusInList(Long plStatusId, ArrayList<Status> plFind) {
		ListIterator<Status> lliFind = plFind.listIterator();
		Status lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getId().longValue() == plStatusId.longValue()) {
				break;
			}
		}

		return lsFind;
	}
	
	private ScheduleF findSfInExistsList( List<ScheduleF> lsfExists) {
		ListIterator<ScheduleF> lliFind = lsfExists.listIterator();
		ScheduleF lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();
			if (getScheduleFForm().getLevel().toString().equals(ScheduleFLevelEnumeration.PRODUCT.toString()) ){
				break;
			} else if((getScheduleFForm().getLevel().toString().equals(ScheduleFLevelEnumeration.HWOWNER.toString()) && getScheduleFForm().getHwowner().equals(lsFind.getHwOwner()) )
					|| (getScheduleFForm().getLevel().toString().equals(ScheduleFLevelEnumeration.HOSTNAME.toString()) && getScheduleFForm().getHostname().equals(lsFind.getHostname()) )
					|| (getScheduleFForm().getLevel().toString().equals(ScheduleFLevelEnumeration.HWBOX.toString()) && getScheduleFForm().getMachineType().equals(lsFind.getMachineType()) && getScheduleFForm().getSerial().equals(lsFind.getSerial()) )) {
				break;
			}
		
		}

		return lsFind;
	}

	public ScheduleF getScheduleF() {
		return (ScheduleF) getSession().get("scheduleF");
	}

	public void setScheduleF(ScheduleF scheduleF) {
		getSession().put("scheduleF", scheduleF);
	}

	public ScheduleFForm getScheduleFForm() {
		return scheduleFForm;
	}

	public void setScheduleFForm(ScheduleFForm scheduleFForm) {
		this.scheduleFForm = scheduleFForm;
	}

	public Long getScheduleFId() {
		return scheduleFId;
	}

	public void setScheduleFId(Long scheduleFId) {
		this.scheduleFId = scheduleFId;
	}

	public ScheduleFService getScheduleFService() {
		return scheduleFService;
	}

	public void setScheduleFService(ScheduleFService scheduleFService) {
		this.scheduleFService = scheduleFService;
	}

	public ArrayList<Scope> getScopeArrayList() {
		return scopeArrayList;
	}

	public void setScopeArrayList(ArrayList<Scope> scopeArrayList) {
		this.scopeArrayList = scopeArrayList;
	}

	public ArrayList<String> getLevelArrayList() {
		return levelArrayList;
	}

	public void setLevelArrayList(ArrayList<String> levelArrayList) {
		this.levelArrayList = levelArrayList;
	}

	public ArrayList<Source> getSourceArrayList() {
		return sourceArrayList;
	}

	public void setSourceArrayList(ArrayList<Source> sourceArrayList) {
		this.sourceArrayList = sourceArrayList;
	}

	public ArrayList<Status> getStatusArrayList() {
		return statusArrayList;
	}

	public void setStatusArrayList(ArrayList<Status> statusArrayList) {
		this.statusArrayList = statusArrayList;
	}
}
