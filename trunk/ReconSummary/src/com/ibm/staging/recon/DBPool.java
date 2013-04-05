package com.ibm.staging.recon;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBPool {

	public Connection getBravoConnection() throws SQLException {

		try {
			Class.forName("COM.ibm.db2.jdbc.app.DB2Driver").newInstance();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		String bravoURL = "jdbc:db2:TRAILS";
		return DriverManager.getConnection(bravoURL, "eaadmin", "Bearw00n");

	}

	public Connection getStagingConnection() throws SQLException {
		String stagingURL = "jdbc:db2:STAGING";
		return DriverManager.getConnection(stagingURL, "eaadmin", "apr03db2");

	}

}
