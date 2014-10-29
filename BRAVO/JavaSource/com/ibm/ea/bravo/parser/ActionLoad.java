package com.ibm.ea.bravo.parser;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.user.UserContainer;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.software.parser.DelegateSwScan;
import com.ibm.ea.bravo.software.parser.ParserInstalledSoftware;
import com.ibm.ea.bravo.software.parser.SwScan;
import com.ibm.ea.utils.EaUtils;

/**
 * 
 * @author dbryson@us.ibm.com
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

public class ActionLoad extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(ActionLoad.class);
    
	public static Properties properties = new Properties();

	public static String appPath;


	public ActionForward tivoli(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.tivoli");
		ActionErrors errors = new ActionErrors();
		
    	// get the id parameter
		String accountId = getParameter(request, Constants.ID);

		// validate the account ID
		if (EaUtils.isBlank(accountId)) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// get the account
    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
		
		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward softwareDiscrepancy(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.softwareDiscrepancy");
		ActionErrors errors = new ActionErrors();
		
    	// get the id parameter
		String accountId = getParameter(request, Constants.ID);

		// validate the account ID
		if (EaUtils.isBlank(accountId)) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// get the account
    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
		
		return mapping.findForward(Constants.SUCCESS);
	}
	public ActionForward authorizedAssets(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.authorizedAssets");
		ActionErrors errors = new ActionErrors();
		
    	// get the id parameter
		String accountId = getParameter(request, Constants.ID);

		// validate the account ID
		if (EaUtils.isBlank(accountId)) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// get the account
    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
		
		return mapping.findForward(Constants.SUCCESS);
	}
	
	
	public ActionForward scrtReport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.scrtReport");
		ActionErrors errors = new ActionErrors();
		
    	// get the id parameter
		String accountId = getParameter(request, Constants.ID);

		// validate the account ID
		if (EaUtils.isBlank(accountId)) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// get the account
    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
		
		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward softAudit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.softAudit");
		// get the id parameter
		String accountId = getParameter(request, Constants.ID);

    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
		
		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward dorana(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.dorana");
		// get the id parameter
		String accountId = getParameter(request, Constants.ID);

    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
		
		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward vm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.vm");
		ActionErrors errors = new ActionErrors();
		
    	// get the id parameter
		String hardwareLparId = getParameter(request, Constants.ID);

    	// get the hardware lpar
		HardwareLpar hardwareLpar = DelegateHardware.getHardwareLpar(hardwareLparId);
		request.setAttribute(Constants.HARDWARE, hardwareLpar);

		// validate the hardware lpar
		if (hardwareLpar == null) {
			// TODO not valid hardware lpar
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
		
    	// get the account
    	String accountId = hardwareLpar.getCustomer().getAccountNumber().toString();
    	Account account = DelegateAccount.getAccount(accountId, request);
    	request.setAttribute(Constants.ACCOUNT, account);
		
		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward init(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		return mapping.findForward(Constants.SUCCESS);
	}
	
	
	public ActionForward load(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.load");
		
        UserContainer user = loadUser(request);
		// Get the action form and some basic file checks
		FormLoad tff = (FormLoad) form;
		if (tff == null) {
			return mapping.findForward(Constants.ERROR);
		}
		
		String scanType = tff.getScanType();
		String parsePreview = tff.getParsePreview();
		String accountId = tff.getAccountId();
		Account account = null;
		
		logger.debug("Account ID: " + accountId);
		
    	ActionErrors errors = tff.validate(mapping, request);
    	if (! errors.isEmpty()) {
    		logger.debug(errors.get().next());
    		saveErrors(request, errors);
    		
    		request.setAttribute(Constants.ID, tff.getHardwareSoftwareId());
	    	account = DelegateAccount.getAccount(accountId, request);
	    	request.setAttribute(Constants.ACCOUNT, account);

    		
    	}
    	
		if ( tff.getCpuName() != null ) {
			logger.debug("executed from select lpar");
	    	account = DelegateAccount.getAccount(accountId, request);
	    	request.setAttribute(Constants.ACCOUNT, account);
			ActionForward a = submit(mapping, form,
					request, response);
			return a;
		}

       
		String dir;
        SwScan thisScan; 
		
		/* set the directory based on what type of file */
		if ( scanType.equals("tivoli")) {
			dir = Constants.UPLOAD_DIR_TAR;
			thisScan = new SwScan(user);
		} else if ( scanType.equals("vm") ){
			dir = Constants.UPLOAD_DIR;
			thisScan = new SwScan(user );
		} else if ( scanType.equals("manual")) {
			thisScan = new SwScan(user);
			dir = Constants.UPLOAD_DIR;			
		} else if ( scanType.equals("softaudit") || scanType.equals("dorana")) {
			dir = Constants.UPLOAD_DIR;
			thisScan = new SwScan(user );			
		} else {
			dir = null;
			thisScan =  null;
			logger.error("Invalid scan type " + scanType );
			return mapping.findForward(Constants.ERROR);			
		}
		
		thisScan.getNotifyMessage().add("Account ID: " + accountId 
				+ " LPAR Name " + thisScan.getName()
				+ " Loaded by (from BRAVO SwScan object): " 
				+ thisScan.getUser().getRemoteUser());
		
        logger.debug(thisScan.getNotifyMessage().lastElement());

		FormFile file = tff.getFile();
		if (file == null) {
			thisScan.getNotifyMessage().add("Error: Null FormFile object passed to ActionLoad");
			logger.error(thisScan.getNotifyMessage().lastElement());
			return mapping.findForward(Constants.ERROR);
		}

		String fname = file.getFileName();

		//TODO hash a better name
		Date now = new Date();
		String date = EaUtils.yearMonthDay(now);
		String time = EaUtils.hourMinuteSecond(now);
		
		if ( fname.toLowerCase().endsWith("xml") || fname.toLowerCase().endsWith("asc") ) {
			fname = fname.toLowerCase();
		} else {
			fname = date + "." + time + request.getRemoteUser() + "." + accountId + scanType + ".csv";
		}
		tff.setFileName(fname);
		thisScan.getNotifyMessage().add("File Name Uploaded: " + dir + fname);
		logger.debug(thisScan.getNotifyMessage().lastElement());

		//-- From here below just copies the file to a standard location
		InputStream streamIn = file.getInputStream();
		OutputStream streamOut = new FileOutputStream(dir + fname);

		int bytesRead = 0;
		int totalBytesRead = 0;
		byte[] buffer = new byte[8192];

		while ((bytesRead = streamIn.read(buffer, 0, 8192)) != -1) {
			try {
				streamOut.write(buffer, 0, bytesRead);
				totalBytesRead += bytesRead;
			} catch (Exception e) {
				thisScan.getNotifyMessage().add(e.getMessage());
				logger.error(e, e);
				return mapping.findForward(Constants.ERROR);
			}
		}

		streamOut.close();
		streamIn.close();
		//-- Stop copying...
		
		thisScan.setFileName(fname);
		thisScan.setScanType(scanType);
		
		// Check to make sure the file size we read is what we expected
		// This check most likely isn't needed because of the exception thrown, but doesn't hurt
		if ( totalBytesRead != file.getFileSize() ) {
			thisScan.getNotifyMessage().add("Error Transmitting File: " + thisScan.getFileName() 
					+ " File size should be: " + file.getFileSize() + " but bytes transmitted: " +
					bytesRead );
			logger.warn(thisScan.getNotifyMessage().lastElement());
		}
		
		// if this is a tar file, no other processing is required
		if ( scanType.equals("tivoli")) {
			logger.debug("Uploaded tar file " + fname);
			// This is as far as we need to go if we don't want to preview
	 		return mapping.findForward(Constants.SUCCESS);						
		}
		
		// Preview Parse the file if parsePreview is set
		if ( parsePreview != null && parsePreview.equals("checked") ) {
			InterfaceParser saImport;
			if ( scanType.equals("softaudit") ) {
				// if the file name ends in XML then this is a distiller file
				logger.debug("Checking if it is an XML file");
				if ( file.getFileName().toLowerCase().endsWith("xml") || file.getFileName().toLowerCase().endsWith("asc") ) {
					IBatch batch = null;
					batch = new FileUploadFtp(request.getRemoteUser(), Constants.UPLOAD_DIR, 
							fname, Constants.UPLOAD_DIR, scanType);
					if (batch != null) {
						addBatch(batch);
						logger.debug("Batch added by " + batch.getRemoteUser() + " who loaded " + fname);
						// need some level of persistence at this point
					}
					return mapping.findForward(Constants.SUCCESS);
				}
		    	saImport = new SoftAuditImporter();	
			} else if ( scanType.equals("dorana") ) {
			    	saImport = new DoranaImporter();						
			} else if ( scanType.equals("vm") ){
		    	saImport = new VMImporter();			
			} else  if ( scanType.equals("manual") ) {			
				saImport = new ManualImporter();
			} else {
				thisScan.getNotifyMessage().add("Program error -- invalid scan type " + scanType
						+ " for Hardware ID " + accountId );
				logger.error(thisScan.getNotifyMessage().lastElement());
				saImport = null;
		 		return mapping.findForward(Constants.ERROR);
			}
			
	    	java.util.ArrayList<String> list = new java.util.ArrayList<String>();
	    	
			if ( saImport.parse(thisScan) ) {
				thisScan.getNotifyMessage().add("User Previewed Parsing");
			}
	    	int numberProducts = thisScan.getInstalledSoftware().size();
	    	int counter = 0;
	    	while ( counter < numberProducts ) {
	    		// Get my software object
	    		ParserInstalledSoftware s = (ParserInstalledSoftware)thisScan.getInstalledSoftware().elementAt(counter);
	    		list.add(s.getProductName());
	    		++counter;
	    	}
			request.setAttribute("parsedAcct", list);
		} else {
			thisScan.getNotifyMessage().add("User did not preview the parsing");
		}
		tff.setCpuName(thisScan.getCpuName());
		tff.setLparName(thisScan.getLparName());
		tff.setAccountId(accountId);
		List<HardwareLpar> hardwareLpars = null;
		hardwareLpars = DelegateSwScan.getHardwareLpars(new Long(accountId));
		request.setAttribute("hardwareLpars", hardwareLpars);
		tff.setScan(thisScan);
		request.setAttribute("scan", thisScan);
		request.setAttribute("accountId", accountId);

 		return mapping.findForward("selectLpar");
