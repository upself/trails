package com.ibm.ea.common.reconcile;

import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;

public interface IReconcileRule {

	public int requiredLicenseQty(Recon recon, AlertUnlicensedSw aus);

	public boolean allocate(Recon recon, License license, AlertUnlicensedSw aus);

	public boolean inMyScope(String allocationMethodology);

}
