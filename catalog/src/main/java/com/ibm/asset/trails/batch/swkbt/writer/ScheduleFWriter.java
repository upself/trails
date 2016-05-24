package com.ibm.asset.trails.batch.swkbt.writer;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.batch.swkbt.service.ScheduleFService;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFH;

/* Author zhysz@cn.ibm.com
*/
public class ScheduleFWriter implements ItemWriter<Map<String, Object>> {
	private static final Logger logger = Logger.getLogger(ScheduleFWriter.class);

	@Autowired
	private ScheduleFService service;

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void write(List<? extends Map<String, Object>> items) throws Exception {
		processScheduleFSwNameChanges(items);
	}

	private void processScheduleFSwNameChanges(List<? extends Map<String, Object>> items) {
		logger.debug("processing scheduleF software name Changes");
		for (Map<String, Object> item : items) {
			Long id = (Long) item.get("id");
			String softwareName = (String) item.get("name");
			logger.debug("Software Id is " + id + ", Software Name is " + softwareName);
			List<ScheduleF> scheduleFList = service.findBySwId(id);
			if (null != scheduleFList && !scheduleFList.isEmpty()) {
             continue;
			}
			for (ScheduleF scheduleF : scheduleFList) {
				logger.debug("Processing ScheduleF id is " + scheduleF.getId());
				if (scheduleF.getSoftwareId().equals(id) && !scheduleF.getSoftwareName().equals(softwareName)) {
                    
					ScheduleFH scheduleFH = new ScheduleFH();
					scheduleFH.setScheduleF(scheduleF);
					scheduleFH.setCustomerId(scheduleF.getCustomerId());
					scheduleFH.setHostname(scheduleF.getHostname());
					scheduleFH.setHwOwner(scheduleF.getHwOwner());
					scheduleFH.setLevel(scheduleF.getLevel());
					scheduleFH.setMachineType(scheduleF.getMachineType());
					scheduleFH.setManufacturer(scheduleF.getManufacturer());
					scheduleFH.setRecordTime(scheduleF.getRecordTime());
					scheduleFH.setRemoteUser(scheduleF.getRemoteUser());
					scheduleFH.setScopeId(scheduleF.getScopeId());
					scheduleFH.setSerial(scheduleF.getSerial());
					scheduleFH.setSoftwareId(scheduleF.getSourceId());
					scheduleFH.setSoftwareName(scheduleF.getSoftwareName());
					scheduleFH.setSoftwareTitle(scheduleF.getSoftwareTitle());
					scheduleFH.setSourceId(scheduleF.getSourceId());
					scheduleFH.setSourceLocation(scheduleF.getSourceLocation());
					scheduleFH.setStatusId(scheduleF.getStatusId());
					scheduleFH.setSWFinanceResp(scheduleF.getSWFinanceResp());
					scheduleFH.setBusinessJustification(scheduleF.getBusinessJustification());
					
					scheduleF.setSoftwareName(softwareName);
					scheduleF.setBusinessJustification("Automatic name change to " + softwareName);
					scheduleF.setRecordTime(new Date());
					scheduleF.getScheduleFHList().add(scheduleFH);
					
					service.merge(scheduleF);
					logger.debug("Update ScheduleF " + scheduleF.toString());
				}
			}

		}
		logger.debug("process scheduleF software name complete");
	}

}
