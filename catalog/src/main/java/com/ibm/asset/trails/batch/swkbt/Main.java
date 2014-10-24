package com.ibm.asset.trails.batch.swkbt;


import org.apache.log4j.PropertyConfigurator;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;

@Component
public class Main {

	private static final String SPRING_CONTEXT = "file:/opt/catalog/swkbt/conf/launch-context.xml";
//	private static final String SPRING_CONTEXT = "classpath:launch-context.xml";
	private static final String LOG4J_PROPERITES ="/opt/catalog/swkbt/conf/log4j.properties";

	public static void main(String[] args) {
		
		new ClassPathXmlApplicationContext(SPRING_CONTEXT);
		PropertyConfigurator.configure(LOG4J_PROPERITES);
	}
}
