package com.ibm.asset.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestDBPool {

	public final static TestDBPool INSTANCE = new TestDBPool();

	private Connection bravoConn, stagingConn;

	private TestDBPool() {
		try {
			Class.forName("com.ibm.db2.jcc.DB2Driver").newInstance();
			String bravoURL = "jdbc:db2://dst20lp05.boulder.ibm.com:50010/TRAILSPD";
			bravoConn = DriverManager.getConnection(bravoURL, "eaadmin",
					"may2012a");

			String stagingURL = "jdbc:db2://tap2.raleigh.ibm.com:50000/STAGING";
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
