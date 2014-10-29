/*
 * Created on Sep 15, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.attachment;
import java.sql.Blob;
import java.util.Date;

import com.ibm.ea.bravo.framework.common.Constants;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Attachment {

	private Long id;
	private String name;
	private Integer size;
	private Blob data;
	private String remoteUser;
	private Date recordTime = new Date();
	private String status = Constants.ACTIVE;
	
	/**
	 * @return Returns the data.
	 */
	public Blob getData() {
		return this.data;
	}
	/**
	 * @param data The data to set.
	 */
	public void setData(Blob data) {
		this.data = data;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return this.id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return this.name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return this.recordTime;
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
		return this.remoteUser;
	}
	/**
	 * @param remoteUser The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
	/**
	 * @return Returns the size.
	 */
	public Integer getSize() {
		return this.size;
	}
	/**
	 * @param size The size to set.
	 */
	public void setSize(Integer size) {
		this.size = size;
	}
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return this.status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}
