package com.ibm.batch;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.sql.Blob;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;

import com.ibm.tap.misld.om.msBatchQueue.MsBatchQueue;

/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BatchMonitor {

	Queue queue = new Queue();

    private static final Logger logger  = Logger.getLogger(BatchMonitor.class);

	boolean running = false;

	public synchronized void execute() {
		logger.debug("[batch] starting the load queue manager");

		MsBatchQueue batchQueue = null;

		try {
			batchQueue = queue.getBatchQueue();
		} catch (HibernateException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (NamingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		while (batchQueue != null) {

			Blob blob = (Blob) ((org.hibernate.lob.SerializableBlob) batchQueue
					.getBatchObject()).getWrappedBlob();

			ObjectInputStream inputStream = null;
			try {
				inputStream = new ObjectInputStream(blob.getBinaryStream());
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			IBatch batch = null;
			try {
				batch = (IBatch) inputStream.readObject();
			} catch (IOException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} catch (ClassNotFoundException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}

			try {
				inputStream.close();
			} catch (IOException e3) {
				// TODO Auto-generated catch block
				e3.printStackTrace();
			}

			try {
				batch.validate();
				batch.execute();
				batch.sendNotify();
			} catch (Exception e) {
				batch.sendNotifyException(e);
			}

			try {
				logger.debug("[batch] popping");
				queue.popBatch();
				// what if this is the last one, and someone sneaks in.

				logger.debug("[batch] getting the next one");
				batchQueue = queue.getBatchQueue();
			}

			catch (Exception e) {
				batch.sendNotifyException(e);
			}

		}
		try {
			logger.debug("[batch] sleeping");
			wait();
		} catch (InterruptedException e) {
			logger.error(e.toString());
		}

	}

	public synchronized void wakeup() {
		logger.debug("[batch] waking up from wakeup....");
		// seems to be happening here. what if you send an notify that is
		// not in wait state

		notify();

	}
}