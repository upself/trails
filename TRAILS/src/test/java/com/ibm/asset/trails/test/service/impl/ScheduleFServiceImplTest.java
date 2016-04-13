package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ScheduleFService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional(propagation = Propagation.REQUIRED)
public class ScheduleFServiceImplTest {
	@Autowired
	private ScheduleFService scheduleFService;
	@Autowired
	private AccountService accountService;
	@Autowired
	private SoftwareDAO softwareDAO;
	private String psSoftwareName = "IBM Lotus Notes" ;
	private String manufacturerName = "CI SOLUTIONS";
	private Account testAccount;
	
	@Test
	public void testScheduleFfindScheduleFbyLevelAndSw() {
		testAccount = accountService.getAccount(Long.valueOf(2541));
		List<ScheduleF> scheduleFList = scheduleFService.findScheduleF(testAccount,psSoftwareName,ScheduleFLevelEnumeration.HWOWNER
				.toString());
		assertNotNull(scheduleFList);
		System.out.println(scheduleFList.get(0).getSoftwareName().toString());
	}
	
	@Test
	public void testScheduleFbyId() {
		ScheduleF scheduleF1 = scheduleFService.getScheduleFDetails(3L);
		ScheduleF scheduleF2 = scheduleFService.findScheduleF(4L);
		assertNotNull(scheduleF1);
		System.out.println(scheduleF1.getSoftwareName().toString());
		assertNotNull(scheduleF2);
		System.out.println(scheduleF2.getManufacturer().toString());
	}
	
	@Test
	public void testScheduleFfindScheduleFbyLevelAndManufacturer() {
		testAccount = accountService.getAccount(Long.valueOf(2541));
		List<ScheduleF> scheduleFList = scheduleFService.findScheduleFbyManufacturer(testAccount,manufacturerName,ScheduleFLevelEnumeration.MANUFACTURER
				.toString());
		assertNotNull(scheduleFList);
		System.out.println(scheduleFList.get(0).getManufacturer().toString());
	}

}
