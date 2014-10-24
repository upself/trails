package com.ibm.asset.trails.batch.swkbt;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobInstance;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.configuration.JobLocator;
import org.springframework.batch.core.configuration.JobRegistry;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.launch.JobOperator;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class loadTadz {

	private static final String SPRING_CONTEXT = "file:/opt/catalog/swkbt/conf/launch-context.xml";

	public static void main(String[] args) {
		ConfigurableApplicationContext context = null;
		JobLauncher launcher;
		context = new ClassPathXmlApplicationContext(SPRING_CONTEXT);
		JobLocator jobLocator;
		JobExecution jobExecution;
		  
		 		try {
		  			Job job;
		   				job = (Job) context.getBean("swkbtLoadJob");
//		   				jobExecution = new JobExecution(jobInstance);
//		   				job.execute(jobExecution);
		   		}
		   		catch (Throwable e) {
		   			System.out.println(e.getLocalizedMessage());
		   		}
		   		finally {
		   			if (context != null) {
		   				context.close();
		   			}
		  		}		
		
	}
}
