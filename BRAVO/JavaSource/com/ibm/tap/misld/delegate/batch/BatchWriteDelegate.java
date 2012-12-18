/*
 * Created on Apr 8, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.batch;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.sql.SQLException;
import java.util.Date;

import javax.naming.NamingException;

import org.hibernate.Hibernate;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.batch.IBatch;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.msBatchQueue.MsBatchQueue;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class BatchWriteDelegate extends Delegate {

	public static void addBatch(IBatch batch) throws HibernateException,
			NamingException {

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ObjectOutputStream oos = null;

		try {
			oos = new ObjectOutputStream(baos);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		try {
			oos.writeObject(batch);
		} catch (IOException e2) {
			e2.printStackTrace();
		}

		byte[] dataAsByteArray = baos.toByteArray();

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		MsBatchQueue batchQueue = new MsBatchQueue();
		batchQueue.setBatchObject(Hibernate.createBlob(dataAsByteArray));
		batchQueue.setRecordTime(new Date());
		batchQueue.setRemoteUser(batch.getRemoteUser());
		batchQueue.setStatus(Constants.ACTIVE);

		session.save(batchQueue);

		tx.commit();
		session.close();

	}

	/**
	 * @return
	 * @throws HibernateException
	 * @throws NamingException
	 * @throws IOException
	 * @throws SQLException
	 */
	public static MsBatchQueue popBatch() throws HibernateException,
			SQLException, IOException, NamingException {

		MsBatchQueue batchQueue = BatchReadDelegate.getBatchQueue();

		if (batchQueue != null) {
			deleteBatchQueue(batchQueue);
		}

		return batchQueue;
	}

	/**
	 * @param batch
	 * @throws HibernateException
	 * @throws NamingException
	 */
	private static void deleteBatchQueue(MsBatchQueue batchQueue)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.delete(batchQueue);

		tx.commit();
		session.close();

	}
}