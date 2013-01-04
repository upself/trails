package com.ibm.asset.trails.domain;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;


@Entity
@DiscriminatorValue("EXPIRED_MAINT")
public class AlertViewExpiredMaint extends AlertView {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "FK_ID")
	private License license;

	public License getLicense() {
		return license;
	}

	public void setLicense(License license) {
		this.license = license;
	}
}
