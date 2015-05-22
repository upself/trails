package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ReportDeliveryTracking;
import com.ibm.asset.trails.domain.ReportDeliveryTrackingHistory;

public interface ReportDeliveryTrackingService {

	public ReportDeliveryTracking getByAccount(Account account);

	public List<ReportDeliveryTrackingHistory> getHistory(
			ReportDeliveryTracking reportDeliveryTracking);

	public void merge(ReportDeliveryTracking reportDeliveryTracking);
}
