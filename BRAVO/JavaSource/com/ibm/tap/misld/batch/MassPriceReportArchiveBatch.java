/*
 * Created on Jun 3, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.io.Serializable;
import java.util.Date;

import com.ibm.batch.IBatch;
import com.ibm.tap.misld.framework.exceptions.EmailDeliveryException;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.report.PriceReportDelegate;

/**
 * @author Thomas
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class MassPriceReportArchiveBatch extends BatchBase implements IBatch,
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String remoteUser = null;

	public MassPriceReportArchiveBatch(String remoteUser) 
	
		throws EmailDeliveryException {

		super();

		this.remoteUser = remoteUser;
		setStartTime(new Date());
	}

	public boolean validate() throws Exception {
		return false;
	}

	public void execute() throws Exception {
	}

	public void sendNotify() {

		try {
			setFrom("PRICE-REPORT-APPROVAL");
			setSubject("Price Report approval/lock complete");
			setTo(remoteUser);
		} catch (Exception e) {
			logMsg(e);
		}
		try {
			PriceReportDelegate.createMassReportArchive(remoteUser);

			sendMsg(remoteUser);

		} catch (Exception e) {
			e.printStackTrace();
			logMsg(e);
		}
	}

	public void sendNotifyException(Exception e) {
		logger.debug(e, e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getName()
	 */
	public String getName() {
		return "Mass Price Report Archive";
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getRemoteUser()
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getCustomerName()
	 */
	public String getCustomerName() {
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.batch.IBatch#getCustomer()
	 */
	public Customer getCustomer() {
		// TODO Auto-generated method stub
		return null;
	}

}