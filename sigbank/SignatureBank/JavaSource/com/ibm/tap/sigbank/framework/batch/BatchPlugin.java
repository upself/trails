package com.ibm.tap.sigbank.framework.batch;

import javax.servlet.ServletException;

import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;

import com.ibm.tap.sigbank.framework.common.Constants;

/**
 * 
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BatchPlugin implements PlugIn {

	private BatchProcessor batchProcessor = new BatchProcessor();

	public void destroy() {
		// Nothing for now
	}

	public void init(ActionServlet servlet, ModuleConfig config)
			throws ServletException {

		batchProcessor.start();

		servlet.getServletContext().setAttribute(Constants.BATCH_FACTORY_KEY,
				this);
	}

	public void addBatch(IBatch batch) {
		batchProcessor.addQueue(batch);
	}

}