package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity(name = "AlertInstalledSwNew")
@Table(name = "ALERT_INSTALLED_SOFTWARE")

public class DataExceptionInstalledSw extends DataException implements Serializable {

	private static final long serialVersionUID = 1L;

	@ManyToOne
	@JoinColumn(name = "INSTALLED_SOFTWARE_ID")
	protected InstalledSoftware installedSw;

	public InstalledSoftware getInstalledSw() {
		return installedSw;
	}

	public void setInstalledSw(InstalledSoftware installedSw) {
		this.installedSw = installedSw;
	}
}