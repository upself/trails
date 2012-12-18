package com.ibm.ea.bravo.framework.batch;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;

import com.ibm.ea.bravo.framework.common.Constants;

public class BatchProcessor extends TimerTask implements PlugIn {
	
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(BatchProcessor.class);

    private Timer timer = new Timer();
    private BatchQueue queue = new BatchQueue();


    // init is called when the Plugin initializes
	public void init(ActionServlet servlet, ModuleConfig config) throws ServletException {
		
		// start up the timer to execute the Batch's run method at the given frequency
		logger.info("start Batch plugin");
		this.timer.scheduleAtFixedRate(this, Constants.BATCH_PLUGIN_DELAY_SECS, Constants.BATCH_PLUGIN_PERIOD_SECS);
	}
	
	// destroy is called when the Plugin is destroyed
	public void destroy() {
		// kill the timer thread
		logger.info("stop Batch plugin");
		this.timer.cancel();
	}
		
	// run is called for each execution of the timer
	public void run() {
		IBatch batch = null;

		while((batch = this.queue.popBatch()) != null) {
			
			try {
	        	batch.setStartTime(new Date());
	            batch.validate();
	            batch.execute();
	            batch.sendNotify();
			} catch (Exception e) {
                batch.sendNotifyException(e);
			}
		}
	}

}