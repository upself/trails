import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;

public class Restore {

	private String filePath = "/var/ftp/EMEA/HISTORY_TABLES.txt";
	private Connection conn;
	private Properties prop;

	private final int DEBUG_LEVEL = 0;

	private int logLevel;

	private String queryInsertReconcileH = "INSERT INTO RECONCILE_H( "
			+ "INSTALLED_SOFTWARE_ID, "
			+ "RECONCILE_TYPE_ID, "
			+ "PARENT_INSTALLED_SOFTWARE_ID, "
			+ "COMMENTS, "
			+ "REMOTE_USER, "
			+ "RECORD_TIME, "
			+ "MACHINE_LEVEL, "
			+ "RECONCILE_H, "
			+ "MANUAL_BREAK "
			+ ") VALUES ( "
			+ "?, "
			+ "?, "
			+ "?, "
			+ "?, "
			+ "?, "
			+ "?, "
			+ "?, "
			+ "?, "
			+ "? "
			+ ") ";

	private String queryInsertHUsedLicense = "INSERT INTO H_USED_LICENSE( "
			+ "LICENSE_ID, "
			+ "USED_QUANTITY, "
			+ "CAPACITY_TYPE_ID "
			+ ") VALUES ( "
			+ "?, "
			+ "?, "
			+ "? "
			+ ") "
			+ "";

	private String queryInsertMapping = "INSERT INTO H_RECONCILE_USED_LICENSE( "
			+ "H_RECONCILE_ID, "
			+ "H_USED_LICENSE_ID "
			+ ") VALUES ( "
			+ "?, "
			+ "? "
			+ ") ";

