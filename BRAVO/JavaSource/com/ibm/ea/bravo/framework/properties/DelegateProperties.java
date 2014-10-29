/*
 * Created on Mar 18, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.properties;

import java.io.FileInputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.DelegateBase;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class DelegateProperties extends DelegateBase {
	
	private static Map<String, Properties> propertiesMap = new HashMap<String, Properties>();
	private static final Logger logger = Logger.getLogger(DelegateProperties.class);
	
	public static void initializeProperties() throws Exception {
		
		List<String> list = Arrays.asList(Constants.PROPERTY_FILES);
		
		if (list == null)
			return;
		
		Iterator<String> i = list.iterator();
		while (i.hasNext()) {
			String propertyFile = (String) i.next();
			
			try {
				
				Properties properties = new Properties();
				properties.load(new FileInputStream(propertyFile));
				
				propertiesMap.put(propertyFile, properties);
				
			} catch (Exception e) {
				logger.error(e);
				continue;
			}
		}
	}
	
	public static String getProperty(String propertyFile, String key) {
		Properties properties = (Properties) propertiesMap.get(propertyFile);
		
		return properties == null ? null : properties.getProperty(key);
	}
	
	public static void dumpProperties(String propertyFile) {
		Properties properties = (Properties) propertiesMap.get(propertyFile);
		if (properties == null) return;
		
		logger.debug(propertyFile + " properties");
		
		Iterator<Object> i = properties.keySet().iterator();
		while (i.hasNext()) {
			String key = (String) i.next();
			String value = properties.getProperty(key);
			
			logger.debug(key + " = " + value);
		}
	}
	
}
