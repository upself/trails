package com.ibm.staging.recon;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ibm.cyclone.Metadata;
import com.ibm.cyclone.component.CPTDBConnectionPool;
import com.ibm.cyclone.component.CPTDBQuery;
import com.ibm.staging.template.AccountDateQty;
import com.ibm.staging.template.Customer;
import com.ibm.staging.template.Result;
import com.ibm.staging.template.TableQty;

public class Summary {
	private static final String summaryFullQty = "select count(*) from v_recon_queue with ur";
	private static final String summaryTotalCustomerQty = "select count(distinct customer_id) from v_recon_queue with ur";
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
	private static String query42 = "select v.table,count(*) from v_recon_queue v where customer_id  = 999999 group by v.table with ur";

	private static String query61 = "select count(*) from software_lpar a left outer join software_lpar_map b on a.id = b.software_lpar_id left outer join scan_record c on b.scan_record_id = c.id where a.action != 'COMPLETE' or b.action != 'COMPLETE' with ur";
	private static String query62 = "select count(distinct a.customer_id) from software_lpar a left outer join software_lpar_map b on a.id = b.software_lpar_id left outer join scan_record c on b.scan_record_id = c.id where a.action != 'COMPLETE' or b.action != 'COMPLETE' with ur";
	private static String query71 = "select a.customer_id  ,date(a.scan_time)  ,count(*)  from software_lpar a  left outer join software_lpar_map b on  a.id = b.software_lpar_id  left outer join scan_record c on  b.scan_record_id = c.id    left outer join scan_software_item si on  c.id = si.scan_record_id  where a.customer_id in (337,414,479,503,504,506,514,525,532,758,1034,1206,1471,2447,2568,2602,2605,2676,2692,2845,2876,2928,2960,2961,2963,2981,2991,3485,3947,4173,5304,5704,5798,5825,6266,6782,7049,7076,7081,7088,7090,7097,7109,7112,7114,7128,7160,7199,7200,7649,7732,7737,8571,8611,8621,8664,8666,8668,8672,8689,8808,8825,8844,8996,8998,9047,9102,9182,9198,9204,9206,9363,9416,9473,9514,9590,9598,9601,9664,9754,11034,11472,11480,11498,11660,11804,11860,11959,12031,12045,12058,12109,12132,12137,12155,12335,12350,12476,12496,12508,12543,12999,13293,13331,13395,13444,13454,13457,13546,13561,13595,13651,13767,13775,13786,13792,13799,13816,13818,14015,14075,14172,14182,14292,14346,14373,14472,14501,14536,14543,14555,14939,14940,15167,15246,15302,15323,15620,14046,4200)  and (  a.action != 'COMPLETE'  or b.action != 'COMPLETE'  or si.action in (1,2)  )  group by  a.customer_id  ,date(a.scan_time)  order by  a.customer_id, date(a.scan_time)  with ur";

	private static String query72 = "select count(*)  from software_lpar a  left outer join software_lpar_map b on  a.id = b.software_lpar_id  left outer join scan_record c on  b.scan_record_id = c.id    left outer join scan_software_item si on  c.id = si.scan_record_id  where a.customer_id in (337,414,479,503,504,506,514,525,532,758,1034,1206,1471,2447,2568,2602,2605,2676,2692,2845,2876,2928,2960,2961,2963,2981,2991,3485,3947,4173,5304,5704,5798,5825,6266,6782,7049,7076,7081,7088,7090,7097,7109,7112,7114,7128,7160,7199,7200,7649,7732,7737,8571,8611,8621,8664,8666,8668,8672,8689,8808,8825,8844,8996,8998,9047,9102,9182,9198,9204,9206,9363,9416,9473,9514,9590,9598,9601,9664,9754,11034,11472,11480,11498,11660,11804,11860,11959,12031,12045,12058,12109,12132,12137,12155,12335,12350,12476,12496,12508,12543,12999,13293,13331,13395,13444,13454,13457,13546,13561,13595,13651,13767,13775,13786,13792,13799,13816,13818,14015,14075,14172,14182,14292,14346,14373,14472,14501,14536,14543,14555,14939,14940,15167,15246,15302,15323,15620,14046,4200)  and (  a.action != 'COMPLETE'  or b.action != 'COMPLETE'  or si.action in (1,2)  )  with ur";

