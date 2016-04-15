package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.ListIterator;

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
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.asset.trails.service.impl.ScheduleFServiceImpl;
import com.ibm.asset.trails.test.utils.PartyMatcher;

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
	private String psSoftwareName = "ADOBE ACROBAT ELEMENTS" ;
	private String psSoftwareName2 = "PASSLOGIX V-GO SSPR" ;
	private String psSoftwareName3 =  "Beyond Trust";
	private String manufacturerName = "CI SOLUTIONS";
	private String manufacturerName2 = "PASSLOGIX";
	private String scopeDescription = "IBM owned, IBM managed";
	private String sourceDescription = "C&N contract reading";
	private String remoteUser = "zhysz@cn.ibm.com";
	private Account testAccount;
	
	private Scope findScopeInList(String plScopeDes, ArrayList<Scope> plFind) {
		ListIterator<Scope> lliFind = plFind.listIterator();
		Scope lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getDescription().equalsIgnoreCase(plScopeDes)) {
				break;
			}
		}

		return lsFind;
	}

	private Source findSourceInList(String plSourceDes, ArrayList<Source> plFind) {
		ListIterator<Source> lliFind = plFind.listIterator();
		Source lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getDescription().equalsIgnoreCase(plSourceDes)) {
				break;
			}
		}

		return lsFind;
	}
	
	private Status findStatusInList(String plStatusDesc, ArrayList<Status> plFind) {
		ListIterator<Status> lliFind = plFind.listIterator();
		Status lsFind = null;

		while (lliFind.hasNext()) {
			lsFind = lliFind.next();

			if (lsFind.getDescription().equalsIgnoreCase(plStatusDesc.toString())) {
				break;
			}
		}

		return lsFind;
	}
	
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
		testAccount = accountService.getAccount(Long.valueOf(2541));
		ArrayList<Software> softwareList = scheduleFService.findSoftwareBySoftwareName(psSoftwareName2);
		ScheduleF psfSave = new ScheduleF();
		psfSave.setId(null);
		psfSave.setAccount(testAccount);
		psfSave.setLevel(ScheduleFLevelEnumeration.PRODUCT.toString());
		psfSave.setHostname(null);
		psfSave.setHwOwner(null);
		psfSave.setMachineType(null);
		psfSave.setSerial(null);
		psfSave.setSoftware(softwareList.get(0));
		psfSave.setManufacturer(manufacturerName2);
		psfSave.setManufacturerName(manufacturerName2);
		psfSave.setSoftwareName(psSoftwareName2);
		psfSave.setSoftwareTitle(psSoftwareName2);
		psfSave.setScope(findScopeInList(scopeDescription, scheduleFService
				.getScopeList()));
		psfSave.setSource(findSourceInList(sourceDescription,
				scheduleFService.getSourceList()));
		psfSave.setStatus(findStatusInList("ACTIVE",
				scheduleFService.getStatusList()));
		psfSave.setSWFinanceResp("IBM");
		psfSave.setScheduleFHList(null);
		psfSave.setSourceLocation("JMCB-SLM-10197-03");
		psfSave.setRemoteUser(remoteUser);
		psfSave.setBusinessJustification("Test triggering Recon queue when scheduleF Save");
		psfSave.setRecordTime(new Date());
		
		ScheduleFService scheduleFServiceImpl = Mockito.mock(ScheduleFServiceImpl.class);
		scheduleFServiceImpl.saveScheduleF(psfSave, remoteUser);
		
	}

}
