/**
 * 
 */
package com.ibm.trac.service;

import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author zhangyi
 * 
 */
public class AbstractJDBCService {

	protected void closeStatement(Statement stmt) {
		try {
			if (stmt != null) {
				stmt.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}