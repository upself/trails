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

		int hwProcessorCount = aus.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getProcessorCount();

		if (hwProcessorCount < 1) {
			hwProcessorCount = aus.getInstalledSoftware().getSoftwareLpar()
					.getProcessorCount();
		}

		if (hwProcessorCount > 0) {
			
			PvuMap pvuMap = null;
			pvuMap = getPvuMapByAus(aus);
			
			int liNumberOfCores = aus.getInstalledSoftware().getSoftwareLpar()
					.getHardwareLpar().getHardware().getNbrCoresPerChip().intValue();

			licenseQty = getLicenseQtyByPvuAndNumberOfCores(liNumberOfCores,pvuMap,hwProcessorCount, pvuInfoDAO);

		}

		return licenseQty;
	}
	
	public int getLicenseQtyByPvuAndNumberOfCores(int liNumberOfCores,PvuMap pvuMap, int hwProcessorCount,PVUInfoDAO pvuInfoDAOLocal) {

		if (pvuMap == null || liNumberOfCores == 0) {
			return DEFAULT_PVU_VALUE * hwProcessorCount;
		} else {
			List<PvuInfo> llPvuInfo = null;
			PvuInfo lpvuiAlert = null;
			if (liNumberOfCores == 1 || liNumberOfCores == 2
					|| liNumberOfCores == 4) {
				llPvuInfo = pvuInfoDAOLocal.find(pvuMap.getProcessorValueUnit()
						.getId(), liNumberOfCores);
				if (llPvuInfo != null && llPvuInfo.size() > 0) {
					lpvuiAlert = llPvuInfo.get(0);
				}
			}

			if (lpvuiAlert != null
					&& lpvuiAlert.getValueUnitsPerCore().intValue() > 0) {

				return lpvuiAlert.getValueUnitsPerCore().intValue()* hwProcessorCount;

			} else {

				llPvuInfo = pvuInfoDAOLocal.find(pvuMap.getProcessorValueUnit()
						.getId());
				if (llPvuInfo != null && llPvuInfo.size() > 0) {
					lpvuiAlert = llPvuInfo.get(0);
				}

				if (lpvuiAlert == null
						|| lpvuiAlert.getValueUnitsPerCore().intValue() == 0) {
					return DEFAULT_PVU_VALUE * hwProcessorCount;
				} else {
					return lpvuiAlert.getValueUnitsPerCore().intValue() * hwProcessorCount;
				}
			}
		}		
	}
	
	private PvuMap getPvuMapByAus(AlertUnlicensedSw aus) {
		
		String lsProcessorBrand = aus.getInstalledSoftware()
				.getSoftwareLpar().getHardwareLpar().getHardware()
				.getMastProcessorType();
		String lsProcessorModel = aus.getInstalledSoftware()
				.getSoftwareLpar().getHardwareLpar().getHardware()
				.getProcessorModel();
		MachineType lmtAlert = aus.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getMachineType();
		
		return pvuMapDAO.getPvuMapByBrandAndModelAndMachineTypeId(
				lsProcessorBrand, lsProcessorModel, lmtAlert);	
		
	}

	public boolean allocate(Recon recon, License license, AlertUnlicensedSw aus) {
		return true;
	}

	public boolean inMyScope(String allocationMethodology) {
		return IN_SCOPE_AM.equalsIgnoreCase(allocationMethodology);
	}

}
