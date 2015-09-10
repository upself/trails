package com.ibm.staging.recon;

import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.velocity.app.Velocity;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.ibm.cyclone.component.CPTMain;

public class Parse {

	public static void main(String[] args) {
		try {

			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(new File("template/ReconSummary.xml"));

			Element root = doc.getDocumentElement();

			String nodeName = root.getNodeName();
			System.out.println(nodeName);

			Velocity.init();

			CPTMain main = new CPTMain();
			main.setName("Helloworld");
			String result = main.execute();

			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void parse() {

	}

}
