package com.ibm.asset.staging.signature;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.ibm.asset.common.DBPool;
import com.ibm.asset.common.FileContentReader;
import com.ibm.asset.common.TestDBPool;

public class SetUniqueInstalledType {

	private String updateSS;
	private String filePath;
	private boolean test;

	private String queryBySrIdSwId;

	private StringBuffer completeIds = new StringBuffer();

	public SetUniqueInstalledType(String table, String sqlFilePath, boolean test)
			throws Exception {
		updateSS = "update " + table + " set action = ? where id  in(";
		queryBySrIdSwId = "select id from "
				+ table
				+ " where action = 'UPDATE' and scan_record_id  = ? and software_id  = ?";
		filePath = sqlFilePath;
		this.test = test;
	}

	public void update() {
		Connection conn = null;
		try {
			FileContentReader reader = new FileContentReader();
			String query = reader.read(this.filePath);

			if (test) {
				conn = TestDBPool.INSTANCE.getStagingConnection();
			} else {
				conn = DBPool.INSTANCE.getStagingConnection();
			}

			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(query);

			int monitor = 0;
			int updateCounter = 0;
			while (rs.next()) {
				monitor++;
				if (monitor % 100 == 0) {
					System.out.println("processed:" + monitor);
					System.out.println(updateCounter
							+ " action of installed types set to COMPLETE");
				}
				long scanRecordId = rs.getLong(1);
				long softwareId = rs.getLong(2);

				updateCounter += processAction(conn, scanRecordId, softwareId);
				updateAction(conn, "COMPLETE", completeIds.toString());
				completeIds = new StringBuffer();
			}
			stmt.close();

			System.out.println("processed:" + monitor);
			System.out.println(updateCounter
					+ " action of installed types set to COMPLETE");
			System.out.println("process finished");

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}

	}

	private int processAction(Connection conn, long scanRecordId,
			long softwareId) {
		PreparedStatement stmt = null;
		int counter = 0;
		try {
			stmt = conn.prepareStatement(this.queryBySrIdSwId);
			stmt.setLong(1, scanRecordId);
			stmt.setLong(2, softwareId);
			ResultSet rs = stmt.executeQuery();
			boolean haveOneUpdated = false;
			while (rs.next()) {
				long installedTypeId = rs.getLong(1);

				if (!haveOneUpdated) {
					haveOneUpdated = true;
					continue;
				}

				if (completeIds.length() != 0) {
					completeIds.append(",");
				}
				completeIds.append(String.valueOf(installedTypeId));
				counter++;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return counter;
	}

	private void updateAction(Connection conn, String action, String ids)
			throws SQLException {
		if (ids.length() == 0) {
			return;
		}
		String query = updateSS + ids + ")";
		PreparedStatement pstmt = conn.prepareStatement(query);
		pstmt.setString(1, action);
		pstmt.executeUpdate();
		pstmt.close();
	}

	public static void main(String[] args) {
		try {
			new SetUniqueInstalledType(args[0], args[1], args[2].equals("1"))
					.update();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
