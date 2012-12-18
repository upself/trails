/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.report;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SCRTReportDownload extends DownloadReport implements IReport {
	private static final Logger logger = Logger
			.getLogger(SCRTReportDownload.class);

	private String accountId;

	private String scrtReportFile;

	private int ARGS_LENGTH = 2;

	public SCRTReportDownload() {
	}

	public SCRTReportDownload(OutputStream outputStream) {
		this.outputStream = outputStream;
	}

	public void execute(String[] args, HttpServletRequest request)
			throws ExceptionAccountAccess {

		// validate the arguments
		if (args.length < ARGS_LENGTH)
			return;

		// define the arguments
		accountId = args[0];
		scrtReportFile = args[1];

		// get the output writer
		PrintWriter os = new PrintWriter(outputStream, true);

		// output the report
		try {
			logger.debug("scrtReportFile=" + Constants.SCRT_REPORT_DIR + scrtReportFile);
			BufferedReader in = new BufferedReader(new FileReader(
					Constants.SCRT_REPORT_DIR + "/" + scrtReportFile));
			String str;
			while ((str = in.readLine()) != null) {
				os.println(str);
			}
			in.close();
		} catch (Exception e) {
			throw new ExceptionAccountAccess();
		}
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public int getARGS_LENGTH() {
		return ARGS_LENGTH;
	}

	public void setARGS_LENGTH(int args_length) {
		ARGS_LENGTH = args_length;
	}

	public String getScrtReportFile() {
		return scrtReportFile;
	}

	public void setScrtReportFile(String scrtReportFile) {
		this.scrtReportFile = scrtReportFile;
	}
}
