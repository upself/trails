package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "MAINFRAME_FEATURE")
public class MainframeFeature extends SoftwareItem {

	private static final long serialVersionUID = -5764669908577943083L;

	@Basic
	@Column(name = "EID")
	protected String eId;

	@Basic
	@Column(name = "SSE_N_ID")
	protected String sseNId;

	@Basic
	@Column(name = "VERSION_ID")
	protected Long version;

	@Basic
	@Column(name = "IBM_CUSTOMER_AGREEMENT")
	protected boolean ibmCustomerAgreement;

	@Basic
	@Column(name = "VUE", length = 10)
	protected String vue;

	@Basic
	@Column(name = "SOFTWARE_PRICING_TYPE", length = 10)
	protected String softwarePricingType;

	public String geteId() {
		return eId;
	}

	public void seteId(String eId) {
		this.eId = eId;
	}

	public String getSseNId() {
		return sseNId;
	}

	public void setSseNId(String sseNId) {
		this.sseNId = sseNId;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public boolean isIbmCustomerAgreement() {
		return ibmCustomerAgreement;
	}

	public void setIbmCustomerAgreement(boolean ibmCustomerAgreement) {
		this.ibmCustomerAgreement = ibmCustomerAgreement;
	}

	public String getVue() {
		return vue;
	}

	public void setVue(String vue) {
		this.vue = vue;
	}

	public String getSoftwarePricingType() {
		return softwarePricingType;
	}

	public void setSoftwarePricingType(String softwarePricingType) {
		this.softwarePricingType = softwarePricingType;
	}

}
