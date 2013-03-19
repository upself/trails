package com.ibm.staging.recon;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ibm.staging.template.AccountDateQty;
import com.ibm.staging.template.Result;
import com.ibm.staging.template.TableQty;

public class Summary {
	private static final String summaryFullQty = "select count(*) from v_recon_queue with ur";
	private static final String p1List = "select c.customer_id, c.account_number,c.customer_name, date(record_time), count(*) from v_recon_queue v, customer c where v.customer_id  = c.customer_id and v.customer_id in ( 12476,9754) group by c.customer_id, c.account_number,c.customer_name,date(v.record_time) order by date(v.record_time) fetch first 50 rows only with ur";
	private static final String p1TableQty = "select v.table, count(*) from v_recon_queue v where v.customer_id in (12476,9754) group by v.table with ur";

	private static final String queryP21 = "select count(distinct v.customer_id) from v_recon_queue v, customer c where v.customer_id  = c.customer_id and c.customer_type_id not in(172, 173, 222, 224, 217) and c.customer_id != 999999 with ur";
	private static final String queryP22 = "select count(*) from v_recon_queue v, customer c where v.customer_id  = c.customer_id and c.customer_type_id not in(172, 173, 222, 224, 217) and c.customer_id != 999999 with ur";
	private static final String queryP23 = "select c.customer_id, c.account_number,c.customer_name, date(record_time), count(*) from v_recon_queue v, customer c where v.customer_id  = c.customer_id and c.customer_type_id not in(172, 173, 222, 224, 217) and c.customer_id !=999999 group by c.customer_id, c.account_number, c.customer_name, date(record_time) order by date(v.record_time) fetch first 10 rows only with ur";
	private static final String queryP24 = "select v.table, count(*) from v_recon_queue v,customer c where v.customer_id = c.customer_id and c.customer_type_id not in (172, 173, 222, 224, 217) and c.customer_id  != 999999 group by v.table with ur";

	private static final String queryP31 = "select count(distinct v.customer_id) from v_recon_queue v, customer c where v.customer_id  = c.customer_id and c.customer_type_id  in (172, 173, 222, 224, 217) with ur";
	private static final String queryP32 = "select count(*) from v_recon_queue v, customer c where v.customer_id  = c.customer_id and c.customer_type_id in(172, 173, 222, 224, 217) with ur";
	private static final String queryP33 = "select c.customer_id, c.account_number,c.customer_name, date(record_time), count(*) from v_recon_queue v, customer c where v.customer_id  = c.customer_id and c.customer_type_id in (172, 173, 222, 224, 217)  group by c.customer_id, c.account_number, c.customer_name, date(record_time) order by date(v.record_time) fetch first 10 rows only with ur";
	private static final String queryP34 = "select v.table, count(*) from v_recon_queue v,customer c where v.customer_id = c.customer_id and c.customer_type_id in (172, 173, 222, 224, 217) group by v.table with ur";

	private static String query41 = "select count(*) from v_recon_queue where customer_id  = 999999 with ur";
	private static String query42 = "select v.table,count(*) from v_recon_queue v group by v.table with ur";

	private static String query51 = "select v.customer_id, count(*) from v_recon_queue v where v.customer_id in (select master_account_id from account_pool) or v.customer_id in (select member_account_id from account_pool) group by v.customer_id order by count(*) desc fetch first 1 rows only with ur";
	private static String query52 = "select table, count(*) from v_recon_queue where customer_id in (select member_account_id from account_pool where master_account_id  = ?) group by table";

