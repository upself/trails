package com.ibm.asset.trails.batch.swkbt.integration;

import org.springframework.integration.Message;
import org.springframework.integration.file.DefaultFileNameGenerator;

public class SwkbtXmlFileNameGenerator extends DefaultFileNameGenerator {

	@Override
	public String generateFileName(Message<?> message) {
		String fileName = super.generateFileName(message);
		fileName = fileName + ".xml";
		return fileName;
	}

}
