package com.ibm.ea.sigbank;

import org.apache.struts.validator.ValidatorActionForm;
import com.ibm.ea.sigbank.MainframeVersion;

public class MainframeFeature  extends ValidatorActionForm {


    /**
	 * 
	 */
	private static final long serialVersionUID = 8113561183183669295L;
	private Long id;
    private MainframeVersion version;
    private Integer ibmCSAgreement;
    private String sseNId;
    private String eid;
    private String swPricingType;
    private String vue;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public MainframeVersion getVersion() {
		return version;
	}
	public void setVersion(MainframeVersion version) {
		this.version = version;
	}
	
	public String getEid() {
		return eid;
	}
	public void setEid(String eid) {
		this.eid = eid;
	}

	public Integer getIbmCSAgreement() {
		return ibmCSAgreement;
	}
	public void setIbmCSAgreement(Integer ibmCSAgreement) {
		this.ibmCSAgreement = ibmCSAgreement;
	}
	
	public String getSseNId() {
		return sseNId;
	}
	public void setSseNId(String sseNId) {
		this.sseNId = sseNId;
	}

	public String getSwPricingType() {
		return swPricingType;
	}
	public void setSwPricingType(String swPricingType) {
		this.swPricingType = swPricingType;
	}
	   
	public String getVue() {
		return vue;
	}
	public void setVue(String vue) {
		this.vue = vue;
	}
}