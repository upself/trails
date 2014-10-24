package com.ibm.asset.trails.batch.swkbt.writer;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.swkbt.schema.ManufacturerType;
import com.ibm.asset.trails.batch.swkbt.service.SwkbtLoaderService;

public class TrailsSwkbtWriter<E> implements ItemWriter<E> {
	private static final Logger logger = Logger
			.getLogger(TrailsSwkbtWriter.class);

	@Autowired
	private SwkbtLoaderService<E> swkbtLoaderService;

	public void write(List<? extends E> items) throws Exception {
		logger.debug("Ready to write from TrailsSwkbtWriter -- " + items.size());

		
		swkbtLoaderService.batchUpdate(items);
	}

	public void setSwkbtLoaderService(SwkbtLoaderService<E> swkbtLoaderService) {
		this.swkbtLoaderService = swkbtLoaderService;
	}
}
