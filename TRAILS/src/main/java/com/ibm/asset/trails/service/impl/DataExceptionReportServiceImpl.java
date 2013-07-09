package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionReportDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.form.DataExceptionReportActionForm;
import com.ibm.asset.trails.service.DataExceptionReportService;

@Service
public class DataExceptionReportServiceImpl implements
        DataExceptionReportService {

    @Autowired
    private DataExceptionReportDao alertReportDao;

    public void setAlertReportDao(DataExceptionReportDao alertReportDao) {
        this.alertReportDao = alertReportDao;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getGeographyReport() {

        List<DataExceptionReportActionForm> data = alertReportDao
                .getGeographyReport();

        return data;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getRegionReport(
            Geography geography) {

        List<DataExceptionReportActionForm> data = alertReportDao
                .getRegionReport(geography);

        return data;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getCountryCodeReport(
            Geography geography, Region region) {

        List<DataExceptionReportActionForm> data = alertReportDao
                .getCountryCodeReport(geography, region);

        return data;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getSectorReport(
            Geography geography, Region region, CountryCode countryCode) {
        List<DataExceptionReportActionForm> data = alertReportDao
                .getSectorReport(geography, region, countryCode);

        return data;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getDepartmentReport(
            Geography geography, Region region, CountryCode countryCode) {
        List<DataExceptionReportActionForm> data = alertReportDao
                .getDepartmentReport(geography, region, countryCode);

        return data;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getAccountReport(
            Geography geography, Region region, CountryCode countryCode,
            Sector sector, Department department) {
        List<DataExceptionReportActionForm> data = alertReportDao
                .getAccountReport(geography, region, countryCode, sector,
                        department);

        return data;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getAlertCountReport(
            Account account) {
        List<DataExceptionReportActionForm> data = alertReportDao
                .getAlertCountReportByAccount(account);

        return data;

    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<DataExceptionReportActionForm> getAlertsOverview(Account account) {
        List<DataExceptionReportActionForm> data = alertReportDao
                .getAlertsOverviewByAccount(account);

        return data;

    }
}
