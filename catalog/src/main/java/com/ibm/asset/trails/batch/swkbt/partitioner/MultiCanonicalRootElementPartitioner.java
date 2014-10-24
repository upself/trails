package com.ibm.asset.trails.batch.swkbt.partitioner;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.batch.core.partition.support.Partitioner;
import org.springframework.batch.item.ExecutionContext;

import com.ibm.asset.trails.batch.swkbt.listener.OutputFileListener;

public class MultiCanonicalRootElementPartitioner implements Partitioner {

	private static final String DEFAULT_ELEMENT_KEY_NAME = "elementName";
	private static final String PARTITION_KEY = "partition";
	private String[] elementNames = new String[0];
	private static final Logger logger = Logger
			.getLogger(MultiCanonicalRootElementPartitioner.class);

	public Map<String, ExecutionContext> partition(int gridSize) {
		Map<String, ExecutionContext> map = new HashMap<String, ExecutionContext>(
				gridSize);
		int i = 0;
		for (String elementName : elementNames) {
			ExecutionContext context = new ExecutionContext();
			context.putString(DEFAULT_ELEMENT_KEY_NAME, elementName);
			map.put(PARTITION_KEY + i, context);
			i++;
			logger.debug("Partitioned " + elementName);
		}
		return map;
	}

	public void setElementNames(String[] elementNames) {
		this.elementNames = elementNames;
	}

}
