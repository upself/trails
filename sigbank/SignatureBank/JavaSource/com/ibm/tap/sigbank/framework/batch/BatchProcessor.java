package com.ibm.tap.sigbank.framework.batch;

import org.apache.log4j.Logger;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BatchProcessor extends Thread {

	BatchMonitor batchMonitor = new BatchMonitor();

	static Logger logger = Logger.getLogger(BatchProcessor.class.getName());

	BatchQueue queue = new BatchQueue();

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

	public synchronized void addQueue(IBatch batch) {

		if (queue.isEmpty()) {
			queue.addBatch(batch);

			batchMonitor.wakeup();
		} else {

			queue.addBatch(batch);
		}

	}

	public synchronized void wakeup() {
		batchMonitor.wakeup();
	}

}