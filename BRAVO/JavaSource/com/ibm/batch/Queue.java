/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.batch;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;

import com.ibm.tap.misld.delegate.batch.BatchReadDelegate;
import com.ibm.tap.misld.delegate.batch.BatchWriteDelegate;
import com.ibm.tap.misld.om.msBatchQueue.MsBatchQueue;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class Queue {

    private static final Logger logger       = Logger
    .getLogger(Queue.class);

	public void addBatch(IBatch batch) throws SQLException, IOException,
			HibernateException, NamingException {

		logger.debug("adding: name=" + batch.getName() + " remoteUser="
				+ batch.getRemoteUser());

		BatchWriteDelegate.addBatch(batch);
	}

	public MsBatchQueue getBatchQueue() throws ClassNotFoundException,
			HibernateException, SQLException, IOException, NamingException {
		return BatchReadDelegate.getBatchQueue();
	}

	public boolean isEmpty() {
		return BatchReadDelegate.isBatchQueueEmpty();
	}

	public MsBatchQueue popBatch() throws IOException, ClassNotFoundException,
			SQLException, HibernateException, NamingException {
		return BatchWriteDelegate.popBatch();
	}

	/**
	 * @return Returns the q.
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 * @throws IOException
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List<MsBatchQueue> getQ() throws ClassNotFoundException,
			HibernateException, SQLException, IOException, NamingException {
		return BatchReadDelegate.getBatchQueues();
	}

}