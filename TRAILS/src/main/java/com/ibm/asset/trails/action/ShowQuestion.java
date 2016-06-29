package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

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

public class ShowQuestion extends AccountBaseAction {

	private static final long serialVersionUID = 1L;

	private ReconWorkspaceService reconWorkspaceService;

	@Autowired
	private LicenseService licenseService;

	@Autowired
	private AllocationMethodologyService allocationMethodologyService;

	private List<ReconcileType> reconcileTypes;

	private Recon recon;

	private Long reconcileTypeId;

	private List<LicenseFilter> filter;

	private List<AllocationMethodology> allocationMethodologies;
	
	private List<Report> reportList;
	
	private Boolean sortReq;
	
	public Boolean getSortReq() {
		return sortReq;
	}

	public void setSortReq(Boolean sortReq) {
		this.sortReq = sortReq;
	}

	public List<Report> getReportList() {
		return reportList;
	}

	public void setReportList(List<Report> reportList) {
		this.reportList = reportList;
	}

	// TODO just going to admit this is pure laziness
	// due to the license free pool being way to large to not paginate
	// so to pass validation we'll pass this flag.
	private Integer flag;

	private List<ReconWorkspace> list = new ArrayList<ReconWorkspace>();

	@Override
	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {
		super.prepare();
	}

	public class LicenseFilter {
		private String manufacturer;
		private Integer capcityType;
		private String productName;
		private String poNo;
		private String swcmId;
		private String licenseOwner;
		
		public String getLicenseOwner() {
			return licenseOwner;
		}

		public void setLicenseOwner(String licenseOwner) {
			this.licenseOwner = licenseOwner;
		}

		private String fuzzed(String s) {
			String str = s.trim();
			if (str != null && !"".equals(str)) {
				return "%" + str.trim() + "%";
			} else {
				return null;
			}
		}

		public String getManufacturer() {
			return manufacturer;
		}

		public void setManufacturer(String manufacturer) {
			this.manufacturer = fuzzed(manufacturer);
		}

		public Integer getCapcityType() {
			return capcityType;
		}

		public void setCapcityType(String capcityType) {
			Integer tmp = Integer.valueOf(capcityType);
			this.capcityType = tmp;
		}

		public String getProductName() {
			return productName;
		}

		public void setProductName(String productName) {
			this.productName = fuzzed(productName);
		}

		public String getPoNo() {
			return poNo;
		}

		public void setPoNo(String poNo) {
			String p = poNo.trim();
			if (p != null && !"".equals(p)) {
				this.poNo = p;
			} else {
				this.poNo = null;
			}
		}

		public String getSwcmId() {
			return swcmId;
		}

		public void setSwcmId(String swcmId) {
			String s = swcmId.trim();
			if (s != null && !"".equals(s)) {
				this.swcmId = s;
			} else {
				this.swcmId = null;
			}
		}

	}
	
	@Override
	@UserRole(userRole = UserRoleType.READER)
	public String execute() {

		setAllocationMethodologies(allocationMethodologyService.findAll());

		recon.setList(list);
		recon.setReconcileTypeId(reconcileTypeId);
		

		// Get the reconcile type chosen
		recon.setReconcileType(getReconWorkspaceService().findReconcileType(
				recon.getReconcileTypeId()));

		if (recon.getReconcileType().getId().intValue() == 1) {
			 List<Report> lReport = new ArrayList<Report>();
			 lReport.add(new Report("License baseline", "licenseBaseline"));
			 setReportList(lReport);
	        
			 //if sort request from manuallAllocation.jsp
			if(null!=sortReq && sortReq){
				setFilter((List<LicenseFilter>)ActionContext.getContext().getSession().get("filters"));				
			}else{
				
			}
			licenseService.freePoolWithParentPaginatedList(getData(),
					getUserSession().getAccount(), getStartIndex(), getData()
							.getObjectsPerPage(), getSort(), getDir(), this
							.getFilter());
			ActionContext.getContext().getSession().put("filters", this.getFilter());
			
		} else if (recon.getReconcileType().getId().intValue() == 2) {
			// customer owned

		} else if (recon.getReconcileType().getId().intValue() == 3) {
			// alternate purchase

		} else if (recon.getReconcileType().getId().intValue() == 4) {
			// included with other product
			ReconWorkspace rw = recon.getList().get(0);
			recon.setInstalledSoftwareList(getReconWorkspaceService()
					.installedSoftwareList(rw.getInstalledSoftwareId(), getAccount(), rw.getSl_hostname(), rw.getOwner(), rw.getAssetName(), rw.getSerial(), rw.getScopeId(), rw.getManufacturerName()));
		} else if (recon.getReconcileType().getId().intValue() == 9) {
			// break manual recon
		} else if (recon.getReconcileType().getId().intValue() == 12) {
			// Break license recon
		} else if (recon.getReconcileType().getId().intValue() == 13) {
			// Enterprise agreement
		} else if (recon.getReconcileType().getId().intValue() == 14) {
			// Customer owned and IBM managed
		}

		return recon.getReconcileType().getId().toString();
	}

