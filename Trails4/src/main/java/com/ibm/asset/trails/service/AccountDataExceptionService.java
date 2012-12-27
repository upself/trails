package com.ibm.asset.trails.service;

import java.util.List;
import java.util.Map;

public interface AccountDataExceptionService {

	List<Map<String, String>> getAlertTypeSummary(Long accountId, String type);

}
