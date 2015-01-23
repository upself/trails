package com.ibm.ea.common.reconcile;

import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;

public class HardwareIflReconRule implements IReconcileRule {

	private static final String IN_SCOPE_ALLOCOACTION_METHDOLOGY_CODE = "HWIFL";

	public int requiredLicenseQty(Recon recon, AlertUnlicensedSw aus) {

		Integer cpuIfl = aus.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getCpuIfl();

		if (cpuIfl != null && cpuIfl > 0) {
			return cpuIfl;
		}

		return 0;

	}

	public boolean allocate(Recon recon, License license, AlertUnlicensedSw aus) {

		String licenseTypeCode = license.getLicenseType().trim();
		boolean isWorkstation = aus.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getMachineType().getType()
				.equalsIgnoreCase("WORKSTATION");

		if (!"NAMED CPU".equalsIgnoreCase(licenseTypeCode)
				&& !"SC".equalsIgnoreCase(licenseTypeCode) && !isWorkstation
				&& !license.isTryAndBuy()) {
			return true;
		}

		String licenseCpuSerial = license.getCpuSerial();
		String hwSerial = aus.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getSerial();
		if (!"NAMED CPU".equalsIgnoreCase(licenseTypeCode)
				&& licenseCpuSerial != null && !isWorkstation
				&& !license.isTryAndBuy()
				&& licenseCpuSerial.equalsIgnoreCase(hwSerial)) {
			return true;
		}

		return false;
	}

	public boolean inMyScope(String allocationMethodology) {
		return IN_SCOPE_ALLOCOACTION_METHDOLOGY_CODE
				.equalsIgnoreCase(allocationMethodology);
	}
}