// 		return mapping.findForward(Constants.SUCCESS);
//		return mapping.findForward("/upload/loadScanSubmit");
		

	}
	
	public ActionForward submit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionLoad.submit");
		
        loadUser(request);
		// Get the action form and some basic file checks
		FormLoad tff = (FormLoad) form;
		if (tff == null) {
			logger.debug("Null form");
			return mapping.findForward(Constants.ERROR);
		}
		
//        String hardwareIdString = tff.getHardwareSoftwareId();
		String scanType = tff.getScanType();
		String accountId = tff.getAccountId();
		String[] selected = tff.getSelected();
		String fileName = tff.getFileName();
		
    	ActionErrors errors = tff.validate(mapping, request);
    	if (! errors.isEmpty()) {
    		logger.debug(errors.get().next());
    		saveErrors(request, errors);
    		
    		request.setAttribute(Constants.ID, tff.getHardwareSoftwareId());

    		if (scanType.equalsIgnoreCase("vm") ||
    			scanType.equalsIgnoreCase("softAudit") ||
				scanType.equalsIgnoreCase("dorana")) {
    			
    	    	// get the hardware lpar
    			HardwareLpar hardwareLpar = DelegateHardware.getHardwareLpar(tff.getHardwareSoftwareId());
    			request.setAttribute(Constants.HARDWARE, hardwareLpar);

    	    	// get the account
    	    	Account account = DelegateAccount.getAccount(accountId, request);
    	    	request.setAttribute(Constants.ACCOUNT, account);

    		} else {

    			// get the account
    	    	Account account = DelegateAccount.getAccount(accountId, request);
    	    	request.setAttribute(Constants.ACCOUNT, account);

    		}
    		
    	}

        SwScan thisScan = tff.getScan(); 
		String dir = Constants.UPLOAD_DIR;
		
		if ( thisScan == null ) {
			logger.debug("Null scan item but file name is " + fileName);
		}
		
		
		List<String> listId = null;
		// Init the batch Interface
		IBatch batch = null;
		if (selected == null) {
			// TODO add error
			logger.debug("none selected but lpar name is " + tff.getLparName());
		} else {
			listId = Arrays.asList(selected);
			logger.debug("some selected and lpar name is " + tff.getLparName());
		}
		
		// Right now only ftp SoftAudit and dorana files else process normally
		if ( scanType.equals("softaudit") || scanType.equals("dorana") ) {
			if ( selected != null ) {
				Iterator<String> i = listId.iterator();
				logger.debug("Starting to ftp file");
				while (i.hasNext()) {
					String id = (String) i.next();
					logger.debug("Working on ID " + id);
					int bytesRead = 0;
					int totalBytesRead = 0;
					byte[] buffer = new byte[8192];
					HardwareLpar h = DelegateHardware.getHardwareLpar(id);
					String realFilename = "WEB_" + accountId + "_" + 
						h.getHardware().getSerial() + "_" + h.getName() + ".TXT";
					logger.debug("Going to send " + realFilename);
					FileInputStream streamInTmp = new FileInputStream(dir + fileName);
					OutputStream streamOutTmp = new FileOutputStream(dir + realFilename);
					while ((bytesRead = streamInTmp.read(buffer, 0, 8192)) != -1) {
						try {
							streamOutTmp.write(buffer, 0, bytesRead);
							totalBytesRead += bytesRead;
						} catch (Exception e) {
							thisScan.getNotifyMessage().add(e.getMessage());
							logger.error(e, e);
							return mapping.findForward(Constants.ERROR);
						}
					}
	
					streamInTmp.close();
					streamOutTmp.close();
					
					batch = new FileUploadFtp(request.getRemoteUser(), Constants.UPLOAD_DIR, 
							realFilename, Constants.UPLOAD_DIR, scanType);
					if (batch != null) {
						addBatch(batch);
						logger.debug("Batch added by " + batch.getRemoteUser() + " who loaded " + realFilename);
						// need some level of persistance at this point
					}
				}
			}
			// now rename the tmp file to the selected file and upload it
			if ( tff.getSubmitInternal().equals("on")) {
				logger.debug("submitting " + scanType + " file per internal information");
				String realFilename = "WEB_" + accountId + "_" + tff.getCpuName() + "_" + tff.getLparName() + ".TXT";
				File oldFile = new File(dir + fileName); 
				oldFile.renameTo(new File(dir + realFilename));
				batch = new FileUploadFtp(request.getRemoteUser(), Constants.UPLOAD_DIR, 
						realFilename, Constants.UPLOAD_DIR, scanType);
	
				if (batch != null) {
					addBatch(batch);
					logger.debug("Batch added by " + batch.getRemoteUser() + " who loaded " + realFilename);
					// need some level of persistance at this point
				}
			} else {
				// 
				logger.debug("TLCMz/Dorana file not submitted to match internal information." + tff.getSubmitInternal());
			}

		} else {
			batch = new BatchSoftwareLoad(thisScan);
			if (batch != null) {
				addBatch(batch);
				logger.debug("Batch added by " + batch.getRemoteUser());
				// need some level of persistence at this point
			}
		}
		
 		return mapping.findForward(Constants.SUCCESS);

	}
}