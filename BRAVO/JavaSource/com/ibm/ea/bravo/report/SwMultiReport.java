package com.ibm.ea.bravo.report;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.poi.util.IOUtils;

import sun.net.ftp.FtpClient;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.properties.DelegateProperties;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;

public class SwMultiReport extends DownloadReport implements IReport {
	private static final Logger logger = Logger.getLogger(SwMultiReport.class);

	private String accountId;

	public SwMultiReport() {

	}

	public SwMultiReport(OutputStream outputStream) {
		this.outputStream = outputStream;
	}

	public void execute(String[] args, HttpServletRequest request)
			throws ExceptionAccountAccess {
		logger.debug("SwMulti - start");

		FtpClient fc = new FtpClient();
		try {
			accountId = args[0];
			Account account = DelegateAccount.getAccount(accountId, request);

			String fileName = "MULTI."
					+ account.getCustomer().getAccountNumber() + ".zip";

			String server = DelegateProperties.getProperty(
					Constants.APP_PROPERTIES, "gsa.ftp.server");
			String user = DelegateProperties.getProperty(
					Constants.APP_PROPERTIES, "gsa.ftp.user");
			String password = DelegateProperties.getProperty(
					Constants.APP_PROPERTIES, "gsa.ftp.password");
			String directory = DelegateProperties.getProperty(
					Constants.APP_PROPERTIES, "gsa.ftp.directory");

			fc.openServer(server);
			fc.login(user, password);
			fc.binary();
			fc.cd(directory);
			InputStream inputStream = fc.get(fileName);
			IOUtils.copy(inputStream, outputStream);

			outputStream.close();
			inputStream.close();

		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (fc != null) {
				try {
					fc.closeServer();
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				}
			}
		}

		logger.debug("SwMulti - end");
	}

}
