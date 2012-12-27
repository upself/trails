package com.ibm.asset.trails.aspect;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.DataExceptionHistory;
import com.ibm.asset.trails.service.DataExceptionHistoryService;

@Aspect
public class DataExceptionHistoryAspect {

	private DataExceptionHistoryService historyService;

	public void setHistoryService(DataExceptionHistoryService historyService) {
		this.historyService = historyService;
	}

	@Before("execution(* com.ibm.asset.trails.service.DataExceptionService.updateAssignment(..))&& args(alert,sessionUser,comments,assign)")
	public void createHistory(DataException alert, String sessionUser, String comments,
			boolean assign) {
		DataExceptionHistory history = historyService.transformToHistory(alert);
		historyService.save(history);
	}

}
