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
public class SoftwareLparOnly extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(SoftwareLparOnly.class);
	
	private String accountId;
	private String accountName;
	private String accountType;
	private String department;
	private String hostname;
	private String biosSerialNumber;
	private String source;

	private String[] HEADER = {
		"Account ID"
		,"Account Name"
		,"Account Type"
		,"Department"
		,"Hostname"
		,"BIOS Serial"
		,"SW Source"
	};
	
	private int ARGS_LENGTH = 1;
	
	public SoftwareLparOnly() { }
	
	public SoftwareLparOnly(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
//	public SoftwareLparOnly(Long accountNumber, String accountName, String accountType
//							, String department, String name, String biosSerial) {
//		this.accountId = accountNumber.toString();
//		this.accountName = accountName;
//		this.accountType = accountType;
//		this.department = department;
//		this.hostname = name;
//		this.biosSerialNumber = biosSerial;
//	}
	
	public void execute(String[] args, HttpServletRequest request) throws ExceptionAccountAccess {
		
		// validate the arguments
		if (args.length < ARGS_LENGTH)
			return;
		
		// define the arguments
		accountId = args[0];
//		ScrollableResults list = null;
//		try {
//			Account account = DelegateAccount.getAccount(accountId,
//					request);
//			if ( account != null ) {
//				logger.debug("got account");
//			}
//
//			Session session = DelegateReport.getSession();
//			if ( session != null ) {
//				logger.debug("got session");
//			}
//
//			list = (ScrollableResults) session.getNamedQuery("reportSoftwareOnlyByCustomer")
//					.setEntity("customer", account.getCustomer()).setString(
//							"status", Constants.ACTIVE).scroll();
//			PrintWriter os = new PrintWriter(outputStream, true);
//			if ( os != null ) {
//				logger.debug("got print writer");
//			}
//			
//			// output the header
//			os.println(tsv(HEADER));
//			
//			while ( list.next() ) {
////				Object[] data = list.get();
//				os.println(tsv(list.get()));
//			}
//			os.close();
//
//			DelegateReport.closeSession(session);
//
//		} catch (Exception e) {
//			logger.error(e);
//		}

		/* Original before we went to scrollable recordsets */
		// get the report
		List<Object[]> list = DelegateReport.getReport(this,request);
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

	public String getAccountId() {
		return accountId;
	}
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	public String getAccountName() {
		return accountName;
	}
	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}
	public String getAccountType() {
		return accountType;
	}
	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}
	public String getBiosSerialNumber() {
		return biosSerialNumber;
	}
	public void setBiosSerialNumber(String biosSerialNumber) {
		this.biosSerialNumber = biosSerialNumber;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
}