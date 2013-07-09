package com.ibm.asset.trails.service;

import java.util.ArrayList;
import java.util.Date;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;

public interface AlertReportService {

	public ArrayList getGeographyAlertOverviewReport();

	public ArrayList getRegionAlertOverviewReport(Geography geography);

	public ArrayList getCountryCodeAlertOverviewReport(Geography geography,
			Region region);

	public ArrayList getSectorAlertOverviewReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList getDepartmentAlertOverviewReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList getAccountAlertOverviewReport(Geography geography,
			Region region, CountryCode countryCode, Sector sector,
			Department department);

	public ArrayList getAlertsOverview(Account account);

	public Date selectReportTimestamp();

	public Integer selectReportMinutesOld();

	public ArrayList getGeographyAlertOperationalReport();

	public ArrayList getRegionAlertOperationalReport(Geography geography);

	public ArrayList getCountryCodeAlertOperationalReport(Geography geography,
			Region region);

	public ArrayList getSectorAlertOperationalReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList getDepartmentAlertOperationalReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList getAccountByNameAlertOperationalReport(
			Geography geography, Region region, CountryCode countryCode,
			Sector sector, Department department);

	public ArrayList getAccountByNumberAlertOperationalReport(
			Geography geography, Region region, CountryCode countryCode,
			Sector sector, Department department);

	public ArrayList getGeographyAlertRedAgingReport();

	public ArrayList getRegionAlertRedAgingReport(Geography geography);

	public ArrayList getCountryCodeAlertRedAgingReport(Geography geography,
			Region region);

	public ArrayList getSectorAlertRedAgingReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList getDepartmentAlertRedAgingReport(Geography geography,
			Region region, CountryCode countryCode);

	public ArrayList getAccountAlertRedAgingReport(Geography geography,
			Region region, CountryCode countryCode, Sector sector,
			Department department);

	public ArrayList getAccountDetailAlertRedAgingReport(Account account);

	public ArrayList getAccountDetailAlertOperationalReport(Account pAccount);

	public ArrayList getAccountDetailAlertOperationalReport(String accountName);

	public ArrayList getAccountRegionAlertOperationalReport(Geography pGeography);

	public ArrayList getAccountCountryCodeAlertOperationalReport(
			Geography pGeography, Region pRegion);

	public ArrayList getAccountRegionAlertRedAgingReport(Geography pGeography);

	public ArrayList getAccountCountryCodeAlertRedAgingReport(
			Geography pGeography, Region pRegion);
}
