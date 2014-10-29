package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionReportDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.form.DataExceptionReportActionForm;

@Transactional
@Repository
public class DataExceptionReportDaoJpa extends AbstractDataExceptionJpa implements
		DataExceptionReportDao {

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getAlertCountReportByAccount(
			Account account) {
		return getEntityManager()
				.createNamedQuery("getAlertCountReportByAccount")
				.setParameter("account", account).getResultList();
	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getAlertsOverviewByAccount(
			Account account) {
		return getEntityManager()
				.createNamedQuery("getAlertOverviewReportByAccount")
				.setParameter("account", account).getResultList();
	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getGeographyReport() {

		return getEntityManager().createNamedQuery("getGeographyReport")
				.getResultList();

	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getRegionReport(Geography geography) {
		if (geography == null) {
			return getEntityManager().createNamedQuery("getRegionReport")
					.getResultList();
		} else {
			return getEntityManager()
					.createNamedQuery("getRegionReportByGeography")
					.setParameter("geography", geography).getResultList();
		}
	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getCountryCodeReport(
			Geography geography, Region region) {
		if (geography != null && region != null) {
			return getEntityManager()
					.createNamedQuery("getCountryReportBYGeographyRegion")
					.setParameter("geography", geography)
					.setParameter("region", region).getResultList();
		} else if (geography != null) {
			return getEntityManager()
					.createNamedQuery("getCountryReportByGeography")
					.setParameter("geography", geography).getResultList();
		} else if (region != null) {
			return getEntityManager()
					.createNamedQuery("getCountryReportByRegion")
					.setParameter("region", region).getResultList();
		} else {
			return getEntityManager().createNamedQuery("getCountryReport")
					.getResultList();
		}
	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getSectorReport(Geography geography,
			Region region, CountryCode countryCode) {
		if (geography != null && region != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery(
							"getSectorReportByGeographyRegionCountryCode")
					.setParameter("geography", geography)
					.setParameter("region", region)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (geography != null && region != null) {
			return getEntityManager()
					.createNamedQuery("getSectorReportByGeographyRegion")
					.setParameter("geography", geography)
					.setParameter("region", region).getResultList();
		} else if (geography != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getSectorReportByGeographyCountryCode")
					.setParameter("geography", geography)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (region != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getSectorReportByRegionCountryCode")
					.setParameter("region", region)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (geography != null) {
			return getEntityManager()
					.createNamedQuery("getSectorReportByGeography")
					.setParameter("geography", geography).getResultList();
		} else if (region != null) {
			return getEntityManager()
					.createNamedQuery("getSectorReportByRegion")
					.setParameter("region", region).getResultList();
		} else if (countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getSectorReportByCountryCode")
					.setParameter("countryCode", countryCode).getResultList();
		} else {
			return getEntityManager().createNamedQuery("getSectorReport")
					.getResultList();
		}
	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getDepartmentReport(Geography geography,
			Region region, CountryCode countryCode) {
		if (geography != null && region != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery(
							"getDepartmentReportByGeographyRegionCountryCode")
					.setParameter("geography", geography)
					.setParameter("region", region)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (geography != null && region != null) {
			return getEntityManager()
					.createNamedQuery("getDepartmentReportByGeographyRegion")
					.setParameter("geography", geography)
					.setParameter("region", region).getResultList();
		} else if (geography != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery(
							"getDepartmentReportByGeographyCountryCode")
					.setParameter("geography", geography)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (region != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getDepartmentReportByRegionCountryCode")
					.setParameter("region", region)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (geography != null) {
			return getEntityManager()
					.createNamedQuery("getDepartmentReportByGeography")
					.setParameter("geography", geography).getResultList();
		} else if (region != null) {
			return getEntityManager()
					.createNamedQuery("getDepartmentReportByRegion")
					.setParameter("region", region).getResultList();
		} else if (countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getDepartmentReportByCountryCode")
					.setParameter("countryCode", countryCode).getResultList();
		} else {
			return getEntityManager().createNamedQuery("getDepartmentReport")
					.getResultList();
		}
	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionReportActionForm> getAccountReport(Geography geography,
			Region region, CountryCode countryCode, Sector sector,
			Department department) {
		if (region != null && geography != null && countryCode != null
				&& department != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByGeographyRegionCountryCodeDepartment")
					.setParameter("geography", geography)
					.setParameter("region", region)
					.setParameter("countryCode", countryCode)
					.setParameter("department", department).getResultList();
		} else if (region != null && geography != null && countryCode != null
				&& sector != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByGeographyRegionCountryCodeSector")
					.setParameter("geography", geography)
					.setParameter("region", region)
					.setParameter("countryCode", countryCode)
					.setParameter("sector", sector).getResultList();
		} else if (geography != null && region != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByGeographyRegionCountryCode")
					.setParameter("geography", geography)
					.setParameter("region", region)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (geography != null && region != null && department != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByGeographyRegionDepartment")
					.setParameter("geography", geography)
					.setParameter("region", region)
					.setParameter("department", department).getResultList();
		} else if (geography != null && region != null && sector != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByGeographyRegionSector")
					.setParameter("geography", geography)
					.setParameter("region", region)
					.setParameter("sector", sector).getResultList();
		} else if (region != null && countryCode != null && department != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByRegionCountryCodeDepartment")
					.setParameter("region", region)
					.setParameter("countryCode", countryCode)
					.setParameter("department", department).getResultList();
		} else if (region != null && countryCode != null && sector != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByRegionCountryCodeSector")
					.setParameter("region", region)
					.setParameter("countryCode", countryCode)
					.setParameter("sector", sector).getResultList();
		} else if (geography != null && countryCode != null
				&& department != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByGeographyCountryCodeDepartment")
					.setParameter("geography", geography)
					.setParameter("countryCode", countryCode)
					.setParameter("department", department).getResultList();
		} else if (geography != null && countryCode != null && sector != null) {
			return getEntityManager()
					.createNamedQuery(
							"getAccountReportByGeographyCountryCodeSector")
					.setParameter("geography", geography)
					.setParameter("countryCode", countryCode)
					.setParameter("sector", sector).getResultList();
		} else if (geography != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByGeographyCountryCode")
					.setParameter("geography", geography)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (region != null && countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByRegionCountryCode")
					.setParameter("region", region)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (countryCode != null && department != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByCountryCodeDepartment")
					.setParameter("department", department)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (countryCode != null && sector != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByCountryCodeSector")
					.setParameter("sector", sector)
					.setParameter("countryCode", countryCode).getResultList();
		} else if (region != null && department != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByRegionDepartment")
					.setParameter("region", region)
					.setParameter("department", department).getResultList();
		} else if (region != null && sector != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByRegionSector")
					.setParameter("region", region)
					.setParameter("sector", sector).getResultList();
		} else if (geography != null && department != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByGeographyDepartment")
					.setParameter("geography", geography)
					.setParameter("department", department).getResultList();
		} else if (geography != null && sector != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByGeographySector")
					.setParameter("geography", geography)
					.setParameter("sector", sector).getResultList();
		} else if (countryCode != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportByCountryCode")
					.setParameter("countryCode", countryCode).getResultList();
		} else if (sector != null) {
			return getEntityManager()
					.createNamedQuery("getAccountReportBySector")
					.setParameter("sector", sector).getResultList();
		} else {
			return getEntityManager()
					.createNamedQuery("getAccountReportByDepartment")
					.setParameter("department", department).getResultList();
		}
	}

}
