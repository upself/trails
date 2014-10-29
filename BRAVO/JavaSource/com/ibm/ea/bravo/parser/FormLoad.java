/**
 * @author dbryson@us.ibm.com
 * Created on Apr 29, 2004
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

package com.ibm.ea.bravo.parser;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.upload.FormFile;

import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.parser.SwScan;


public class FormLoad extends ActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private FormFile file;
	private String load;
	private String scanType;
	private String parsePreview;
	private String submitInternal;
	private String hardwareSoftwareId;
	private String accountId;
	private String fileName;
	private String cpuName;
	private String lparName;
	private String[] selected;
	private SwScan scan;
	/**
	 * @return Returns the submitInternal.
	 */
	public String getSubmitInternal() {
		if ( submitInternal != null ) {
			// true returns "on"
			return submitInternal;
		} else {
			return "off";
		}
	}
	/**
	 * @param submitInternal The submitInternal to set.
	 */
	public void setSubmitInternal(String submitInternal) {
		this.submitInternal = submitInternal;
	}
	/**
	 * @return Returns the cpuName.
	 */
	public String getCpuName() {
		return cpuName;
	}
	/**
	 * @param cpuName The cpuName to set.
	 */
	public void setCpuName(String cpuName) {
		this.cpuName = cpuName;
	}
	/**
	 * @return Returns the lparName.
	 */
	public String getLparName() {
		return lparName;
	}
	/**
	 * @param lparName The lparName to set.
	 */
	public void setLparName(String lparName) {
		this.lparName = lparName;
	}
	/* we are going to be passed the id for the hardware 
	 * so we will need to extract all the other inforrmation
	 *  based on the hardware id */

	
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();
		if ( file != null ) {
	 		if (file.getFileName() == null || file.getFileName().equals("")) {
				errors.add(Constants.ERROR, new ActionMessage(Constants.FILE_NAME_REQUIRED));			
				return errors;
			}
	 		if ( file.getFileSize() > Constants.FILE_MAX_SIZE ) {
	 			errors.add(Constants.ERROR, new ActionMessage(Constants.FILE_TOO_LARGE));
	 			return errors;
	 		}
	 		if ( file.getFileSize() == 0 ) {
	 			errors.add(Constants.ERROR, new ActionMessage(Constants.FILE_ZERO));
	 			return errors; 			
	 		}
	 		if (parsePreview != null && parsePreview.equals("true") && 
	 				 scanType.equals("tivoli")  ) {
	 			errors.add("Nothing", new ActionMessage(Constants.NO_PREVIEW_ALLOWD));
	 		}
		}
 		try {
			if (DelegateAccount.getAccount(accountId, request) == null) {
				errors.add(Constants.ERROR, new ActionMessage(Constants.ACCOUNT_INVALID));
			}
		} catch (ExceptionAccountAccess e) {
			errors.add(Constants.ERROR, new ActionMessage(Constants.ACCOUNT_ACCESS));
		}
// 		if (EaUtils.isBlank(hardwareSoftwareId)) {
// 			errors.add(Constants.ERROR, new ActionMessage(Constants.HARDWARE_INVALID));
// 		}

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
	 * @param file The file to set.
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
	 * @param load The load to set.
	 */
	public void setLoad(String load) {
		this.load = load;
	}
	/**
	 * @return Returns the parsePreview.
	 */
	public String getParsePreview() {
		if ( parsePreview != null ) {
			// true returns "on"
			return parsePreview;
		} else {
			return "off";
		}
	}
	/**
	 * @param parsePreview The parsePreview to set.
	 */
	public void setParsePreview(String parsePreview) {
		this.parsePreview = parsePreview;
	}
	/**
	 * @return Returns the scanType.
	 */
	public String getScanType() {
		return scanType;
	}
	/**
	 * @param scanType The scanType to set.
	 */
	public void setScanType(String scanType) {
		this.scanType = scanType;
	}
	/**
	 * @return Returns the hardwareSoftwareId.
	 */
	public String getHardwareSoftwareId() {
		return hardwareSoftwareId;
	}
	/**
	 * @param hardwareSoftwareId The hardwareSoftwareId to set.
	 */
	public void setHardwareSoftwareId(String hardwareSoftwareId) {
		this.hardwareSoftwareId = hardwareSoftwareId;
	}
	/**
	 * @return Returns the selected.
	 */
	public String[] getSelected() {
		return selected;
	}
	/**
	 * @param selected The selected to set.
	 */
	public void setSelected(String[] selected) {
		this.selected = selected;
	}
	/**
	 * @return Returns the scan.
	 */
	public SwScan getScan() {
		return scan;
	}
	/**
	 * @param scan The scan to set.
	 */
	public void setScan(SwScan scan) {
		this.scan = scan;
	}
	/**
	 * @return Returns the fileName.
	 */
	public String getFileName() {
		return fileName;
	}
	/**
	 * @param fileName The fileName to set.
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}