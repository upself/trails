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
import org.hibernate.HibernateException;
import org.hibernate.ScrollMode;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AccountAssets extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(AccountAssets.class);
	
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
		,"Asset Type"
		,"ATP Serial Number"
		,"BIOS Serial Number"
		,"Hardware Lpar"
		,"Software Lpar"
		,"Hardware Status"
		,"Machine Type"
		,"CPU Model"
		,"Hardware Complex"
		,"CHASSIS ID"
		,"Cloud Name"
		,"Customer Number"
		,"Scantime Date"
		,"Effective processor count"
		,"Physical HW processor count"
		,"Effective Threads Count"
		,"vCPU"
		,"HW_EXT_ID"
		,"SW_EXT_ID"
		,"HW_TI_ID"
		,"SW_TI_ID"
		,"HW Chips"
		,"Server Type"
		,"OS Type"
		,"SPLA"
		,"Virtual Flag"
		,"Virtual Mobility Restriction"
		,"sysplex"
		,"MF sysplex"
		,"Cluster type"
		,"Backup method"
		,"Internet Acc Flag"
		,"Capped LPAR"
		,"Mast Processor Type"
		,"Processor Manufacturer"
		,"Processor Model"
		,"NBR Cores Per Chip"
		,"NBR Of Chips Max"
		,"Hardware IFL"
		,"Shared processor"
		,"Shared"
		,"Multi Tenant"
		,"CPU IBM LSPR MIPS"
		,"CPU Gartner MIPS"
		,"CPU MSU"
		,"Part IBM LSPR MIPS"
		,"Part Gartner MIPS"
		,"Part MSU"
		,"Lpar Status"
	};
	
	public AccountAssets() { }
	
	public AccountAssets(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	
	public void execute(String[] args, HttpServletRequest request) throws HibernateException, Exception {
		
		// validate the arguments
		if (args.length < ARGS_LENGTH)
			return;
		
		// define the arguments
		accountId = args[0];
		// new method start here
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
			
			list = session.getNamedQuery("reportAccountAsset")
					.setLong("accountNumber", account.getCustomer().getAccountNumber())
					.scroll(ScrollMode.FORWARD_ONLY);
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
		// new method end
		
		
		// Original Method
		
//		// get the report
//		List list = DelegateReport.getReport(this,request);
//		
//		// get the output writer
//		PrintWriter os = new PrintWriter(outputStream, true);
//		
//		// write the header
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
