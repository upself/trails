package com.ibm.asset.trails.form;

import java.util.Set;

import com.ibm.asset.trails.domain.ReconInstalledSoftware;
import com.ibm.asset.trails.domain.ReconLicense;

public class BreakResult {
	ReconInstalledSoftware reconInstalledSoftware;
	Set<ReconLicense> reconLicenseSet;

	public BreakResult() {

	}

	public BreakResult(ReconInstalledSoftware reconInstalledSoftware,
			Set<ReconLicense> reconLicenseSet) {
		this.reconInstalledSoftware = reconInstalledSoftware;
		this.reconLicenseSet = reconLicenseSet;
	}

	public ReconInstalledSoftware getReconInstalledSoftware() {
		return reconInstalledSoftware;
	}

	public void setReconInstalledSoftware(
			ReconInstalledSoftware reconInstalledSoftware) {
		this.reconInstalledSoftware = reconInstalledSoftware;
	}

	public Set<ReconLicense> getReconLicenseSet() {
		return reconLicenseSet;
	}

	public void setReconLicenseSet(Set<ReconLicense> reconLicenseSet) {
		this.reconLicenseSet = reconLicenseSet;
	}

}
