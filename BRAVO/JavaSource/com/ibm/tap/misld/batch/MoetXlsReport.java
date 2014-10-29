/*
 * Created on Jun 7, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.util.HashMap;

import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author denglers
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class MoetXlsReport {

    private String   xlsTemplate = null;

    private Customer customer    = null;

    private HashMap  xlsReport   = null;

    MoetXlsReport(String xlsTemplate, Customer customer) {

        this.xlsTemplate = xlsTemplate;
        this.customer = customer;
    }

    /**
     * @return
     */
    public Customer getCustomer() {
        return customer;
    }

    /**
     * @return
     */
    public HashMap getXlsReport() {
        return xlsReport;
    }

    /**
     * @return
     */
    public String getXlsTemplate() {
        return xlsTemplate;
    }

    /**
     * @param customer
     */
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    /**
     * @param list
     */
    public void setXlsReport(HashMap list) {
        xlsReport = list;
    }

    /**
     * @param string
     */
    public void setXlsTemplate(String string) {
        xlsTemplate = string;
    }

}