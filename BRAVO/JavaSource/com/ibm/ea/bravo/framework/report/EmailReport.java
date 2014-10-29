/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.report;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class EmailReport extends ReportBase {

	protected String reportDir;
	
	public abstract void execute(String[] arguments);

	public String getReportDir() {
		return this.reportDir;
	}
	public void setReportDir(String reportDir) {
		this.reportDir = reportDir;
	}
}