	@Override
	public void validate() {

		ArrayList<ReconWorkspace> newList = new ArrayList<ReconWorkspace>();

		if (flag == null) {
			if (reconcileTypeId == null) {
				addFieldError("reconcileTypeId", "You must select an action");
			} else {

				Iterator<ReconWorkspace> i = list.iterator();
				while (i.hasNext()) {
					ReconWorkspace rw = i.next();
					if (rw.isSelected()) {
						newList.add(rw);
					}
				}
				if (newList.size() < 1) {
					addFieldError("selected",
							"You must select at least one line item.");
				} else {
					// If manual allocation or included with other product, we
					// only
					// accept one selection
					if (reconcileTypeId.intValue() == 1
							|| reconcileTypeId.intValue() == 4) {
						if (newList.size() > 1) {
							addFieldError("selected",
									"You may only select one line item for this action.");
						}
					}
				}
			}

			if (hasFieldErrors()) {
				// TODO find a better way than pulling this over from resultlist
				if (getSort() == null) {
					setSort("alertAge");
				}

				getReconWorkspaceService().paginatedList(getData(),
						getUserSession().getAccount(),
						getUserSession().getReconSetting(), getStartIndex(),
						getData().getObjectsPerPage(), getSort(), getDir());

				reconcileTypes = getReconWorkspaceService()
						.reconcileTypes(true);
			} else {
				list = newList;
				setPage(1);
				setSort("coalesce(L.quantity - sum(LUQV.usedQuantity),l.quantity)");
				setDir("desc");
				super.prepare();
			}
		} else {
			setList(recon.getList());
			setReconcileTypeId(recon.getReconcileTypeId());
			if (getSort() == null || getSort().equalsIgnoreCase("alertAge")) {
				setSort("coalesce(L.quantity - sum(LUQV.usedQuantity),l.quantity)");
				setDir("desc");
			}
			super.prepare();
		}
	}

	public List<License> getReconLicenseList() {
		return getRecon().getLicenseList();
	}

	public ReconWorkspaceService getReconWorkspaceService() {
		return reconWorkspaceService;
	}

	public void setReconWorkspaceService(
			ReconWorkspaceService reconWorkspaceService) {
		this.reconWorkspaceService = reconWorkspaceService;
	}

	public List<ReconcileType> getReconcileTypes() {
		return reconcileTypes;
	}

	public void setReconcileTypes(List<ReconcileType> reconcileTypes) {
		this.reconcileTypes = reconcileTypes;
	}

	public Recon getRecon() {
		return recon;
	}

	public void setRecon(Recon recon) {
		this.recon = recon;
	}

	public List<ReconWorkspace> getList() {
		return list;
	}

	public void setList(List<ReconWorkspace> list) {
		this.list = list;
	}

	public Long getReconcileTypeId() {
		return reconcileTypeId;
	}

	public void setReconcileTypeId(Long reconcileTypeId) {
		this.reconcileTypeId = reconcileTypeId;
	}

	public LicenseService getLicenseService() {
		return licenseService;
	}

	public void setLicenseService(LicenseService licenseService) {
		this.licenseService = licenseService;
	}

	public Integer getFlag() {
		return flag;
	}

	public void setFlag(Integer flag) {
		this.flag = flag;
	}

	public List<LicenseFilter> getFilter() {
		return filter;
	}

	public void setFilter(List<LicenseFilter> filter) {
		this.filter = filter;
	}

	public List<AllocationMethodology> getAllocationMethodologies() {
		return allocationMethodologies;
	}

	public void setAllocationMethodologies(
			List<AllocationMethodology> allocationMethodologies) {
		this.allocationMethodologies = allocationMethodologies;
	}
}
