package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
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
import com.ibm.asset.trails.service.impl.ScheduleFServiceImpl;

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
	private String psSoftwareName2 = "PASSLOGIX V-GO SSPR" ;
	private String psSoftwareName3 =  "Beyond Trust";
	private String manufacturerName = "CI SOLUTIONS";
	private Account testAccount;
	
	@Test
	public void testScheduleFfindSoftwareByName(){
		ArrayList<Software> softwareList = scheduleFService.findSoftwareBySoftwareName(psSoftwareName);
		assertNotNull(softwareList);
		ArrayList<Software> softwareList3 = scheduleFService.findSoftwareBySoftwareName(psSoftwareName3);
		assertNotNull(softwareList3);
	}
	
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
		ScheduleF scheduleF1 = scheduleFService.getScheduleFDetails(3001L);
		ScheduleF scheduleF2 = scheduleFService.findScheduleF(3002L);
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
	
	//@Test
	public void testTriggeredReconWhenScheduleFSave(){
		String psRemoteUser = "zhysz@cn.ibm.com";
		testAccount = accountService.getAccount(Long.valueOf(2541));
		ArrayList<Software> softwareList = scheduleFService.findSoftwareBySoftwareName(psSoftwareName2);
		ScheduleF psfSave = new ScheduleF();
		psfSave.setAccount(testAccount);
		psfSave.setLevel(ScheduleFLevelEnumeration.PRODUCT.toString());
		psfSave.setSoftware(softwareList.get(0));
		ScheduleFService scheduleFServiceImpl = Mockito.mock(ScheduleFServiceImpl.class);
		scheduleFServiceImpl.saveScheduleF(psfSave, psRemoteUser);
	}

}
