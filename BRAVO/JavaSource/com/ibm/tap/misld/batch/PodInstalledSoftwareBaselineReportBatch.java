/*
 * Created on Jun 3, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.io.FileOutputStream;
import java.io.Serializable;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.ibm.batch.IBatch;
import com.ibm.tap.misld.delegate.baseline.MsInstalledSoftwareBaselineReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.exceptions.EmailDeliveryException;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author Thomas
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class PodInstalledSoftwareBaselineReportBatch extends BatchBase
		implements IBatch, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String podName = null;

	private String remoteUser = null;

	public PodInstalledSoftwareBaselineReportBatch(String podName,
			String remoteUser) 
		throws EmailDeliveryException {

		super();

		this.podName = podName;
		this.remoteUser = remoteUser;
		setStartTime(new Date());
	}

	public boolean validate() throws Exception {
		return false;
	}

	public void execute() throws Exception {
	}

	public void sendNotify() {

		String reportTemplateFilename = null;

		reportTemplateFilename = "Software_Baseline_Report_Template.xls";

		try {
			setFrom("SOFTWARE-BASELINE-REPORT");
			setSubject("Software Baseline Report for: " + podName);
			setTo(remoteUser);
		} catch (Exception e) {
			logMsg(e);
		}
		try {
			XlsReport xlsReport = new XlsReport(reportTemplateFilename, null, null);

			xlsReport.setXlsReport(MsInstalledSoftwareBaselineReadDelegate
					.getPodBaselineReport(podName, remoteUser));

			XlsReportGenerator xlsReportGenerator = new XlsReportGenerator();
			HSSFWorkbook wb = xlsReportGenerator.buildXlsReport(xlsReport);

			if (wb != null) {
				FileOutputStream fileOut = null;
				String fileOutName = "software_baseline_report_" + podName
						+ ".xls";

				fileOut = new FileOutputStream(Constants.SPREAD_IN
						+ fileOutName);
				wb.write(fileOut);
				fileOut.close();

				addBody("The Software Baseline report for " + podName
						+ " is attached below.");
				addAttachment(Constants.SPREAD_IN + fileOutName);
				sendMsg(remoteUser);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logMsg(e);
		}
	}

	public void sendNotifyException(Exception e) {
		logger.debug(e, e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getName()
	 */
	public String getName() {
		return "Software Baseline Report";
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getRemoteUser()
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getCustomer()
	 */
	public Customer getCustomer() {
		// TODO Auto-generated method stub
		return null;
	}

}