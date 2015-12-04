package com.ibm.ea.bravo.upload;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.discrepancy.DelegateDiscrepancy;
import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.SFTPUtil;
import com.ibm.ea.bravo.framework.email.DelegateEmail;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.framework.properties.DelegateProperties;
import com.ibm.ea.sigbank.Software;
import com.ibm.ea.utils.EaUtils;
import com.ibm.ea.utils.PoiUtils;

public class SoftwareDiscrepancy extends UploadBase implements IBatch {

	private static final Logger logger = Logger
			.getLogger(SoftwareDiscrepancy.class);

	private String batchName = "Software Discrepancy Load Batch";

	private String dir = Constants.UPLOAD_DIR;

	private int uploadFields = 6;

	private String email;

	private StringBuffer report = new StringBuffer();

	private HttpServletRequest request;

	// setup some caching
    private Map<String, Software> softwares = new HashMap<String, Software>();

    private Map<String, Account> accounts = new HashMap<String, Account>();

	public SoftwareDiscrepancy() {
	}

	public SoftwareDiscrepancy(String email, String filename,
			HttpServletRequest request) {
		this.email = email;
		this.filename = filename;
		this.request = request;
	}

	public void execute() throws Exception {

		logger.debug("SoftwareDiscrepancy.execute - begin");
		logger.info("SoftwareDiscrepancy: " + dir + filename);

		report.append("BRAVO Missing Software Discrepancy Upload: "
				+ new Date() + "\n\n\n");

		// get the excel data from the loader file
		List<String[]> excel = PoiUtils.getExcelData(dir + filename, uploadFields);

		// make sure we've got data
		if (excel == null) {
			logger.error("Error with Excel file: " + dir + filename);
			report.append("Error with Excel file: " + dir + filename + "\n");
			return;
		}

		logger.debug("got list of rows from excel file");

		// get the MISSING discrepancy type
		DiscrepancyType missingDiscrepancyType = DelegateDiscrepancy
				.getDiscrepancyType(DelegateDiscrepancy.MISSING);
		logger.debug("got missingDiscrepancyType=" + missingDiscrepancyType);

		// setup csv file for xfer to back end loader
		String loaderFile = this.filename + ".csv";
		logger.debug("loaderFile=" + loaderFile);
		BufferedWriter out = new BufferedWriter(
				new FileWriter(dir + loaderFile));
		logger.debug("created bufferedwriter object for loaderFile");

		int row = 1;
		int completed = 0;
		report.append("row " + row + " header:" + "\n");

		// iterate through the list of data
		Iterator<String[]> i = excel.iterator();
		while (i.hasNext()) {
			// increase the row count
			row++;

			logger.debug("processing excel data row: " + row);

			// setup some variables for convenience
			String[] data = (String[]) i.next();
			String accountId = data[0];
			String softwareLparName = data[1].toUpperCase().trim();
			String processorCount = data[2];
			String softwareName = data[3].trim();
			String version = data[4].toUpperCase().trim();
			String users = data[5];

			// validate accountId
			logger.debug("accountId=" + accountId);
			Account account = getAccount(accountId, request);
			if (account == null) {
				logger.error("row " + row + " invalid account: " + accountId);
				report.append("row " + row + " invalid account: " + accountId
						+ "\n");

				// skip to the next line
				continue;
			}

			// validate softwareLparName
			logger.debug("softwareLparName=" + softwareLparName);
			if (EaUtils.isBlank(softwareLparName)) {
				logger.error("row " + row + " invalid software lpar: "
						+ softwareLparName);
				report.append("row " + row + " invalid software lpar: "
						+ softwareLparName + "\n");

				// skip to the next line
				continue;
			}

			// validate processorCount
			logger.debug("processorCount=" + processorCount);
			if (!EaUtils.isPositiveInteger(processorCount)) {
				logger.error("row " + row + " invalid processor count: "
						+ processorCount);
				report.append("row " + row + " invalid processor count: "
						+ processorCount + "\n");

				// skip to the next line
				continue;
			}

			// validate softwareName
			logger.debug("softwareName=" + softwareName);
			Software software = getSoftware(softwareName);
			if (software == null) {
				logger.error("row " + row + " invalid software: "
						+ softwareName);
				report.append("row " + row + " invalid software: "
						+ softwareName + "\n");

				// skip to the next line
				continue;
			}

			// validate version
			logger.debug("version=" + version);
			if (version.length() > 8) {
				logger.error("row " + row + " invalid version (>8 chars): "
						+ version);
				report.append("row " + row + " invalid version (>8 chars): "
						+ version + "\n");

				// skip to the next line
				continue;
			}

			// validate users if specified, can be blank, not a required field
			logger.debug("users=" + users);
			users = EaUtils.isBlank(users) ? "0" : users;
			logger.debug("updated users=" + users);
			if (!EaUtils.isPositiveInteger(users) && !users.equals("0")) {
				logger.error("row " + row + " invalid users count: " + users);
				report.append("row " + row + " invalid users count: " + users
						+ "\n");

				// skip to the next line
				continue;
			}

			logger.info("row " + row + " was successful: " + softwareName);
			report.append("row " + row + " was successful: " + softwareName
					+ "\n");

			// write row to csv to xfer to back end loader.
			out.write("\"" + accountId + "\",");
			out.write("\"" + softwareLparName + "\",");
			out.write("\"" + processorCount + "\",");
			out.write("\"" + softwareName + "\",");
			out.write("\"" + version + "\",");
			out.write("\"" + users + "\",");
			out.write("\"" + software.getSoftwareId() + "\"");
			out.newLine();
			completed++;
		}

		// print footnote to user in email
		report.append("\n\nNOTE: These changes have been submitted"
				+ " to the BRAVO back-end loaders for processing,"
				+ " the changes may not be immediately seen in the"
				+ " BRAVO web application.");

		// close loaderFile handle
		out.close();
		
		// make sure we've got data that we have generated
		if (completed == 0) {
			logger.error("Error internally with Excel file: " + dir + filename);
			report.append("Error internally with Excel file: " + dir + filename + "\n");
			if (new File(dir + loaderFile).delete()) {
				logger.debug("deleted loaderFile: " + loaderFile);
			} else {
				logger.error("could not delete loaderFile: " + loaderFile);
			}
			return;
		}

		// boolean flag
		boolean success = false;

		// ftp loaderFile
		int ftpAttempts = 0;
		String FTP_HOST = DelegateProperties.getProperty(Constants.APP_PROPERTIES, "ftpHost");
		String FTP_USER = DelegateProperties.getProperty(Constants.APP_PROPERTIES, "ftpUser");
		String FTP_PASSWORD = DelegateProperties.getProperty(Constants.APP_PROPERTIES, "ftpPassword");
		
		if(FTP_HOST == null || FTP_HOST.equals("") 
			|| FTP_USER == null || FTP_USER.equals("")
			|| FTP_PASSWORD == null || FTP_PASSWORD.equals(""))
		{
			logger.error("login info is not filled, please check host, user and password for ftp");
			return;
		}
		
		while (ftpAttempts < Constants.MAX_FTP_ATTEMPTS) {

			if (ftpAttempts > 0) {
				logger.error("sleeping "
						+ (Constants.FTP_RETRY_WAIT_SECS / 1000) + " seconds");
				Thread.sleep(Constants.FTP_RETRY_WAIT_SECS);
			}

			ftpAttempts++;

			success = SFTPUtil.sftpFileAsci(FTP_HOST,
					FTP_USER,FTP_PASSWORD, this.dir,
					loaderFile, Constants.FTP_DIR_MANUAL);

			if (!success) {
				logger.error("ftp attempt " + ftpAttempts
						+ " failed of loaderFile: " + loaderFile);
			} else {
				logger.debug("ftp complete for loaderFile " + loaderFile);
				break;
			}
		}

		// clean up local loaderFile
		if (new File(dir + loaderFile).delete()) {
			logger.debug("deleted loaderFile: " + loaderFile);
		} else {
			logger.error("could not delete loaderFile: " + loaderFile);
		}

		logger.debug("SoftwareDiscrepancy.execute - end");
	}
	
