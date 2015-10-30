package com.ibm.cyclone.component;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

public class CPTPropertiesLoader extends AbstractXMLCPT {

	private Properties properties = new Properties();
	private String name;

	public CPTPropertiesLoader(String path, String name) {
		super("propertyLoader", path);
		this.name = name;
	}

	public String getProperty(String key) {
		return (String) this.properties.get(key);
	}

	public void execute() {

		try {
			parse();
		} catch (ParserConfigurationException e1) {
			e1.printStackTrace();
		} catch (SAXException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		String path = element.getAttribute("path");

		InputStream in = null;
		try {
			in = new FileInputStream(path);
			properties.load(in);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	@Override
	protected String getElementName() {
		return this.name;
	}

}
