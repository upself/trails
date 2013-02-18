/*
 * Created on May 27, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.sigbank.upload;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Serializable;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.validator.Validator;
import org.apache.commons.validator.ValidatorResources;
import org.apache.log4j.Logger;
import org.apache.struts.util.MessageResources;

import com.ibm.tap.sigbank.filter.SoftwareFilterDelegate;
import com.ibm.tap.sigbank.framework.batch.BatchBase;
import com.ibm.tap.sigbank.framework.batch.IBatch;
import com.ibm.tap.sigbank.framework.email.EmailDelegate;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class MassLoadFilterBatch extends BatchBase implements IBatch,
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

	public MassLoadFilterBatch(String remoteUser, String fileName,
			MessageResources resources, String errorDir,
			HttpServletRequest request) {

		this.remoteUser = remoteUser;
		this.fileName = fileName;
		this.request = request;
	}

	public boolean validate() throws Exception {
		return false;
	}

	public void execute() {

		StringBuffer message = new StringBuffer();

		logger.debug("starting batch loader for filter load");

		String str;
		int i = 1;

		try {
			InputStreamReader fileReader = new InputStreamReader(
					new FileInputStream(fileName), "ISO-8859-1");

			BufferedReader in = new BufferedReader(fileReader);
			// Test section. Lets try and use the commons validator using our
			// same struts rules
			// Step 1, need the validation resources (rules)
			InputStream inStream = this.getClass().getClassLoader()
					.getResourceAsStream("validator.xml");
			InputStream rulesStream = this.getClass().getClassLoader()
					.getResourceAsStream("validator-rules.xml");

			// Create the validator resource
			InputStream[] valStreamArray = { rulesStream, inStream };

			ValidatorResources valRes = new ValidatorResources(valStreamArray);
			Validator val = new Validator(valRes, "/SoftwareFilterSave");
			val.setOnlyReturnErrors(false);
			val.setParameter("javax.servlet.http.HttpServletRequest", request);

			while ((str = in.readLine()) != null) {

				String msgs;

				msgs = SoftwareFilterDelegate.massLoadFilters(str, val, valRes,
						remoteUser, i);

				message.append(msgs);

				i++;
			}
			in.close();

			EmailDelegate.sendMessage("Upload Complete", remoteUser, message);

			System.out.println("done with load");

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