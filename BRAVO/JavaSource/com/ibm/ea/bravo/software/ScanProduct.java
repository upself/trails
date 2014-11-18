/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import java.util.Date;

//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End

/**
 * @author Thomas
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ScanProduct {

	private Long id;
	//Change Bravo to use Software View instead of Product Object Start
	//private Product software;
	private Software software;
	//Change Bravo to use Software View instead of Product Object End
	private String saProduct;
	private String vmProduct;
	private String doranaProduct;
    private String remoteUser;
    private Date recordTime;
    private String status;
    private String version;

	/**
	 * @return Returns the doranaProduct.
	 */
	public String getDoranaProduct() {
		return doranaProduct;
	}
	/**
	 * @param doranaProduct The doranaProduct to set.
	 */
	public void setDoranaProduct(String doranaProduct) {
		this.doranaProduct = doranaProduct;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	/**
	 * @return Returns the vmProduct.
	 */
	public String getVmProduct() {
		return vmProduct;
	}
	/**
	 * @param vmProduct The vmProduct to set.
	 */
	public void setVmProduct(String vmProduct) {
		this.vmProduct = vmProduct;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return recordTime;
	}
	/**
	 * @param recordTime The recordTime to set.
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
	 * @param remoteUser The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
	/**
	 * @return Returns the saProduct.
	 */
	public String getSaProduct() {
		return saProduct;
	}
	/**
	 * @param saProduct The saProduct to set.
	 */
	public void setSaProduct(String saProduct) {
		this.saProduct = saProduct;
	}
	
	//Change Bravo to use Software View instead of Product Object Start
	/**
	 * @return Returns the software.
	 */
	/*public Product getSoftware() {
		return software;
	}*/
	/**
	 * @param software The software to set.
	 */
	/*public void setSoftware(Product software) {
		this.software = software;
	}*/
	
	/**
	 * @return Returns the software.
	 */
	public Software getSoftware() {
		return software;
	}
	/**
	 * @param software The software to set.
	 */
	public void setSoftware(Software software) {
		this.software = software;
	}
	//Change Bravo to use Software View instead of Product Object End
	
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}
