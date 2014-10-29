/*
 * Created on Feb 1, 2006
 *
 */
package com.ibm.ea.bravo.software.parser;

import java.util.Vector;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.user.UserContainer;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.software.InstalledSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.cndb.Customer;

/**
 * @author dbryson@us.ibm.com
 * 
 */
public class SwScan extends SoftwareLpar {

	private static final Logger logger = Logger.getLogger(SwScan.class);

	private Vector<InstalledSoftware> installedSoftware;

	private String scanType;

	private UserContainer user;

	private String fileName;

	private HardwareLpar hardware;

	private boolean isParsed;

	private Boolean goodFile;

	private Vector<String> notifyMessage;
	
	private String lparName;
	private String cpuName;

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
	/**
	 * @return Returns the notifyMessage.
	 */
	public Vector<String> getNotifyMessage() {
		return notifyMessage;
	}

	/**
	 * @param notifyMessage
	 *            The notifyMessage to set.
	 */
	public void setNotifyMessage(Vector<String> notifyMessage) {
		this.notifyMessage = notifyMessage;
	}

	/**
	 * @return Returns the goodFile.
	 */
	public Boolean getGoodFile() {
		return goodFile;
	}

	/**
	 * @param goodFile
	 *            The goodFile to set.
	 */
	public void setGoodFile(Boolean goodFile) {
		this.goodFile = goodFile;
	}

	/*
	 * Constructor for parsing when we are given the hardware ID and user This
	 * happens when scanType = vm, softaudit, and dorana
	 */
	public SwScan(Long hardwareId, UserContainer user) {
		this.setInstalledSoftware(new Vector<InstalledSoftware>());
		this.setNotifyMessage(new Vector<String>());
		this.hardware = new HardwareLpar();
		this.user = new UserContainer();
		setCustomer(new Customer());
		this.setUser(user);
		this.setGoodFile(null);
		try {
			this.setHardware(DelegateSwScan.getHardwareLpar(hardwareId
					.intValue()));
			this.setCustomer(this.getHardware().getCustomer());
		} catch (Exception e) {
			// TODO Auto-generated catch block -- change to email notice
			e.printStackTrace();
			logger.warn(e.getMessage());
			this.notifyMessage.add(e.getMessage());
		}
		this.setParsed(false);
	}

	/*
	 * constructor for parsing when scanType = manual, tivoli which do not pass
	 * hardward ID
	 */
	public SwScan(UserContainer user) {
		this.setInstalledSoftware(new Vector<InstalledSoftware>());
		this.user = new UserContainer();
		setCustomer(new Customer());
		this.setNotifyMessage(new Vector<String>());
		this.setUser(user);
		this.setParsed(false);
		this.setGoodFile(null);
	}

	/**
	 * @return Returns the hardware.
	 */
	public HardwareLpar getHardware() {
		return hardware;
	}

	/**
	 * @param hardware
	 *            The hardware to set.
	 */
	public void setHardware(HardwareLpar hardware) {
		this.hardware = hardware;
	}

	/**
	 * @return Returns the isParsed.
	 */
	public boolean isParsed() {
		return isParsed;
	}

	/**
	 * @param isParsed
	 *            The isParsed to set.
	 */
	public void setParsed(boolean isParsed) {
		this.isParsed = isParsed;
	}

	/**
	 * @return Returns the fileName.
	 */
	public String getFileName() {
		return fileName;
	}

	/**
	 * @param fileName
	 *            The fileName to set.
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	/**
	 * @return Returns the installedSoftware.
	 */
	public Vector<InstalledSoftware> getInstalledSoftware() {
		return installedSoftware;
	}

	/**
	 * @param installedSoftware
	 *            The installedSoftware to set.
	 */
	public void setInstalledSoftware(Vector<InstalledSoftware> installedSoftware) {
		this.installedSoftware = installedSoftware;
	}

	/**
	 * @return Returns the scanType.
	 */
	public String getScanType() {
		return scanType;
	}

	/**
	 * @param scanType
	 *            The scanType to set.
	 */
	public void setScanType(String scanType) {
		this.scanType = scanType;
	}

	/**
	 * @return Returns the user.
	 */
	public UserContainer getUser() {
		return user;
	}

	/**
	 * @param user
	 *            The user to set.
	 */
	public void setUser(UserContainer user) {
		this.user = user;
	}
}
