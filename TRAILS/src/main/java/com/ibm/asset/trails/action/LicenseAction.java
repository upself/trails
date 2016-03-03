package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Report;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class LicenseAction extends AccountReportBaseAction {
    private static final long serialVersionUID = 1L;

    private List<CapacityType> capacityTypeList;

    private License license;

    private Long licenseId;

    @Autowired
    private LicenseService licenseService;

    private String requestURI;

    @UserRole(userRole = UserRoleType.READER)
    public String doLicense() {

        setRequestURI("license.htm");
        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doLicenseDetails() {
        if (getLicenseId() == null) {
            return Action.ERROR;
        } else {
            setLicense(getLicenseService().getLicenseDetails(getLicenseId()));
        }

        return Action.SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String doFreePool() {
        getLicenseService().freePoolWithParentPaginatedList(getData(),
                getAccount(), getStartIndex(), getData().getObjectsPerPage(),
                getSort(), getDir(),null);

        setRequestURI("licenseFreePool.htm");
        return "freepool";
    }

    @Override
    @UserRole(userRole = UserRoleType.READER)
    public void prepare() {
        super.prepare();

        List<Report> lReport = new ArrayList<Report>();

        if (getSort() == null) {
            setSort("productName");
            setDir("ASC");
        }

        lReport.add(new Report("License baseline", "licenseBaseline"));
        super.setReportList(lReport);
    }

    public List<CapacityType> getCapacityTypeList() {
        return capacityTypeList;
    }

    public License getLicense() {
        return license;
    }

    public Long getLicenseId() {
        return licenseId;
    }

    public LicenseService getLicenseService() {
        return licenseService;
    }

    public void setCapacityTypeList(List<CapacityType> capacityTypeList) {
        this.capacityTypeList = capacityTypeList;
    }

    public void setLicense(License license) {
        this.license = license;
    }

    public void setLicenseId(Long licenseId) {
        this.licenseId = licenseId;
    }

    public void setLicenseService(LicenseService licenseService) {
        this.licenseService = licenseService;
        setCapacityTypeList(getLicenseService().getCapacityTypeList());
    }

    public String getRequestURI() {
        return requestURI;
    }

    public void setRequestURI(String requestURI) {
        this.requestURI = requestURI;
    }
}
