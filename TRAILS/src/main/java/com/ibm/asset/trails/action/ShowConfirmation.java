package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.action.ShowQuestion.LicenseFilter;
import com.ibm.asset.trails.domain.AllocationMethodology;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.asset.trails.domain.Report;
import com.ibm.asset.trails.service.AllocationMethodologyService;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.ActionContext;

public class ShowConfirmation extends AccountBaseAction {

	private static final long serialVersionUID = 1L;

	private ReconWorkspaceService reconWorkspaceService;

	private Recon recon;

	private String runon;

	private boolean automated;

	private boolean manual;

	private Long installedSoftwareId;

	private String comments;

	private String[] availableLicenseId;

	private String maxLicenses;

	private String per;

	private List<ReconWorkspace> list;

	@Autowired
	private LicenseService licenseService;

	@Autowired
	private AllocationMethodologyService allocationMethodologyService;

	private List<License> licenseList = new ArrayList<License>();

	private List<AllocationMethodology> allocationMethodologies;

	private String[] selectedLicenseId;

	private boolean disabled;
	
	private List<Report> reportList;
	
	private List<LicenseFilter> filter;
	

	public List<LicenseFilter> getFilter() {
		return filter;
	}

	public void setFilter(List<LicenseFilter> filter) {
		this.filter = filter;
	}

	public List<Report> getReportList() {
		return reportList;
	}

	public void setReportList(List<Report> reportList) {
		this.reportList = reportList;
	}

	@Override
	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {
		super.prepare();

		if (getPer() == null || getPer().equalsIgnoreCase("PVU")
				|| getPer().equalsIgnoreCase("HWGARTMIPS")
				|| getPer().equalsIgnoreCase("LPARGARTMIPS")
				|| getPer().equalsIgnoreCase("HWLSPRMIPS")
				|| getPer().equalsIgnoreCase("LPARLSPRMIPS")
				|| getPer().equalsIgnoreCase("HWMSU")
				|| getPer().equalsIgnoreCase("LPARMSU")) {
			disabled = true;
		}
		setAllocationMethodologies(allocationMethodologyService.findAll());
		
	}

	@UserRole(userRole = UserRoleType.READER)
	public String cancel() {
		return "cancel";
	}

	@UserRole(userRole = UserRoleType.READER)
	public String addAvailableLicenses() {
		 List<Report> lReport = new ArrayList<Report>();
		 lReport.add(new Report("License baseline", "licenseBaseline"));
		 setReportList(lReport);
		 setFilter(this.getFilter());
		 List<License> llLicense = getRecon().getLicenseList();
		 boolean lbFoundLicense = false;
		 
		if (llLicense == null) {
			llLicense = new ArrayList<License>();
		}

		for (String lsLicenseId : availableLicenseId) {
			lbFoundLicense = false;

			for (License llTemp : llLicense) {
				if (llTemp.getId().compareTo(Long.valueOf(lsLicenseId)) == 0) {
					lbFoundLicense = true;
					break;
				}
			}

			if (!lbFoundLicense) {
				llLicense.add(getLicenseService().getLicenseDetails(
						Long.valueOf(lsLicenseId)));
			}
		}

		if (llLicense.size() > 0) {
			getRecon().setLicenseList(llLicense);
		}
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		if (getMaxLicenses() != null && getMaxLicenses().trim().length() > 0) {
			recon.setMaxLicenses(new Integer(maxLicenses));
		}
		recon.setPer(per);

		return "license";
	}

	@UserRole(userRole = UserRoleType.READER)
	public String deleteSelectedLicenses() {
		List<License> llLicense = getRecon().getLicenseList();
		ListIterator<License> lliLicense = null;
		License llTemp;
		
	    List<Report> lReport = new ArrayList<Report>();
	    lReport.add(new Report("License baseline", "licenseBaseline"));
   	    setReportList(lReport);

		if (llLicense == null) {
			llLicense = new ArrayList<License>();
		}

		for (String lsLicenseId : selectedLicenseId) {
			lliLicense = llLicense.listIterator();

			while (lliLicense.hasNext()) {
				llTemp = lliLicense.next();

				if (llTemp.getId().compareTo(Long.valueOf(lsLicenseId)) == 0) {
					lliLicense.remove();
					break;
				}
			}
		}

		getRecon().setLicenseList(llLicense);
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		if (getMaxLicenses() != null && getMaxLicenses().trim().length() > 0) {
			recon.setMaxLicenses(new Integer(maxLicenses));
		}
		recon.setPer(per);

		return "license";
	}

