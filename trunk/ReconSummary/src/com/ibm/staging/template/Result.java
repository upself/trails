package com.ibm.staging.template;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Result {

	public static final String SUMMARY_TOTAL = "0";

	public static final String P11 = "1";

	public static final String P12 = "2";

	public static final String P21 = "3";

	public static final String P22 = "4";

	public static final String P23 = "5";

	public static final Object P24 = "6";

	public static final Object P31 = "7";

	public static final Object P32 = "8";

	public static final Object P33 = "9";

	public static final Object P34 = "10";

	public static final Object P41 = "11";

	public static final Object P42 = "12";

	public static final Object P51 = "13";

	public static final Object P52 = "14";

	private StringBuffer result = new StringBuffer();

	private Map parameter = new HashMap();

	public void build() {
		result.append("Summary: \n");
		result.append("Total Records in full queue:"
				+ parameter.get(SUMMARY_TOTAL) + "\n");
		result.append("\n");

		p1();
		p2();
		p3();
		p4();
		p5();

	}

	private void p5() {

		result.append("\nSpecial (temp):" + parameter.get(P51) + " \n");

		result.append("- Full volume for pooled account: \n");
		List full = (List) parameter.get(P52);
		for (int i = 0; i < full.size(); i++) {
			TableQty t = (TableQty) full.get(i);
			result.append(t.getName() + "," + t.getQty() + "\n");
		}

	}

	private void p4() {
		result.append("\nPriority 4: 999999 Account \n");
		result.append("- Total records in queue:" + parameter.get(P41) + "\n");
		result.append("- Full volume for Priority 4: \n");

		List full = (List) parameter.get(P42);
		for (int i = 0; i < full.size(); i++) {
			TableQty t = (TableQty) full.get(i);
			result.append(t.getName() + "," + t.getQty() + "\n");
		}

	}

	private void p3() {
		result.append("\n");
		result.append("Priority 3: Workstation Accounts \n");
		result.append("- Total Number of Accounts:" + parameter.get(P31) + "\n");
		result.append("- Total records in queue:" + parameter.get(P32) + "\n");
		result.append("- First 10 Accounts in queue:\n");

		List topTen = (List) parameter.get(P33);
		for (int i = 0; i < topTen.size(); i++) {
			AccountDateQty l = (AccountDateQty) topTen.get(i);
			result.append(l.getIndex() + "," + l.getCustomerId() + ","
					+ l.getAccountNumber() + "," + l.getRecordDate() + ","
					+ l.getQty() + "," + l.getAccountName() + "\n");
		}

		result.append("- Full volume for Priority 3: \n");
		List full = (List) parameter.get(P34);
		for (int i = 0; i < full.size(); i++) {
			TableQty t = (TableQty) full.get(i);
			result.append(t.getName() + "," + t.getQty() + "\n");
		}

	}

	private void p1() {
		result.append("Priority 1: Special Accounts \n");

		List p11 = (List) parameter.get(P11);
		for (int i = 0; i < p11.size(); i++) {
			AccountDateQty l = (AccountDateQty) p11.get(i);
			result.append(l.getIndex() + "," + l.getCustomerId() + ","
					+ l.getAccountNumber() + "," + l.getRecordDate() + ","
					+ l.getQty() + "," + l.getAccountName() + "\n");
		}

		result.append("- Full volume for Priority 1: \n");
		List p12 = (List) parameter.get(P12);
		for (int i = 0; i < p12.size(); i++) {
			TableQty t = (TableQty) p12.get(i);
			result.append(t.getName() + "," + t.getQty() + "\n");
		}
		result.append("\n");
	}

	private void p2() {
		result.append("Priority 2: Server Accounts \n");
		result.append("- Total Number of Accounts:" + parameter.get(P21) + "\n");
		result.append("- Total records in queue:" + parameter.get(P22) + "\n");
		result.append("- First 10 Accounts in queue: \n");

		List p23 = (List) parameter.get(P23);
		for (int i = 0; i < p23.size(); i++) {
			AccountDateQty l = (AccountDateQty) p23.get(i);
			result.append(l.getIndex() + "," + l.getCustomerId() + ","
					+ l.getAccountNumber() + "," + l.getRecordDate() + ","
					+ l.getQty() + "," + l.getAccountName() + "\n");
		}
		result.append("- Full volume for Priority 2: \n");
		List p24 = (List) parameter.get(P24);
		for (int i = 0; i < p24.size(); i++) {
			TableQty t = (TableQty) p24.get(i);
			result.append(t.getName() + "," + t.getQty() + "\n");
		}
	}

	public void output() {
		System.out.println(result.toString());
	}

	public Map getParameter() {
		return parameter;
	}

}
