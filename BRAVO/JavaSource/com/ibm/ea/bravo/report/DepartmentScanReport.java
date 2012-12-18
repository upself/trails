/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.report;

import java.math.BigDecimal;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class DepartmentScanReport {

	private Long geographyId;

	private Long regionId;

	private Long countryCodeId;

	private Long accountNumber;

	private String customerName;

	private String customerType;

	private String swAnalyst;

	private String hwAnalyst;

	private String swGrFlag;

	private String assetType;

	private Long swLparWoScan;

	private Long hwLpars;

	private Long hwSwComposites;

	private BigDecimal hwScanPercent;

	public DepartmentScanReport(Long accountNumber, String customerName,
			String customerType, String swAnalyst, String hwAnalyst,
			String swGrFlag, String assetType, Long swLparWoScan,
			Long hwLpars, Long hwSwComposites, BigDecimal hwScanPercent) {

		this.accountNumber = accountNumber;
		this.customerName = customerName;
		this.customerType = customerType;
		this.swAnalyst = swAnalyst;
		this.hwAnalyst = hwAnalyst;
		this.swGrFlag = swGrFlag;
		this.assetType = assetType;
		this.swLparWoScan = swLparWoScan;
		this.hwLpars = hwLpars;
		this.hwSwComposites = hwSwComposites;
		this.hwScanPercent = hwScanPercent;
	}

	public DepartmentScanReport(Long geographyId, Long regionId,
			Long countryCodeId, String customerName, String customerType,
			String swAnalyst, String assetType, Long swLparWoScan,
			Long hwLpars, Long hwSwComposites) {

		this.geographyId = geographyId;
		this.regionId = regionId;
		this.countryCodeId = countryCodeId;
		this.customerName = customerName;
		this.customerType = customerType;
		this.swAnalyst = swAnalyst;
		this.assetType = assetType;
		this.swLparWoScan = swLparWoScan;
		this.hwLpars = hwLpars;
		this.hwSwComposites = hwSwComposites;
	}

	public DepartmentScanReport(String customerName, Long accountNumber,
			String swAnalyst, String assetType, Long swLparWoScan,
			Long hwLpars, Long hwSwComposites) {

		this.accountNumber = accountNumber;
		this.customerName = customerName;
		this.swAnalyst = swAnalyst;
		this.assetType = assetType;
		this.swLparWoScan = swLparWoScan;
		this.hwLpars = hwLpars;
		this.hwSwComposites = hwSwComposites;
	}

	public Long getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}

	public String getAssetType() {
		return assetType;
	}

	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	public String getHwAnalyst() {
		return hwAnalyst;
	}

	public void setHwAnalyst(String hwAnalyst) {
		this.hwAnalyst = hwAnalyst;
	}

	public Long getHwLpars() {
		return hwLpars;
	}

	public void setHwLpars(Long hwLpars) {
		this.hwLpars = hwLpars;
	}

	public BigDecimal getHwScanPercent() {
		return hwScanPercent;
	}

	public void setHwScanPercent(BigDecimal hwScanPercent) {
		this.hwScanPercent = hwScanPercent;
	}

	public Long getHwSwComposites() {
		return hwSwComposites;
	}

	public void setHwSwComposites(Long hwSwComposites) {
		this.hwSwComposites = hwSwComposites;
	}

	public String getSwAnalyst() {
		return swAnalyst;
	}

	public void setSwAnalyst(String swAnalyst) {
		this.swAnalyst = swAnalyst;
	}

	public String getSwGrFlag() {
		return swGrFlag;
	}

	public void setSwGrFlag(String swGrFlag) {
		this.swGrFlag = swGrFlag;
	}

	public Long getSwLparWoScan() {
		return swLparWoScan;
	}

	public void setSwLparWoScan(Long swLparWoScan) {
		this.swLparWoScan = swLparWoScan;
	}

	public Integer getCalculatedPercent() {
		int t = 0;

		if (this.hwSwComposites == null || this.hwLpars == null) {
			return null;
		}

		t = this.hwSwComposites.intValue() * 100 / this.hwLpars.intValue();

		return new Integer(t);
	}

	public Long getCountryCodeId() {
		return countryCodeId;
	}

	public void setCountryCodeId(Long countryCodeId) {
		this.countryCodeId = countryCodeId;
	}

	public Long getGeographyId() {
		return geographyId;
	}

	public void setGeographyId(Long geographyId) {
		this.geographyId = geographyId;
	}

	public Long getRegionId() {
		return regionId;
	}

	public void setRegionId(Long regionId) {
		this.regionId = regionId;
	}

}
