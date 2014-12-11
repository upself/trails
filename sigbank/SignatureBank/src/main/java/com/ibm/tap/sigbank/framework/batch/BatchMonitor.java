package com.ibm.tap.sigbank.framework.batch;

import java.util.Date;

import org.apache.log4j.Logger;

/**
 * 
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BatchMonitor {

	BatchQueue queue = new BatchQueue();

	static Logger logger = Logger.getLogger(BatchMonitor.class);

	boolean running = false;

	public synchronized void execute() {
		logger.debug("[batch] starting the load queue manager");

		IBatch batch = null;

		try {
			batch = queue.getBatch();
		} catch (Exception e) {
			logger.error(e, e);
		}

		while (batch != null) {
			try {
				batch.setStartTime(new Date());
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
				batch = queue.getBatch();
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