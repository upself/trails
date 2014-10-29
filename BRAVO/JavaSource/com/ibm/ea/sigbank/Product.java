/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProductMap;


public class Product
	extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
    private Long id;
    private String function;
    private Integer pvu;
    private Integer licenseType;
    private Manufacturer manufacturer;
    private ProductInfo productInfo;
    private KbDefinition kbDefinition;
    private SoftwareItem softwareItem;
    private MicrosoftProductMap microsoftProductMap;
	private String status;

     
    //****************************************************************
    // return fields as if this is still pointing to Software
	public Integer getVendorManaged() {
		if ( kbDefinition.getCustom2() == null ) {
			return 0;
		}
		if ( kbDefinition.getCustom2().compareToIgnoreCase("true") == 0 ) {
			return 1;
		} else {
			return 0;
		}
	}
	public String getSoftwareType() {
		String softwareType = "";
		
		return softwareType;
	}
	public String getStatusImage() {
		if ( kbDefinition.getDeleted() == 0 ) {
			status = Constants.ACTIVE;
		} else {
			status = Constants.INACTIVE;
		}
		if (status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_OK + "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_NA + "\" width=\"12\" height=\"10\"/>";
	}
	
	public String getStatusIcon() {
		if ( kbDefinition.getDeleted() == 0 ) {
			status = Constants.ACTIVE;
		} else {
			status = Constants.INACTIVE;
		}
		if (status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}
	public String getComments() {
		return productInfo.getComments();
	}
	public String getLevel() {
		if ( productInfo.getLicensable().booleanValue() == true ) {
			return "LICENSABLE";
		} else {
			return "UN-LICENSABLE";
		}
	}
	public String getOwner() {
		String owner = "";
		return owner;
	}
	public Integer getPriority() {
		return productInfo.getPriority();
	}
	public Date getRecordTime() {
		return productInfo.getRecordTime();
	}
	public String getRemoteUser() {
		return productInfo.getRemoteUser();
	}
	public SoftwareCategory getSoftwareCategory() {
		return productInfo.getSoftwareCategory();
	}
	public String getSoftwareCategoryId() {
		return getSoftwareCategory().getSoftwareCategoryId().toString();
	}
	public Long getSoftwareId() {
		return getId();
	}
	public String getSoftwareName() {
		return softwareItem.getName();
	}
	public String getStatus() {
		if ( kbDefinition.getDeleted() == 0 ) {
			status = Constants.ACTIVE;
		} else {
			status = Constants.INACTIVE;
		}
		
		return status;
	}

    
    //****************************************************
    
    
    
	public KbDefinition getKbDefinition() {
		return kbDefinition;
	}
	public MicrosoftProductMap getMicrosoftProductMap() {
		return microsoftProductMap;
	}
	public void setMicrosoftProductMap(MicrosoftProductMap microsoftProductMap) {
		this.microsoftProductMap = microsoftProductMap;
	}
	public SoftwareItem getSoftwareItem() {
		return softwareItem;
	}
	public void setSoftwareItem(SoftwareItem softwareItem) {
		this.softwareItem = softwareItem;
	}
	public void setKbDefinition(KbDefinition kbDefinition) {
		this.kbDefinition = kbDefinition;
	}
	public ProductInfo getProductInfo() {
		return productInfo;
	}
	public void setProductInfo(ProductInfo productInfo) {
		this.productInfo = productInfo;
	}
	public Manufacturer getManufacturer() {
		return manufacturer;
	}
	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getFunction() {
		return function;
	}
	public void setFunction(String function) {
		this.function = function;
	}
	public Integer getPvu() {
		return pvu;
	}
	public void setPvu(Integer pvu) {
		this.pvu = pvu;
	}
	public Integer getLicenseType() {
		return licenseType;
	}
	public void setLicenseType(Integer licenseType) {
		this.licenseType = licenseType;
	}

    
}