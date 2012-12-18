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
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class GlobalDiscrepancies extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(GlobalDiscrepancies.class);
	
	private String[] HEADER = {
		"Geo"
		,"Region"
		,"Country"
		,"Account ID"
		,"Account Name"
		,"Account Type"
		,"Department"
		,"Hostname"
		,"Software Name"
		,"Discrepancy Type"
		,"Invalid Category"
		,"Last Updated By"
		,"Last Updated On"
		,"Version"
		,"Research Flag"
		,"Comments"
	};
	
	private int ARGS_LENGTH = 1;
	
	public GlobalDiscrepancies() { }
	
	public GlobalDiscrepancies(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
	public void execute(String[] args, HttpServletRequest request) {
		Long softwareId;		
		String software;
		ScrollableResults list = null;

		try {
			// validate the arguments
			if (args.length < ARGS_LENGTH)
				return;
			
			software = request.getParameter("software");
			logger.debug("Software ID: "+software);
			
			// define the arguments
			softwareId = Long.parseLong(software);
			
			// get the report
	
			Session session = DelegateReport.getSession();

			list = session.getNamedQuery("reportDiscrepanciesBySoftware")
					.setLong("software", softwareId)
					.setString("status", Constants.ACTIVE).scroll();
			
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