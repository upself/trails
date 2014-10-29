package com.ibm.ea.bravo.upload;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.email.DelegateEmail;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.Hardware;
import com.ibm.ea.bravo.hardware.SCRTRecord;
import com.ibm.ea.utils.EaUtils;

public class SCRTReport extends UploadBase implements IBatch {

	private static final Logger logger = Logger.getLogger(SCRTReport.class);

	private String batchName = "SCRT Report Load Batch";

	private String dir = Constants.UPLOAD_DIR;
	
	private String scrtDir = Constants.SCRT_REPORT_DIR;

	private String email;

	private StringBuffer report = new StringBuffer();

	private HttpServletRequest request;

    private Map<String, Account> accounts = new HashMap<String, Account>();

	public SCRTReport() {
	}

	public SCRTReport(String email, String filename, HttpServletRequest request) {
		this.email = email;
		this.filename = filename;
		this.request = request;
	}

	public void execute() throws Exception {
		logger.debug("SCRTReport.execute - begin");
		logger.info("SCRTReport: " + dir + filename);

		report.append("BRAVO SCRTReport Upload: " + new Date() + "\n\n\n");

		// fields to extract from scrt report
		String customerName = null;
		String customerNumber = null;
		String serialNumber = null;
		String machineType = null;
		String model = null;
		String countryCode = null;
		String machineRatedCapacity = null;
		String poNumber = null;
		String reportYear = null;
		String reportMonth = null;
		Map<String, String> lpars = new HashMap<String, String>();
		String cpc = null;

		Iterator<String> it = null;
		String reportSection = null;
		BufferedReader in = new BufferedReader(new FileReader(dir + filename));
		String line = null;
		while ((line = in.readLine()) != null) {
			// get array of csv elements
			String[] s = parseLine(line);
			// set reportSection
			if (s[0].matches("^.* SUB-CAPACITY REPORT .*$")) {
				reportSection = "sub-cap-report";
			} else if (s[0].equals("TOOL INFORMATION")) {
				reportSection = "tool-info";
			} else if (s[0].equals("PRODUCT SUMMARY INFORMATION")) {
				reportSection = "prod-summary-info";
			} else if (s[0].equals("DETAIL LPAR DATA SECTION")) {
				reportSection = "detail-lpar-data-section";
			} else if (s[0].equals("PRODUCT MAX CONTRIBUTORS")) {
				reportSection = "prod-max-contrib";
			} else if (s[0].equals("PRODUCT GRID SNAPSHOT")) {
				reportSection = "prod-grid-snapshot";
			} else if (s[0].equals("DETAIL DATA COLLECTION")) {
				reportSection = "detail-data-collection";
			}
			// extract values
			if (reportSection.equals("sub-cap-report")) {
				// customerName
				if (s[0].equals("Customer Name")) {
					customerName = s[1].toUpperCase();
				}
				// customerNumber, countryCode
				if (s[0].equals("Customer Number")) {
					customerNumber = s[1].substring(3,s[1].length());
					countryCode = s[1].substring(0, 3);
				}
				// serialNumber
				if (s[0].equals("Machine Serial Number")) {
					serialNumber = s[1].toUpperCase();
				}
				// machineType, model
				if (s[0].equals("Machine Type and Model")) {
					machineType = (s[1].split("-"))[0];
					model = (s[1].split("-"))[1];
				}
				// machineRatedCapacity
				if (s[0].equals("Machine Rated Capacity (MSUs)")) {
					machineRatedCapacity = s[1];
				}
				// poNumber
				if (s[0].equals("Purchase Order Number")) {
					poNumber = s[1].toUpperCase();
				}
			} else if (reportSection.equals("tool-info")) {
				// reportYear, reportMonth
				if (s[0].equals("Reporting Period")) {
					reportYear = (s[1].split(" "))[2].replaceAll(",", "").toUpperCase();
					String tmpMonth = (s[1].split(" "))[1].replaceAll(",", "").toUpperCase();
					if (tmpMonth.equals("JAN"))
						reportMonth = "01";
					if (tmpMonth.equals("FEB"))
						reportMonth = "02";
					if (tmpMonth.equals("MAR"))
						reportMonth = "03";
					if (tmpMonth.equals("APR"))
						reportMonth = "04";
					if (tmpMonth.equals("MAY"))
						reportMonth = "05";
					if (tmpMonth.equals("JUN"))
						reportMonth = "06";
					if (tmpMonth.equals("JUL"))
						reportMonth = "07";
					if (tmpMonth.equals("AUG"))
						reportMonth = "08";
					if (tmpMonth.equals("SEP"))
						reportMonth = "09";
					if (tmpMonth.equals("OCT"))
						reportMonth = "10";
					if (tmpMonth.equals("NOV"))
						reportMonth = "11";
					if (tmpMonth.equals("DEC"))
						reportMonth = "12";
				}
			} else if (reportSection.equals("detail-lpar-data-section")) {
				// lpars
				if (!s[0].equals(null) && !s[0].equals("")
						&& !s[0].equals("DETAIL LPAR DATA SECTION")
						&& !s[0].matches("^=.*") && !s[0].equals("CPC")) {
					lpars.put(s[0].toUpperCase(), s[1]);
				}
				// cpc
				if (s[0].equals("CPC")) {
					cpc = s[1];
				}
			}
		}
		in.close();
		
		boolean error = false;

		// report extraction fields
		report.append("----- SCRT Report Extracted Data Elements -----\n");
		if (EaUtils.isBlank(customerName)) {
			String msg = "ERROR: Invalid Customer Name";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Customer Name: " + customerName;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(customerNumber)) {
			String msg = "ERROR: Invalid Customer Number";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Customer Number: " + customerNumber;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(countryCode)) {
			String msg = "ERROR: Invalid Country Code";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Country Code: " + countryCode;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(serialNumber)) {
			String msg = "ERROR: Invalid Serial Number";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Serial Number: " + serialNumber;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(machineType)) {
			String msg = "ERROR: Invalid Machine Type";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Machine Type: " + machineType;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(model)) {
			String msg = "ERROR: Invalid Model";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Model: " + model;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(machineRatedCapacity)) {
			String msg = "ERROR: Invalid Machine Rated Capacity";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Machine Rated Capacity: " + machineRatedCapacity;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(poNumber)) {
			String msg = "ERROR: Invalid PO Number";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "PO Number: " + poNumber;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(reportYear)) {
			String msg = "ERROR: Invalid Report Year";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Report Year: " + reportYear;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(reportMonth)) {
			String msg = "ERROR: Invalid Report Month";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "Report Month: " + reportMonth;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		if (EaUtils.isBlank(cpc)) {
			String msg = "ERROR: Invalid CPC";
			report.append(msg + "\n");
			logger.error(msg);
			error = true;
		} else {
			String msg = "CPC: " + cpc;
			report.append(msg + "\n");
			logger.debug(msg);
		}
		it = lpars.keySet().iterator();
		while (it.hasNext()) {
			String lpar = (String) it.next();
			String msus = (String) lpars.get(lpar);
			if (EaUtils.isBlank(lpar)) {
				String msg = "ERROR: Invalid LPAR";
				report.append(msg + "\n");
				logger.error(msg);
				error = true;
			} else {
				String msg = "LPAR: " + lpar;
				report.append(msg + "\n");
				logger.debug(msg);
			}
			if (EaUtils.isBlank(msus)) {
				String msg = "ERROR: Invalid MSUs";
				report.append(msg + "\n");
				logger.error(msg);
				error = true;
			} else {
				String msg = "MSUs: " + msus;
				report.append(msg + "\n");
				logger.debug(msg);
			}
		}
		report.append("\n\n");
		
		if (error == true) {
			logger.error("errors found in validation, terminating batch");
			return;
		} else {
			logger.debug("all validation checks complete");
		}
		
		// get passed accountId/account
		String accountId = request.getParameter("accountId");
		logger.debug("accountId=" + accountId);
		Account account = getAccount(accountId, request);
		logger.debug("account=" + account.getCustomer());

		// if the account is invalid, save an error
		if (account == null) {
			String msg = "The account you specified in your upload is invalid: " + accountId;
			report.append(msg + "\n");
			logger.error(msg);
			logger.error("terminating batch");
			return;
		}
		logger.debug("validation of account complete");
		
		// validate valid hardware record in bravo
		String sn5Passed = serialNumber.substring((serialNumber.length() - 5),
				serialNumber.length());			
		logger.debug("sn5Passed=" + sn5Passed);
		Hardware hw = DelegateHardware.getHardware(account, machineType, sn5Passed);
		if (hw == null) {
			String msg = "ERROR: SCRT Report hardware with Machine Type: "
				+ machineType + " and Serial Number: " + serialNumber
				+ " not found.";
			report.append(msg + "\n");
			logger.error(msg);
			logger.error("terminating batch");
			return;
		}
		logger.debug("validation of hardware record complete");
		
		// validate valid customer number for hardware
		if (!customerNumber.equals(hw.getCustomerNumber())) {
			String msg = "ERROR: SCRT Report Customer Number: "
				+ customerNumber + " does not match BRAVO record.";
			report.append(msg + "\n");
			logger.error(msg);
			logger.error("terminating batch");
			return;
		}
		logger.debug("validation of customer number complete");
		
		// copy upload file to scrt_upload dir
		String scrtReportFile = countryCode + "_" + customerNumber
				+ "_" + machineType + "-" + model + "_"
				+ serialNumber.substring((serialNumber.length() - 5))
				+ "_" + reportYear + "_" + reportMonth + ".csv";
		if (new File(scrtDir + scrtReportFile).exists()) {
			new File(scrtDir + scrtReportFile).delete();
			logger.debug("deleted previous file: " + scrtDir + scrtReportFile);
		}
		InputStream streamIn = new FileInputStream(dir + filename);
		OutputStream streamOut = new FileOutputStream(scrtDir + scrtReportFile);
		int bytesRead = 0;
		byte[] buffer = new byte[8192];
		logger.debug("copy file: " + dir + filename + " to file: " + scrtDir + scrtReportFile);
		while ((bytesRead = streamIn.read(buffer, 0, 8192)) != -1) {
			streamOut.write(buffer, 0, bytesRead);
		}
		streamOut.close();
		streamIn.close();
		
		// iterate through the list of lpars and save
		report.append("----- SCRT Report Processing -----\n");
		it = lpars.keySet().iterator();
		while (it.hasNext()) {
			String lpar = (String) it.next();
			String msus = (String) lpars.get(lpar);
			logger.debug("starting save/update process for lpar: " + lpar);
			// create pojo
			SCRTRecord scrtRecord = new SCRTRecord();
			scrtRecord.setHardware(hw);
			scrtRecord.setYear(new Integer(reportYear));
			scrtRecord.setMonth(new Integer(reportMonth));
			scrtRecord.setCpc(new Integer(cpc));
			scrtRecord.setLpar(lpar);
			scrtRecord.setMsu(new Integer(msus));
			scrtRecord.setScrtReportFile(scrtReportFile);
			scrtRecord.setRemoteUser(remoteUser);
			logger.debug("creation of scrtRecord pojo complete");
			// attempt to save pojo
			SCRTRecord dbScrtRecord = DelegateHardware.saveSCRTRecord(scrtRecord, request);
			logger.debug("save of scrtRecord complete");
			if (dbScrtRecord == null) {
				String msg = "Save of SCRT Report record for LPAR: " + lpar + " failed!!";
				report.append(msg + "\n");
				logger.error(msg);
				continue;
			}
			String msg = "SCRT Record for LPAR: " + lpar + " successfully stored.";
			report.append(msg + "\n");
			logger.debug(msg);
		}
		
		// ensure no orphaned scrt records from previous uploads
		List<SCRTRecord> scrtRecords = DelegateHardware.getSCRTRecords(hw, reportYear, reportMonth);
		for (int i = 0; i < scrtRecords.size(); i++) {
			SCRTRecord scrtRecord = (SCRTRecord) scrtRecords.get(i);
			boolean found = false;
			it = lpars.keySet().iterator();
			while (it.hasNext()) {
				String lpar = (String) it.next();
				if (lpar.equals(scrtRecord.getLpar())) {
					found = true;
				}
			}
			if (found == false) {
				DelegateHardware.deleteSCRTRecord(hw,
						reportYear, reportMonth, scrtRecord.getLpar());
				logger.debug("scrt report entry not found for lpar: " 
						+ scrtRecord.getLpar()
						+ ", deleted old entry from db.");
			} else {
				logger.debug("scrt repor entry found for lpar: "
						+ scrtRecord.getLpar()
						+ ", ignoring.");
			}
		}

		logger.debug("SCRTReport.execute - end");
	}

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

	public String[] parseLine(String line) {
		String[] s = parseLine(line, new Vector<String>());
		return s;
	}

	// Break an individual line into tokens. This is a recursive function
	// that extracts the first token, then recursively parses the
	// remainder of the line.
	private String[] parseLine(String line, Vector<String> v) {

		String firstToken = null;
		String remainderOfLine = null;
		int commaIndex = locateFirstDelimiter(line);
		if (commaIndex > -1) {
			firstToken = line.substring(0, commaIndex).trim();
			remainderOfLine = line.substring(commaIndex + 1).trim();
		} else {
			// no commas, so the entire line is the token
			firstToken = line;
		}

		// remove redundant quotes
		firstToken = cleanupQuotes(firstToken);

		// store element in vector
		v.add(firstToken);

		// recursively process the remainder of the line
		if (remainderOfLine != null) {
			parseLine(remainderOfLine, v);
		}

		String[] s = new String[v.size()];
		for (int i = 0; i < v.size(); i++) {
			s[i] = (String) v.get(i);
		}
		return s;
	}

	// locate the position of the comma, taking into account that
	// a quoted token may contain ignorable commas.
	private int locateFirstDelimiter(String curLine) {
		if (curLine.startsWith("\"")) {
			boolean inQuote = true;
			int numChars = curLine.length();
			for (int i = 1; i < numChars; i++) {
				char curChar = curLine.charAt(i);
				if (curChar == '"') {
					inQuote = !inQuote;
				} else if (curChar == ',' && !inQuote) {
					return i;
				}
			}
			return -1;
		} else {
			return curLine.indexOf(',');
		}
	}

	// remove quotes around a token, as well as pairs of quotes
	// within a token.
	private String cleanupQuotes(String token) {
		StringBuffer buf = new StringBuffer();
		int length = token.length();
		int curIndex = 0;

		if (token.startsWith("\"") && token.endsWith("\"")) {
			curIndex = 1;
			length--;
		}

		boolean oneQuoteFound = false;
		boolean twoQuotesFound = false;

		while (curIndex < length) {
			char curChar = token.charAt(curIndex);
			if (curChar == '"') {
				twoQuotesFound = (oneQuoteFound) ? true : false;
				oneQuoteFound = true;
			} else {
				oneQuoteFound = false;
				twoQuotesFound = false;
			}

			if (twoQuotesFound) {
				twoQuotesFound = false;
				oneQuoteFound = false;
				curIndex++;
				continue;
			}

			buf.append(curChar);
			curIndex++;
		}

		return buf.toString();
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
		DelegateEmail.sendMessage("BRAVO SCRT Report Upload",
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
