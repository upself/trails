package com.ibm.asset.trails.domain;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Formula;

@Entity
@Table(name = "CUSTOMER")
@org.hibernate.annotations.Entity(mutable = false)
@NamedQueries({
        @NamedQuery(name = "accountDetails", query = "FROM Account A JOIN FETCH A.department JOIN FETCH A.industry LEFT OUTER JOIN FETCH A.dpe LEFT OUTER JOIN FETCH A.softwareContact JOIN FETCH A.accountType LEFT OUTER JOIN FETCH A.countryCode WHERE A.id = :customerId"),
        @NamedQuery(name = "accountByAccountNumber", query = "FROM Account WHERE account = :accountNumber") })
public class Account {

    @Id
    @Column(name = "CUSTOMER_ID")
    private Long id;

    @Column(name = "CUSTOMER_NAME")
    private String name;

    @Column(name = "ACCOUNT_NUMBER")
    private Long account;

    @Column(name = "STATUS")
    private String status;

    @Column(name = "SW_LICENSE_MGMT")
    private String swlm;

    @Column(name = "SW_INTERLOCK")
    private String softwareInterlock;

    @Column(name = "SW_TRACKING")
    private String softwareTracking;

    @Column(name = "SW_FINANCIAL_MGMT")
    private String softwareFinancialManagement;

    @Column(name = "SW_COMPLIANCE_MGMT")
    private String softwareComplianceManagement;

    @Column(name = "SW_FINANCIAL_RESPONSIBILITY")
    private String softwareFinancialResponsibility;

    @Column(name = "HW_SUPPORT")
    private String hardwareSupport;

    @Column(name = "CONTRACT_SIGN_DATE")
    private Date contractSignDate;

    @Column(name = "SW_SUPPORT")
    private String softwareSupport;

    @Formula("cast(account_number as char(10))")
    private String accountStr;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "POD_ID")
    private Department department;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "INDUSTRY_ID")
    private Industry industry;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CONTACT_DPE_ID", nullable = true)
    private Dpe dpe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CONTACT_SW_ID")
    private SoftwareContact softwareContact;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CUSTOMER_TYPE_ID")
    private AccountType accountType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COUNTRY_CODE_ID")
    private CountryCode countryCode;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "memberAccount")
    private Set<AccountPool> masterAccounts = new HashSet<AccountPool>();

    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY)
    private Set<AlertView> alerts = new HashSet<AlertView>();

    @Column(name = "SCAN_VALIDITY")
    private Integer scanValidity;

    public Long getAccount() {
        return account;
    }

    public void setAccount(Long account) {
        this.account = account;
    }

    public String getAccountStr() {
        return accountStr;
    }

    public void setAccountStr(String accountStr) {
        this.accountStr = accountStr;
    }

    public AccountType getAccountType() {
        return accountType;
    }

    public void setAccountType(AccountType accountType) {
        this.accountType = accountType;
    }

    public CountryCode getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(CountryCode countryCode) {
        this.countryCode = countryCode;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Dpe getDpe() {
        return dpe;
    }

    public void setDpe(Dpe dpe) {
        this.dpe = dpe;
    }

    public String getHardwareSupport() {
        return hardwareSupport;
    }

    public void setHardwareSupport(String hardwareSupport) {
        this.hardwareSupport = hardwareSupport;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Industry getIndustry() {
        return industry;
    }

    public void setIndustry(Industry industry) {
        this.industry = industry;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSoftwareComplianceManagement() {
        return softwareComplianceManagement;
    }

    public void setSoftwareComplianceManagement(
            String softwareComplianceManagement) {
        this.softwareComplianceManagement = softwareComplianceManagement;
    }

    public SoftwareContact getSoftwareContact() {
        return softwareContact;
    }

    public void setSoftwareContact(SoftwareContact softwareContact) {
        this.softwareContact = softwareContact;
    }

    public String getSoftwareFinancialManagement() {
        return softwareFinancialManagement;
    }

    public void setSoftwareFinancialManagement(
            String softwareFinancialManagement) {
        this.softwareFinancialManagement = softwareFinancialManagement;
    }

    public String getSoftwareFinancialResponsibility() {
        return softwareFinancialResponsibility;
    }

    public void setSoftwareFinancialResponsibility(
            String softwareFinancialResponsibility) {
        this.softwareFinancialResponsibility = softwareFinancialResponsibility;
    }

    public String getSoftwareInterlock() {
        return softwareInterlock;
    }

    public void setSoftwareInterlock(String softwareInterlock) {
        this.softwareInterlock = softwareInterlock;
    }

    public String getSoftwareSupport() {
        return softwareSupport;
    }

    public void setSoftwareSupport(String softwareSupport) {
        this.softwareSupport = softwareSupport;
    }

    public String getSoftwareTracking() {
        return softwareTracking;
    }

    public void setSoftwareTracking(String softwareTracking) {
        this.softwareTracking = softwareTracking;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSwlm() {
        return swlm;
    }

    public void setSwlm(String swlm) {
        this.swlm = swlm;
    }

    public Set<AlertView> getAlerts() {
        return alerts;
    }

    public void setAlerts(Set<AlertView> alerts) {
        this.alerts = alerts;
    }

    public Integer getScanValidity() {
        return scanValidity;
    }

    public void setScanValidity(Integer scanValidity) {
        this.scanValidity = scanValidity;
    }

    public Date getContractSignDate() {
        return contractSignDate;
    }

    public void setContractSignDate(Date contractSignDate) {
        this.contractSignDate = contractSignDate;
    }

    public Set<AccountPool> getMasterAccounts() {
        return masterAccounts;
    }

    public void setMasterAccounts(Set<AccountPool> masterAccounts) {
        this.masterAccounts = masterAccounts;
    }
}
