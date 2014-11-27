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

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;
import com.ibm.ea.bravo.software.DelegateSoftware;
//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product; 
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AccountSoftware extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(AccountSoftware.class);
	
	private String accountId;
	private String softwareId;

	private String[] HEADER = {
		"Account ID"
		,"Account Name"
		,"Account Type"
		,"Department"
		,"Hostname"
//serial number
//asset type
		,"Software Name"
		,"Discrepancy Type"
		,"Last Updated By"
		,"Last Updated On"
		,"Research Flag"
	};
	
	private int ARGS_LENGTH = 1;
	
	public AccountSoftware() { }
	
	public AccountSoftware(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
	public void execute(String[] args, HttpServletRequest request) throws ExceptionAccountAccess {
		
		// validate the arguments
		if (args.length < ARGS_LENGTH)
			return;
		
		// define the arguments
		accountId = args[0];
		softwareId = args[1];
//		List list = new ArrayList();

		// validate the account exists
		Account account = DelegateAccount.getAccount(accountId,
				request);
		if (account == null) {
			logger.info("account not found in AccountSoftware report. Account: " + accountId);
			return;
		}

		// validate the software exists
		//Change Bravo to use Software View instead of Product Object Start
		//Product software = DelegateSoftware.getSigBank(softwareId);
		Software software = DelegateSoftware.getSigBank(softwareId);
		//Change Bravo to use Software View instead of Product Object End
		if (software == null) {
			return;
		}
		// get the report
		ScrollableResults list = null;

		try {

			Session session = DelegateReport.getSession();

			list = session.getNamedQuery("reportLparsByAccountBySoftware")
					.setEntity("customer", account.getCustomer()).setEntity(
							"software", software).setString("status",
							Constants.ACTIVE).scroll();
			PrintWriter os = new PrintWriter(outputStream, true);
			
			os.println(Constants.CONFIDENTIAL);
			
			
			// output the header
			os.println(tsv(HEADER));
			
			while ( list.next() ) {
//				Object[] data = list.get();
				os.println(tsv(list.get()));
			}
			os.close();

			DelegateReport.closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}
		
//		// get the report
//		List list = DelegateReport.getReport(this, request);
//		
//		// get the output writer
//		PrintWriter os = new PrintWriter(outputStream, true);
//		
//		// output the header
//		os.println(tsv(HEADER));
//
//		// output the report
//		Iterator i = list.iterator();
//		while (i.hasNext()) {
//			Object[] data = (Object[]) i.next();
//			
//			os.println(tsv(data));
//		}
		
	}

	public String getAccountId() {
		return accountId;
	}
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	public String getSoftwareId() {
		return softwareId;
	}
	public void setSoftwareId(String softwareId) {
		this.softwareId = softwareId;
	}
}