package com.ibm.tap.misld.report;

import java.util.Vector;

public class ReportCollection {

    public String reportTitle;

    public Vector columnList;

    public Vector rows;

    public String getReportTitle() {
        return reportTitle;
    }

    public Vector getColumnList() {
        return columnList;
    }

    public Vector getRows() {
        return rows;
    }

    public void setReportTitle(String reportTitle) {
        this.reportTitle = reportTitle;
    }

    public void setColumnList(Vector columnList) {
        this.columnList = columnList;
    }

    public void setRows(Vector rows) {
        this.rows = rows;
    }
}