	public Restore(String path, String historyPath, int logLevel) {
		this.filePath = historyPath;
		this.logLevel = logLevel;
		prop = new Properties();
		try {
			prop.load(new FileInputStream(new File(path)));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void loadFile() {
		BufferedReader read = null;
		try {
			read = new BufferedReader(new FileReader(new File(filePath)));
			String str = null;
			boolean head = true;

			int rowCounter = -1;
			while ((str = read.readLine()) != null) {
				rowCounter++;
				if (head || str.trim().length() == 0) {
					head = false;
					continue;
				}

				String[] values = str.split("\t", -1);

				ReconcileHistory reconcileHistory = new ReconcileHistory();
				reconcileHistory.pharse(values);

				UsedLicenseHistory usedLicenseHistory = new UsedLicenseHistory();
				usedLicenseHistory.pharse(values);

				this.persist(reconcileHistory, usedLicenseHistory, rowCounter);
			}
			read.close();
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

	}

	public void persist(ReconcileHistory rh, UsedLicenseHistory ulh, int rowNO) {

		try {
			if (conn == null) {
				printout("connect start", DEBUG_LEVEL);
				Class.forName(prop.getProperty("driver"));
				conn = DriverManager.getConnection(prop.getProperty("url"),
						prop.getProperty("user"), prop.getProperty("password"));
				printout("connect end", DEBUG_LEVEL);
			}

			printout("persist start", DEBUG_LEVEL);
			boolean exists = persistReconcile(rh);
			persisUsedLicense(ulh);
			persisMapping(rh, ulh);
			printout("persist end", DEBUG_LEVEL);

			if (rowNO != 0 && rowNO % 150 == 0) {
				if (conn != null) {
					conn.commit();
					conn.close();
					conn = null;
				}
			}

			if (exists) {
				System.out.println("EXISTS:row="
						+ rowNO
						+ ",rId="
						+ rh.id
						+ ",ulId="
						+ ulh.id);
			} else {
				System.out.println("NEW:row="
						+ rowNO
						+ ",rId="
						+ rh.id
						+ ",ulId="
						+ ulh.id);
			}

		} catch (SQLException e) {
			System.out.println("ERROR:row="
					+ rowNO
					+ ",rId="
					+ rh.id
					+ ",ulId="
					+ ulh.id
					+ ",MSG:"
					+ e.getMessage());
			System.out.println("cause:" + e.getCause());
		} catch (ClassNotFoundException e) {
			System.out.println("ERROR:row="
					+ rowNO
					+ ",rId="
					+ rh.id
					+ ",ulId="
					+ ulh.id
					+ ",MSG:"
					+ e.getMessage());
		}
	}

	private void persisMapping(ReconcileHistory rh, UsedLicenseHistory ulh)
			throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(queryInsertMapping);
			stmt.setLong(1, rh.id);
			stmt.setLong(2, ulh.id);
			stmt.executeUpdate();

			printout("mapping created rhId=" + rh.id + " ulhId=" + ulh.id,
					DEBUG_LEVEL);
		} finally {
			if (stmt != null) {
				try {
					stmt.close();
					stmt = null;
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}

	private void persisUsedLicense(UsedLicenseHistory ulh) throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(queryInsertHUsedLicense,
					Statement.RETURN_GENERATED_KEYS);
			stmt.setLong(1, ulh.licenseId);
			stmt.setInt(2, ulh.usedQuantity);
			stmt.setByte(3, ulh.capacityTypeId);
			stmt.executeUpdate();
			ResultSet ids = stmt.getGeneratedKeys();
			if (ids.next()) {
				ulh.id = ids.getLong(1);
			}

			printout("used license created, id=" + ulh.id, DEBUG_LEVEL);

		} finally {
			if (stmt != null) {
				try {
					stmt.close();
					stmt = null;
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}

	private void printout(String content, int level) {
		if (this.logLevel == level) {
			System.out.println(content);
		}

	}

	private boolean persistReconcile(ReconcileHistory rh) throws SQLException {
		boolean exists = false;
		PreparedStatement stmt = null;
		try {
			stmt = conn
					.prepareStatement("select id from reconcile_h where installed_software_id  = ? with ur");

			stmt.setLong(1, rh.installedSoftwareId);
			ResultSet result = stmt.executeQuery();
			if (result.next()) {
				rh.id = result.getLong(1);
				exists = true;
				printout("Reconcile exists, id=" + rh.id, DEBUG_LEVEL);
			} else {
				stmt = conn.prepareStatement(queryInsertReconcileH,
						Statement.RETURN_GENERATED_KEYS);
				stmt.setLong(1, rh.installedSoftwareId);
				stmt.setByte(2, rh.reconcileTypeId);
				stmt.setLong(3, rh.parentInstalledSoftwareId);
				stmt.setString(4, rh.comments);
				stmt.setString(5, rh.remoteUser);
				stmt.setTimestamp(6, rh.recordTime);
				stmt.setByte(7, rh.machineLevel);
				stmt.setByte(8, rh.reconcileH);
				stmt.setByte(9, rh.manualBreak);
				stmt.executeUpdate();

				ResultSet ids = stmt.getGeneratedKeys();
				if (ids.next()) {
					rh.id = ids.getLong(1);
				}
				printout("Reconcile created, id=" + rh.id, DEBUG_LEVEL);
			}
		} finally {
			if (stmt != null) {
				try {
					stmt.close();
					stmt = null;
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}

		return exists;
	}

	public static void main(String[] args) {
		int logLevel = -1;
		if (args.length == 3) {
			logLevel = Integer.valueOf(args[2]).intValue();
		}
		new Restore(args[0], args[1], logLevel).loadFile();
	}

	class ReconcileHistory {

		private long installedSoftwareId;
		private byte reconcileTypeId;
		private long id;
		private long parentInstalledSoftwareId;
		private String comments;
		private String remoteUser;
		private Timestamp recordTime;
		private byte machineLevel;
		private byte reconcileH;
		private byte manualBreak;

		public void pharse(String[] str) {
			for (int i = 0; i < str.length; i++) {
				switch (i) {
				case 0:
					this.installedSoftwareId = Long.valueOf(str[0]).longValue();
					break;
				case 1:
					this.reconcileTypeId = Byte.valueOf(str[1]).byteValue();
					break;
				case 2:
					this.id = -1;
					break;
				case 3:
					this.parentInstalledSoftwareId = Long.valueOf(str[3])
							.longValue();
					break;
				case 4:
					this.comments = str[4];
					break;
				case 5:
					this.remoteUser = str[5];
					break;
				case 6:
					DateFormat df = new SimpleDateFormat(
							"yyyy-MM-dd-HH.mm.ss.SSSSSSS");
					try {
						this.recordTime = new Timestamp(df.parse(str[6])
								.getTime());

					} catch (ParseException e) {
						e.printStackTrace();
					}
					break;
				case 7:
					this.machineLevel = Byte.valueOf(str[7]).byteValue();
					break;
				case 8:
					this.reconcileH = Byte.valueOf(str[8]).byteValue();
					break;
				case 9:
					this.manualBreak = Byte.valueOf(str[9]).byteValue();
					break;
				default:
					break;
				}
			}

		}
	}

	class UsedLicenseHistory {

		private long id;
		private long licenseId;
		private int usedQuantity;
		private byte capacityTypeId;

		public void pharse(String[] str) {
			for (int i = 12; i < str.length; i++) {
				switch (i) {
				case 12:
					this.id = -1;
					break;
				case 13:
					this.licenseId = Long.valueOf(str[13]).longValue();
					break;
				case 14:
					this.usedQuantity = Integer.valueOf(str[14]).intValue();
					break;
				case 15:
					this.capacityTypeId = Byte.valueOf(str[15]).byteValue();
					break;
				default:
					break;
				}
			}
		}
	}
}
