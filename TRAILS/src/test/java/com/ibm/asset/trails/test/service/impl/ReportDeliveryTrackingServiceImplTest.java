package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.assertNotNull;

import java.util.Date;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ReportDeliveryTracking;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ReportDeliveryTrackingService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ReportDeliveryTrackingServiceImplTest {

	@Autowired
	private ReportDeliveryTrackingService reportDeliveryTrackingService;

	@Autowired
	private AccountService accountService;

	@Test
	public void testMergeForNew() {
		Account account = accountService.getAccount(2541L);

		ReportDeliveryTracking reportDeliveryTracking = buildReportDeliveryTracking(account);

		reportDeliveryTrackingService.merge(reportDeliveryTracking);

		assertNotNull(reportDeliveryTracking.getId());
	}

	@Test
	public void testGetByAccount() {
		Account account = accountService.getAccount(2541L);
		ReportDeliveryTracking retrived = reportDeliveryTrackingService
				.getByAccount(account);

		assertNotNull(retrived);
	}

	private ReportDeliveryTracking buildReportDeliveryTracking(Account account) {
		ReportDeliveryTracking reportDeliveryTracking = new ReportDeliveryTracking();
		reportDeliveryTracking.setRecordTime(new Date());
		reportDeliveryTracking.setRemoteUser("JUNIT");
		reportDeliveryTracking.setQmxReference("testing reference");
		reportDeliveryTracking.setReportingCycle("weekly");
		reportDeliveryTracking.setLastDeliveryTime(new Date());
		reportDeliveryTracking.setAccount(account);
		reportDeliveryTracking.setNextDeliveryTime(new Date());
		return reportDeliveryTracking;
	}

}
