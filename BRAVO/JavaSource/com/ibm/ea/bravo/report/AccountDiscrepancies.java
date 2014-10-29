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

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AccountDiscrepancies extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(AccountDiscrepancies.class);
	
	private String accountId;

	private String[] HEADER = {
		"Account ID"
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
		,"Comment"
	};
	
	private int ARGS_LENGTH = 1;
	
	public AccountDiscrepancies() { }
	
	public AccountDiscrepancies(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
	public void execute(String[] args, HttpServletRequest request) throws ExceptionAccountAccess {
		logger.debug("AccountDiscrepancies - start");
		logger.debug(HEADER);
		
		// validate the arguments
		if (args.length < ARGS_LENGTH)
			return;
		
		// define the arguments
		accountId = args[0];
		
		// get the report
		ScrollableResults list = null;
		try {
			Account account = DelegateAccount.getAccount(accountId,
					request);
			if ( account != null ) {
				logger.debug("got account");
			}

			Session session = DelegateReport.getSession();
			if ( session != null ) {
				logger.debug("got session");
			}
			
			list = session.getNamedQuery("reportDiscrepanciesByCustomer")
					.setLong("customer",
							account.getCustomer().getCustomerId().longValue())
					.setString("status", Constants.ACTIVE).scroll();
			PrintWriter os = new PrintWriter(outputStream, true);
			if ( os != null ) {
				logger.debug("got print writer");
			}
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
		
		
		// get the output writer
//
//		// output the report
//		Iterator i = list.iterator();
//		while (i.hasNext()) {
//			Object[] data = (Object[]) i.next();
//			
//			os.println(tsv(data));
//		}
		logger.debug("finished report");
	}

	public String getAccountId() {
		return accountId;
	}
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
}