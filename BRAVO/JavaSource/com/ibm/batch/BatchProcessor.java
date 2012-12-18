/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.batch;

import java.io.IOException;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BatchProcessor extends Thread {

	BatchMonitor batchMonitor = new BatchMonitor();

    private static final Logger logger       = Logger
                                                     .getLogger(BatchProcessor.class);

	Queue queue = new Queue();

	public void run() {
		while (true) {

			batchMonitor.execute();

			try {
				sleep(2000);
			} catch (InterruptedException e) {
				logger.error(e, e);
			}
		}
	}

	public synchronized void addQueue(IBatch batch) throws HibernateException,
			SQLException, IOException, NamingException {

		logger.info("batch]  adding batch " + batch.getName() + "  to the que");

		if (queue.isEmpty()) {
			logger.debug("[batch] empty queue, adding on to queue");
			queue.addBatch(batch);

			logger.debug("[batch] waking up from addQueue");
			batchMonitor.wakeup();
		} else {
			logger.debug("[batch]  batch is not empty, so just add on");

			queue.addBatch(batch);
		}

		logger.debug("leaving...");
	}

	public synchronized void wakeup() {
		batchMonitor.wakeup();
	}

}