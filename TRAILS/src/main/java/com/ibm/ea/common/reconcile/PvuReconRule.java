package com.ibm.ea.common.reconcile;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.dao.PVUInfoDAO;
import com.ibm.asset.trails.dao.PVUMapDAO;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.PvuInfo;
import com.ibm.asset.trails.domain.PvuMap;
import com.ibm.asset.trails.domain.Recon;

public class PvuReconRule implements IReconcileRule {

	private static final String IN_SCOPE_AM = "PVU";

	@Autowired
	private PVUMapDAO pvuMapDAO;

	@Autowired
	private PVUInfoDAO pvuInfoDAO;

	private final int DEFAULT_PVU_VALUE = 0;

	public int requiredLicenseQty(Recon recon, AlertUnlicensedSw aus) {

		int licenseQty = 0;

		int hwChips = aus.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getChips();
		int hwProcessorCount = aus.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getProcessorCount();

		if (hwProcessorCount < 1) {
			hwProcessorCount = aus.getInstalledSoftware().getSoftwareLpar()
					.getProcessorCount();
		}

		if (hwProcessorCount > 0) {
			if (hwChips == 0) {
				licenseQty = DEFAULT_PVU_VALUE * hwProcessorCount;
			} else {
				String lsProcessorBrand = aus.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getMastProcessorType();
				String lsProcessorModel = aus.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getProcessorModel();
				MachineType lmtAlert = aus.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getMachineType();
				PvuMap pvuMap = null;
				int liNumberOfCores = 0;

				pvuMap = pvuMapDAO.getPvuMapByBrandAndModelAndMachineTypeId(
						lsProcessorBrand, lsProcessorModel, lmtAlert);

				if (pvuMap == null) {
					licenseQty = DEFAULT_PVU_VALUE * hwProcessorCount;
				} else {
					liNumberOfCores = hwProcessorCount / hwChips;

					if (liNumberOfCores == 0) {
						licenseQty = DEFAULT_PVU_VALUE * hwProcessorCount;
					} else {
						List<PvuInfo> llPvuInfo = null;
						PvuInfo lpvuiAlert = null;
						if (liNumberOfCores == 1 || liNumberOfCores == 2
								|| liNumberOfCores == 4) {
							llPvuInfo = pvuInfoDAO.find(pvuMap
									.getProcessorValueUnit().getId(),
									liNumberOfCores);
							if (llPvuInfo != null && llPvuInfo.size() > 0) {
								lpvuiAlert = llPvuInfo.get(0);
							}
						}

						if (lpvuiAlert != null
								&& lpvuiAlert.getValueUnitsPerCore().intValue() > 0) {
							licenseQty = lpvuiAlert.getValueUnitsPerCore()
									.intValue() * hwProcessorCount;
						} else {
							llPvuInfo = pvuInfoDAO.find(pvuMap
									.getProcessorValueUnit().getId());
							if (llPvuInfo != null && llPvuInfo.size() > 0) {
								lpvuiAlert = llPvuInfo.get(0);
							}

							if (lpvuiAlert == null
									|| lpvuiAlert.getValueUnitsPerCore()
											.intValue() == 0) {
								licenseQty = DEFAULT_PVU_VALUE
										* hwProcessorCount;
							} else {
								licenseQty = lpvuiAlert.getValueUnitsPerCore()
										.intValue() * hwProcessorCount;
							}
						}
					}
				}
			}
		} 

		return licenseQty;
	}

	public boolean allocate(Recon recon, License license, AlertUnlicensedSw aus) {
		return true;
	}

	public boolean inMyScope(String allocationMethodology) {
		return IN_SCOPE_AM.equalsIgnoreCase(allocationMethodology);
	}

}
