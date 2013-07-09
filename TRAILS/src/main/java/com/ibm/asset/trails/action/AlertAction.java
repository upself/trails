package com.ibm.asset.trails.action;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.AlertReportService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class AlertAction extends BaseListAction {

    private static final long serialVersionUID = 1L;

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

    private AccountService accountService;

    @Autowired
    private AlertReportService alertReportService;

    private Date reportTimestamp;

    private Integer reportMinutesOld;

    @Override
    @UserRole(userRole = UserRoleType.READER)
    public void prepare() {

        if (getGeographyId() != null) {
            setGeography(getAccountService().getGeography(getGeographyId()));
        }

        if (getRegionId() != null) {
            setRegion(getAccountService().getRegion(getRegionId()));
        }

        if (getCountryCodeId() != null) {
            setCountryCode(getAccountService().getCountryCode(
                    getCountryCodeId()));
        }

        if (getDepartmentId() != null) {
            setDepartment(getAccountService().getDepartment(getDepartmentId()));
        }

        if (getSectorId() != null) {
            setSector(getAccountService().getSector(getSectorId()));
        }
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doGeography() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getGeographyAlertOverviewReport());

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doHome() {
        return Action.SUCCESS;
    }
    
    @UserRole(userRole = UserRoleType.READER)
    public String doAlertsHome() {
        return Action.SUCCESS;
    }
    
    @UserRole(userRole = UserRoleType.READER)
    public String doOperationalHome() {
        return Action.SUCCESS;
    }
    
    @UserRole(userRole = UserRoleType.READER)
    public String doAlertredAgingHome() {
        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doRegion() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getRegionAlertOverviewReport(
                        getGeography()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doCountryCode() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getCountryCodeAlertOverviewReport(
                        getGeography(), getRegion()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doSector() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getSectorAlertOverviewReport(
                        getGeography(), getRegion(), getCountryCode()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doDepartment() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getDepartmentAlertOverviewReport(
                        getGeography(), getRegion(), getCountryCode()));

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
                getAlertReportService().getAccountAlertOverviewReport(
                        getGeography(), getRegion(), getCountryCode(),
                        getSector(), getDepartment()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doPendingCustomerDecision() {
        return Action.SUCCESS;
    }

    private void retrieveReportInfo() {
        setReportTimestamp(getAlertReportService().selectReportTimestamp());
        setReportMinutesOld(getAlertReportService().selectReportMinutesOld());
    }

    public Long getGeographyId() {
        return geographyId;
    }

    public void setGeographyId(Long geographyId) {
        this.geographyId = geographyId;
    }

    public Geography getGeography() {
        return geography;
    }

    public void setGeography(Geography geography) {
        this.geography = geography;
    }

    public Region getRegion() {
        return region;
    }

    public void setRegion(Region region) {
        this.region = region;
    }

    public Long getRegionId() {
        return regionId;
    }

    public void setRegionId(Long regionId) {
        this.regionId = regionId;
    }

    public CountryCode getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(CountryCode countryCode) {
        this.countryCode = countryCode;
    }

    public Long getCountryCodeId() {
        return countryCodeId;
    }

    public void setCountryCodeId(Long countryCodeId) {
        this.countryCodeId = countryCodeId;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }

    public AccountService getAccountService() {
        return accountService;
    }

    public void setAccountService(AccountService accountService) {
        this.accountService = accountService;
    }

    public AlertReportService getAlertReportService() {
        return alertReportService;
    }

    public void setAlertReportService(AlertReportService alertReportService) {
        this.alertReportService = alertReportService;
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

    public Sector getSector() {
        return sector;
    }

    public void setSector(Sector sector) {
        this.sector = sector;
    }

    public Long getSectorId() {
        return sectorId;
    }

    public void setSectorId(Long sectorId) {
        this.sectorId = sectorId;
    }
}
