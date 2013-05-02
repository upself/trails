package com.ibm.asset.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBPool {

	public final static DBPool INSTANCE = new DBPool();

	private Connection bravoConn, stagingConn;

	private DBPool() {
		try {
			Class.forName("COM.ibm.db2.jdbc.app.DB2Driver").newInstance();
			String bravoURL = "jdbc:db2:TRAILS";
			bravoConn = DriverManager.getConnection(bravoURL, "eaadmin",
					"Green8ay");

			String stagingURL = "jdbc:db2:STAGING";
			stagingConn = DriverManager.getConnection(stagingURL, "eaadmin",
					"apr03db2");
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public Connection getBravoConnection() {
		return bravoConn;
	}

	public Connection getStagingConnection() {
		return stagingConn;
	}
}
