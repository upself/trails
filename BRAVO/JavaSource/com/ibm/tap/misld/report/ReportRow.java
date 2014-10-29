package com.ibm.tap.misld.report;

import java.util.Vector;

/**
 * 
 * @author newtont
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ReportRow {

    Vector reportElements = new Vector();

    public void add(ReportElement reportElement) {
        reportElements.add(reportElement);
    }

    /**
     * @return Returns the reportElements.
     */
    public Vector getReportElements() {
        return reportElements;
    }

    /**
     * @param reportElements
     *            The reportElements to set.
     */
    public void setReportElements(Vector reportElements) {
        this.reportElements = reportElements;
    }
}