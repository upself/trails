package com.ibm.asset.trails.form;

public class SwTrackingAlertReport {

	private String name;

	private Long id;

	private Long accountNumber;

	private String alertName;

	private Long redSum;

	private Long yellowSum;

	private Long greenSum;

	private Long assetSum;

	private String geographyName;

	private String regionName;

	private String countryCodeName;

	private String sectorName;

	private String accountTypeName;

	public SwTrackingAlertReport(String name, Long id, String alertName,
			Long redSum, Long yellowSum, Long greenSum, Long assetSum) {
		this.name = name;
		this.id = id;
		this.alertName = alertName;
		this.redSum = redSum;
		this.yellowSum = yellowSum;
		this.greenSum = greenSum;
		this.assetSum = assetSum;
	}

	public SwTrackingAlertReport(String name, Long accountNumber, Long id,
			String geographyName, String regionName, String countryCodeName,
			String sectorName, String accountTypeName, String alertName, Long redSum,
			Long yellowSum, Long greenSum, Long assetSum) {
		this.name = name;
		this.accountNumber = accountNumber;
		this.id = id;
		this.geographyName = geographyName;
		this.regionName = regionName;
		this.countryCodeName = countryCodeName;
		this.sectorName = sectorName;
		this.accountTypeName = accountTypeName;
		this.alertName = alertName;
		this.redSum = redSum;
		this.yellowSum = yellowSum;
		this.greenSum = greenSum;
		this.assetSum = assetSum;
	}

	public SwTrackingAlertReport(String name, String alertName, Long redSum,
			Long yellowSum, Long greenSum, Long assetSum) {
		this.name = name;
		this.alertName = alertName;
		this.redSum = redSum;
		this.yellowSum = yellowSum;
		this.greenSum = greenSum;
		this.assetSum = assetSum;
	}

	public Double getOperationalMetric() {
		if (getAssetSum().doubleValue() == 0.0) {
			return 100.0;
		} else {
				return Double.valueOf((1-(getRedSum().doubleValue() / getAssetSum().doubleValue())) * 100);
		}
	}

	public String getAlertName() {
		return alertName;
	}

	public void setAlertName(String alertName) {
		this.alertName = alertName;
	}

	public String getAlertNameWithCount() {

		int sum = getGreenSum().intValue() + getYellowSum().intValue()
				+ getRedSum().intValue();

		return getAlertName() + "(" + sum + ")";
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

	public Long getGreenSum() {
		return greenSum;
	}

	public void setGreenSum(Long greenSum) {
		this.greenSum = greenSum;
	}

	public Long getRedSum() {
		return redSum;
	}

	public void setRedSum(Long redSum) {
		this.redSum = redSum;
	}

	public Long getYellowSum() {
		return yellowSum;
	}

	public void setYellowSum(Long yellowSum) {
		this.yellowSum = yellowSum;
	}

	public Long getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}

	public Long getAssetSum() {
		return assetSum;
	}

	public void setAssetSum(Long assetSum) {
		this.assetSum = assetSum;
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
