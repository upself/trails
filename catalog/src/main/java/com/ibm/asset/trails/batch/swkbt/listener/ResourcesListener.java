package com.ibm.asset.trails.batch.swkbt.listener;

import org.apache.log4j.Logger;
import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.listener.StepListenerSupport;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.core.io.Resource;
import com.ibm.asset.trails.batch.swkbt.service.impl.SwkbtLoaderServiceImpl;

public class ResourcesListener extends StepListenerSupport<Object, Object> {


	private String resourcesKeyName = "resourcesKeyName";
	
	private Resource[] resources = new Resource[0];
	
	private static final Logger logger = Logger
			.getLogger(ResourcesListener.class);


	public void setResources(Resource[] resources) {
		this.resources = resources;
	}
	
	@Override
	public  ExitStatus afterStep(StepExecution stepExecution) {
		ExecutionContext executionContext = stepExecution.getExecutionContext();
		logger.debug("Mapping Resources -- number: " + resources.length);
		if (resources.length <= 0) {
			logger.debug("Seeking resources again ! ");			
		}
		
		if (!executionContext.containsKey(resourcesKeyName)) {
			executionContext.put(resourcesKeyName,resources);
			return new ExitStatus("COMPLETED WITH RESOURCES");
		}
		return new ExitStatus("RESOURCES EXIST");
	}

}
