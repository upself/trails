package com.ibm.ldap;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Vector;

import com.ibm.swat.password.ReturnCode;
import com.ibm.swat.password.cwa2;
import com.ibm.swat.password.cwaapi;

public class LDAPSearch {

	private String start;
	private String end;
	private String filePath;
	private String groupName;

	private StringBuffer authzContent = new StringBuffer();
	private StringBuffer groups;

	private File authzFile;
	private StringBuffer result;

	public void init() {
		authzFile = new File(filePath);
		groups = new StringBuffer(groupName + " = ");
	}

	private void searchLdap() {
		ReturnCode rc;
		cwa2 CWA2 = new cwa2("bluepages.ibm.com", "bluegroups.ibm.com");
		Vector list = new Vector();

		rc = CWA2.listMembers("com.ibm.tapmf.svn.writer", 0, list, "mail");

		if (rc == cwaapi.SUCCESS) {
			for (int i = 0; i < list.size(); i++) {
				groups.append(list.elementAt(i));
				if (list.size() > 1 && i != (list.size() - 1)) {
					groups.append(",");
				}
			}
		} else {
			System.out.println(rc.getMessage());
		}
		CWA2 = null;

	}

	private void loadConf() {

		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(authzFile));
			String line = null;

			while ((line = reader.readLine()) != null) {
				authzContent.append(line + "\n");
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
	}

	private void buildAuthzContent() {

		int insertPoint = authzContent.indexOf(start) + start.length();
		String head = authzContent.substring(0, insertPoint);

		int breakPoint = authzContent.indexOf(end);
		String bottom = authzContent.substring(breakPoint);

		result = new StringBuffer();
		result.append(head + "\n");
		result.append(groups + "\n");
		result.append(bottom);

	}

	public void run() {
		init();
		loadConf();
		searchLdap();
		buildAuthzContent();
		writeBack();
	}

	private void writeBack() {
		BufferedWriter writer = null;
		try {
			writer = new BufferedWriter(new FileWriter(authzFile));
			writer.write(result.toString());

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (writer != null) {
				try {
					writer.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

	public static void main(String[] args) {
		LDAPSearch ldap = new LDAPSearch();

		ldap.setStart(args[0]);
		ldap.setEnd(args[1]);
		ldap.setFilePath(args[2]);
		ldap.setGroupName(args[3]);

		ldap.run();
	}

	public void setStart(String start) {
		this.start = start;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

}
