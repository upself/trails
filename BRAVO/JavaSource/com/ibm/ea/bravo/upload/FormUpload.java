/**
 * @author dbryson@us.ibm.com Created on Apr 29, 2004 To change the template for
 *         this generated file go to Window&gt;Preferences&gt;Java&gt;Code
 *         Generation&gt;Code and Comments
 */

package com.ibm.ea.bravo.upload;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.upload.FormFile;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class FormUpload extends ActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(FormUpload.class);

	private FormFile file;

	private String load;

	private String uploadType;

	private String parsePreview;

	private String hardwareSoftwareId;

	private String accountId;

	/*
	 * we are going to be passed the id for the hardware so we will need to
	 * extract all the other inforrmation based on the hardware id
	 */

	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();

		logger.debug("accountId = " + accountId);
		logger.debug("hardwareSoftwareId = " + hardwareSoftwareId);

		// get the account and set it in the request
		Account account = null;
		try {
			account = DelegateAccount.getAccount(accountId, request);
		} catch (ExceptionAccountAccess e) {
			errors.add(Constants.ERROR, new ActionMessage(
					Constants.ACCOUNT_ACCESS));
		}
		request.setAttribute(Constants.ACCOUNT, account);

		// validate the account
		if (account == null) {
			errors.add(Constants.ERROR, new ActionMessage(
					Constants.ACCOUNT_INVALID));
		}

		// validate the file
		if (file == null || EaUtils.isBlank(file.getFileName())) {
			errors.add(Constants.ERROR, new ActionMessage(
					Constants.FILE_NAME_REQUIRED));
		}

		// validate the upload type
		if (EaUtils.isBlank(uploadType)
				|| (!uploadType.equalsIgnoreCase(Constants.TIVOLI)
						&& !uploadType
								.equalsIgnoreCase(Constants.SOFTWARE_DISCREPANCY) && !uploadType
						.equalsIgnoreCase(Constants.SCRT_REPORT)&& !uploadType
						.equalsIgnoreCase(Constants.AUTHORIZED_ASSETS))) {

			errors.add(Constants.ERROR, new ActionMessage(
					Constants.UNKNOWN_ERROR));
		}

		// validate the hardwaresoftwareId
		if (EaUtils.isBlank(hardwareSoftwareId)) {
			errors.add(Constants.ERROR, new ActionMessage(
					Constants.HARDWARE_INVALID));
		}

		return errors;
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	/**
	 * @return Returns the file.
	 */
	public FormFile getFile() {
		return file;
	}

	/**
	 * @param file
	 *            The file to set.
	 */
	public void setFile(FormFile file) {
		this.file = file;
	}

	/**
	 * @return Returns the load.
	 */
	public String getLoad() {
		return load;
	}

	/**
	 * @param load
	 *            The load to set.
	 */
	public void setLoad(String load) {
		this.load = load;
	}

	/**
	 * @return Returns the parsePreview.
	 */
	public String getParsePreview() {
		if (parsePreview != null) {
			// true returns "on"
			return parsePreview;
		} else {
			return "off";
		}
	}

	/**
	 * @param parsePreview
	 *            The parsePreview to set.
	 */
	public void setParsePreview(String parsePreview) {
		this.parsePreview = parsePreview;
	}

	/**
	 * @return Returns the uploadType.
	 */
	public String getUploadType() {
		return uploadType;
	}

	/**
	 * @param uploadType
	 *            The uploadType to set.
	 */
	public void setUploadType(String scanType) {
		this.uploadType = scanType;
	}

	/**
	 * @return Returns the hardwareSoftwareId.
	 */
	public String getHardwareSoftwareId() {
		return hardwareSoftwareId;
	}

	/**
	 * @param hardwareSoftwareId
	 *            The hardwareSoftwareId to set.
	 */
	public void setHardwareSoftwareId(String hardwareSoftwareId) {
		this.hardwareSoftwareId = hardwareSoftwareId;
	}
}