	public List<License> getReconLicenseList() {
		return getRecon().getLicenseList();
	}

	@UserRole(userRole = UserRoleType.READER)
	public String manualAllocation() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		if (maxLicenses != null && !"".equals(maxLicenses)) {
			recon.setMaxLicenses(new Integer(maxLicenses));
		}
		recon.setPer(per);

		licenseList = getRecon().getLicenseList();

		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String customerOwned() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);

		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String included() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		recon.setComments(comments);
		recon.setInstalledSoftware(getReconWorkspaceService()
				.getInstalledSoftware(installedSoftwareId));
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String altPurchase() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		recon.setComments(comments);
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String breakRecon() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);

		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String breakLicenseRecon() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);

		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String assign() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		recon.setComments(comments);

		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String unassign() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		recon.setComments(comments);

		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String enterpriseAgreement() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);
		recon.setComments(comments);
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String pendingCustomerDecision() {
		getData().setList(recon.getList());
		recon.setAutomated(automated);
		recon.setManual(manual);
		recon.setRunon(runon);

		return SUCCESS;
	}

	@Override
	public void validate() {
		// Find which button was pressed by finding the method name that was
		// called
		Map<String, Object> lmParameter = ActionContext.getContext()
				.getParameters();
		Set<String> lsParameterKey = lmParameter.keySet();
		Iterator<String> liParameterKey = lsParameterKey.iterator();
		String lsKey = null;
		String lsMethod = null;
		
		if (recon.getReconcileType().getId() == 1) {
			 List<Report> lReport = new ArrayList<Report>();
			 lReport.add(new Report("License baseline", "licenseBaseline"));
			 setReportList(lReport);			
		}

		while (liParameterKey.hasNext()) {
			lsKey = liParameterKey.next();

			if (lsKey.startsWith("method:")) {
				lsMethod = lsKey.substring(7);
			}
		}

		if (recon.getReconcileType().getId() == 3
				|| recon.getReconcileType().getId() == 4
				|| recon.getReconcileType().getId() == 10
				|| recon.getReconcileType().getId() == 11
				|| recon.getReconcileType().getId() == 13) {
			if (StringUtils.isBlank(comments)) {
				addFieldError("comments", "You must enter a comment, less than 255 characters");
			}else if (StringUtils.length(comments) > 255){
				addFieldError("comments", "comment must be less than 255 characters");
			}
		}

		else if (recon.getReconcileType().getId() == 1) {
			if (lsMethod != null
					&& lsMethod.equalsIgnoreCase("addAvailableLicenses")) {
				if (availableLicenseId == null
						|| availableLicenseId.length == 0) {
					addFieldError("availableLicenseId",
							"You must select at least one available license");
				}
				else{
					if(hasSameCapacityType(availableLicenseId,getRecon().getLicenseList()) == false){
						addFieldError("availableLicenseId",
								"You have selected two or more licenses with different capacity types. Please ensure that all selected licenses have the same capacity type");	
					}
				} 
			} else if (lsMethod != null
					&& lsMethod.equalsIgnoreCase("deleteSelectedLicenses")) {
				if (selectedLicenseId == null || selectedLicenseId.length == 0) {
					addFieldError("selectedLicenseId",
							"You must select as least one selected license");
				}
			} else {
				if (getRecon().getLicenseList() == null
						|| getRecon().getLicenseList().isEmpty()) {
					addFieldError("licenseId",
							"You must select at least one license");
				} else if (per.equalsIgnoreCase("PVU") && !isAllPvuLicenses()) {
					addFieldError("licenseId",
							"You must select license(s) with a Capacity type of PROCESSOR VALUE UNIT");
				} else if (per.equalsIgnoreCase("PROCESSOR") && !isValidProcessor()){
					addFieldError("per", "LPAR proc must be active and greater than zero");
				} else if ((per.equalsIgnoreCase("HWGARTMIPS")
						|| per.equalsIgnoreCase("LPARGARTMIPS")
						|| per.equalsIgnoreCase("HWLSPRMIPS")
						|| per.equalsIgnoreCase("LPARLSPRMIPS")
						|| per.equalsIgnoreCase("HWMSU") || per
							.equalsIgnoreCase("LPARMSU"))
						&& !isAllGSLMLicenses(per)) {
					addFieldError("licenseId",
							"You must select license(s) with a Capacity type of Mainframes");
				}
				if (StringUtils.isBlank(maxLicenses)
						&& !(per.equalsIgnoreCase("PVU")
								|| per.equalsIgnoreCase("HWGARTMIPS")
								|| per.equalsIgnoreCase("LPARGARTMIPS")
								|| per.equalsIgnoreCase("HWLSPRMIPS")
								|| per.equalsIgnoreCase("LPARLSPRMIPS")
								|| per.equalsIgnoreCase("HWMSU")
								|| per.equalsIgnoreCase("LPARMSU") || per
									.equalsIgnoreCase("HWIFL"))) {
					addFieldError("maxLicenses",
							"You must enter the number of license to apply for each LPAR or processor");
				} else if (!(per.equalsIgnoreCase("PVU")
						|| per.equalsIgnoreCase("HWGARTMIPS")
						|| per.equalsIgnoreCase("LPARGARTMIPS")
						|| per.equalsIgnoreCase("HWLSPRMIPS")
						|| per.equalsIgnoreCase("LPARLSPRMIPS")
						|| per.equalsIgnoreCase("HWMSU")
						|| per.equalsIgnoreCase("LPARMSU") || per
							.equalsIgnoreCase("HWIFL"))
						&& (!StringUtils.isNumeric(maxLicenses) || Integer
								.valueOf(maxLicenses).intValue() < 1)) {
					addFieldError("maxLicenses",
							"Number of licenses must be an integer greater than zero");
				}
				if (StringUtils.isBlank(per)) {
					addFieldError("per",
							"You must enter an allocation methodology");
				}
			}

		}
		if ((recon.getReconcileType().getId() == 1
				|| recon.getReconcileType().getId() == 13 || recon
				.getReconcileType().getId() == 14) && (!manual || !automated)) {
			list = recon.getList();
			if (list != null && list.size() > 0) {
				boolean manualMessage = false;
				boolean automatedMessage = false;
				for (int i = 0; i < list.size(); i++) {
					ReconWorkspace rw = list.get(i);
					if (rw.getReconcileTypeId() != null) {
						ReconcileType rt = reconWorkspaceService
								.findReconcileType(rw.getReconcileTypeId());
						if (rt.isManual()) {
							if (!manualMessage && !manual) {
								addFieldError("manual",
										"You must check \"Overwrite manual reconciliations\" option");
								manualMessage = true;
							}
						} else {
							if (!automatedMessage && !automated) {
								addFieldError("automated",
										"You must check \"Overwrite automated reconciliations\" option");
								automatedMessage = true;
							}
						}
					}
					if (manualMessage && automatedMessage)
						break;
				}
			}
		}

		if (hasFieldErrors()
				|| (recon.getReconcileType().getId() == 1 && lsMethod != null && (lsMethod
						.equalsIgnoreCase("addAvailableLicenses") || lsMethod
						.equalsIgnoreCase("deleteSelectedLicenses")))) {
			if (recon.getReconcileType().getId() == 1) {
				List<LicenseFilter> filterlist = (List<LicenseFilter>)ActionContext.getContext().getSession().get("filters");
				
				licenseService.freePoolWithParentPaginatedList(getData(),
						getUserSession().getAccount(), getStartIndex(),
						getData().getObjectsPerPage(), getSort(), getDir(),
						filterlist);
			}

			list = recon.getList();
		}
	}

	private boolean isAllPvuLicenses() {
		boolean lbAllPvuLicenses = true;

		for (License llTemp : getRecon().getLicenseList()) {
			if (llTemp.getCapacityType().getCode().intValue() != 17) {
				lbAllPvuLicenses = false;
				break;
			}
		}

		return lbAllPvuLicenses;
	}
	
	private boolean isValidProcessor(){
		boolean isValidProcessor = true;
		for(ReconWorkspace reconWorkspace : recon.getList()){
			if(!reconWorkspace.getHwLparEffProcessorStatus().equalsIgnoreCase("ACTIVE")){
				isValidProcessor = false;
				break;
			}else if(null == reconWorkspace.getHwLparEffProcessorCount() || reconWorkspace.getHwLparEffProcessorCount() <=0){
				isValidProcessor = false;
				break;
			}
		}
		
		return isValidProcessor;
	}

	private boolean isAllGSLMLicenses(String per) {
		boolean lbAllGSLMLicenses = true;

		for (License llTemp : getRecon().getLicenseList()) {

			if (per.equalsIgnoreCase("HWGARTMIPS")
					&& llTemp.getCapacityType().getCode() != 70) {
				lbAllGSLMLicenses = false;
				break;
			}
			if (per.equalsIgnoreCase("LPARGARTMIPS")
					&& llTemp.getCapacityType().getCode() != 70) {
				lbAllGSLMLicenses = false;
				break;
			}
			if (per.equalsIgnoreCase("HWLSPRMIPS")
					&& llTemp.getCapacityType().getCode() != 5) {
				lbAllGSLMLicenses = false;
				break;
			}
			if (per.equalsIgnoreCase("LPARLSPRMIPS")
					&& llTemp.getCapacityType().getCode() != 5) {
				lbAllGSLMLicenses = false;
				break;
			}
			if (per.equalsIgnoreCase("HWMSU")
					&& llTemp.getCapacityType().getCode() != 9) {
				lbAllGSLMLicenses = false;
				break;
			}
			if (per.equalsIgnoreCase("LPARMSU")
					&& llTemp.getCapacityType().getCode() != 9) {
				lbAllGSLMLicenses = false;
				break;
			}
		}

		return lbAllGSLMLicenses;
	}

	public ReconWorkspaceService getReconWorkspaceService() {
		return reconWorkspaceService;
	}

	public void setReconWorkspaceService(
			ReconWorkspaceService reconWorkspaceService) {
		this.reconWorkspaceService = reconWorkspaceService;
	}

	public Recon getRecon() {
		return recon;
	}

	public void setRecon(Recon recon) {
		this.recon = recon;
	}

	public boolean isAutomated() {
		return automated;
	}

	public void setAutomated(boolean automated) {
		this.automated = automated;
	}

	public boolean isManual() {
		return manual;
	}

	public void setManual(boolean manual) {
		this.manual = manual;
	}

	public String getRunon() {
		return runon;
	}

	public void setRunon(String runon) {
		this.runon = runon;
	}

	public Long getInstalledSoftwareId() {
		return installedSoftwareId;
	}

	public void setInstalledSoftwareId(Long installedSoftwareId) {
		this.installedSoftwareId = installedSoftwareId;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String[] getAvailableLicenseId() {
		return availableLicenseId;
	}

	public void setAvailableLicenseId(String[] availableLicenseId) {
		this.availableLicenseId = availableLicenseId;
	}

	public String getMaxLicenses() {
		return maxLicenses;
	}

	public void setMaxLicenses(String maxLicenses) {
		this.maxLicenses = maxLicenses;
	}

	public String getPer() {
		return per;
	}

	public void setPer(String per) {
		this.per = per;
	}

	public LicenseService getLicenseService() {
		return licenseService;
	}

	public void setLicenseService(LicenseService licenseService) {
		this.licenseService = licenseService;
	}

	public List<ReconWorkspace> getList() {
		return list;
	}

	public void setList(List<ReconWorkspace> list) {
		this.list = list;
	}

	public List<License> getLicenseList() {
		return licenseList;
	}

	public void setLicenseList(List<License> licenseList) {
		this.licenseList = licenseList;
	}

	public String[] getSelectedLicenseId() {
		return selectedLicenseId;
	}

	public void setSelectedLicenseId(String[] selectedLicenseId) {
		this.selectedLicenseId = selectedLicenseId;
	}

	public boolean isDisabled() {
		return disabled;
	}

	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}

	public List<AllocationMethodology> getAllocationMethodologies() {
		return allocationMethodologies;
	}

	public void setAllocationMethodologies(
			List<AllocationMethodology> allocationMethodologies) {
		this.allocationMethodologies = allocationMethodologies;
	}
	
	private boolean hasSameCapacityType(String[] selectedLicenseIds, List<License> licenseListInReconWorkspace){
		boolean sameCapacityTypeFlag = true;
		
		if(selectedLicenseIds!=null){
			List<License> selectedLicenseArray = new ArrayList<License>();
			for (String selectedLicenseId : selectedLicenseIds){
				 if(selectedLicenseId!=null && !"".equals(selectedLicenseId.trim())){
					 License selectedLicense = getLicenseService().getLicenseDetails(Long.valueOf(selectedLicenseId.trim()));
					 selectedLicenseArray.add(selectedLicense);
				 }
			 }
			
			if(licenseListInReconWorkspace!=null && licenseListInReconWorkspace.size()>0){
				selectedLicenseArray.addAll(licenseListInReconWorkspace);
			}
			
			for(int index = 1; index < selectedLicenseArray.size(); index++){
				 if(selectedLicenseArray.get(0).getCapacityType().getCode().intValue() 
				  !=selectedLicenseArray.get(index).getCapacityType().getCode().intValue()){
					 sameCapacityTypeFlag = false;
					 break;
				 }
			}
		}
		
		return sameCapacityTypeFlag;		
	}
}
