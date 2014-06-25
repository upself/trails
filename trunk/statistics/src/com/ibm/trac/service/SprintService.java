/**
 * 
 */
package com.ibm.trac.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.ibm.trac.DBConnect;
import com.ibm.trac.domain.Sprint;

/**
 * @author zhangyi
 * 
 */
public class SprintService extends AbstractJDBCService {

	public void insertSprint(String name, String start, String end, int width,
			int height) {
		Connection c = DBConnect.getInstance().getStatisticConn();
		SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = null;
		Date endDate = null;
		try {
			startDate = formater.parse(start);
			endDate = formater.parse(end);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		PreparedStatement stmt = null;
		try {
			stmt = c.prepareStatement("insert into sprint(name, start, end, width, height) values (?,?,?,?,?)");
			stmt.setString(1, name);
			stmt.setLong(2, startDate.getTime());
			stmt.setLong(3, endDate.getTime());
			stmt.setInt(4, width);
			stmt.setInt(5, height);

			stmt.execute();

		} catch (SQLException e) {
			closeStatement(stmt);
			e.printStackTrace();
		} finally {
			closeStatement(stmt);
		}

	}

	public void deleteSprint(long id) {
		Connection c = DBConnect.getInstance().getStatisticConn();
		Statement stmt = null;
		try {
			stmt = c.createStatement();
			stmt.executeUpdate("delete from sprint where id  = " + id);
		} catch (SQLException e) {
			closeStatement(stmt);
			e.printStackTrace();
		} finally {
			closeStatement(stmt);
		}

	}

	public List<Sprint> loadSprint() {
		Connection c = DBConnect.getInstance().getStatisticConn();
		Statement queryAll = null;
		List<Sprint> sprints = new ArrayList<Sprint>();
		try {
			queryAll = c.createStatement();

			ResultSet rs = queryAll
					.executeQuery("select id, name, start,end, effort,width, height from sprint order by name");

			while (rs.next()) {
				Sprint s = new Sprint();
				s.setId(rs.getLong(1));
				s.setName(rs.getString(2));

				Date sDate = new Date();
				sDate.setTime(rs.getLong(3));
				s.setStart(sDate);

				Date eDate = new Date();
				eDate.setTime(rs.getLong(4));
				s.setEnd(eDate);

				s.setEffort(rs.getFloat(5));
				s.setWidth(rs.getInt(6));
				s.setHeight(rs.getInt(7));

				sprints.add(s);
			}
		} catch (SQLException e) {
			closeStatement(queryAll);
			e.printStackTrace();
		} finally {
			closeStatement(queryAll);
		}

		return sprints;
	}

	public Sprint loadSprint(long id) {

		Connection c = DBConnect.getInstance().getStatisticConn();
		Statement queryAll = null;
		List<Sprint> sprints = new ArrayList<Sprint>();
		try {
			queryAll = c.createStatement();

			ResultSet rs = queryAll
					.executeQuery("select id, name, start,end, effort, width, height from sprint where id="
							+ id);

			while (rs.next()) {
				Sprint s = new Sprint();
				s.setId(rs.getLong(1));
				s.setName(rs.getString(2));

				Date sDate = new Date();
				sDate.setTime(rs.getLong(3));
				s.setStart(sDate);

				Date eDate = new Date();
				eDate.setTime(rs.getLong(4));
				s.setEnd(eDate);

				s.setEffort(rs.getFloat(5));
				s.setWidth(rs.getInt(6));
				s.setHeight(rs.getInt(7));

				sprints.add(s);
			}
		} catch (SQLException e) {
			closeStatement(queryAll);
			e.printStackTrace();
		} finally {
			closeStatement(queryAll);
		}

		return sprints.size() > 0 ? sprints.get(0) : null;

	}

	public float loadEffort(long id) {
		Connection statConn = DBConnect.getInstance().getStatisticConn();
		Connection tracConn = DBConnect.getInstance().getTracConn();
		Statement statStmt = null;
		PreparedStatement tracStmt = null;
		float effortTotal = 0;
		try {
			statStmt = statConn.createStatement();
			ResultSet rs = statStmt
					.executeQuery("select name from sprint where id  = " + id);

			String sprintName = null;
			if (rs.next()) {
				sprintName = rs.getString(1);
			}

			tracStmt = tracConn
					.prepareStatement("select  t.id, t.summary, tc.value from ticket t, ticket_custom tc \r\n"
							+ "where \r\n"
							+ "t.id  = tc.ticket\r\n"
							+ "and t.type!='story' \r\n"
							+ "and tc.name='estimate'\r\n"
							+ "and t.milestone=? \r\n"
							+ "and t.status != 'closed'");
			tracStmt.setString(1, sprintName);
			ResultSet effortRs = tracStmt.executeQuery();

			while (effortRs.next()) {
				float effort = effortRs.getFloat(3);
				if (Float.NaN == effort) {
					effort = 0;
				}
				effortTotal += effort;
			}

			if (effortTotal > 0) {
				statStmt.executeUpdate("update sprint set effort ="
						+ effortTotal
						+ " where id ="
						+ id);
			}

		} catch (SQLException e) {
			closeStatement(statStmt);
			closeStatement(tracStmt);
			e.printStackTrace();
		} finally {
			closeStatement(statStmt);
			closeStatement(tracStmt);
		}

		return effortTotal;

	}

	/**
	 * @param id
	 * @param name
	 * @param start
	 * @param end
	 * @return
	 */
	public void updateSprint(long id, String name, String start, String end,
			int width, int height) {

		Connection c = DBConnect.getInstance().getStatisticConn();
		SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = null;
		Date endDate = null;
		try {
			startDate = formater.parse(start);
			endDate = formater.parse(end);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		PreparedStatement stmt = null;
		try {
			stmt = c.prepareStatement("update sprint set name=?, start=?, end=?, height=?, width=? where id  = ?");
			stmt.setString(1, name);
			stmt.setLong(2, startDate.getTime());
			stmt.setLong(3, endDate.getTime());
			stmt.setInt(4, height);
			stmt.setInt(5, width);
			stmt.setLong(6, id);

			stmt.execute();

		} catch (SQLException e) {
			closeStatement(stmt);
			e.printStackTrace();
		} finally {
			closeStatement(stmt);
		}
	}
}
