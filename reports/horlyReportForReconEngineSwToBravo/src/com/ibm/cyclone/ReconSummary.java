package com.ibm.cyclone;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.ibm.cyclone.component.CPTDBConnectionPool;
import com.ibm.cyclone.component.CPTDBQuery;

public class ReconSummary {

	private String templatePath;
	private String dbConfigPath;

	public ReconSummary(String arg1, String arg2) {
		templatePath = arg1;
		dbConfigPath = arg2;
	}

	public ReconSummary() {
		templatePath = "files/recon_summary_template.vm";
		dbConfigPath = "files/db_config.xml";
	}

	@SuppressWarnings("unchecked")
	private void build() {
		StringWriter writer = null;
		try {
			Velocity.init();
			CPTDBConnectionPool.INSTANCE.setPath(dbConfigPath);

			Template template = Velocity.getTemplate(templatePath);

			VelocityContext context = new VelocityContext();

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();

			Document doc = db.parse(new File(dbConfigPath));
			Element root = doc.getDocumentElement();

			NodeList nodeList = root.getElementsByTagName("dbQuery");
			for (int i = 0; i < nodeList.getLength(); i++) {
				Element e = (Element) nodeList.item(i);

				String name = e.getAttribute("name");
				CPTDBQuery cptDbQuery = new CPTDBQuery(dbConfigPath, name);
				cptDbQuery.execute();
				context.put(name, cptDbQuery.getResult());
			}

			Map<Long, Map<String, Object>> customerMap = new HashMap<Long, Map<String, Object>>();
			for (Map<String, Object> c : (List<Map<String, Object>>) context
					.get("queryCustomerCache")) {
				customerMap.put((Long) c.get("customerId"), c);
			}

			for (Map<String, Object> c : (List<Map<String, Object>>) context
					.get("query71")) {
				Long cId = (Long) c.get("customerId");
				Map<String, Object> custDesc = customerMap.get(cId);
				c.put("accountNumber", custDesc.get("accountNumber"));
				c.put("customerName", custDesc.get("customerName"));
			}

			writer = new StringWriter();
			template.merge(context, writer);
			System.out.println(writer.toString());

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			CPTDBConnectionPool.INSTANCE.closeConnections();
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

		if (args.length == 2) {
			new ReconSummary(args[0], args[1]).build();
		} else {
			new ReconSummary().build();
		}

	}

}
