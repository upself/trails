package com.ibm.asset.trails.action;

import java.util.List;

import com.ibm.asset.trails.domain.Report;

public class AccountReportBaseAction extends AccountBaseAction {

    private static final long serialVersionUID = 1L;

    private List<Report> reportList;

    private boolean customerOwnedCustomerManagedSearch = false;

    public boolean isCustomerOwnedCustomerManagedSearch() {
        return customerOwnedCustomerManagedSearch;
    }

    public void setCustomerOwnedCustomerManagedSearch(
            boolean customerOwnedCustomerManagedSearch) {
        this.customerOwnedCustomerManagedSearch = customerOwnedCustomerManagedSearch;
    }

    public List<Report> getReportList() {
        return reportList;
    }

    public void setReportList(List<Report> reportList) {
        this.reportList = reportList;
    }
}
