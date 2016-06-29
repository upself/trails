package com.ibm.asset.trails.aspect;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;


import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;


import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.DatabaseDeterminativeService;

@Aspect
public class ReportStatisticLogAspect {
	
	private DatabaseDeterminativeService dbdeterminativeService;
	private String persistenceDB;
	private String reportLogPath;

	public void setDbdeterminativeService(DatabaseDeterminativeService dbdeterminativeService) {
		this.dbdeterminativeService = dbdeterminativeService;
	}
	
	public void setReportLogPath(String reportLogPath){
		this.reportLogPath=reportLogPath;
	}
		
	@Around("execution(* com.ibm.asset.trails.service.ReportService.getFullReconciliationReport(..))")
	public void logAround(ProceedingJoinPoint joinPoint) throws Throwable {
		persistenceDB=dbdeterminativeService.getPersistenceDB();
        
		String filename = reportLogPath +File.separator+ "ReportDownLoadStatistic.txt";
        FileWriter f = new FileWriter(filename,true);
        PrintWriter pw = null;
        try {
            pw = new PrintWriter(f);
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd EEE HH:mm:ss.SSS",Locale.getDefault());
            Calendar cals = Calendar.getInstance();
            String stTime = dateFormat.format(cals.getTime()).toUpperCase();
            joinPoint.proceed();           
            Calendar cale = Calendar.getInstance();
            String endTime = dateFormat.format(cale.getTime()).toUpperCase();
            pw.printf(" " + ((Account) joinPoint.getArgs()[0]).getAccountAsLong()+","+(joinPoint.getArgs()[1])+","+(joinPoint.getArgs()[2])+","+persistenceDB+",StartTime : "+stTime+", EndTime : "+endTime+"\r\n");
            pw.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }finally{
            if(pw!=null){
                pw.close();
            }
        } 
	   }
}
