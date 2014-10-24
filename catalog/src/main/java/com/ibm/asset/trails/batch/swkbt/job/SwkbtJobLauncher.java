package com.ibm.asset.trails.batch.swkbt.job;

import java.io.File;
import java.util.Date;

import org.apache.log4j.Logger;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.JobParametersInvalidException;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.repository.JobExecutionAlreadyRunningException;
import org.springframework.batch.core.repository.JobInstanceAlreadyCompleteException;
import org.springframework.batch.core.repository.JobRestartException;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.batch.swkbt.writer.TrailsSwkbtWriter;

public class SwkbtJobLauncher {
	
	private static final Logger logger = Logger
			.getLogger(SwkbtJobLauncher.class);


	@Autowired
	private Job job;

	@Autowired
	private JobLauncher jobLauncher;

	public File handleCanonicalFile(File file)
			throws JobExecutionAlreadyRunningException, JobRestartException,
			JobInstanceAlreadyCompleteException, JobParametersInvalidException {
		

		JobParametersBuilder builder = new JobParametersBuilder();
		builder.addString("input.file", file.getAbsolutePath()).addDate("date",
				new Date(System.currentTimeMillis()));
		logger.debug(job.getName() + " is starting to handle file: "+ file.getAbsolutePath());

		jobLauncher.run(job, builder.toJobParameters());
		return file;
	}

	public void setJobLauncher(JobLauncher jobLauncher) {
		this.jobLauncher = jobLauncher;
	}

}
