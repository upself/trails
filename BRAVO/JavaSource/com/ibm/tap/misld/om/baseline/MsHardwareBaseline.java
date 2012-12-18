/*
 * Created on Feb 8, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.om.baseline;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MsHardwareBaseline
        extends ValidatorActionForm {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long     msHardwareBaselineId;

    private Customer customer;

    private String   serialNumber;

    private String   nodeName;

    private String   machineType;

    private String   machineModel;

    private Integer  processorCount;

    private String   nodeOwner;

    private Date     scanTime;

    private String   country;

    private String   comment;

    private String   remoteUser;

    private Date     recordTime;

    private String   status;

    private boolean  usMachines;

    private String   loader;

    /**
     * @return Returns the comment.
     */
    public String getComment() {
        return comment;
    }

    /**
     * @param comment
     *            The comment to set.
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

    /**
     * @return Returns the country.
     */
    public String getCountry() {
        return country;
    }

    /**
     * @param country
     *            The country to set.
     */
    public void setCountry(String country) {
        this.country = country;
    }

    /**
     * @return Returns the customer.
     */
    public Customer getCustomer() {
        return customer;
    }

    /**
     * @param customer
     *            The customer to set.
     */
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    /**
     * @return Returns the machineModel.
     */
    public String getMachineModel() {
        return machineModel;
    }

    /**
     * @param machineModel
     *            The machineModel to set.
     */
    public void setMachineModel(String machineModel) {
        this.machineModel = machineModel;
    }

    /**
     * @return Returns the machineType.
     */
    public String getMachineType() {
        return machineType;
    }

    /**
     * @param machineType
     *            The machineType to set.
     */
    public void setMachineType(String machineType) {
        this.machineType = machineType;
    }

    /**
     * @return Returns the msHardwareBaselineId.
     */
    public Long getMsHardwareBaselineId() {
        return msHardwareBaselineId;
    }

    /**
     * @param msHardwareBaselineId
     *            The msHardwareBaselineId to set.
     */
    public void setMsHardwareBaselineId(Long msHardwareBaselineId) {
        this.msHardwareBaselineId = msHardwareBaselineId;
    }

    /**
     * @return Returns the nodeName.
     */
    public String getNodeName() {
        return nodeName;
    }

    /**
     * @param nodeName
     *            The nodeName to set.
     */
    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    /**
     * @return Returns the nodeOwner.
     */
    public String getNodeOwner() {
        return nodeOwner;
    }

    /**
     * @param nodeOwner
     *            The nodeOwner to set.
     */
    public void setNodeOwner(String nodeOwner) {
        this.nodeOwner = nodeOwner;
    }

    /**
     * @return Returns the recordTime.
     */
    public Date getRecordTime() {
        return recordTime;
    }

    /**
     * @param recordTime
     *            The recordTime to set.
     */
    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
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
     * @return Returns the serialNumber.
     */
    public String getSerialNumber() {
        return serialNumber;
    }

    /**
     * @param serialNumber
     *            The serialNumber to set.
     */
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    /**
     * @return Returns the status.
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status
     *            The status to set.
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return Returns the scanTime.
     */
    public Date getScanTime() {
        return scanTime;
    }

    /**
     * @param scanTime
     *            The scanTime to set.
     */
    public void setScanTime(Date scanTime) {
        this.scanTime = scanTime;
    }

    /**
     * @return Returns the usMachines.
     */
    public boolean isUsMachines() {
        return usMachines;
    }

    /**
     * @param usMachines
     *            The usMachines to set.
     */
    public void setUsMachines(boolean usMachines) {
        this.usMachines = usMachines;
    }

    /**
     * @return Returns the loader.
     */
    public String getLoader() {
        return loader;
    }

    /**
     * @param loader
     *            The loader to set.
     */
    public void setLoader(String loader) {
        this.loader = loader;
    }

    /**
     * @return Returns the processorCount.
     */
    public Integer getProcessorCount() {
        return processorCount;
    }

    /**
     * @param processorCount
     *            The processorCount to set.
     */
    public void setProcessorCount(Integer processorCount) {
        this.processorCount = processorCount;
    }
}