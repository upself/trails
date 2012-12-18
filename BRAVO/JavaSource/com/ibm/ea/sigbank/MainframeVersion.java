package com.ibm.ea.sigbank;

import java.util.HashSet;
import java.util.Set;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.ea.sigbank.Manufacturer;
import com.ibm.ea.sigbank.MainframeFeature;
import com.ibm.ea.sigbank.Product;

public class MainframeVersion extends ValidatorActionForm  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8606532028953385366L;
    private Long id;
    private Manufacturer manufacturer;
    private Product mfProduct;
    private Integer ibmCSAgreement;
    private String idenfifier;
    private String serviceSupportId;
    private String swPricingType;
    private Integer version;
    private String vue;
	private Set<MainframeFeature> mainframeFeature = new HashSet<MainframeFeature>();
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Manufacturer getManufacturer() {
		return manufacturer;
	}
	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}
	public Product getMfProduct() {
		return mfProduct;
	}
	public void setMfProduct(Product mfProduct) {
		this.mfProduct = mfProduct;
	}

	public Integer getIbmCSAgreement() {
		return ibmCSAgreement;
	}
	public void setIbmCSAgreement(Integer ibmCSAgreement) {
		this.ibmCSAgreement = ibmCSAgreement;
	}
	
	public String getIdenfifier() {
		return idenfifier;
	}
	public void setIdenfifier(String idenfifier) {
		this.idenfifier = idenfifier;
	}
	public String getServiceSupportId() {
		return serviceSupportId;
	}
	public void setServiceSupportId(String serviceSupportId) {
		this.serviceSupportId = serviceSupportId;
	}
	
	public String getSwPricingType() {
		return swPricingType;
	}
	public void setSwPricingType(String swPricingType) {
		this.swPricingType = swPricingType;
	}
	
	public Integer getVersion() {
		return version;
	}
	public void setVersion(Integer version) {
		this.version = version;
	}
    
	public String getVue() {
		return vue;
	}
	public void setVue(String vue) {
		this.vue = vue;
	}
	
	public Set<MainframeFeature> getMainframeFeature() {
		if (mainframeFeature == null) {
			mainframeFeature = new HashSet<MainframeFeature>();
		}
		return mainframeFeature;
	}

	public void setMainframeFeature(Set<MainframeFeature> mainframeFeature) {
		this.mainframeFeature = mainframeFeature;
	}
}