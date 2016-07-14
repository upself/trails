package com.ibm.asset.trails.service;

import java.util.ArrayList;
import java.util.Date;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.form.SwTrackingAlertReport;

public interface SwTrackingReportService {

	public Date selectReportTimestamp();

	public Integer selectReportMinutesOld();

	public ArrayList<SwTrackingAlertReport> getGeographySwTrackingAlertReport();

	public ArrayList<SwTrackingAlertReport> getRegionSwTrackingAlertReport(Geography geography);

	public ArrayList<SwTrackingAlertReport> getCountryCodeSwTrackingAlertReport(Geography geography,
			Region region);

	public ArrayList<SwTrackingAlertReport> getSectorSwTrackingAlertReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList<SwTrackingAlertReport> getDepartmentSwTrackingAlertReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList<SwTrackingAlertReport> getAccountByNameSwTrackingAlertReport(
			Geography geography, Region region, CountryCode countryCode,
			Sector sector, Department department);

	public ArrayList<SwTrackingAlertReport> getAccountByNumberSwTrackingAlertReport(
			Geography geography, Region region, CountryCode countryCode,
			Sector sector, Department department);

	public ArrayList<SwTrackingAlertReport> getAccountDetailSwTrackingAlertReport(Account pAccount);

	public ArrayList<SwTrackingAlertReport> getAccountDetailSwTrackingAlertReport(String accountName);

	public ArrayList<SwTrackingAlertReport> getAccountRegionSwTrackingAlertReport(Geography pGeography);

	public ArrayList<SwTrackingAlertReport> getAccountCountryCodeSwTrackingAlertReport(
			Geography pGeography, Region pRegion);
}
