package com.ibm.asset.hwlpar;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.ibm.asset.common.RowFileReader;
import com.ibm.asset.common.TestDBPool;

public class UpdateLparStatus {

	private static final String FILE_NAME = "/Users/IBM_ADMIN/Desktop/OS2_wrong_count_IDs.txt";

	private static final String UPDATE_INACTIVE_LPAR_STATUS = "update hardware_lpar set lpar_status ='INACTIVE' where id  = ?";
	private static final String QUERY_LPAR_STATUS = "select customer_id from hardware_lpar where id  = ?";
	private static final String INSERT_APPEND_TO_RECON = "insert into recon_hw_lpar(CUSTOMER_ID,HARDWARE_LPAR_ID, ACTION, REMOTE_USER ,RECORD_TIME) values (?,?,?,?,current timestamp)";

	public void upate() {

		try {

			List hwIds = new RowFileReader().read(FILE_NAME);

			Connection conn = TestDBPool.INSTANCE.getBravoConnection();
			conn.setAutoCommit(false);

			for (int i = 0; i < hwIds.size(); i++) {

				long hwLparId = Long.valueOf((String) hwIds.get(i)).longValue();
				PreparedStatement stmt = conn
						.prepareStatement(QUERY_LPAR_STATUS);
				stmt.setLong(1, hwLparId);
				ResultSet rs = stmt.executeQuery();
				long customerId = -1;
				while (rs.next()) {
					customerId = rs.getLong(1);
				}

				PreparedStatement updateLparStatus = conn
						.prepareStatement(UPDATE_INACTIVE_LPAR_STATUS);
				updateLparStatus.setLong(1, hwLparId);

				updateLparStatus.executeUpdate();

				PreparedStatement appendToRecon = conn
						.prepareStatement(INSERT_APPEND_TO_RECON);
				appendToRecon.setLong(1, customerId);
				appendToRecon.setLong(2, hwLparId);
				appendToRecon.setString(3, "UPDATE");
				appendToRecon.setString(4, "TOOL");

				appendToRecon.executeUpdate();

				conn.commit();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		new UpdateLparStatus().upate();
	}
}
