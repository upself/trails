package com.ibm.asset.trails.domain;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;


@Entity
@DiscriminatorValue("SOFTWARE_LPAR")
public class AlertViewSoftwareLpar extends AlertView {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "FK_ID")
	private SoftwareLpar softwareLpar;

	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}
}
