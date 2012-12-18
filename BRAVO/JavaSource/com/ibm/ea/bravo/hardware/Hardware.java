/*
 * Created on May 18, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.hardware;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.machinetype.MachineType;
import com.ibm.ea.cndb.Customer;

/**
 * @author iddadmin
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Hardware implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long id;

	private MachineType machineType;

	private String serial;

	private String country;

	private String owner;

	private String customerNumber;

	private String hardwareStatus;

	private Set<HardwareLpar> hardwareLpars;

	private String remoteUser;

	private String status;

	private Date recordTime;

	private Customer customer;

	private Integer processorCount;

	private Integer chips;

	private String model;

	private String serverType;
	
	private Integer cpuMIPS;
	
	private Integer cpuMSU;
	
	public String getServerType() {
		return serverType;
	}

	public void setServerType(String serverType) {
		this.serverType = serverType;
	}

	public Integer getCpuMIPS() {
		return cpuMIPS;
	}

	public void setCpuMIPS(Integer cpuMIPS) {
		this.cpuMIPS = cpuMIPS;
	}

	public Integer getCpuMSU() {
		return cpuMSU;
	}
	
	public void setCpuMSU(Integer cpuMSU) {
		this.cpuMSU = cpuMSU;
	}

	public Integer getChips() {
		return chips;
	}

	public void setChips(Integer chips) {
		this.chips = chips;
	}

	public String getCountry() {
		return this.country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getHardwareStatus() {
		return this.hardwareStatus;
	}

	public void setHardwareStatus(String hardwareStatus) {
		this.hardwareStatus = hardwareStatus;
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public MachineType getMachineType() {
		return this.machineType;
	}

	public void setMachineType(MachineType machineType) {
		this.machineType = machineType;
	}

	public String getOwner() {
		return this.owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public Date getRecordTime() {
		return this.recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public String getRemoteUser() {
		return this.remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public String getSerial() {
		return this.serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Set<HardwareLpar> getHardwareLpars() {
		return this.hardwareLpars;
	}

	public void setHardwareLpars(Set<HardwareLpar> hardwareLpars) {
		this.hardwareLpars = hardwareLpars;
	}

	public String getStatusImage() {
		if (this.status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_OK
					+ "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_NA
					+ "\" width=\"12\" height=\"10\"/>";
	}

	public String getStatusIcon() {
		if (this.status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}

	public String getCustomerNumber() {
		return this.customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	// private MachineType machineType;
	// private String serial;
	// private String country;
	// private String owner;
	// private String customerNumber;
	// private String hardwareStatus;
	// private Set hardwareLpars;
	// private String remoteUser;
	// private String status;
	// private Date recordTime;

	public String toString() {
		String s = "[Hardware]";
		s += " machineType=" + this.machineType.getName();
		s += ",serial=" + this.getSerial();
		s += ",country=" + this.getCountry();
		s += ",owner=" + this.getOwner();
		s += ",customerNumber=" + this.getCustomerNumber();
		s += ",hardwareStatus=" + this.getHardwareStatus();
		s += ",remoteUser=" + this.getRemoteUser();
		s += ",status=" + this.getStatus();
		s += ",recordTime=" + this.getRecordTime();
		s += ",processorCount=" + this.getProcessorCount();
		s += ",model=" + this.getModel();
		return s;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public Integer getProcessorCount() {
		return processorCount;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}
}
