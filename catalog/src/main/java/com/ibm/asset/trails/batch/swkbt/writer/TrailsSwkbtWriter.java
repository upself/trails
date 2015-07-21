package com.ibm.asset.trails.batch.swkbt.writer;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.batch.swkbt.service.SwkbtLoaderService;

public class TrailsSwkbtWriter<E> implements ItemWriter<E>,StepExecutionListener {
	
	private String source = "source";
	private static final Logger logger = Logger
			.getLogger(TrailsSwkbtWriter.class);


	@Autowired
	private SwkbtLoaderService<E> swkbtLoaderService;

	public void write(List<? extends E> items) throws Exception {
		logger.debug("Ready to write from TrailsSwkbtWriter -- " + items.size());
		swkbtLoaderService.batchUpdate(items,source);
	}

	public void setSwkbtLoaderService(SwkbtLoaderService<E> swkbtLoaderService) {
		this.swkbtLoaderService = swkbtLoaderService;
	}

	public void beforeStep(StepExecution stepExecution) {
		    JobExecution jobExecution = stepExecution.getJobExecution();
	        ExecutionContext jobContext = jobExecution.getExecutionContext();
	        this.source = (String) jobContext.get("sourceName");
	        logger.debug("Get Definition Source from TrailsSwkbtWriter -- " + source);
	}

	public ExitStatus afterStep(StepExecution stepExecution) {
		// TODO Auto-generated method stub
		return null;
	}
}
