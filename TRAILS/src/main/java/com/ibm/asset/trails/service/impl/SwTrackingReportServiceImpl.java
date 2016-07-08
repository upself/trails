package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;
import java.util.Date;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertViewRedAging;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.form.AlertOperationalReport;
import com.ibm.asset.trails.form.AlertOverviewReport;
import com.ibm.asset.trails.form.AlertRedAgingReport;
import com.ibm.asset.trails.service.SwTrackingReportService;

@Service
public class SwTrackingReportServiceImpl implements SwTrackingReportService {

    private EntityManager em;

    @PersistenceContext(unitName="trailspd")
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    private EntityManager getEntityManager() {
        return em;
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOverviewReport> getGeographyAlertOverviewReport() {
        return (ArrayList<AlertOverviewReport>) getEntityManager()
                .createNamedQuery("geographyAlertOverviewReport")
                .getResultList();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOverviewReport> getRegionAlertOverviewReport(
            Geography geography) {

        if (geography == null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("regionAlertOverviewReport")
                    .getResultList();
        } else {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("regionAlertOverviewReportByGeography")
                    .setParameter("geography", geography).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOverviewReport> getCountryCodeAlertOverviewReport(
            Geography geography, Region region) {

        if (region != null && geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeAlertOverviewReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeAlertOverviewReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("countryCodeAlertOverviewReportByRegion")
                    .setParameter("region", region).getResultList();
        } else {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("countryCodeAlertOverviewReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOverviewReport> getSectorAlertOverviewReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOverviewReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOverviewReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOverviewReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOverviewReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("sectorAlertOverviewReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("sectorAlertOverviewReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("sectorAlertOverviewReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("sectorAlertOverviewReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOverviewReport> getDepartmentAlertOverviewReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOverviewReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOverviewReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOverviewReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOverviewReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOverviewReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("departmentAlertOverviewReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOverviewReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("departmentAlertOverviewReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOverviewReport> getAccountAlertOverviewReport(
            Geography geography, Region region, CountryCode countryCode,
            Sector sector, Department department) {

        if (region != null && geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByRegionByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && countryCode != null
                && sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByRegionByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null && department != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByRegionByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByRegionBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && countryCode != null && department != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByRegionByCountryCodeByDepartment")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && countryCode != null && sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByRegionByCountryCodeBySector")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null && sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && department != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByCountryCodeByDepartment")
                    .setParameter("department", department)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByCountryCodeBySector")
                    .setParameter("sector", sector)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && department != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByRegionByDepartment")
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByRegionBySector")
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && department != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOverviewReportByGeographyBySector")
                    .setParameter("geography", geography)
                    .setParameter("sector", sector).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("accountAlertOverviewReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (sector != null) {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("accountAlertOverviewReportBySector")
                    .setParameter("sector", sector).getResultList();
        } else {
            return (ArrayList<AlertOverviewReport>) getEntityManager()
                    .createNamedQuery("accountAlertOverviewReportByDepartment")
                    .setParameter("department", department).getResultList();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAlertsOverview(Account account) {
        return (ArrayList<AlertOverviewReport>) getEntityManager()
                .createNamedQuery("alertOverviewReportByAccount")
                .setParameter("account", account).getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Date selectReportTimestamp() {
        String query = "SELECT recordTime FROM MqtAlertReport";
        Query q = getEntityManager().createQuery(query).setFirstResult(0)
                .setMaxResults(1);

        return (Date) q.getSingleResult();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Integer selectReportMinutesOld() {
        String lsQuery = "SELECT (DAYS(current_timestamp) - DAYS(a.recordTime)) * 86400 + (MIDNIGHT_SECONDS(current_timestamp) - MIDNIGHT_SECONDS(a.recordTime)) FROM MqtAlertReport a";
        Query lQuery = getEntityManager().createQuery(lsQuery)
                .setFirstResult(0).setMaxResults(1);
        Double diff = Math
                .floor(((Long) lQuery.getSingleResult()).intValue() / 60);
        return diff.intValue();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOperationalReport> getGeographyAlertOperationalReport() {
        return (ArrayList<AlertOperationalReport>) getEntityManager()
                .createNamedQuery("geographyAlertOperationalReport")
                .getResultList();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOperationalReport> getRegionAlertOperationalReport(
            Geography geography) {

        if (geography == null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("regionAlertOperationalReport")
                    .getResultList();
        } else {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("regionAlertOperationalReportByGeography")
                    .setParameter("geography", geography).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOperationalReport> getCountryCodeAlertOperationalReport(
            Geography geography, Region region) {

        if (region != null && geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeAlertOperationalReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeAlertOperationalReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeAlertOperationalReportByRegion")
                    .setParameter("region", region).getResultList();
        } else {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("countryCodeAlertOperationalReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOperationalReport> getSectorAlertOperationalReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOperationalReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOperationalReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOperationalReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOperationalReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("sectorAlertOperationalReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("sectorAlertOperationalReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertOperationalReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("sectorAlertOperationalReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOperationalReport> getDepartmentAlertOperationalReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOperationalReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOperationalReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOperationalReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOperationalReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOperationalReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOperationalReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertOperationalReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("departmentAlertOperationalReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOperationalReport> getAccountByNameAlertOperationalReport(
            Geography geography, Region region, CountryCode countryCode,
            Sector sector, Department department) {

        if (region != null && geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByRegionByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && countryCode != null
                && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByRegionByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByRegionBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByRegionByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && countryCode != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByRegionByCountryCodeBySector")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && countryCode != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByRegionByCountryCodeByDepartment")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByCountryCodeBySector")
                    .setParameter("sector", sector)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByCountryCodeByDepartment")
                    .setParameter("department", department)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByRegionBySector")
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByRegionByDepartment")
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyBySector")
                    .setParameter("geography", geography)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByGeographyByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("department", department).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportBySector")
                    .setParameter("sector", sector).getResultList();
        } else {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameAlertOperationalReportByDepartment")
                    .setParameter("department", department).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertOperationalReport> getAccountByNumberAlertOperationalReport(
            Geography geography, Region region, CountryCode countryCode,
            Sector sector, Department department) {

        if (region != null && geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByRegionByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && countryCode != null
                && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByRegionByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByRegionBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByRegionByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && countryCode != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByRegionByCountryCodeBySector")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && countryCode != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByRegionByCountryCodeByDepartment")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByCountryCodeBySector")
                    .setParameter("sector", sector)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByCountryCodeByDepartment")
                    .setParameter("department", department)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByRegionBySector")
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByRegionByDepartment")
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyBySector")
                    .setParameter("geography", geography)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && department != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByGeographyByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("department", department).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (sector != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportBySector")
                    .setParameter("sector", sector).getResultList();
        } else {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberAlertOperationalReportByDepartment")
                    .setParameter("department", department).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertRedAgingReport> getGeographyAlertRedAgingReport() {
        return (ArrayList<AlertRedAgingReport>) getEntityManager()
                .createNamedQuery("geographyAlertRedAgingReport")
                .getResultList();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertRedAgingReport> getRegionAlertRedAgingReport(
            Geography geography) {

        if (geography == null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("regionAlertRedAgingReport")
                    .getResultList();
        } else {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("regionAlertRedAgingReportByGeography")
                    .setParameter("geography", geography).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertRedAgingReport> getCountryCodeAlertRedAgingReport(
            Geography geography, Region region) {

        if (region != null && geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeAlertRedAgingReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeAlertRedAgingReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("countryCodeAlertRedAgingReportByRegion")
                    .setParameter("region", region).getResultList();
        } else {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("countryCodeAlertRedAgingReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertRedAgingReport> getSectorAlertRedAgingReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertRedAgingReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertRedAgingReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertRedAgingReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorAlertRedAgingReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("sectorAlertRedAgingReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("sectorAlertRedAgingReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("sectorAlertRedAgingReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("sectorAlertRedAgingReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertRedAgingReport> getDepartmentAlertRedAgingReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertRedAgingReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertRedAgingReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertRedAgingReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertRedAgingReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertRedAgingReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("departmentAlertRedAgingReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentAlertRedAgingReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("departmentAlertRedAgingReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertRedAgingReport> getAccountAlertRedAgingReport(
            Geography geography, Region region, CountryCode countryCode,
            Sector sector, Department department) {

        if (region != null && geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByRegionByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && countryCode != null
                && sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByRegionByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null && department != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByRegionByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByRegionBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && countryCode != null && department != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByRegionByCountryCodeByDepartment")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && countryCode != null && sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByRegionByCountryCodeBySector")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null
                && department != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null && sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && department != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByCountryCodeByDepartment")
                    .setParameter("department", department)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByCountryCodeBySector")
                    .setParameter("sector", sector)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && department != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByRegionByDepartment")
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByRegionBySector")
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && department != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyBySector")
                    .setParameter("geography", geography)
                    .setParameter("sector", sector).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("accountAlertRedAgingReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (sector != null) {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("accountAlertRedAgingReportBySector")
                    .setParameter("sector", sector).getResultList();
        } else {
            return (ArrayList<AlertRedAgingReport>) getEntityManager()
                    .createNamedQuery("accountAlertRedAgingReportByDepartment")
                    .setParameter("department", department).getResultList();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAccountDetailAlertRedAgingReport(Account account) {
        return (ArrayList<AlertViewRedAging>) getEntityManager()
                .createNamedQuery("alertRedAgingByAccount")
                .setParameter("account", account.getId()).getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAccountDetailAlertOperationalReport(Account pAccount) {
        return (ArrayList<AlertOperationalReport>) getEntityManager()
                .createNamedQuery("alertOperationalReportByAccount")
                .setParameter("account", pAccount).getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAccountDetailAlertOperationalReport(String accountName) {
        return (ArrayList<AlertOperationalReport>) getEntityManager()
                .createNamedQuery("alertOperationalReportByAccountName")
                .setParameter("accountName", accountName).getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAccountRegionAlertOperationalReport(Geography pGeography) {
        return (ArrayList<AlertOperationalReport>) getEntityManager()
                .createNamedQuery("accountAlertOperationalReportByGeography")
                .setParameter("geography", pGeography).getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAccountCountryCodeAlertOperationalReport(
            Geography pGeography, Region pRegion) {
        if (pGeography != null && pRegion != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOperationalReportByGeographyByRegion")
                    .setParameter("geography", pGeography)
                    .setParameter("region", pRegion).getResultList();
        } else if (pGeography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertOperationalReportByGeography")
                    .setParameter("geography", pGeography).getResultList();
        } else { // pRegion != null
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("accountAlertOperationalReportByRegion")
                    .setParameter("region", pRegion).getResultList();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAccountRegionAlertRedAgingReport(Geography pGeography) {
        return (ArrayList<AlertOperationalReport>) getEntityManager()
                .createNamedQuery("accountAlertRedAgingReportByGeography")
                .setParameter("geography", pGeography).getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAccountCountryCodeAlertRedAgingReport(
            Geography pGeography, Region pRegion) {
        if (pGeography != null && pRegion != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByRegion")
                    .setParameter("geography", pGeography)
                    .setParameter("region", pRegion).getResultList();
        } else if (pGeography != null) {
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("accountAlertRedAgingReportByGeography")
                    .setParameter("geography", pGeography).getResultList();
        } else { // pRegion != null
            return (ArrayList<AlertOperationalReport>) getEntityManager()
                    .createNamedQuery("accountAlertRedAgingReportByRegion")
                    .setParameter("region", pRegion).getResultList();
        }
    }

}
