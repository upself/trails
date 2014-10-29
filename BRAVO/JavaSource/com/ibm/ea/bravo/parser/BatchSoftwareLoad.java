package com.ibm.ea.bravo.parser;

/** 
 * @author dbryson@us.ibm.com
 */
import java.io.Serializable;
import java.util.Iterator;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.batch.BatchBase;
import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.email.DelegateEmail;
import com.ibm.ea.bravo.software.parser.DelegateSwScan;
import com.ibm.ea.bravo.software.parser.SwScan;
import com.ibm.ea.bravo.upload.SoftwareDiscrepancy;

public class BatchSoftwareLoad extends BatchBase implements IBatch, Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static final Logger logger = Logger.getLogger(SoftwareDiscrepancy.class);

	private String remoteUser;
	private String scanType;
	private SwScan swScan;
	private String name;
	
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return Returns the swScan.
	 */
	public SwScan getSwScan() {
		return swScan;
	}
	/**
	 * @param swScan The swScan to set.
	 */
	public void setSwScan(SwScan swScan) {
		this.swScan = swScan;
	}

	public BatchSoftwareLoad(SwScan thisScan ) {
		super();
		this.swScan = thisScan;
		this.remoteUser = thisScan.getUser().getRemoteUser();
		this.scanType = thisScan.getScanType();
		this.name = thisScan.getName();
	}
	public void execute() throws Exception {
		InterfaceParser saImport;
		if ( scanType.equals("softaudit") ) {
	    	saImport = new SoftAuditImporter();						
		} else if ( scanType.equals("vm") ){
	    	saImport = new VMImporter();			
		} else if ( scanType.equals("tivoli") ) {
			// NOT SUPPORTED AT THIS TIME
			// This should NEVER be called because 
			// The files are just copied and not parsed this way
			saImport = null;
			return;
		} else if ( scanType.equals("manual" ) ) {
			saImport = new ManualImporter();		
		} else if ( scanType.equals("dorana" ) ) {
			saImport = new DoranaImporter();		
		} else {
			saImport = null;
			return;
		}
		if ( saImport.parse(swScan) ) {
			if ( scanType.equals("softaudit")) {
				logger.debug("ftp'ing file");
			} else {
				DelegateSwScan.write(swScan);
			}
		}
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void sendNotify() {
		StringBuffer message = new StringBuffer();
		for ( Iterator<String> messageLines = this.swScan.getNotifyMessage().iterator(); messageLines.hasNext(); ) {
			message.append((String) messageLines.next() + "\n");
		}
		logger.debug("\n" + message);
		String emailType;
		if ( this.getScanType().equals("softaudit")) {
			emailType = "BRAVO SoftAdudit Upload";
		} else if ( this.getScanType().equals("vm")) {
			emailType = "BRAVO VM Upload";
		} else if ( this.getScanType().equals("dorana")) {
			emailType = "BRAVO Dorana Upload";
		} else {
			emailType = "BRAVO Missing Software Discrepancy Upload";
		}
		DelegateEmail.sendMessage(emailType, remoteUser, message);
	}

	public void sendNotifyException(Exception e) {
		logger.error(e, e);
	}

	public boolean validate() throws Exception {
		return true;
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
	 * @param remoteUser The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
}
