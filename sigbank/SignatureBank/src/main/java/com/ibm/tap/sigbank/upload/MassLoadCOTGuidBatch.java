/*
 * Created on Mar 27, 2014
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.sigbank.upload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts.util.MessageResources;

import sun.net.TelnetOutputStream;
import org.apache.commons.net.ftp.FTPClient;
//import sun.net.ftp.FtpClient;

import com.ibm.tap.sigbank.software.CotGuidLoadDelegate;
import com.ibm.tap.sigbank.framework.batch.BatchBase;
import com.ibm.tap.sigbank.framework.batch.IBatch;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.email.EmailDelegate;

/**
 * @author newtont
 * 
 *         To change the template for this generated type comment go to
 *         Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class MassLoadCOTGuidBatch extends BatchBase implements IBatch,
		Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(MassLoadFilterBatch.class);

	private String remoteUser = null;

	private String fileName;

	private HttpServletRequest request;

	public static Properties properties = new Properties();

	public MassLoadCOTGuidBatch(String remoteUser, String fileName,
			MessageResources resources, String errorDir,
			HttpServletRequest request) {

		this.remoteUser = remoteUser;
		this.fileName = fileName;
		this.request = request;

		logger.debug("Loading the initialization for ActionAdministrationLoader");

		try {
			properties.load(new FileInputStream(Constants.APP_PROPERTIES));

		} catch (Exception e) {
			logger.error(e, e);
		}
	}

	public boolean validate() throws Exception {
		return false;
	}

	public void execute() {

		StringBuffer message = new StringBuffer();
		FileOutputStream fop = null;
		File file;

		logger.debug("starting batch loader for OCT load");

		String str;
		int i = 1;

		try {
			InputStreamReader fileReader = new InputStreamReader(
					new FileInputStream(fileName), "ISO-8859-1");

			BufferedReader in = new BufferedReader(fileReader);

			// String filepath =
			// request.getSession().getServletContext().getRealPath("")+"/reports/COTProductReport.tsv";
			// System.out.printf(filepath);
			 String filepath =
			 "/var/sigbank/tomcat/webapps/SignatureBank/reports/COTProductReport.tsv";
			//String filepath = "/var/sigbank/work/COTProductReport.tsv";
			file = new File(filepath);
			fop = new FileOutputStream(file);
			String encoding = "UTF8";
			OutputStreamWriter osw = new OutputStreamWriter(fop, encoding);
			BufferedWriter bw = new BufferedWriter(osw);
			//FtpClient fc = new FtpClient();
			FTPClient fc = new FTPClient();
			
			// if file doesnt exists, then create it
			if (!file.exists()) {
				file.createNewFile();
			}

			try {
				SimpleDateFormat lsdfNow = new SimpleDateFormat(
						"MM-dd-yyyy HH:mm:ss");
				bw.write("Component_Only_Table - Product Report");
				bw.newLine();
				bw.write("Report Time: "
						+ lsdfNow.format(Calendar.getInstance().getTime())
								.toString());
				bw.newLine();
				bw.write("IBM Confidential");
				bw.newLine();
				bw.newLine();
				bw.write("GUID");
				bw.write("\t");
				bw.write("SOFTWARE NAME");
				bw.write("\t");
				bw.write("MANUFACTURER");
				bw.write("\t");
				bw.write("PRODUCT ROLE");
				bw.write("\t");
				bw.write("STATUS");
				bw.newLine();
			} catch (Exception e) {
				e.printStackTrace();
			}

			while ((str = in.readLine()) != null) {

				String msgs;

				msgs = CotGuidLoadDelegate.massLoadCotGuid(str, bw, remoteUser,
						i);

				message.append(msgs);
				boolean containerContainsContent = StringUtils
						.containsIgnoreCase(msgs, "Exist");
				if (!containerContainsContent) {
					bw.newLine();
				}
				i++;
			}
			in.close();
			bw.flush();
			bw.close();
			fop.flush();
			fop.close();
			try {
				String outfile = "a.tsv";
				String server = properties.getProperty("ftp.server");
				String user = properties.getProperty("ftp.user");
				String password = properties.getProperty("ftp.password");
				String directory = properties.getProperty("ftp.directory");
				//fc.openServer(server);
				//fc.login(user, password);
				//fc.binary();
				//fc.cd(directory);
				fc.connect(server);
				fc.login(user, password);
				fc.cwd(directory);
				
				FileInputStream inputStream = new FileInputStream(filepath);
				OutputStream outputStream = fc.storeFileStream(outfile);//fc.put(outfile);

				byte c[] = new byte[4096];
				int read = 0;
				while ((read = inputStream.read(c)) != -1) {
					outputStream.write(c, 0, read);
				}
				outputStream.close();
				inputStream.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (fc != null) {
					try {
						//fc.closeServer();
						fc.disconnect();
					} catch (IOException e) {
						logger.error(e.getMessage(), e);
					}
				}
			}
			EmailDelegate.sendMessage("Upload Complete", remoteUser, message);
			boolean success = (new File(fileName)).delete();
			if (!success) {
				logger.error("could not delete " + fileName);
			}
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * @param workC
	 * @param workCN
	 * @return
	 */

	public void sendNotify() {
		// logMsg();
	}

	public void sendNotifyException(Exception e) {
		// logMsg(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getName()
	 */
	public String getName() {
		return "Customer Number Load";
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getRemoteUser()
	 */
	public String getRemoteUser() {
		return remoteUser;

	}

	public void printMessage(String message, StringBuffer out, int row) {
		out.append("STATUS [" + row + "]: " + message);
	}

	public void printError(String message, StringBuffer out, int row) {
		out.append("ERROR [" + row + "]: " + message);
	}
}