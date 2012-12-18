/*
 * Created on May 7, 2006
 */
package com.ibm.ea.bravo.framework.common;

import java.io.FileInputStream;
import java.io.IOException;
import java.net.SocketException;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Logger;

/**
 * @author lamm
 */
public abstract class FTPUtil {

	private static final Logger logger = Logger.getLogger(FTPUtil.class);

	public static boolean ftpFileAsci(String host, String id, String pw,
			String sourceDir, String sourceFile, String targetDir) {

		boolean success = false;
		success = FTPUtil.ftpFile(host, id, pw, sourceDir, sourceFile,
				targetDir, FTP.ASCII_FILE_TYPE);
		return success;
	}

	public static boolean ftpFile(String host, String id, String pw,
			String sourceDir, String sourceFile, String targetDir,
			int ftpFileType) {

		boolean success = false;

		logger.debug("host=" + host);
		logger.debug("id=" + id);
		logger.debug("sourceDir=" + sourceDir);
		logger.debug("sourceFile=" + sourceFile);
		logger.debug("targetDir=" + targetDir);
		logger.debug("ftpFileType=" + ftpFileType);

		FTPClient ftp = new FTPClient();
		try {
			// attempt connection
			ftp.connect(host);
			logger.debug("connected to ftp host: " + host);
			logger.debug("reply string=" + ftp.getReplyString());
			// check reply code
			int reply = ftp.getReplyCode();
			logger.debug("reply code=" + reply);
			if (!FTPReply.isPositiveCompletion(reply)) {
				logger.error("ftp server refused connection, reply=" + reply);
				ftp.disconnect();
				success = false;
			} else {
				// attempt login
				boolean login = ftp.login(id, pw);
				logger.debug("login reply string=" + ftp.getReplyString());
				logger.debug("login reply code=" + ftp.getReplyCode());
				if (!login) {
					logger.error("ftp failed login");
					ftp.disconnect();
					success = false;
				} else {
					// set transfer type
					ftp.setFileType(ftpFileType);
					logger.debug("set file type reply string="
							+ ftp.getReplyString());
					// set local to passive mode
					ftp.enterLocalPassiveMode();
					// change to targetDir
					ftp.changeWorkingDirectory(targetDir);
					logger.debug("change working dir reply string="
							+ ftp.getReplyString());
					String pwd = ftp.printWorkingDirectory();
					logger.debug("pwd=" + pwd);
					// transfer file
					FileInputStream in = new FileInputStream(sourceDir + "/"
							+ sourceFile);
					if ( in == null ) {
						logger.error("Cannot open input file");
					}
					boolean storeFile = ftp.storeFile(sourceFile, in);
					logger.debug("store file reply string="
							+ ftp.getReplyString());
					if (!storeFile) {
						logger.error("ftp put failed");
						in.close();
						ftp.logout();
						ftp.disconnect();
						success = false;
					} else {
						logger.debug("ftp put successful");
						in.close();
						ftp.logout();
						ftp.disconnect();
						success = true;
					}
				}
			}
		} catch (SocketException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return success;
	}

	public static boolean ftpJob(String host, String id, String pw,
			String sourceDir, String sourceFile, String targetDir) {

		boolean success = false;

		logger.debug("host=" + host);
		logger.debug("id=" + id);
		logger.debug("pw=" + pw);
		logger.debug("targetDir=" + targetDir);
		logger.debug("sourceDir=" + sourceDir);
		logger.debug("sourceFile=" + sourceFile);
		/* quote site filetype=jes */
		FTPClient ftp = new FTPClient();
		try {
			// attempt connection
			ftp.connect(host);
			logger.debug("connected to ftp host: " + host);
			logger.debug("reply string=" + ftp.getReplyString());
			// check reply code
			int reply = ftp.getReplyCode();
			if (!FTPReply.isPositiveCompletion(reply)) {
				logger.error("ftp server refused connection, reply=" + reply);
				ftp.disconnect();
				success = false;
			} else {
				// attempt login
				if (!ftp.login(id, pw)) {
					logger.error("ftp failed login");
					ftp.disconnect();
					success = false;
				} else {
					// set transfer type
					ftp.setFileType(FTP.ASCII_FILE_TYPE);
					// set to passive mode
					ftp.enterLocalPassiveMode();
					// change to targetDir
					ftp.changeWorkingDirectory(targetDir);
					logger.debug("change working dir reply string="
							+ ftp.getReplyString());
					String pwd = ftp.printWorkingDirectory();
					logger.debug("pwd=" + pwd);
					// Set site data for automatic job sumbission
					ftp.sendSiteCommand("quote site filetype=jes");
					// transfer file
					FileInputStream in = new FileInputStream(sourceDir + "/"
							+ sourceFile);
					if (!ftp.storeFile(targetDir + "/" + sourceFile, in)) {
						logger.error("ftp put failed");
						in.close();
						ftp.logout();
						ftp.disconnect();
						success = false;
					} else {
						logger.debug("ftp put successful");
						in.close();
						ftp.logout();
						ftp.disconnect();
						success = true;
					}
				}
			}
		} catch (SocketException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return success;
	}
}
