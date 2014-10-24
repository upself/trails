package com.ibm.asset.trails.batch.swkbt.listener;

import org.apache.log4j.Logger;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.listener.StepListenerSupport;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.beans.factory.annotation.Value;

import com.ibm.asset.trails.batch.swkbt.service.impl.SwkbtLoaderServiceImpl;

public class OutputFileListener extends StepListenerSupport<Object, Object> {

	@Value("${loader.dir}")
	private String outputDir;
	private String outputKeyName = "outputFile";
	private String inputKeyName = "elementName";
	
	private static final Logger logger = Logger
			.getLogger(OutputFileListener.class);

	public void setOutputKeyName(String outputKeyName) {
		this.outputKeyName = outputKeyName;
	}

	public void setInputKeyName(String inputKeyName) {
		this.inputKeyName = inputKeyName;
	}

	@Override
	public void beforeStep(StepExecution stepExecution) {
		ExecutionContext executionContext = stepExecution.getExecutionContext();
		if (executionContext.containsKey(inputKeyName)
				&& !executionContext.containsKey(outputKeyName)) {
			String inputName = executionContext.getString(inputKeyName);
			logger.debug("Working on File - " + inputName.toLowerCase() + ".xml");
			executionContext.putString(outputKeyName,
					outputDir + inputName.toLowerCase() + ".xml");
		}
	}

}
