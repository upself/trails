package com.ibm.asset.trails.action;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.SwTrackingReportService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class SwTrackingReportAction extends BaseListAction{
    /**
	 * 
	 */
	private static final long serialVersionUID = 4070976635658356268L;

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
    private SwTrackingReportService swTrackingReportService;

    private Date reportTimestamp;

    private Integer reportMinutesOld;

    private String accountName;

    private boolean detail;

    private String accountMethod;

    private Long accountId;

    private Account account;

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

        if (getSectorId() != null) {
            setSector(getAccountService().getSector(getSectorId()));
        }

        if (getDepartmentId() != null) {
            setDepartment(getAccountService().getDepartment(getDepartmentId()));
        }

        if (getAccountId() != null) {
            setAccount(getAccountService().getAccount(getAccountId()));
        }
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doGeography() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getGeographyAlertOperationalReport());

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doRegion() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getRegionAlertOperationalReport(
                        getGeography()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doCountryCode() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getCountryCodeAlertOperationalReport(
                        getGeography(), getRegion()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doSector() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getSectorAlertOperationalReport(
                        getGeography(), getRegion(), getCountryCode()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doDepartment() {
        retrieveReportInfo();
        getData().setList(
                getAlertReportService().getDepartmentAlertOperationalReport(
                        getGeography(), getRegion(), getCountryCode()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doAccountByName() {
        if (getCountryCode() == null && getDepartment() == null
                && getSector() == null) {
            return Action.ERROR;
        }

        retrieveReportInfo();

        if (isDetail()) {
            getData().setList(
                    getAlertReportService()
                            .getAccountDetailAlertOperationalReport(
                                    getAccountName()));
            return "detail";
        }

        setAccountMethod("name");
        getData().setList(
                getAlertReportService().getAccountByNameAlertOperationalReport(
                        getGeography(), getRegion(), getCountryCode(),
                        getSector(), getDepartment()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doAccountByNumber() {
        if (getCountryCode() == null && getDepartment() == null
                && getSector() == null) {
            return Action.ERROR;
        }

        retrieveReportInfo();
        setAccountMethod("number");
        getData().setList(
                getAlertReportService()
                        .getAccountByNumberAlertOperationalReport(
                                getGeography(), getRegion(), getCountryCode(),
                                getSector(), getDepartment()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.REPORTSREADER)
    public String doAccountDetailDownload() {
        getData().setList(
                getAlertReportService().getAccountDetailAlertOperationalReport(
                        getAccount()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doAccountRegion() {
        getData().setList(
                getAlertReportService().getAccountRegionAlertOperationalReport(
                        getGeography()));

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doAccountCountryCode() {
        getData().setList(
                getAlertReportService()
                        .getAccountCountryCodeAlertOperationalReport(
                                getGeography(), getRegion()));

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

    public SwTrackingReportService getAlertReportService() {
        return swTrackingReportService;
    }

    public void setAlertReportService(SwTrackingReportService swTrackingReportService) {
        this.swTrackingReportService = swTrackingReportService;
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

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public boolean isDetail() {
        return detail;
    }

    public void setDetail(boolean detail) {
        this.detail = detail;
    }

    public String getAccountMethod() {
        return accountMethod;
    }

    public void setAccountMethod(String accountMethod) {
        this.accountMethod = accountMethod;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

}
