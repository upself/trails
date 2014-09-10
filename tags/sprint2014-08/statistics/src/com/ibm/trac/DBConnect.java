/**
 * 
 */
package com.ibm.trac;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * @author zhangyi
 * 
 */
public class DBConnect {

	private static final String confFile = "/var/trac/swtools/conf/statistic.txt";

	private static String tracDBURL = "/opt/trac/trac.db";
	private static String statisticDBURL = "/opt/trac/statistic.db";

	private static DBConnect conn;

	private Connection tracConnection;
	private Connection statisticConnection;

	/**
	 * 
	 */
	private DBConnect() {
		File file = new File(confFile);
		if (file.exists()) {
			try {
				Properties prop = new Properties();
				prop.load(new FileInputStream(file));
				tracDBURL = prop.getProperty("tracDBURL");
				statisticDBURL = prop.getProperty("statisticDBURL");

			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static DBConnect getInstance() {
		if (conn == null) {
			conn = new DBConnect();
		}
		return conn;
	}

	public Connection getTracConn() {

		if (tracConnection == null) {
			try {
				Class.forName("org.sqlite.JDBC");
				tracConnection = DriverManager.getConnection("jdbc:sqlite:"
						+ tracDBURL);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return tracConnection;

	}

	public Connection getStatisticConn() {

		if (statisticConnection == null) {
			try {
				Class.forName("org.sqlite.JDBC");
				statisticConnection = DriverManager
						.getConnection("jdbc:sqlite:" + statisticDBURL);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return statisticConnection;
	}

}
