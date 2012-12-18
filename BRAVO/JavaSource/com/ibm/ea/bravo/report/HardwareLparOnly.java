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

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class HardwareLparOnly extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(HardwareLparOnly.class);
	
	private String accountId;
	private String lparName;
	private String acquisitionTime;

	private int ARGS_LENGTH = 1;
	
	private String[] HEADER = {
		"Account ID"
		,"Account Name"
		,"Account Type"
		,"Department"
		,"Hostname"
		,"Serial Number"
	};
	
	public HardwareLparOnly() { }
	
	public HardwareLparOnly(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
	public void execute(String[] args, HttpServletRequest request) throws ExceptionAccountAccess {
		
		// validate the arguments
		if (args.length < ARGS_LENGTH)
			return;
		
		// define the arguments
		accountId = args[0];
		
		// get the report
		List<Object[]> list = DelegateReport.getReport(this,request);
		logger.debug("list.size = " + list.size());
		
		// get the output writer
		PrintWriter os = new PrintWriter(outputStream, true);
		os.println(Constants.CONFIDENTIAL);
		
		// write the header
		os.println(tsv(HEADER));
		
		// output the report
		Iterator<Object[]> i = list.iterator();
		while (i.hasNext()) {
			Object[] data = (Object[]) i.next();
			
			os.println(tsv(data));
		}
	}

	public String getAccountId() {
		return accountId;
	}
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	public String getAcquisitionTime() {
		return acquisitionTime;
	}
	public void setAcquisitionTime(String acquisitionTime) {
		this.acquisitionTime = acquisitionTime;
	}
	public int getARGS_LENGTH() {
		return ARGS_LENGTH;
	}
	public void setARGS_LENGTH(int args_length) {
		ARGS_LENGTH = args_length;
	}
	public String getLparName() {
		return lparName;
	}
	public void setLparName(String lparName) {
		this.lparName = lparName;
	}
}
