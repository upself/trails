package com.ibm.ea.common.reconcile;

import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;

import edu.emory.mathcs.backport.java.util.Arrays;

public class MipMsuReconRule implements IReconcileRule {

	private static final String[] IN_SCOPE_AM_CODE = { "HWGARTMIPS",
			"LPARGARTMIPS", "HWLSPRMIPS", "LPARLSPRMIPS", "HWMSU", "LPARMSU" };

	public int requiredLicenseQty(Recon recon, AlertUnlicensedSw aus) {
		String allocationMethodology = recon.getPer();
		int licQty = 0;

		if (allocationMethodology.equalsIgnoreCase("HWGARTMIPS")) {
			licQty = Integer.valueOf(aus.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getCpuGartnerMips() == null ? 0 : aus
					.getInstalledSoftware().getSoftwareLpar().getHardwareLpar()
					.getHardware().getCpuGartnerMips().intValue());
		}
		if (allocationMethodology.equalsIgnoreCase("LPARGARTMIPS")) {
			licQty = Integer
					.valueOf(aus.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getPartGartnerMips() == null ? 0
							: aus.getInstalledSoftware().getSoftwareLpar()
									.getHardwareLpar().getPartGartnerMips()
									.intValue());
		}
		if (allocationMethodology.equalsIgnoreCase("HWLSPRMIPS")) {
			licQty = Integer.valueOf(aus.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getCpuLsprMips() == null ? 0 : aus.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getCpuLsprMips().intValue());
		}
		if (allocationMethodology.equalsIgnoreCase("LPARLSPRMIPS")) {
			licQty = Integer
					.valueOf(aus.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getPartLsprMips() == null ? 0
							: aus.getInstalledSoftware().getSoftwareLpar()
									.getHardwareLpar().getPartLsprMips()
									.intValue());
		}
		if (allocationMethodology.equalsIgnoreCase("HWMSU")) {
			licQty = Integer.valueOf(aus.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getCpuMsu() == null ? 0 : aus.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getCpuMsu().intValue());
		}
		if (allocationMethodology.equalsIgnoreCase("LPARMSU")) {
			licQty = Integer
					.valueOf(aus.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getPartMsu() == null ? 0 : aus
							.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getPartMsu().intValue());
		}

		return licQty;
	}

	public boolean allocate(Recon recon, License license, AlertUnlicensedSw aus) {

		if (recon.getPer().equalsIgnoreCase("HWGARTMIPS")
				&& license.getCapacityType().getCode() != 70) {
			return false;
		}
		if (recon.getPer().equalsIgnoreCase("LPARGARTMIPS")
				&& license.getCapacityType().getCode() != 70) {
			return false;
		}
		if (recon.getPer().equalsIgnoreCase("HWLSPRMIPS")
				&& license.getCapacityType().getCode() != 5) {
			return false;
		}
		if (recon.getPer().equalsIgnoreCase("LPARLSPRMIPS")
				&& license.getCapacityType().getCode() != 5) {
			return false;
		}
		if (recon.getPer().equalsIgnoreCase("HWMSU")
				&& license.getCapacityType().getCode() != 9) {
			return false;
		}
		if (recon.getPer().equalsIgnoreCase("LPARMSU")
				&& license.getCapacityType().getCode() != 9) {
			return false;
		}
		return true;
	}

	public boolean inMyScope(String allocationMethodology) {
		return Arrays.asList(IN_SCOPE_AM_CODE).contains(allocationMethodology);
	}

}
