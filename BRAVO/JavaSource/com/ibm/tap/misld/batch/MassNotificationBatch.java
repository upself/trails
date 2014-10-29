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
import com.ibm.tap.misld.delegate.baseline.MsHardwareBaselineReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.exceptions.EmailDeliveryException;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.report.NotificationDelegate;

/**
 * @author Thomas
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class MassNotificationBatch extends BatchBase implements IBatch,
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Customer customer = null;

	private String remoteUser = null;

	public MassNotificationBatch(Customer customer, String remoteUser) 
	
		throws EmailDeliveryException {

		super();

		this.customer = customer;
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

		reportTemplateFilename = "Microsoft_Hardware_Scan_Template.xls";

		try {
			setFrom("HARDWARE-SCAN-REPORT");
			setSubject("Hardware scan report for: "
					+ customer.getCustomerName());
			setTo(customer.getContactDPE().getRemoteUser());
		} catch (Exception e) {
			logMsg(e);
		}
		try {
			XlsReport xlsReport = new XlsReport(reportTemplateFilename,
					customer, null);

			xlsReport.setXlsReport(MsHardwareBaselineReadDelegate
					.getScanReport(customer));

			XlsReportGenerator xlsReportGenerator = new XlsReportGenerator();
			HSSFWorkbook wb = xlsReportGenerator.buildXlsReport(xlsReport);

			if (wb != null) {
				FileOutputStream fileOut = null;
				String fileOutName = "hardware_scan_report_"
						+ this.customer.getAccountNumber() + ".xls";

				fileOut = new FileOutputStream(Constants.SPREAD_IN
						+ fileOutName);
				wb.write(fileOut);
				fileOut.close();

				addBody("DPE, \n\n");

				addBody("Attached is a spreadsheet that contains the time that we last scanned your in-scope Windows servers for SPLA/ESPLA license reporting.  This spreadsheet should contain the hostnames for any servers that have a Microsoft operating system or any other Microsoft products which IBM is responsible licensing.  Please look at this spreadsheet and verify that the IBM provided Microsoft products utilized on your account have not changed (added, removed, updated) since the last scan date.\n\n");

				addBody("Any servers using Microsoft Software that have been added or changed since the last scan date must be scanned for a Microsoft software inventory.  If updates are required and there is currently not an automated scanning agent in place on your account, please follow this procedure to ensure your servers are reported correctly:\n");
				addBody("- Set change Windows for the SW inventory scan.\n");
				addBody("- Engage your server support team to run software inventory scan.\n");
				addBody("- Ensure inventory scans are completed and output files have been sent to the inventory server.\n\n");
				addBody("The SW inventory script(w32-ix86.zip) and scanning procedure and documentation (standalone.pdf) can be downloaded from this link:  http://tap.raleigh.ibm.com/standalone/ .\n\n");
				addBody("If you need help or have any questions, please contact your software asset management representative.\n\n");
				addAttachment(Constants.SPREAD_IN + fileOutName);
				sendMsg(remoteUser);
			}
			
			NotificationDelegate.createNotification(customer,remoteUser,"SCAN");
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
		return "Hardware Scan Report";
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
	 * @see com.ibm.batch.IBatch#getCustomerName()
	 */
	public String getCustomerName() {
		return customer.getCustomerName();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getCustomer()
	 */
	public Customer getCustomer() {
		// TODO Auto-generated method stub
		return this.customer;
	}

}