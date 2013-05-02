package com.ibm.asset.hwlpar;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.ibm.asset.common.DBPool;
import com.ibm.asset.common.RowFileReader;

public class UpdateLparStatus {

	private static final String FILE_NAME = "/home/zyizhang/OS2_wrong_count_IDs.txt";

	private static final String UPDATE_INACTIVE_LPAR_STATUS = "update hardware_lpar set lpar_status ='INACTIVE' where id  = ?";
	private static final String QUERY_LPAR_STATUS = "select customer_id from hardware_lpar where id  = ?";
	private static final String INSERT_APPEND_TO_RECON = "insert into recon_hw_lpar(CUSTOMER_ID,HARDWARE_LPAR_ID, ACTION, REMOTE_USER ,RECORD_TIME) values (?,?,?,?,current timestamp)";
	private static final String query_recon_hw_lpar = "select count(*) from recon_hw_lpar where hardware_lpar_id =?";
	private static final String query_hw_lpar = "select count(*) from hardware_lpar where id =?";

	public void upate() {

		try {

			List hwIds = new RowFileReader().read(FILE_NAME);

			Connection conn = DBPool.INSTANCE.getBravoConnection();
			conn.setAutoCommit(false);

			for (int i = 0; i < hwIds.size(); i++) {

				long hwLparId = Long.valueOf((String) hwIds.get(i)).longValue();

				System.out.println(i + ":" + hwLparId);
				int exists = fetchCount(conn, hwLparId, query_hw_lpar);
				if (exists <= 0) {
					System.out.println(hwLparId + " not exists");
					continue;
				}

				PreparedStatement stmt = conn
						.prepareStatement(QUERY_LPAR_STATUS);
				stmt.setLong(1, hwLparId);

				ResultSet rs = stmt.executeQuery();
				long customerId = -1;
				while (rs.next()) {
					customerId = rs.getLong(1);
				}
				stmt.close();

				PreparedStatement updateLparStatus = conn
						.prepareStatement(UPDATE_INACTIVE_LPAR_STATUS);
				updateLparStatus.setLong(1, hwLparId);

				updateLparStatus.executeUpdate();

				PreparedStatement appendToRecon = null;
				int count = fetchCount(conn, hwLparId, query_recon_hw_lpar);
				if (count == 0) {

					appendToRecon = conn
							.prepareStatement(INSERT_APPEND_TO_RECON);
					appendToRecon.setLong(1, customerId);
					appendToRecon.setLong(2, hwLparId);
					appendToRecon.setString(3, "UPDATE");
					appendToRecon.setString(4, "TOOL");

					appendToRecon.executeUpdate();
				}
				conn.commit();

				updateLparStatus.close();
				if (appendToRecon != null) {
					appendToRecon.close();
				}

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private int fetchCount(Connection conn, long hwLparId, String query)
			throws SQLException {
		PreparedStatement stmt2 = conn.prepareStatement(query);
		stmt2.setLong(1, hwLparId);

		ResultSet rs2 = stmt2.executeQuery();
		int count = 0;
		while (rs2.next()) {
			count = rs2.getInt(1);
		}
		stmt2.close();
		return count;
	}

	public static void main(String[] args) {
		new UpdateLparStatus().upate();
	}
}
