package com.ibm.ea.bravo.report;

import java.math.BigDecimal;

import com.ibm.ea.cndb.Customer;

public class VGlobalScan {

	private Long id;

	private Customer customer;

	private String assetType;

	private Integer hwSwTotal;

	private Integer hwTotal;

	private Integer swNoScan;

	private BigDecimal percentHw;

	public String getAssetType() {
		return assetType;
	}

	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public Integer getHwSwTotal() {
		return hwSwTotal;
	}

	public void setHwSwTotal(Integer hwSwTotal) {
		this.hwSwTotal = hwSwTotal;
	}

	public Integer getHwTotal() {
		return hwTotal;
	}

	public void setHwTotal(Integer hwTotal) {
		this.hwTotal = hwTotal;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public BigDecimal getPercentHw() {
		return percentHw;
	}

	public void setPercentHw(BigDecimal percentHw) {
		this.percentHw = percentHw;
	}

	public Integer getSwNoScan() {
		return swNoScan;
	}

	public void setSwNoScan(Integer swNoScan) {
		this.swNoScan = swNoScan;
	}
}
