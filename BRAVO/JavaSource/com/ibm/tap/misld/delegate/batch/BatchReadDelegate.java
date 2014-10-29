/*
 * Created on Apr 8, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.batch;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.batch.IBatch;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.msBatchQueue.MsBatchQueue;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class BatchReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws SQLException
	 * @throws IOException
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static MsBatchQueue getBatchQueue() throws SQLException,
			IOException, HibernateException, NamingException {

		MsBatchQueue batchQueue = null;
		Session session = getHibernateSession();

		batchQueue = (MsBatchQueue) session.getNamedQuery("getMinBatch")
				.uniqueResult();

		session.close();

		return batchQueue;
	}

	/**
	 * @return
	 */
	public static boolean isBatchQueueEmpty() {

		List batchQueues = null;

		try {
			Session session = getHibernateSession();

			batchQueues = session.getNamedQuery("getBatchQueues").list();

			session.close();

		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		}

		if (batchQueues.isEmpty()) {
			return true;
		}

		return false;
	}

	/**
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws HibernateException
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	public static List<MsBatchQueue> getBatchQueues() throws SQLException,
			HibernateException, NamingException, IOException,
			ClassNotFoundException {

		List batchQueues = null;
		List returnList = new Vector();

		Session session = getHibernateSession();

		batchQueues = session.getNamedQuery("getBatchQueues").list();

		session.close();

		Iterator i = batchQueues.iterator();

		while (i.hasNext()) {
			MsBatchQueue batchQueue = (MsBatchQueue) i.next();

			Blob blob = (Blob) ((org.hibernate.lob.SerializableBlob) batchQueue
					.getBatchObject()).getWrappedBlob();

			ObjectInputStream inputStream = null;

			inputStream = new ObjectInputStream(blob.getBinaryStream());

			IBatch batch = null;

			batch = (IBatch) inputStream.readObject();

			inputStream.close();

			batch.setStartTime(batchQueue.getRecordTime());
			batch.setBatchId(batchQueue.getBatchQueueId().intValue());
			returnList.add(batch);
		}

		return returnList;
	}

	/**
	 * @return
	 */
	public static List getBatchReport() {
		// TODO Auto-generated method stub
		return null;
	}

}