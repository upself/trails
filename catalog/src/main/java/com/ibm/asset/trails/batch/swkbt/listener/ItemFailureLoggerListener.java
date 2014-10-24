package com.ibm.asset.trails.batch.swkbt.listener;

import org.apache.log4j.Logger;
import org.springframework.batch.core.listener.ItemListenerSupport;

public class ItemFailureLoggerListener extends ItemListenerSupport {
	
	private static final Logger logger = Logger
			.getLogger(ItemFailureLoggerListener.class);


    public void onReadError(Exception ex) {
        logger.error("Encountered error on read", ex);
    }

    public void onWriteError(Exception ex, Object item) {
        logger.error("Encountered error on write", ex);
    }

}