	private static String queryCustomerCache = "select customer_id, customer_name, account_number  from customer with ur";

	private static Map customerMap = new HashMap();

	public static void main(String[] args) {
		start(args[0]);
	}

	private static void start(String path) {

		String queryPath = "template/queries.xml";
		CPTDBConnectionPool.INSTANCE.setPath(queryPath);

		try {
			Result result = new Result();
			Map parameter = result.getParameter();

			// summary
			CPTDBQuery query = new CPTDBQuery(queryPath, "trailsConnection");
			query.execute();

			rs = stmt.executeQuery();
			while (rs.next()) {
				Customer c = new Customer();
				c.setCustomerId(rs.getLong(1));
				c.setCustomerName(rs.getString(2));
				c.setAccountNumber(rs.getLong(3));

				customerMap.put(rs.getString(1), c);
			}

			rs = stmt.executeQuery(summaryFullQty);
			while (rs.next()) {
				parameter.put(Result.SUMMARY_TOTAL, rs.getString(1));
			}

			rs = stmt.executeQuery(summaryTotalCustomerQty);
			while (rs.next()) {
				parameter.put(Result.SUMMARY_CUSTOMER_TOTAL, rs.getString(1));
			}

			fetchThreadQty(parameter, "/home/zyizhang/reconThreadQty.txt",
					Result.RECON_THREAD_QTY);
			fetchThreadQty(parameter, "/home/zyizhang/swToBravoThreadQty.txt",
					Result.SW_TO_BRAVO_THREAD_QTY);

			// p1
			p1(parameter, stmt);

			// p2
			p2(parameter, stmt);

			// p3
			p3(parameter, stmt);
			//
			p4(parameter, stmt);

			// staging
			p6(parameter, stagingStmt);

			p7(parameter, stagingStmt);

			result.build();
			result.output();

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rs.close();
				stmt.close();
				stagingStmt.close();
				bravoConn.close();
				stagingConn.close();

			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
	}

	private static void p7(Map parameter, Statement stagingStmt)
			throws SQLException {

		ResultSet rs;
		rs = stagingStmt.executeQuery(query71);
		int i = 1;
		List rList = new ArrayList();
		while (rs.next()) {
			AccountDateQty l = new AccountDateQty();
			l.setIndex(i++);
			l.setCustomerId(rs.getLong(1));

			Customer c = (Customer) customerMap.get(rs.getString(1));
			l.setAccountNumber(c.getAccountNumber());
			l.setAccountName(c.getCustomerName());
			l.setRecordDate(rs.getDate(2));
			l.setQty(rs.getInt(3));

			rList.add(l);
		}
		parameter.put(Result.P71, rList);

		rs = stagingStmt.executeQuery(query72);
		while (rs.next()) {
			parameter.put(Result.P72, rs.getString(1));
		}

	}

	private static void p6(Map parameter, Statement stagingStmt)
			throws SQLException {
		ResultSet rs = stagingStmt.executeQuery(query61);
		while (rs.next()) {
			parameter.put(Result.P61, rs.getString(1));
		}

		rs = stagingStmt.executeQuery(query62);
		while (rs.next()) {
			parameter.put(Result.P62, rs.getString(1));
		}

	}

	private static void fetchThreadQty(Map parameter, String fileName,
			String pName) {

		File file = new File(fileName);

		List threadsQty = new ArrayList();
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(file));
			String line = null;
			while ((line = reader.readLine()) != null) {
				threadsQty.add(line);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		parameter.put(pName, threadsQty);

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
		writeAccountDateQty(parameter, stmt, Result.P11, p1List);

		ResultSet rs;
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

	private static void writeAccountDateQty(Map parameter, Statement stmt,
			String pName, String query) throws SQLException {
		ResultSet rs;
		rs = stmt.executeQuery(query);
		int i = 1;
		List rList = new ArrayList();
		while (rs.next()) {
			AccountDateQty l = new AccountDateQty();
			l.setIndex(i++);
			l.setCustomerId(rs.getLong(1));
			l.setAccountNumber(rs.getLong(2));
			l.setAccountName(rs.getString(3));
			l.setRecordDate(rs.getDate(4));
			l.setQty(rs.getInt(5));

			rList.add(l);
		}
		parameter.put(pName, rList);
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
