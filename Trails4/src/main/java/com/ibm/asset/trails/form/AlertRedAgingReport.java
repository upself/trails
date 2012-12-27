package com.ibm.asset.trails.form;

public class AlertRedAgingReport {

	private String name;

	private Long id;

	private Long accountNumber;

	private String alertName;

	private Long red91Sum;

	private Long red121Sum;

	private Long red151Sum;

	private Long red181Sum;

	private Long red366Sum;

	private String geographyName;

	private String regionName;

	private String countryCodeName;

	private String sectorName;

	private String accountTypeName;

	public AlertRedAgingReport(String name, Long id, String alertName,
			Long red91Sum, Long red121Sum, Long red151Sum, Long red181Sum,
			Long red366Sum) {
		this.name = name;
		this.id = id;
		this.alertName = alertName;
		this.red91Sum = red91Sum;
		this.red121Sum = red121Sum;
		this.red151Sum = red151Sum;
		this.red181Sum = red181Sum;
		this.red366Sum = red366Sum;
	}

	public AlertRedAgingReport(String name, Long accountNumber, Long id,
			String geographyName, String regionName, String countryCodeName,
			String sectorName, String accountTypeName, String alertName,
			Long red91Sum, Long red121Sum, Long red151Sum, Long red181Sum,
			Long red366Sum) {
		this.name = name;
		this.accountNumber = accountNumber;
		this.id = id;
		this.geographyName = geographyName;
		this.regionName = regionName;
		this.countryCodeName = countryCodeName;
		this.sectorName = sectorName;
		this.accountTypeName = accountTypeName;
		this.alertName = alertName;
		this.red91Sum = red91Sum;
		this.red121Sum = red121Sum;
		this.red151Sum = red151Sum;
		this.red181Sum = red181Sum;
		this.red366Sum = red366Sum;
	}

	public AlertRedAgingReport(String name, Long accountNumber, Long id,
			String alertName, Long red91Sum, Long red121Sum, Long red151Sum,
			Long red181Sum, Long red366Sum) {
		this.name = name;
		this.accountNumber = accountNumber;
		this.id = id;
		this.alertName = alertName;
		this.red91Sum = red91Sum;
		this.red121Sum = red121Sum;
		this.red151Sum = red151Sum;
		this.red181Sum = red181Sum;
		this.red366Sum = red366Sum;
	}

	public int getTotalRed() {
		return this.red91Sum.intValue() + this.red121Sum.intValue()
				+ this.red151Sum.intValue() + this.red181Sum.intValue()
				+ this.red366Sum.intValue();
	}

	public String getAlertName() {
		return alertName;
	}

	public void setAlertName(String alertName) {
		this.alertName = alertName;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}

	public Long getRed121Sum() {
		return red121Sum;
	}

	public void setRed121Sum(Long red121Sum) {
		this.red121Sum = red121Sum;
	}

	public Long getRed151Sum() {
		return red151Sum;
	}

	public void setRed151Sum(Long red151Sum) {
		this.red151Sum = red151Sum;
	}

	public Long getRed181Sum() {
		return red181Sum;
	}

	public void setRed181Sum(Long red181Sum) {
		this.red181Sum = red181Sum;
	}

	public Long getRed366Sum() {
		return red366Sum;
	}

	public void setRed366Sum(Long red366Sum) {
		this.red366Sum = red366Sum;
	}

	public Long getRed91Sum() {
		return red91Sum;
	}

	public void setRed91Sum(Long red91Sum) {
		this.red91Sum = red91Sum;
	}

	public String getAccountTypeName() {
		return accountTypeName;
	}

	public void setAccountTypeName(String accountTypeName) {
		this.accountTypeName = accountTypeName;
	}

	public String getCountryCodeName() {
		return countryCodeName;
	}

	public void setCountryCodeName(String countryCodeName) {
		this.countryCodeName = countryCodeName;
	}

	public String getGeographyName() {
		return geographyName;
	}

	public void setGeographyName(String geographyName) {
		this.geographyName = geographyName;
	}

	public String getRegionName() {
		return regionName;
	}

	public void setRegionName(String regionName) {
		this.regionName = regionName;
	}

	public String getSectorName() {
		return sectorName;
	}

	public void setSectorName(String sectorName) {
		this.sectorName = sectorName;
	}
}
