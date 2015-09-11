package com.ibm.cyclone.component;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.ibm.cyclone.Metadata;

public class CPTDBQuery extends AbstractXMLCPT {

	private String queryName;

	private List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

	private List<Metadata> metadata = new ArrayList<Metadata>();

	public CPTDBQuery(String path, String queryName) {
		super("dbQuery", path);
		this.queryName = queryName;
	}

	public List<Map<String, Object>> getResult() {
		return result;
	}

	public void execute() {

		try {
			parse();
		} catch (ParserConfigurationException e1) {
			e1.printStackTrace();
		} catch (SAXException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		try {
			String connName = element.getAttribute("connection");
			Connection connection = CPTDBConnectionPool.INSTANCE
					.getConnection(connName);

			String query = element.getElementsByTagName("query").item(0)
					.getFirstChild().getNodeValue();
			ResultSet rs = connection.createStatement().executeQuery(query);

			NodeList list = element.getElementsByTagName("metadata");
			for (int i = 0; i < list.getLength(); i++) {
				Element currentElement = (Element) list.item(i);

				Metadata m = new Metadata();
				m.name = currentElement.getAttribute("name");
				m.type = currentElement.getAttribute("type");
				m.sequence = Integer.valueOf(currentElement
						.getAttribute("sequence"));
				metadata.add(m);
			}

			while (rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				for (Metadata m : metadata) {
					if ("string".equalsIgnoreCase(m.type)) {
						map.put(m.name, rs.getString(m.sequence));
					} else if ("long".equalsIgnoreCase(m.type)) {
						map.put(m.name, rs.getLong(m.sequence));
					} else if ("date".equalsIgnoreCase(m.type)) {
						map.put(m.name, rs.getDate(m.sequence));
					} else if ("int".equalsIgnoreCase(m.type)) {
						map.put(m.name, rs.getInt(m.sequence));
					} else {
						throw new RuntimeException("Unknown metadata type");
					}
				}

				result.add(map);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	protected String getElementName() {
		return this.queryName;
	}

}
