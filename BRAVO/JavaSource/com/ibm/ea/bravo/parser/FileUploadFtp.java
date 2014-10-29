/*
 * Created on May 27, 2004
 */
package com.ibm.ea.bravo.parser;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.Serializable;
import java.util.Date;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.batch.BatchBase;
import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.FTPUtil;
import com.ibm.ea.bravo.framework.email.DelegateEmail;

/**
 * @author newtont
 */
public class FileUploadFtp extends BatchBase implements IBatch, Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(FileUploadFtp.class);

	private String batchName = "FileUploadFtp";

	private String remoteUser = null;

	private String uploadDir;

	private String uploadFileShort;

	private String uploadFile;

	private String csvFile;

	private String csvFileShort;

	private String errorFile;

	private String errorFileShort;

	private Date startTime;

	private String errorDir;
	
	private String scanType;
	
	private boolean fileSent;
	
    private static Properties properties = new Properties();

	public FileUploadFtp(String remoteUser, String uploadDir,
			String uploadFileShort, String errorDir, String scanType) {
		this.remoteUser = remoteUser;
		this.uploadDir = uploadDir;
		this.uploadFileShort = uploadFileShort;
		this.errorDir = errorDir;

		// calc file names
//		this.uploadFile = uploadDir + "/" + uploadFileShort;
		this.uploadFile = uploadFileShort;
		logger.debug("uploadFile=" + this.uploadFile);
		this.csvFileShort = uploadFileShort + ".csv";
		logger.debug("csvFileShort=" + this.csvFileShort);
		this.csvFile = Constants.UPLOAD_DIR + "/" + this.csvFileShort;
		logger.debug("csvFile=" + this.csvFile);
		this.errorFileShort = uploadFileShort + ".error";
		logger.debug("errorFileShort=" + this.errorFile);
		this.errorFile = Constants.UPLOAD_DIR + "/" + this.errorFileShort;
		logger.debug("errorFile=" + this.errorFile);
		this.fileSent = false;
		this.scanType = scanType;
		try {
			properties.load(new FileInputStream(Constants.APP_PROPERTIES));
		} catch (Exception e) {
			logger.error("CANNOT get ftp host from setting to default " + Constants.APP_PROPERTIES, e);
			e.printStackTrace();
			properties.setProperty("ftpHost", "tap.raleigh.ibm.com");
		}
	}

	public boolean validate() throws Exception {
		return false;
	}

	public void execute() throws Exception {

		logger.info("starting file upload batch: " + this.uploadFile);

		// Set up File name for ftp job
		String jclfilename = Constants.UPLOAD_DIR + "/"
				+ this.getUploadFileShort();

		// boolean flag
		boolean success = false;

		// ftp csvFile
		int ftpAttempts = 0;
		String ftpHost = properties.getProperty("ftpHost");
		while (ftpAttempts < Constants.MAX_FTP_ATTEMPTS) {

			if (ftpAttempts > 0) {
				logger.error("sleeping "
						+ (Constants.FTP_RETRY_WAIT_SECS / 6000) + " seconds");
				Thread.sleep(Constants.FTP_RETRY_WAIT_SECS / 6);
			}

			ftpAttempts++;
			logger.info("Sending File");
			success = false;
			if ( this.scanType.equals("softaudit") ) {
			
			success = FTPUtil.ftpFileAsci(ftpHost,
					Constants.FTP_ID_ANONYMOUS, this.remoteUser, this.uploadDir,
					this.uploadFile, Constants.FTP_DIR_TLCMZ);
			}
			if ( this.scanType.equals("dorana") ) {
				success = FTPUtil.ftpFileAsci(Constants.FTP_HOST,
						Constants.FTP_ID_ANONYMOUS, this.remoteUser, this.uploadDir,
						this.uploadFile, Constants.FTP_DIR_DORANA);				
			}
			if (!success) {
				logger.error("ftp attempt " + ftpAttempts + " failed of JCL: "
						+ jclfilename);
			} else {
				logger.info("ftp complete for JCL " + jclfilename);
				this.fileSent = true;
				break;
			}
		}

		logger.info("completed file upload batch: " + this.uploadFile);
	}

	public void sendNotify() {
		StringBuffer message = new StringBuffer();
		message.append(this.getUploadFileShort() + " has been received by the ftp cue.");
		if (this.fileSent) {
			message.append("The ftp cue system reports that it was placed in the processing cue and will be processed by the system shortly. ");
		} else {
			message.append("The ftp cue system could not send this file to the processing cue. Please report this to support via the ticket system. ");
			message.append("The file will NOT be processed until this is resolved. Do not submit another file. Report this error.");
		}
		logger.debug("\n" + message);
		String emailType = this.getUploadFileShort() + "received into ftp cue";
		DelegateEmail.sendMessage(emailType, remoteUser, message);
		// logMsg();
	}

	public void sendNotifyException(Exception e) {

		logger.error("caught exception: " + e.toString());

		// ftp error file to atp
		boolean success = false;
		int ftpAttempts = 0;

		try {
			// create empty error file for ftp to tap
			BufferedWriter out = new BufferedWriter(new FileWriter(
					this.errorFile));
			logger.debug("created bufferedwriter object for errorFile");
			out.write("caught exception: " + e.toString());
			out.newLine();
			out.close();

			// attempt ftp, may be useless if ftp failure was reason we got here
			while (ftpAttempts < Constants.MAX_FTP_ATTEMPTS) {

				if (ftpAttempts > 0) {
					logger.error("sleeping "
							+ (Constants.FTP_RETRY_WAIT_SECS / 1000)
							+ " seconds");
					Thread.sleep(Constants.FTP_RETRY_WAIT_SECS);
				}

				ftpAttempts++;

				success = FTPUtil.ftpFileAsci(Constants.FTP_HOST,
						Constants.FTP_ID, Constants.FTP_PW,
						Constants.UPLOAD_DIR, this.errorFileShort,
						Constants.FTP_DIR_TLCMZ);
				if (!success) {
					logger.error("ftp attempt " + ftpAttempts
							+ " failed of csvFile: " + this.errorFile);
				} else {
					logger.debug("ftp complete for csvFile " + this.errorFile);
					break;
				}
			}

			// delete files
			this.deleteAllFiles();

		} catch (Exception e2) {
			e2.printStackTrace();
		}
	}

	private void deleteAllFiles() {

		// uploadFile
		if (new File(this.uploadFile).exists()) {
			if (new File(uploadFile).delete()) {
				logger.debug("deleted uploadFile: " + uploadFile);
			} else {
				logger.error("could not delete upload file: " + uploadFile);
			}
		}

		// csvFile
		if (new File(this.csvFile).exists()) {
			if (new File(this.csvFile).delete()) {
				logger.debug("deleted csvFile: " + this.csvFile);
			} else {
				logger.error("could not delete csvFile: " + this.csvFile);
			}
		}

		// errorFile
		if (new File(this.errorFile).exists()) {
			if (new File(this.errorFile).delete()) {
				logger.debug("deleted errorFile: " + this.errorFile);
			} else {
				logger.error("could not delete errorFile: " + this.errorFile);
			}
		}
	}

	public String getName() {
		return "File Upload";
	}

	/**
	 * @return Returns the batchName.
	 */
	public String getBatchName() {
		return batchName;
	}

	/**
	 * @param batchName
	 *            The batchName to set.
	 */
	public void setBatchName(String batchName) {
		this.batchName = batchName;
	}

	/**
	 * @return Returns the errorDir.
	 */
	public String getErrorDir() {
		return errorDir;
	}

	/**
	 * @param errorDir
	 *            The errorDir to set.
	 */
	public void setErrorDir(String errorDir) {
		this.errorDir = errorDir;
	}

	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @param remoteUser
	 *            The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/**
	 * @return Returns the startTime.
	 */
	public Date getStartTime() {
		return startTime;
	}

	/**
	 * @param startTime
	 *            The startTime to set.
	 */
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	/**
	 * @return Returns the uploadDir.
	 */
	public String getUploadDir() {
		return uploadDir;
	}

	/**
	 * @param uploadDir
	 *            The uploadDir to set.
	 */
	public void setUploadDir(String uploadDir) {
		this.uploadDir = uploadDir;
	}

	/**
	 * @return Returns the uploadFile.
	 */
	public String getUploadFile() {
		return uploadFile;
	}

	/**
	 * @param uploadFile
	 *            The uploadFile to set.
	 */
	public void setUploadFile(String uploadFile) {
		this.uploadFile = uploadFile;
	}

	/**
	 * @return Returns the uploadFileShort.
	 */
	public String getUploadFileShort() {
		return uploadFileShort;
	}

	/**
	 * @param uploadFileShort
	 *            The uploadFileShort to set.
	 */
	public void setUploadFileShort(String uploadFileShort) {
		this.uploadFileShort = uploadFileShort;
	}
}