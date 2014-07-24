package com.ibm.asset.trails.domain;

import java.util.Date;

public class LicenseDisplay {

    private Long licenseId;

    private String catalogMatch;

    private String productName;

    private String product;

    private Integer capTypeCode;

    private String capTypeDesc;

    private Integer availableQty;

    private Integer quantity;

    private Date expireDate;

    private String cpuSerial;

    private String extSrcId;
    
    private String environment;

    private Long ownerAccountNumber;

    public LicenseDisplay() {
    }

    public LicenseDisplay(Long licenseId, String productName, String product,
            Integer capTypeCode, String capTypeDesc, Long availableQty,
            Integer quantity, Date expireDate, String cpuSerial,
            String extSrcId, String environment, Long ownerAccountNumber) {
        super();
        this.licenseId = licenseId;
        this.productName = productName;
        this.product = product;
        this.capTypeCode = capTypeCode;
        this.capTypeDesc = capTypeDesc;
        this.availableQty = availableQty.intValue();
        this.quantity = quantity;
        this.expireDate = expireDate;
        this.cpuSerial = cpuSerial;
        this.extSrcId = extSrcId;
        this.environment = environment;
        this.ownerAccountNumber = ownerAccountNumber;
    }

    public Integer getAvailableQty() {
        return availableQty;
    }

    public void setAvailableQty(Integer availableQty) {
        this.availableQty = availableQty;
    }

    public Integer getCapTypeCode() {
        return capTypeCode;
    }

    public void setCapTypeCode(Integer capTypeCode) {
        this.capTypeCode = capTypeCode;
    }

    public String getCapTypeDesc() {
        return capTypeDesc;
    }

    public void setCapTypeDesc(String capTypeDesc) {
        this.capTypeDesc = capTypeDesc;
    }

    public String getCatalogMatch() {
        String result;
        if (product == null) {
            result = "No";
        } else {
            result = "Yes";
        }
        return result;
    }

    public void setCatalogMatch(String catalogMatch) {
        this.catalogMatch = catalogMatch;
    }

    public String getCpuSerial() {
        return cpuSerial;
    }

    public void setCpuSerial(String cpuSerial) {
        this.cpuSerial = cpuSerial;
    }

    public Date getExpireDate() {
        return expireDate;
    }

    public void setExpireDate(Date expireDate) {
        this.expireDate = expireDate;
    }

    public String getExtSrcId() {
        return extSrcId;
    }

    public void setExtSrcId(String extSrcId) {
        this.extSrcId = extSrcId;
    }

    public Long getLicenseId() {
        return licenseId;
    }

    public void setLicenseId(Long licenseId) {
        this.licenseId = licenseId;
    }

    public Long getOwnerAccountNumber() {
        return ownerAccountNumber;
    }

    public void setOwnerAccountNumber(Long ownerAccountNumber) {
        this.ownerAccountNumber = ownerAccountNumber;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

	public String getEnvironment() {
		return environment;
	}

	public void setEnvironment(String environment) {
		this.environment = environment;
	}
}
