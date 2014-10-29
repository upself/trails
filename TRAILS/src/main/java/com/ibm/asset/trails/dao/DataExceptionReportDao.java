package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.form.DataExceptionReportActionForm;

public interface DataExceptionReportDao {

	List<DataExceptionReportActionForm> getAlertCountReportByAccount(Account account);

	List<DataExceptionReportActionForm> getAlertsOverviewByAccount(Account account);

	List<DataExceptionReportActionForm> getGeographyReport();

	List<DataExceptionReportActionForm> getRegionReport(Geography geography);

	List<DataExceptionReportActionForm> getCountryCodeReport(Geography geography,
			Region region);

	List<DataExceptionReportActionForm> getSectorReport(Geography geography,
			Region region, CountryCode countryCode);

	List<DataExceptionReportActionForm> getDepartmentReport(Geography geography,
			Region region, CountryCode countryCode);

	List<DataExceptionReportActionForm> getAccountReport(Geography geography,
			Region region, CountryCode countryCode, Sector sector,
			Department department);

}
