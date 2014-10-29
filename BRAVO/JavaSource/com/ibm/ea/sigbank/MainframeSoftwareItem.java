package com.ibm.ea.sigbank;

import org.apache.struts.validator.ValidatorActionForm;


public class MainframeSoftwareItem extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
//    private MainframeVersion mainframeVersion;
//    private MainframeFeature smainframeFeature;    
    
    private Long id;
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}

//	public MainframeVersion getMainframeVersion() {
//		return mainframeVersion;
//	}
//	public void setMainframeVersion(MainframeVersion mainframeVersion) {
//		this.mainframeVersion = mainframeVersion;
//	}
	
//	public MainframeFeature getSmainframeFeature() {
//		return smainframeFeature;
//	}
//	public void setSmainframeFeature(MainframeFeature smainframeFeature) {
//		this.smainframeFeature = smainframeFeature;
//	}
	
}
