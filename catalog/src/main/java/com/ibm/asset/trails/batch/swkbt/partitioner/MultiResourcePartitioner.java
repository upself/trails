package com.ibm.asset.trails.batch.swkbt.partitioner;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.batch.core.partition.support.Partitioner;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.core.io.Resource;
import org.springframework.util.Assert;

public class MultiResourcePartitioner implements Partitioner {

	private static final String DEFAULT_KEY_NAME = "fileName";

	private static final String PARTITION_KEY = "partition";

	private Resource[] resources = new Resource[0];

	private String keyName = DEFAULT_KEY_NAME;

	private String[] elementNames = new String[0];
	
	private static final Logger logger = Logger
			.getLogger(MultiResourcePartitioner.class);

	public void setResources(Resource[] resources) {
		this.resources = resources;
	}

	public void setElementNames(String[] elementNames) {
		this.elementNames = elementNames;
	}

	public void setKeyName(String keyName) {
		this.keyName = keyName;
	}

	public Map<String, ExecutionContext> partition(int gridSize) {
		Map<String, ExecutionContext> map = new HashMap<String, ExecutionContext>(
				gridSize);
		int i = 0;
		logger.debug("Mapping Resources in partitioner -- number: " + resources.length);
		for (Resource resource : resources) {
			logger.debug("Working on resource " + resource.toString());
			for (String elementName : elementNames) {
				String fileName = elementName.toLowerCase() + ".xml";
				logger.debug("Mapping Resources " + fileName);
				if (fileName.equals(resource.getFilename())) {
					ExecutionContext context = new ExecutionContext();
					Assert.state(resource.exists(), "Resource does not exist: "
							+ resource);
					try {
						context.putString(keyName, resource.getURL()
								.toExternalForm());
						context.putString("elementName", elementName);
						logger.debug("looking at -- " + elementName);
					} catch (IOException e) {
						logger.debug("File not found " + fileName);
						throw new IllegalArgumentException(
								"File could not be located for: " + resource, e);
					}
					map.put(PARTITION_KEY + i, context);
					i++;
				}
			}
		}
		return map;
	}

}
