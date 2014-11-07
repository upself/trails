package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "MAINFRAME_VERSION")
public class MainframeVersion extends SoftwareItem {
	private static final long serialVersionUID = 6686223676749113056L;

	@Basic
	@Column(name = "SERVICE_SUPPORT_ID")
	protected String serviceSupportId;

	@Basic
	@Column(name = "IDENTIFIER")
	protected String identifier;

	@Basic
	@Column(name = "MANUFACTURER_ID")
	protected Long manufacturer;

	@Basic
	@Column(name = "VERSION")
	protected Integer version;

	@Basic
	@Column(name = "PRODUCT_ID")
	protected Long productInfo;

	@Basic
	@Column(name = "VUE", length = 10)
	protected String vue;

	@Basic
	@Column(name = "SOFTWARE_PRICING_TYPE", length = 10)
	protected String softwarePricingType;

	@Basic
	@Column(name = "IBM_CUSTOMER_AGREEMENT")
	protected boolean ibmCustomerAgreement;

	@OneToOne(optional = true, cascade = CascadeType.MERGE)
	@JoinColumn(name = "ID", referencedColumnName = "ID")
	protected MainframeProductInfo mainframeProductInfo;

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getServiceSupportId() {
		return serviceSupportId;
	}

	public void setServiceSupportId(String serviceSupportId) {
		this.serviceSupportId = serviceSupportId;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public Long getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Long manufacturer) {
		this.manufacturer = manufacturer;
	}

	public Long getProductInfo() {
		return productInfo;
	}

	public void setProductInfo(Long productInfo) {
		this.productInfo = productInfo;
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

	public boolean isIbmCustomerAgreement() {
		return ibmCustomerAgreement;
	}

	public void setIbmCustomerAgreement(boolean ibmCustomerAgreement) {
		this.ibmCustomerAgreement = ibmCustomerAgreement;
	}

	public MainframeProductInfo getMainframeProductInfo() {
		return mainframeProductInfo;
	}

	public void setMainframeProductInfo(
			MainframeProductInfo mainframeProductInfo) {
		this.mainframeProductInfo = mainframeProductInfo;
	}

}
