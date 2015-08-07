package com.ibm.asset.trails.domain;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
@DiscriminatorValue("HWCFGDTA")
public class AlertViewHardwareCfgData extends AlertView{
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "FK_ID")
	private Hardware hardware;

	public Hardware getHardware() {
		return hardware;
	}

	public void setHardware(Hardware hardware) {
		this.hardware = hardware;
	}
}
