package com.ibm.asset.trails.batch.swkbt.writer;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.ItemWriter;

import com.ibm.asset.swkbt.schema.SwkbType;

public class SwkbtSourceWriter<E> implements ItemWriter<E>,StepExecutionListener { 
	private static final Logger logger = Logger
			.getLogger(SwkbtSourceWriter.class);
    private StepExecution stepExecution;
    private String definitionSource;
	private String SOURCE_KEY_NAME = "sourceName";

	public void write(List<? extends E> items) throws Exception {
		logger.debug("Ready to write from SwkbtSourceWriter -- " + items.size()); 
		for (E item : items) {
			save((SwkbType) item);
			logger.debug("Saved " + item.toString());
		}

	}

	public void save(SwkbType xmlEntity) throws Exception {
	        if( xmlEntity.getDatabaseInstanceName().contains("SwKBT")){
	        	definitionSource = "SWKBT";
	        } else if( xmlEntity.getDatabaseInstanceName().contains("z/OS")){
            	definitionSource = "TADZ";
	        } else {
	        	definitionSource = "UNKNOWN";
	        }
	        ExecutionContext stepContext = this.stepExecution.getExecutionContext();
	        stepContext.put(SOURCE_KEY_NAME,definitionSource);
	        logger.debug("Saving deinifiontSource --" + definitionSource);
	    	System.out.print("***************here comes Definitionsource "+definitionSource);
	}
	
	public ExitStatus afterStep(StepExecution stepExecution) {
		ExecutionContext executionContext = stepExecution.getExecutionContext();
			
		return null;
	}

	public void beforeStep(StepExecution stepExecution) {
		this.stepExecution = stepExecution;
	}
}
