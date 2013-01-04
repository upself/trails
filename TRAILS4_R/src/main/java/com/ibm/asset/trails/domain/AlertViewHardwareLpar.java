package com.ibm.asset.trails.domain;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;


@Entity
@DiscriminatorValue("HARDWARE_LPAR")
public class AlertViewHardwareLpar extends AlertView {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "FK_ID")
	private HardwareLpar hardwareLpar;

	public HardwareLpar getHardwareLpar() {
		return hardwareLpar;
	}

	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
	}

}
