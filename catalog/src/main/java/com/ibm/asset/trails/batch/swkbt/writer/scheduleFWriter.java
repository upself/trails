package com.ibm.asset.trails.batch.swkbt.writer;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.batch.swkbt.service.ScheduleFService;
import com.ibm.asset.trails.domain.ScheduleF;

/* Author zhysz@cn.ibm.com
*/
public class scheduleFWriter implements ItemWriter<Map<String, Object>> {
	private static final Logger logger = Logger
			.getLogger(scheduleFWriter.class);

	@Autowired
	private ScheduleFService service;

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void write(List<? extends Map<String, Object>> items)
			throws Exception {
		processScheduleFSwNameChanges(items);
	}

	private void processScheduleFSwNameChanges(
			List<? extends Map<String, Object>> items) {
		logger.debug("processing scheduleF software name Changes");
		for (Map<String, Object> item : items) {
			Long id = (Long) item.get("softwareId");
			String softwareName = (String) item.get("softwareName");
			List<ScheduleF> scheduleFList = service.findBySwId(id);
			for(ScheduleF scheduleF:scheduleFList){
			if (scheduleF.getSoftwareId() == id && !scheduleF.getSoftwareName().equals(softwareName)) {				
				scheduleF.setSoftwareName(softwareName);
				service.merge(scheduleF);
				logger.debug("Update ScheduleF " + scheduleF.toString());
			} 
			}
		}
		logger.debug("process scheduleF software name complete");
	}

}
