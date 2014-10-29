package com.ibm.asset.trails.action;

import java.util.Date;
import java.util.Date;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class AlertReportAction extends BaseListAction {

    private static final long serialVersionUID = -4177329710943793048L;

    @Autowired
    private DataExceptionReportService alertReportService;

    private AccountService accountService;

    private Long geographyId;

    private Geography geography;

    private Long regionId;

    private Region region;

    private Long countryCodeId;

    private CountryCode countryCode;

    private Long sectorId;

    private Sector sector;

    private Long departmentId;

    private Department department;
    
    private Date reportTimestamp;
	private Integer reportMinutesOld;

    public void setAlertReportService(
            DataExceptionReportService alertReportService) {
        this.alertReportService = alertReportService;
    }

    public DataExceptionReportService getAlertReportService() {
        return alertReportService;
    }

    public void setAccountService(AccountService accountService) {
        this.accountService = accountService;
    }

    public AccountService getAccountService() {
        return accountService;
    }

    @Override
    public void prepare() {
        if (getGeographyId() != null) {
            setGeography(accountService.getGeography(geographyId));
        }

        if (getRegionId() != null) {
            setRegion(accountService.getRegion(regionId));
        }

        if (getCountryCodeId() != null) {
            setCountryCode(accountService.getCountryCode(countryCodeId));
        }

        if (getDepartmentId() != null) {
            setDepartment(accountService.getDepartment(departmentId));
        }

        if (getSectorId() != null) {
            setSector(getAccountService().getSector(sectorId));
        }
        
    }
    
    private void retrieveReportInfo() {
		setReportTimestamp(new Date());
		setReportMinutesOld(0);
	}
    
    @UserRole(userRole = UserRoleType.READER)
    public String doDataExceptionHome() {
        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doGeography() {
    	retrieveReportInfo();
        getData().setList(alertReportService.getGeographyReport());
        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doRegion() {
    	retrieveReportInfo();
        getData().setList(alertReportService.getRegionReport(geography));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doCountryCode() {
    	retrieveReportInfo();
        getData().setList(
                alertReportService.getCountryCodeReport(geography, region));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doSector() {
    	retrieveReportInfo();
        getData().setList(
                alertReportService.getSectorReport(geography, region,
                        countryCode));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doDepartment() {
    	retrieveReportInfo();
        getData().setList(
                alertReportService.getDepartmentReport(geography, region,
                        countryCode));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doAccount() {
        if (getCountryCode() == null && getDepartment() == null
                && getSector() == null) {
            return Action.ERROR;
        }
        retrieveReportInfo();
        getData().setList(
                alertReportService.getAccountReport(geography, region,
                        countryCode, sector, department));

        return Action.SUCCESS;
    }

    public void setGeographyId(Long geographyId) {
        this.geographyId = geographyId;
    }

    public Long getGeographyId() {
        return geographyId;
    }

    public Geography getGeography() {
        return geography;
    }

    public void setGeography(Geography geography) {
        this.geography = geography;
    }

    public void setRegionId(Long regionId) {
        this.regionId = regionId;
    }

    public Long getRegionId() {
        return regionId;
    }

    public Region getRegion() {
        return region;
    }

    public void setRegion(Region region) {
        this.region = region;
    }

    public void setCountryCodeId(Long countryCodeId) {
        this.countryCodeId = countryCodeId;
    }

    public Long getCountryCodeId() {
        return countryCodeId;
    }

    public CountryCode getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(CountryCode countryCode) {
        this.countryCode = countryCode;
    }

    public void setSectorId(Long sectorId) {
        this.sectorId = sectorId;
    }

    public Long getSectorId() {
        return sectorId;
    }

    public Sector getSector() {
        return sector;
    }

    public void setSector(Sector sector) {
        this.sector = sector;
    }

    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }

    public Long getDepartmentId() {
        return departmentId;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }
    
	public Integer getReportMinutesOld() {
		return reportMinutesOld;
	}

	public Date getReportTimestamp() {
		return reportTimestamp;
	}

	public void setReportMinutesOld(Integer reportMinutesOld) {
		this.reportMinutesOld = reportMinutesOld;
	}

	public void setReportTimestamp(Date reportTimestamp) {
		this.reportTimestamp = reportTimestamp;
	}

}
