/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.report;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;

import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class ReportBase {
	
	protected OutputStream outputStream;
	protected String remoteUser;
	
	public abstract void execute(String[] arguments, HttpServletRequest request) throws ExceptionAccountAccess, HibernateException, Exception;
	
	public String tsv(Object[] data) {
		return EaUtils.join(data, Constants.TAB);
	}

	public String csv(Object[] data) {
		return EaUtils.join(data, Constants.COMMA);
	}

	public OutputStream getOutputStream() {
		return this.outputStream;
	}
	public void setOutputStream(OutputStream outputStream) {
		this.outputStream = outputStream;
	}
	public String getRemoteUser() {
		return this.remoteUser;
	}
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
}
