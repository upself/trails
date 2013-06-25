package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class ShowQuestion extends AccountBaseAction {

	private static final long serialVersionUID = 1L;

	private ReconWorkspaceService reconWorkspaceService;

	@Autowired
	private LicenseService licenseService;

	private List<ReconcileType> reconcileTypes;

	private Recon recon;

	private Long reconcileTypeId;

	private LicenseFilter filter;

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

		private List<String> manufacturer;
		private List<Integer> capcityType;
		private List<String> productName;
		private List<String> poNo;
		private List<String> swcmId;

		public void setCapcityType(List<String> capcityType) {
			this.capcityType = new ArrayList<Integer>();
			for (String str : capcityType) {
				Integer tmp = Integer.valueOf(str);
				if (tmp == -1) {
					continue;
				}
				this.capcityType.add(tmp);
			}
		}
		public List<Integer> getCapcityType() {
			return capcityType;
		}
		
		public void setSwcmId(List<String> swcmId) {
			this.swcmId = trim(swcmId);
		}
		public List<String> getSwcmId() {
			return swcmId;
		}

		public List<String> getManufacturer() {
			return manufacturer;
		}
		public void setManufacturer(List<String> manufacturer) {
			this.manufacturer = trim(manufacturer);
		}

		

		public List<String> getProductName() {
			return productName;
		}
		public void setProductName(List<String> productName) {
			this.productName = trim(productName);
		}

		public List<String> getPoNo() {
			return poNo;
		}
		public void setPoNo(List<String> poNo) {
			this.poNo = trim(poNo);
		}

		private List<String> trim(List<String> list) {
			List<String> result = new ArrayList<String>();
			for (String str : list) {
				String trimed = str.trim();
				if ("".equals(trimed)) {
					continue;
				}
				result.add(trimed);
			}
			return result;
		}
	}

	@Override
	@UserRole(userRole = UserRoleType.READER)
	public String execute() {

		recon.setList(list);
		recon.setReconcileTypeId(reconcileTypeId);

		// Get the reconcile type chosen
		recon.setReconcileType(getReconWorkspaceService().findReconcileType(
				recon.getReconcileTypeId()));

		if (recon.getReconcileType().getId().intValue() == 1) {
			licenseService.freePoolWithParentPaginatedList(getData(),
					getUserSession().getAccount(), getStartIndex(), getData()
							.getObjectsPerPage(), getSort(), getDir(), this
							.getLicenseFilter());
		} else if (recon.getReconcileType().getId().intValue() == 2) {
			// customer owned

		} else if (recon.getReconcileType().getId().intValue() == 3) {
			// alternate purchase

		} else if (recon.getReconcileType().getId().intValue() == 4) {
			// included with other product
			ReconWorkspace rw = recon.getList().get(0);
			recon.setInstalledSoftwareList(getReconWorkspaceService()
					.installedSoftwareList(rw.getInstalledSoftwareId()));
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

	private LicenseFilter getLicenseFilter() {
		if (this.filter == null) {
			this.filter = new LicenseFilter();
		}
		return this.filter;
	}

	public void setManufacturer(List<String> manufacturer) {
		getLicenseFilter().setManufacturer(manufacturer);
	}

	public void setCapcityType(List<String> capcityType) {
		getLicenseFilter().setCapcityType(capcityType);
	}

	public void setProductName(List<String> productName) {
		getLicenseFilter().setProductName(productName);
	}

	public void setPoNo(List<String> poNo) {
		getLicenseFilter().setPoNo(poNo);
	}

	public void setSwcmId(List<String> swcmId) {
		getLicenseFilter().setSwcmId(swcmId);
	}

}
