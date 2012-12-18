/*
 * Created on Mar 4, 2009
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.cndb.Customer;

/**
 * @author jain
 * 
 * Note:  Since mapping to a native sql query instead of hibernate, 
 * the attributes had to be in CAPS.
 */
public class ManualQueue extends OrmBase {
	/**
     * 
     */
    private static final long serialVersionUID = -177257424612002638L;
    private Long id;
	private Customer customer;
	private Long softwareLparId;
	private String hostName;
	private Long softwareId;
	private Integer deleted;
	private String comments;
	public Long getSoftwareId() {
		return softwareId;
	}
	public void setSoftwareId(Long softwareId) {
		this.softwareId = softwareId;
	}
	public ManualQueue() {
		customer = new Customer();
	}
	public String getHostName() {
		return hostName;
	}
	public void setHostName(String hostName) {
		this.hostName = hostName;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getSoftwareLparId() {
		return softwareLparId;
	}
	public void setSoftwareLparId(Long softwareLparId) {
		this.softwareLparId = softwareLparId;
	}
	public Customer getCustomer() {
		return customer;
	}
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}
	public Integer getDeleted() {
		return deleted;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getComments() {
		return comments;
	}
}
