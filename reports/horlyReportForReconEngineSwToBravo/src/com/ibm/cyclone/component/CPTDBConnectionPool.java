package com.ibm.cyclone.component;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

public class CPTDBConnectionPool extends AbstractXMLCPT {

	private Map<String, Connection> map;

	public final static CPTDBConnectionPool INSTANCE = new CPTDBConnectionPool();

	private String name;

	private CPTDBConnectionPool() {
		super("connection");
	}

	public Connection getConnection(String name) {
		if (map == null) {
			map = new HashMap<String, Connection>();
		}

		Connection conn = map.get(name);
		if (conn == null) {

			this.name = name;
			try {
				super.parse();

				String url = element.getElementsByTagName("url").item(0)
						.getFirstChild().getNodeValue();
				String user = element.getElementsByTagName("user").item(0)
						.getFirstChild().getNodeValue();
				String password = element.getElementsByTagName("password")
						.item(0).getFirstChild().getNodeValue();

				String driver = element.getElementsByTagName("driver").item(0)
						.getFirstChild().getNodeValue();

				Class.forName(driver).newInstance();
				Connection connection = DriverManager.getConnection(url, user,
						password);

				map.put(name, connection);

			} catch (ParserConfigurationException e) {
				e.printStackTrace();
			} catch (SAXException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return map.get(name);
	}

	@Override
	protected String getElementName() {
		return this.name;
	}

	public void closeConnections() {
		if (map != null && map.size() > 0) {
			Set<String> keys = map.keySet();

			for (String key : keys) {
				Connection conn = map.get(key);
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
