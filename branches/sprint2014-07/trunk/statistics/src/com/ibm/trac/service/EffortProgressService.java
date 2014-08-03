/**
 * 
 */
package com.ibm.trac.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.ibm.trac.DBConnect;
import com.ibm.trac.domain.EffortProgress;
import com.ibm.trac.domain.Sprint;

/**
 * @author zhangyi
 * 
 */
public class EffortProgressService extends AbstractJDBCService {

	public List<EffortProgress> loadEfforProgress(Sprint sprint) {

		Connection conn = DBConnect.getInstance().getStatisticConn();
		PreparedStatement stmt = null;
		List<EffortProgress> effrtPrgrs = new ArrayList<EffortProgress>();
		try {
			stmt = conn
					.prepareStatement("select ep.id, ep.sprint, ep.time, ep.effort\r\n"
							+ "from sprint s, effort_progress ep\r\n"
							+ "where\r\n"
							+ "s.id  = ep.sprint\r\n"
							+ "and s.id = ?\r\n"
							+ "order by time asc");
			stmt.setLong(1, sprint.getId());
			ResultSet rs = stmt.executeQuery();

			buildEffortProgress(sprint, effrtPrgrs, rs);

		} catch (SQLException e) {
			e.printStackTrace();
			closeStatement(stmt);
		} finally {
			closeStatement(stmt);
		}

		return effrtPrgrs;
	}

	private void buildEffortProgress(Sprint sprint, List<EffortProgress> eps,
			ResultSet rs) throws SQLException {
		while (rs.next()) {
			EffortProgress ep = new EffortProgress();
			ep.setSprint(sprint);
			ep.setId(rs.getLong(1));

			Date time = new Date();
			time.setTime(rs.getLong(3));
			ep.setTime(time);

			ep.setEffort(rs.getFloat(4));
			eps.add(ep);
		}
	}

	/**
	 * @param sprint
	 */
	public void addEffortRecord(Sprint sprint) {
		Connection conn = DBConnect.getInstance().getStatisticConn();
		PreparedStatement stmt = null;

		try {
			stmt = conn
					.prepareStatement("insert into effort_progress(sprint, time, effort) "
							+ "values (?, ?, ?)");
			stmt.setLong(1, sprint.getId());
			stmt.setLong(2, new Date().getTime());

			TracService tracService = new TracService();
			float leftEffort = tracService.loadLeftEffort(sprint);
			stmt.setFloat(3, leftEffort);

			stmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
			closeStatement(stmt);
		} finally {
			closeStatement(stmt);
		}
	}

	/**
	 * @param id
	 */
	public void delEffortRecord(long id) {
		Connection conn = DBConnect.getInstance().getStatisticConn();
		PreparedStatement stmt = null;

		try {
			stmt = conn
					.prepareStatement("delete from effort_progress where id  = ?");
			stmt.setLong(1, id);
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			closeStatement(stmt);
		} finally {
			closeStatement(stmt);
		}

	}
}
