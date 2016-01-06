package com.ibm.asset.trails.batch.swkbt.processor;

import java.util.Map;

import org.springframework.batch.item.ItemProcessor;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;

public class SwguidReportProcessor implements
		ItemProcessor<Map<String, Object>, Map<String, Object>> {

	@Autowired
	private ProductInfoService service;

	public Map<String, Object> process(Map<String, Object> item)
			throws Exception {
		String guid = (String) item.get("guid");
		Boolean exists = service.licensableOverrideExists(guid);
		if (exists) {
			return item;
		}
		return null;
	}

}