	public static void main(String[] args) {
		try {
			Class.forName("COM.ibm.db2.jdbc.app.DB2Driver").newInstance();
			String url = "jdbc:db2:TRAILS";
			Connection conn = DriverManager.getConnection(url, "eaadmin",
					"Bearw00n");

			// Class.forName("com.ibm.db2.jcc.DB2Driver").newInstance();
			// String url =
			// "jdbc:db2://dst20lp05.boulder.ibm.com:50010/TRAILSPD";
			// Connection conn = DriverManager.getConnection(url, "eaadmin",
			// "may2012a");

			Result result = new Result();
			Map parameter = result.getParameter();

			Statement stmt = conn.createStatement();

			// summary
			ResultSet rs = stmt.executeQuery(summaryFullQty);
			while (rs.next()) {
				parameter.put(Result.SUMMARY_TOTAL, rs.getString(1));
			}

			// p1
			p1(parameter, stmt);

			// p2
			p2(parameter, stmt);

			// p3
			p3(parameter, stmt);
			//
			p4(parameter, stmt);

			p5(parameter, stmt, conn);

			result.build();
			result.output();

			rs.close();
			stmt.close();
			conn.close();

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	private static void p5(Map parameter, Statement stmt, Connection conn)
			throws SQLException {
		ResultSet rs = null;
		// rs = stmt.executeQuery(query51);
		String poolCustomerId = "9000";
		// while (rs.next()) {
		// poolCustomerId = rs.getString(1);
		// }
		parameter.put(Result.P51, poolCustomerId);

		PreparedStatement ps = conn.prepareStatement(query52);
		ps.setString(1, poolCustomerId);
		rs = ps.executeQuery();

		List tableQtyList = new ArrayList();
		while (rs.next()) {
			TableQty tableQty = new TableQty();
			tableQty.setName(rs.getString(1));
			tableQty.setQty(rs.getInt(2));

			tableQtyList.add(tableQty);
		}
		parameter.put(Result.P52, tableQtyList);
	}

	private static void p4(Map parameter, Statement stmt) throws SQLException {
		ResultSet rs;
		rs = stmt.executeQuery(query41);
		while (rs.next()) {
			parameter.put(Result.P41, rs.getString(1));
		}

		rs = stmt.executeQuery(query42);
		List tableQtyList = new ArrayList();
		while (rs.next()) {
			TableQty tableQty = new TableQty();
			tableQty.setName(rs.getString(1));
			tableQty.setQty(rs.getInt(2));

			tableQtyList.add(tableQty);
		}
		parameter.put(Result.P42, tableQtyList);

	}

	private static void p3(Map parameter, Statement stmt) throws SQLException {
		ResultSet rs;
		rs = stmt.executeQuery(queryP31);
		while (rs.next()) {
			parameter.put(Result.P31, rs.getString(1));
		}

		rs = stmt.executeQuery(queryP32);
		while (rs.next()) {
			parameter.put(Result.P32, rs.getString(1));
		}

		rs = stmt.executeQuery(queryP33);
		int i = 1;
		List accountDateQtyList = new ArrayList();
		while (rs.next()) {
			AccountDateQty l = new AccountDateQty();
			l.setIndex(i++);
			l.setCustomerId(rs.getLong(1));
			l.setAccountNumber(rs.getLong(2));
			l.setAccountName(rs.getString(3));
			l.setRecordDate(rs.getDate(4));
			l.setQty(rs.getInt(5));

			accountDateQtyList.add(l);
		}
		parameter.put(Result.P33, accountDateQtyList);

		rs = stmt.executeQuery(queryP34);
		List tableQtyList = new ArrayList();
		while (rs.next()) {
			TableQty tableQty = new TableQty();
			tableQty.setName(rs.getString(1));
			tableQty.setQty(rs.getInt(2));

			tableQtyList.add(tableQty);
		}
		parameter.put(Result.P34, tableQtyList);

	}

	private static void p1(Map parameter, Statement stmt) throws SQLException {
		ResultSet rs;
		rs = stmt.executeQuery(p1List);
		int i = 1;
		List p1ListR = new ArrayList();
		while (rs.next()) {
			AccountDateQty l = new AccountDateQty();
			l.setIndex(i++);
			l.setCustomerId(rs.getLong(1));
			l.setAccountNumber(rs.getLong(2));
			l.setAccountName(rs.getString(3));
			l.setRecordDate(rs.getDate(4));
			l.setQty(rs.getInt(5));

			p1ListR.add(l);
		}
		parameter.put(Result.P11, p1ListR);

		rs = stmt.executeQuery(p1TableQty);
		List p1TableQty = new ArrayList();
		while (rs.next()) {
			TableQty tableQty = new TableQty();
			tableQty.setName(rs.getString(1));
			tableQty.setQty(rs.getInt(2));

			p1TableQty.add(tableQty);
		}
		parameter.put(Result.P12, p1TableQty);
	}

	private static void p2(Map parameter, Statement stmt) throws SQLException {
		ResultSet rs;
		int i;
		rs = stmt.executeQuery(queryP21);
		while (rs.next()) {
			parameter.put(Result.P21, rs.getString(1));
		}

		rs = stmt.executeQuery(queryP22);
		while (rs.next()) {
			parameter.put(Result.P22, rs.getString(1));
		}

		rs = stmt.executeQuery(queryP23);
		i = 1;
		List accountDateQtyList = new ArrayList();
		while (rs.next()) {
			AccountDateQty l = new AccountDateQty();
			l.setIndex(i++);
			l.setCustomerId(rs.getLong(1));
			l.setAccountNumber(rs.getLong(2));
			l.setAccountName(rs.getString(3));
			l.setRecordDate(rs.getDate(4));
			l.setQty(rs.getInt(5));

			accountDateQtyList.add(l);
		}
		parameter.put(Result.P23, accountDateQtyList);

		rs = stmt.executeQuery(queryP24);
		List tableQtyList = new ArrayList();
		while (rs.next()) {
			TableQty tableQty = new TableQty();
			tableQty.setName(rs.getString(1));
			tableQty.setQty(rs.getInt(2));

			tableQtyList.add(tableQty);
		}
		parameter.put(Result.P24, tableQtyList);
	}
}
