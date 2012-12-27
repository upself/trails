package com.ibm.asset.trails.domain;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;


@Entity
@DiscriminatorValue("UNLICENSED_ISV_SW")
public class AlertViewUnlicensedIsvSw extends AlertView {

	@ManyToOne
	@JoinColumn(name = "FK_ID")
	private InstalledSoftware installedSoftware;

	public InstalledSoftware getInstalledSoftware() {
		return installedSoftware;
	}

	public void setInstalledSoftware(InstalledSoftware installedSoftware) {
		this.installedSoftware = installedSoftware;
	}
}
