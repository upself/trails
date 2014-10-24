package com.ibm.asset.trails.batch.swkbt.processor;

import java.util.Map;

import org.springframework.batch.item.ItemProcessor;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.batch.swkbt.service.ReportService;

public class FilterDeltaProcessor implements
		ItemProcessor<Map<String, Object>, Map<String, Object>> {

	@Autowired
	private ReportService reportService;

	public Map<String, Object> process(Map<String, Object> item)
			throws Exception {
		String softwareVersion = (String) item.get("filterVersion");
		String filterName = (String) item.get("filterName");
		Boolean exists = reportService
				.filterExists(filterName, softwareVersion);
		if (exists) {
			return null;
		}
		return item;
	}

}
