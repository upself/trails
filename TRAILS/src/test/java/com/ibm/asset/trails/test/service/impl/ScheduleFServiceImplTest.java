package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.*;

import java.util.ArrayList;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ScheduleFService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ScheduleFServiceImplTest {
	@Autowired
	private ScheduleFService scheduleFService;
	@Autowired
	private AccountService accountService;
	@Autowired
	private SoftwareDAO softwareDAO;
	private String psSoftwareName = "VISTA NETWORKS NET ALLY" ;
	
	@Test
	public void testScheduleFfindSoftwareBySoftwareName() {
		ArrayList<Software> softwareLs = scheduleFService.findSoftwareBySoftwareName(psSoftwareName);
		assertNotNull(softwareLs);
		System.out.println(softwareLs.get(0).getSoftwareName().toString());
	}
	
	@Test
	public void testScheduleFfindScheduleFbyCustomerAndSoftware() {
		Account account = accountService.getAccountByAccountNumber(35400L);
		Software software = softwareDAO.getSoftwareDetails(218119L);
		ScheduleF scheduleF = scheduleFService.findScheduleF(account,software);
		assertNotNull(scheduleF);
		System.out.println(scheduleF.getSoftwareName().toString());
		assertEquals(software,scheduleF.getSoftware());
	}
	

}
