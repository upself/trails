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
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.form.SwTrackingAlertReport;
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

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Date selectReportTimestamp() {
        String query = "SELECT recordTime FROM SwTrackingAlertReport";
        Query q = getEntityManager().createQuery(query).setFirstResult(0)
                .setMaxResults(1);

        return (Date) q.getSingleResult();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Integer selectReportMinutesOld() {
        String lsQuery = "SELECT (DAYS(current_timestamp) - DAYS(a.recordTime)) * 86400 + (MIDNIGHT_SECONDS(current_timestamp) - MIDNIGHT_SECONDS(a.recordTime)) FROM SwTrackingAlertReport a";
        Query lQuery = getEntityManager().createQuery(lsQuery)
                .setFirstResult(0).setMaxResults(1);
        Double diff = Math
                .floor(((Long) lQuery.getSingleResult()).intValue() / 60);
        return diff.intValue();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getGeographySwTrackingAlertReport() {
        return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                .createNamedQuery("geographySwTrackingAlertReport")
                .getResultList();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getRegionSwTrackingAlertReport(
            Geography geography) {

        if (geography == null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("regionSwTrackingAlertReport")
                    .getResultList();
        } else {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("regionSwTrackingAlertReportByGeography")
                    .setParameter("geography", geography).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getCountryCodeSwTrackingAlertReport(
            Geography geography, Region region) {

        if (region != null && geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeSwTrackingAlertReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeSwTrackingAlertReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "countryCodeSwTrackingAlertReportByRegion")
                    .setParameter("region", region).getResultList();
        } else {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("countryCodeSwTrackingAlertReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getSectorSwTrackingAlertReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorSwTrackingAlertReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorSwTrackingAlertReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorSwTrackingAlertReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorSwTrackingAlertReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("sectorSwTrackingAlertReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("sectorSwTrackingAlertReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "sectorSwTrackingAlertReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("sectorSwTrackingAlertReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getDepartmentSwTrackingAlertReport(
            Geography geography, Region region, CountryCode countryCode) {

        if (region != null && geography != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentSwTrackingAlertReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentSwTrackingAlertReportByGeographyByRegion")
                    .setParameter("geography", geography)
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null && geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentSwTrackingAlertReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentSwTrackingAlertReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (geography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentSwTrackingAlertReportByGeography")
                    .setParameter("geography", geography).getResultList();
        } else if (region != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentSwTrackingAlertReportByRegion")
                    .setParameter("region", region).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "departmentSwTrackingAlertReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("departmentSwTrackingAlertReport")
                    .getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountByNameSwTrackingAlertReport(
            Geography geography, Region region, CountryCode countryCode,
            Sector sector, Department department) {

        if (region != null && geography != null && countryCode != null
                && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByRegionByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && countryCode != null
                && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByRegionByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByRegionBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByRegionByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && countryCode != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByRegionByCountryCodeBySector")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && countryCode != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByRegionByCountryCodeByDepartment")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null
                && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByCountryCodeBySector")
                    .setParameter("sector", sector)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByCountryCodeByDepartment")
                    .setParameter("department", department)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByRegionBySector")
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByRegionByDepartment")
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyBySector")
                    .setParameter("geography", geography)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByGeographyByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("department", department).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportBySector")
                    .setParameter("sector", sector).getResultList();
        } else {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNameSwTrackingAlertReportByDepartment")
                    .setParameter("department", department).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountByNumberSwTrackingAlertReport(
            Geography geography, Region region, CountryCode countryCode,
            Sector sector, Department department) {

        if (region != null && geography != null && countryCode != null
                && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByRegionByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (region != null && geography != null && countryCode != null
                && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByRegionByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByRegionByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && geography != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByRegionBySector")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && geography != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByRegionByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (region != null && countryCode != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByRegionByCountryCodeBySector")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && countryCode != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByRegionByCountryCodeByDepartment")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByCountryCodeBySector")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && countryCode != null
                && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByCountryCodeByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByCountryCode")
                    .setParameter("geography", geography)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByRegionByCountryCode")
                    .setParameter("region", region)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByCountryCodeBySector")
                    .setParameter("sector", sector)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (countryCode != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByCountryCodeByDepartment")
                    .setParameter("department", department)
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (region != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByRegionBySector")
                    .setParameter("region", region)
                    .setParameter("sector", sector).getResultList();
        } else if (region != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByRegionByDepartment")
                    .setParameter("region", region)
                    .setParameter("department", department).getResultList();
        } else if (geography != null && sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyBySector")
                    .setParameter("geography", geography)
                    .setParameter("sector", sector).getResultList();
        } else if (geography != null && department != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByGeographyByDepartment")
                    .setParameter("geography", geography)
                    .setParameter("department", department).getResultList();
        } else if (countryCode != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByCountryCode")
                    .setParameter("countryCode", countryCode).getResultList();
        } else if (sector != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportBySector")
                    .setParameter("sector", sector).getResultList();
        } else {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountByNumberSwTrackingAlertReportByDepartment")
                    .setParameter("department", department).getResultList();
        }
    }

    @SuppressWarnings({"unchecked" })
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountDetailSwTrackingAlertReport(Account pAccount) {
        return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                .createNamedQuery("SwTrackingAlertReportByAccount")
                .setParameter("account", pAccount).getResultList();
    }

    @SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountDetailSwTrackingAlertReport(String accountName) {
        return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                .createNamedQuery("SwTrackingAlertReportByAccountName")
                .setParameter("accountName", accountName).getResultList();
    }

    @SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountRegionSwTrackingAlertReport(Geography pGeography) {
        return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                .createNamedQuery("accountSwTrackingAlertReportByGeography")
                .setParameter("geography", pGeography).getResultList();
    }

    @SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountCountryCodeSwTrackingAlertReport(
            Geography pGeography, Region pRegion) {
        if (pGeography != null && pRegion != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountSwTrackingAlertReportByGeographyByRegion")
                    .setParameter("geography", pGeography)
                    .setParameter("region", pRegion).getResultList();
        } else if (pGeography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountSwTrackingAlertReportByGeography")
                    .setParameter("geography", pGeography).getResultList();
        } else { // pRegion != null
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("accountSwTrackingAlertReportByRegion")
                    .setParameter("region", pRegion).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountRegionAlertRedAgingReport(Geography pGeography) {
        return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                .createNamedQuery("accountAlertRedAgingReportByGeography")
                .setParameter("geography", pGeography).getResultList();
    }

    @SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<SwTrackingAlertReport> getAccountCountryCodeAlertRedAgingReport(
            Geography pGeography, Region pRegion) {
        if (pGeography != null && pRegion != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery(
                            "accountAlertRedAgingReportByGeographyByRegion")
                    .setParameter("geography", pGeography)
                    .setParameter("region", pRegion).getResultList();
        } else if (pGeography != null) {
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("accountAlertRedAgingReportByGeography")
                    .setParameter("geography", pGeography).getResultList();
        } else { // pRegion != null
            return (ArrayList<SwTrackingAlertReport>) getEntityManager()
                    .createNamedQuery("accountAlertRedAgingReportByRegion")
                    .setParameter("region", pRegion).getResultList();
        }
    }

}
