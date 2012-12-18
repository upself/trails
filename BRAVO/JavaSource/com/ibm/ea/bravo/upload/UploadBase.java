/*
 * Created on Jun 25, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.upload;

import com.ibm.ea.bravo.framework.batch.BatchBase;
import com.ibm.ea.bravo.framework.batch.IBatch;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class UploadBase extends BatchBase implements IBatch {

	protected String dir;
	protected String filename;
	protected String remoteUser;

	public String getDir() {
		return dir;
	}
	public void setDir(String dir) {
		this.dir = dir;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getRemoteUser() {
		return remoteUser;
	}
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
	
	public boolean validate() throws Exception {
		return false;
	}
	public void execute() throws Exception {
	}
	public void sendNotify() {
	}
	public void sendNotifyException(Exception e) {
	}
	public String getName() {
		return null;
	}
}
