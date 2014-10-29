package com.ibm.tap.misld.quartz.listeners;

// Java utilities
import java.util.Date;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;

import com.ibm.tap.misld.quartz.jobs.DailyPriceReportEscalationJob;


public class DailyPriceReportEscalationListener implements ServletContextListener {

    public static final String QUARTZ_FACTORY_KEY = "org.quartz.impl.StdSchedulerFactory.KEY";
    	 
    public void contextInitialized(ServletContextEvent sce) {
    //	System.out.println("MS Wizard DailyPriceReportEscalation has been disabled");
    //}

    	System.out.println("Entered into DailyPriceReportEscalation at " + new Date() + "....................>>>>>>>");
    	String factoryKey = sce.getServletContext().getInitParameter("servlet-context-factory-key");
    	if (factoryKey == null) {
    		factoryKey = QUARTZ_FACTORY_KEY;
    	}

    	StdSchedulerFactory sf = (StdSchedulerFactory) sce.getServletContext().getAttribute(factoryKey);
    	
    
    	try {
    	    Scheduler sched=sf.getScheduler();
    	   
    	    JobDetail jd=new JobDetail("DailyPriceReportEscalationJob","Daily Job Group", DailyPriceReportEscalationJob.class);
    	    
    	    CronTrigger st=new CronTrigger("DailyPriceReportEscalationTrigger","Daily Job Group", "0 0 2 ? * MON-FRI");
   	    
    	    sched.scheduleJob(jd, st);
    	    
    	} catch (Exception ex) {
    	}
    }
    	  
    public void contextDestroyed(ServletContextEvent sce) {
    	   
    }
    
}