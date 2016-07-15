package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Date;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.form.AlertOverviewReport;
import com.ibm.asset.trails.form.SwTrackingAlertReport;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.SwTrackingReportService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional(propagation = Propagation.REQUIRED)
public class SwTrackingReportServiceImplTest {
	@Autowired
	private SwTrackingReportService SwTrackingReportService;
	@Autowired
	private AccountService accountService;
	
	private ArrayList<SwTrackingAlertReport>  swTrackingAlertList;
	private ArrayList<AlertOverviewReport> swTrackingOverviewList;
	
	@Test
	public void testGetReportTiemstamp(){
		Date datetime  = (Date) SwTrackingReportService.selectReportTimestamp();
		//System.out.print(datetime.toString());
        assertTrue(datetime.toString().equals("2016-07-03 20:26:51.0"));
	}
	
	@Test
	public void testGetSwTrackingAlertsOverview(){
		Account account = accountService.getAccount(2541L);
		swTrackingOverviewList = SwTrackingReportService.getSwTrackingAlertsOverview(account);
		assertNotNull(swTrackingOverviewList);
	}
	
	//@Test
	public void testGetGeographySwTrackingAlertReport(){
		Account account = accountService.getAccount(2541L);
		Geography geography = account.getCountryCode().getRegion().getGeography();
		swTrackingAlertList = SwTrackingReportService.getGeographySwTrackingAlertReport();
		assertNotNull(swTrackingAlertList);
	}
}