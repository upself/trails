package com.ibm.cyclone.component;

import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public abstract class AbstractXMLCPT {

	private String path;

	private String tagName;

	protected Element element;

	public AbstractXMLCPT(String tagName) {
		this.tagName = tagName;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public AbstractXMLCPT(String tagName, String path) {
		this.tagName = tagName;
		this.path = path;
	}

	protected void parse() throws ParserConfigurationException, SAXException,
			IOException {

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();

		Document doc = db.parse(new File(path));
		Element root = doc.getDocumentElement();

		NodeList nodeList = root.getElementsByTagName(tagName);

		for (int i = 0; i < nodeList.getLength(); i++) {
			Element element = (Element) nodeList.item(i);
			String name = element.getAttribute("name");
			if (getElementName() == null) {
				throw new RuntimeException("Element name not defined");
			}

			if (getElementName().equals(name)) {
				this.element = element;
				break;
			}
		}

		if (this.element == null) {
			throw new RuntimeException("Element" + getElementName()
					+ "not found in " + path);
		}
	}

	protected abstract String getElementName();

}
