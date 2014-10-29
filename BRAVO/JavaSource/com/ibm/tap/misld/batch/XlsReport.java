/*
 * Created on Jun 7, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.util.List;

import com.ibm.ea.cndb.Pod;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author denglers
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class XlsReport {

    private String   xlsTemplate = null;

    private Customer customer    = null;
    
    private Pod      pod		 = null;

    private List     xlsReport   = null;

    XlsReport(String xlsTemplate, Customer customer2, Pod pod) {

        this.xlsTemplate = xlsTemplate;
        this.customer = customer2;
        this.pod = pod;
    }

	/**
     * @return
     */
    public Pod getPod() {
        return pod;
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
    public List getXlsReport() {
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
    public void setPod(Pod pod) {
        this.pod = pod;
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
    public void setXlsReport(List list) {
        xlsReport = list;
    }

    /**
     * @param string
     */
    public void setXlsTemplate(String string) {
        xlsTemplate = string;
    }

}