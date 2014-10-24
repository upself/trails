package com.ibm.asset.trails.batch.swkbt;

import java.io.File;

import org.apache.log4j.Logger;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.UnexpectedJobExecutionException;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.util.FileCopyUtils; 
import org.springframework.core.io.Resource;
import org.springframework.util.Assert;

import com.ibm.asset.trails.batch.swkbt.listener.OutputFileListener;

public class FileMovingTasklet implements Tasklet, InitializingBean {

	private static final Logger logger = Logger
			.getLogger(OutputFileListener.class);
	private Resource fromDirectory;
    private Resource toDirectory;

    public RepeatStatus execute(StepContribution contribution, 
                                ChunkContext chunkContext) throws Exception {
        File fromDir = fromDirectory.getFile();
        Assert.state(fromDir.isDirectory());
        File toDir = toDirectory.getFile();
        Assert.state(toDir.isDirectory()); 
        File[] fromfiles = fromDir.listFiles();
        File[] tofiles = toDir.listFiles();
    	logger.debug("Start move files ");
    	
        if (fromfiles != null ){
        for (int i = 0; i < fromfiles.length; i++) {
        	File cofile=new File(toDir.getAbsolutePath() + "/" + fromfiles[i].getName());
        	 logger.debug("From file " + fromDir.getAbsolutePath() + "/" + fromfiles[i].getName() + " TO " + "file " + toDir.getAbsolutePath() + "/" + cofile.getName());
// comment out lines to keep the attributes of destination files !
//          if (tofiles != null ){
//       	 for (int j = 0; j < tofiles.length; j++) {
//        		 if(fromfiles[i].getName().equals(tofiles[j].getName())){
//        			 logger.debug("File exists in destination directory , deleting file "+toDir.getAbsolutePath() +tofiles[j].getName());
//        			 boolean deleted = tofiles[j].delete();
//        	            if (!deleted) {
//        	                throw new UnexpectedJobExecutionException("Could not delete file " + 
//        	                		toDir.getAbsolutePath() + tofiles[j].getPath());
//        	            }
//        		 }
//        	 }
//           } 
        	   FileCopyUtils.copy(fromfiles[i],cofile);
           	logger.debug("Copying file  " + fromDir.getAbsolutePath() + "/" + fromfiles[i].getName());         
          }
        } else {
        	logger.debug("File source directory is null ");
        }
        return RepeatStatus.FINISHED;
    }

    public void setFromDirectory(Resource fromDirectory) {
        this.fromDirectory = fromDirectory;
    }
    
    public void setToDirectory(Resource toDirectory) {
        this.toDirectory = toDirectory;
    }

    public void afterPropertiesSet() throws Exception {
        Assert.notNull(fromDirectory, "directory must be set");
    }
}