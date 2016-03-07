package com.ibm.asset.trails.domain;

import java.util.Date;

public class LicenseDisplay {

    private Long licenseId;

    private String catalogMatch;

    private String productName;
    
    private String product;
    
    private String fullDesc; //License Name
    
    private String capacityType;

    private Integer capTypeCode;

    private String capTypeDesc;

    private Integer availableQty;
    
    private String totalQtyString;
    
    private Integer quantity;

    private Date expireDate;

    private String cpuSerial;

    private String extSrcId;
    
    private String environment;

    private Long ownerAccountNumber;
    
    private String swproPID;
    
    private String poNumber;
    
    private String poolAsString;
    
    private String recordTimeAsString;
    
    private String expireDateString;

	private String availableQtyString;

	private String licenseOwner;

	public LicenseDisplay() {
    }

    public LicenseDisplay(Long licenseId, String productName, String product, String fullDesc,
            Integer capTypeCode, String capTypeDesc, Long availableQty,
            Integer quantity, Date expireDate, String cpuSerial,
            String extSrcId, String environment, Long ownerAccountNumber) {
        super();
        this.licenseId = licenseId;
        this.productName = productName;
        this.product = product;
        this.fullDesc =  fullDesc;
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
    
    public LicenseDisplay(Long licenseId, String productName, String product, String fullDesc,
    		String swproPID, Integer capTypeCode, String capTypeDesc, Long availableQty,
            Integer quantity, Date expireDate, String cpuSerial,
            String extSrcId, String environment, Long ownerAccountNumber) {
        super();
        this.licenseId = licenseId;
        this.productName = productName;
        this.product = product;
        this.fullDesc =  fullDesc;
        this.swproPID = swproPID;
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
    
    public LicenseDisplay(String productName, String catalogMatch, String fullDesc, String swproPID, String capacityType, 
    		String totalQtyString, String availableQtyString, String expireDateString, String poNumber, String cpuSerial,
    		String licenseOwner, String poolAsString, String extSrcId, String recordTimeAsString) {
        super();
        this.productName = productName;
        System.out.println("=== received catalogMatch: " + catalogMatch);
        System.out.println("=== getCatalogMatch() result : " + getCatalogMatch());
        this.catalogMatch = catalogMatch;
        this.fullDesc =  fullDesc;
        this.swproPID = swproPID;
        this.capacityType = capacityType;
        this.totalQtyString = totalQtyString;
        this.availableQtyString = availableQtyString;
        this.expireDateString = expireDateString;
        this.poNumber = poNumber;
        this.cpuSerial = cpuSerial;
        this.licenseOwner = licenseOwner;
        this.poolAsString = poolAsString;
        this.extSrcId = extSrcId; //SWCM ID
        this.recordTimeAsString = recordTimeAsString;
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

	public String getFullDesc() {
		return fullDesc;
	}

	public void setFullDesc(String fullDesc) {
		this.fullDesc = fullDesc;
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

	public String getSwproPID() {
		return swproPID;
	}

	public void setSwproPID(String swproPID) {
		this.swproPID = swproPID;
	}

	public String getTotalQty() {
		return totalQtyString;
	}

	public void setTotalQty(String totalQty) {
		this.totalQtyString = totalQty;
	}

	public String getPoNumber() {
		return poNumber;
	}

	public void setPoNumber(String poNumber) {
		this.poNumber = poNumber;
	}

	public String getPoolAsString() {
		return poolAsString;
	}

	public void setPoolAsString(String poolAsString) {
		this.poolAsString = poolAsString;
	}

	public String getRecordTimeAsString() {
		return recordTimeAsString;
	}

	public void setRecordTimeAsString(String recordTimeAsString) {
		this.recordTimeAsString = recordTimeAsString;
	}

	public String getCapacityType() {
		return capacityType;
	}

	public void setCapacityType(String capacityType) {
		this.capacityType = capacityType;
	}

	public String getExpireDateString() {
		return expireDateString;
	}

	public void setExpireDateString(String expireDateString) {
		this.expireDateString = expireDateString;
	}
	
    public String getTotalQtyString() {
		return totalQtyString;
	}

	public void setTotalQtyString(String totalQtyString) {
		this.totalQtyString = totalQtyString;
	}

	public String getAvailableQtyString() {
		return availableQtyString;
	}

	public void setAvailableQtyString(String availableQtyString) {
		this.availableQtyString = availableQtyString;
	}

	public String getLicenseOwner() {
		return licenseOwner;
	}

	public void setLicenseOwner(String licenseOwner) {
		this.licenseOwner = licenseOwner;
	}
	
	
}
