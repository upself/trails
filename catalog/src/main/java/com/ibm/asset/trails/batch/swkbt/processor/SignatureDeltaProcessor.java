package com.ibm.asset.trails.batch.swkbt.processor;

import java.util.Map;

import org.springframework.batch.item.ItemProcessor;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.batch.swkbt.service.ReportService;

public class SignatureDeltaProcessor implements
		ItemProcessor<Map<String, Object>, Map<String, Object>> {

	@Autowired
	private ReportService reportService;

	public Map<String, Object> process(Map<String, Object> item)
			throws Exception {
		String fileName = (String) item.get("fileName");
		Integer fileSize = (Integer) item.get("fileSize");
		if (fileName.length() > 88) {
			return null;
		}
		Boolean exists = reportService.signatureExists(fileName, fileSize);
		if (exists) {
			return null;
		}
		return item;
	}

}
