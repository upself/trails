package com.ibm.tap.trails.framework;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class TrailsInitListener implements ServletContextListener {

	public void contextInitialized(ServletContextEvent sce) {
		String props = "/opt/trails/conf/trails.properties";
		
		String classPathRoot = PropertiesLoaderSupport.class.getResource("")
				.getPath();
		if (classPathRoot.indexOf("dst1185") != -1) {
			props = "/opt/trails/conf/trailsDST1185.properties";
		}

		Properties propsFromFile = new Properties();
		try {
			propsFromFile.load(new FileInputStream(new File(props)));
		} catch (IOException e) {
			e.printStackTrace();
		}

		String key = "app.root.name";
		System.setProperty(key, propsFromFile.getProperty(key));
	}

	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub

	}

}
