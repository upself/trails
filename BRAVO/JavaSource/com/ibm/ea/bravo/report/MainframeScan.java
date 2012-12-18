/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.report;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;

/**
 * @author jain
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class MainframeScan extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(MainframeScan.class);
	
	private String[] HEADER = {
		"Account ID"
		,"Account Name"
		,"Account Type"
		,"Hostname"
		,"BIOS Serial Number"
		,"HW Serial Number"
		,"Scan Time"
		,"SW Product Name"
		,"Manufacturer"
		,"License level"
	};
	
	public MainframeScan() { }
	
	public MainframeScan(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
	public void execute(String[] args, HttpServletRequest request) {
		ScrollableResults list = null;

		try {

			// get the report
	
			Session session = DelegateReport.getSession();

			list = session.getNamedQuery("mainFrameScanReport").scroll();
			
			// get the output writer
			PrintWriter os = new PrintWriter(outputStream, true);
			
			os.println(Constants.CONFIDENTIAL);
			
			// output the header
			os.println(tsv(HEADER));
	
			// output the report
			while ( list.next() ) {
				os.println(tsv(list.get()));
			}
			os.close();
			DelegateReport.closeSession(session);
	
		} catch (Exception e) {
			logger.error(e);
		}
	}
}