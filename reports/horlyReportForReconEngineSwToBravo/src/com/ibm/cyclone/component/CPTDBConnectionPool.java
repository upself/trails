package com.ibm.cyclone.component;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Attr;
import org.w3c.dom.Comment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class CPTDBConnectionPool {

	private Map<String, Connection> map;

	private String path;

	public final static CPTDBConnectionPool INSTANCE = new CPTDBConnectionPool();

	private CPTDBConnectionPool() {

	}

	public void setPath(String path) {
		this.path = path;
	}

	public Connection getConnection(String name) {
		if (map == null) {
			parse();
		}
		return map.get(name);
	}

	public void execute() {
		parse();
	}

	private void parse() {

		try {
			Class.forName("COM.ibm.db2.jdbc.app.DB2Driver").newInstance();

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();

			Document doc = db.parse(new File(path));
			Element root = doc.getDocumentElement();

			NodeList list = root.getElementsByTagName("connection");

			for (int i = 0; i < list.getLength(); i++) {
				Element element = (Element) list.item(i);
				String name = element.getAttribute("name");
				String url = element.getElementsByTagName("url").item(0)
						.getFirstChild().getNodeValue();
				String user = element.getElementsByTagName("user").item(0)
						.getFirstChild().getNodeValue();
				String password = element.getElementsByTagName("password")
						.item(0).getFirstChild().getNodeValue();

				Connection connection = DriverManager.getConnection(url, user,
						password);

				if (map == null) {
					map = new HashMap<String, Connection>();
				}

				map.put(name, connection);

			}

		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	private void parseElement(Element element) {
		String tagName = element.getNodeName();

		NodeList children = element.getChildNodes();

		System.out.print("<" + tagName);

		// element元素的所有属性所构成的NamedNodeMap对象，需要对其进行判断
		NamedNodeMap map = element.getAttributes();

		// 如果该元素存在属性
		if (null != map) {
			for (int i = 0; i < map.getLength(); i++) {
				// 获得该元素的每一个属性
				Attr attr = (Attr) map.item(i);

				String attrName = attr.getName();
				String attrValue = attr.getValue();

				System.out.print(" " + attrName + "=\"" + attrValue + "\"");
			}
		}

		System.out.print(">");

		for (int i = 0; i < children.getLength(); i++) {
			Node node = children.item(i);
			// 获得结点的类型
			short nodeType = node.getNodeType();

			if (nodeType == Node.ELEMENT_NODE) {
				// 是元素，继续递归
				parseElement((Element) node);
			} else if (nodeType == Node.TEXT_NODE) {
				// 递归出口
				System.out.print(node.getNodeValue());
			} else if (nodeType == Node.COMMENT_NODE) {
				System.out.print("<!--");

				Comment comment = (Comment) node;

				// 注释内容
				String data = comment.getData();

				System.out.print(data);

				System.out.print("-->");
			}
		}

		System.out.print("</" + tagName + ">");
	}

	public static void main(String[] args) {
		CPTDBConnectionPool.INSTANCE.parse();
	}
}
