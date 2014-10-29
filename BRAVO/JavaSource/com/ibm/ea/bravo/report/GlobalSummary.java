/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.report;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class GlobalSummary extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(GlobalSummary.class);
	
	private String[] HEADER = {
		"HW SW"
		,"HW Only"
		,"SW Only"
		,"SW Discrep None"
		,"SW Discrep"
		,"Account ID"
		,"Account Name"
		,"Account Type"
		,"Account Dept"
		,"Account Status"
	};
	
	private int ARGS_LENGTH = 1;
	
	public GlobalSummary() { }
	
	public GlobalSummary(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
	public void execute(String[] args) {
		
		// validate the arguments
		if (args.length < ARGS_LENGTH)
			return;
		
		// get the report
		List<Object[]> list = DelegateReport.getReport(this);
		logger.debug("list.size = " + list.size());
		
		// get the output writer
		PrintWriter os = new PrintWriter(outputStream, true);
		os.println(Constants.CONFIDENTIAL);
		
		// output the header
		os.println(tsv(HEADER));

		// output the report
		Iterator<Object[]> i = list.iterator();
		while (i.hasNext()) {
			Object[] data = (Object[]) i.next();
			
			os.println(tsv(data));
		}
	}

}