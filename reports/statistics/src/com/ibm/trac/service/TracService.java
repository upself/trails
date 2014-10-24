/**
 * 
 */
package com.ibm.trac.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.ibm.trac.DBConnect;
import com.ibm.trac.domain.Sprint;
import com.ibm.trac.domain.TracTicket;

/**
 * @author zhangyi
 * 
 */
public class TracService extends AbstractJDBCService {

	public float loadLeftEffort(Sprint sprint) {
		Connection tracConn = DBConnect.getInstance().getTracConn();
		PreparedStatement stmt = null;
		float leftEffort = 0;
		try {
			stmt = tracConn
					.prepareStatement("select  t.id, tc.name, tc.value \r\n"
							+ "from ticket t left join ticket_custom tc \r\n"
							+ "on t.id  = tc.ticket\r\n"
							+ "where \r\n"
							+ "t.type!='story' \r\n"
							+ "and tc.name in('estimate','progress')\r\n"
							+ "and t.milestone=?\r\n"
							+ "and t.status != 'closed'");

			stmt.setString(1, sprint.getName());

			ResultSet rs = stmt.executeQuery();
			Map<Long, TracTicket> idTicketMap = new HashMap<Long, TracTicket>();
			while (rs.next()) {

				long ticketId = rs.getLong(1);
				TracTicket t = idTicketMap.get(ticketId);

				if (t == null) {
					t = new TracTicket();
					t.setId(ticketId);
					idTicketMap.put(t.getId(), t);
				}

				String name = rs.getString(2);
				if ("estimate".equals(name)) {
					String estimate = rs.getString(3).replaceAll("\\?", "");
					if (estimate != null && !"".equals(estimate)) {
						t.setEstimate(Float.valueOf(estimate));
					} else {
						t.setEstimate(0);
					}
				} else if ("progress".equals(name)) {
					String percentage = rs.getString(3);
					if (percentage != null && !"".equals(percentage)) {
						t.setProgress(Float.valueOf(percentage.replaceAll("%",
								"")) / 100);
					} else {
						t.setProgress(0);
					}
				}

			}

			Iterator<TracTicket> iter = idTicketMap.values().iterator();
			while (iter.hasNext()) {
				TracTicket t = (TracTicket) iter.next();
				leftEffort += t.getEstimate() * (1 - t.getProgress());
			}

		} catch (SQLException e) {
			closeStatement(stmt);
			e.printStackTrace();
		} finally {
			closeStatement(stmt);
		}

		return leftEffort;
	}
}