	private Software getSoftware(String softwareName) {
		Software software = null;
		// check the cache first
		software = (Software) softwares.get(softwareName);
		
		// if not in the cache, try the database
		if (software == null) {
			software = DelegateSoftware.getSoftware(softwareName);

			// if the account was in the database, save it in the cache
			if (software != null)
				softwares.put(softwareName, software);
		}
		return software;
	}
	//Change Bravo to use Software View instead of Product Object End
	
	private Account getAccount(String accountId, HttpServletRequest request)
			throws ExceptionAccountAccess {
		Account account = null;

		// check the cache first
		account = (Account) accounts.get(accountId);

		// if not in the cache, try the database
		if (account == null) {
			account = DelegateAccount.getAccount(accountId, request);

			// if the account was in the database, save it in the cache
			if (account != null)
				accounts.put(accountId, account);
		}

		return account;
	}

	public boolean validate() throws Exception {

		if (EaUtils.isBlank(dir))
			return false;

		if (EaUtils.isBlank(filename))
			return false;

		return true;
	}

	public String getDir() {
		return dir;
	}

	public void sendNotify() {
		logger.debug("\n" + report);
		DelegateEmail.sendMessage("BRAVO Missing Software Discrepancy Upload",
				email, report);
	}

	public void sendNotifyException(Exception e) {
		logger.error(e, e);
		logger.error("\n" + report);
	}

	public String getName() {
		return batchName;
	}
}