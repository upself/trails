package com.ibm.asset.trails.test.dao.jpa;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.dao.VSoftwareLparDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ScheduleFService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class VSoftwareLparDAOJpaTest {
	private final static String REMOTE_USER        = "TDD Auto Testing";
	
	//ScheduleF Level
	private final static String MANUFACTURER_LEVEL = "MANUFACTURER";
	private final static String PRODUCT_LEVEL      = "PRODUCT";
	private final static String HWOWNER_LEVEL      = "HWOWNER";
	private final static String HWBOX_LEVEL        = "HWBOX";
	private final static String HOSTNAME_LEVEL     = "HOSTNAME";
	
	//Testing Data
	private final static String MANUFACTURER_IBM      = "IBM";
	private final static String MANUFACTURER_IBM_ITD  = "IBM_ITD";
	private final static String HW_OWNER              = "IBM";
	private final static String HWBOX_MACHINE_TYPE    = "2373";
	private final static String HWBOX_SERIAL          = "00RTST5";
	private final static String HOSTNAME              = "RECONTEST3";
	private final static String SOFTWARE_NAME_IBM     = "IBM Lotus Notes";
	private final static String SOFTWARE_NAME_IBM_ITD = "IBM OS/400";
	
    @Autowired
    private VSoftwareLparDAO vSoftwareLparDAO;
    
    @Autowired
	private ScheduleFService scheduleFService;
	
    @Autowired
	private AccountService accountService;
	
    @Autowired
	private SoftwareDAO softwareDAO;

    @Test
    public void testGetScheduleFItem4ManufacturerLevel() {
    	//Set status to 'INACTIVE' for PRODUCT Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF productLevelScheduleF = scheduleFService.getScheduleFDetails(4L);
    	productLevelScheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(productLevelScheduleF, REMOTE_USER);
    	
    	//Set status to 'INACTIVE' for HWOWNER Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hwownerLevelScheduleF = scheduleFService.getScheduleFDetails(5L);
    	hwownerLevelScheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hwownerLevelScheduleF, REMOTE_USER);
    	
    	//Set status to 'INACTIVE' for HWBOX Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hwboxLevelScheduleF = scheduleFService.getScheduleFDetails(6L);
    	hwboxLevelScheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hwboxLevelScheduleF, REMOTE_USER);
    	
    	//Set status to 'INACTIVE' for HOSTNAME Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hostnameLevelscheduleF = scheduleFService.getScheduleFDetails(7L);
    	hostnameLevelscheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hostnameLevelscheduleF, REMOTE_USER);
    	
    	Account account = accountService.getAccountByAccountNumber(35400L);
    	ScheduleF scheduleF = vSoftwareLparDAO.getScheduleFItem(account, SOFTWARE_NAME_IBM, HOSTNAME, HW_OWNER, HWBOX_MACHINE_TYPE, HWBOX_SERIAL, MANUFACTURER_IBM);
    	assertNotNull(scheduleF);
    	assertEquals(MANUFACTURER_IBM,scheduleF.getManufacturer());//Manufacturer Name 'IBM'
    	assertEquals(MANUFACTURER_LEVEL,scheduleF.getLevel());//Schedule Level 'MANUFACTURER'
    }
    
    @Test
    public void testGetScheduleFItem4ProductLevel() {
    	//Set status to 'INACTIVE' for HWOWNER Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hwownerLevelScheduleF = scheduleFService.getScheduleFDetails(5L);
    	hwownerLevelScheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hwownerLevelScheduleF, REMOTE_USER);
    	
    	//Set status to 'INACTIVE' for HWBOX Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hwboxLevelScheduleF = scheduleFService.getScheduleFDetails(6L);
    	hwboxLevelScheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hwboxLevelScheduleF, REMOTE_USER);
    	
    	//Set status to 'INACTIVE' for HOSTNAME Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hostnameLevelscheduleF = scheduleFService.getScheduleFDetails(7L);
    	hostnameLevelscheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hostnameLevelscheduleF, REMOTE_USER);
    	
    	Account account = accountService.getAccountByAccountNumber(35400L);
    	ScheduleF scheduleF = vSoftwareLparDAO.getScheduleFItem(account, SOFTWARE_NAME_IBM, HOSTNAME, HW_OWNER, HWBOX_MACHINE_TYPE, HWBOX_SERIAL, MANUFACTURER_IBM);
    	assertNotNull(scheduleF);
    	assertEquals(SOFTWARE_NAME_IBM,scheduleF.getSoftwareName());//Software Name 'IBM Lotus Notes'
    	assertEquals(PRODUCT_LEVEL,scheduleF.getLevel());//Schedule Level 'PRODUCT'
    }
    
    @Test
    public void testGetScheduleFItem4HWOwnerLevel(){
    	//Set status to 'INACTIVE' for HWBOX Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hwboxLevelScheduleF = scheduleFService.getScheduleFDetails(6L);
    	hwboxLevelScheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hwboxLevelScheduleF, REMOTE_USER);
    	
    	//Set status to 'INACTIVE' for HOSTNAME Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hostnameLevelscheduleF = scheduleFService.getScheduleFDetails(7L);
    	hostnameLevelscheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hostnameLevelscheduleF, REMOTE_USER);
    	
    	Account account = accountService.getAccountByAccountNumber(35400L);
    	ScheduleF scheduleF = vSoftwareLparDAO.getScheduleFItem(account, SOFTWARE_NAME_IBM, HOSTNAME, HW_OWNER, HWBOX_MACHINE_TYPE, HWBOX_SERIAL, MANUFACTURER_IBM);
    	assertNotNull(scheduleF);
    	assertEquals(SOFTWARE_NAME_IBM,scheduleF.getSoftwareName());//Software Name 'IBM Lotus Notes'
    	assertEquals(HWOWNER_LEVEL,scheduleF.getLevel());//Schedule Level 'HWOWNER'
    }
    
    @Test
    public void testGetScheduleFItem4HWBoxLevel() {
    	//Set status to 'INACTIVE' for HOSTNAME Level ScheduleF for Software 'IBM Lotus Notes'
    	ScheduleF hostnameLevelscheduleF = scheduleFService.getScheduleFDetails(7L);
    	hostnameLevelscheduleF.getStatus().setId(1L);
    	scheduleFService.saveScheduleF(hostnameLevelscheduleF, REMOTE_USER);
    	
    	Account account = accountService.getAccountByAccountNumber(35400L);
    	ScheduleF scheduleF = vSoftwareLparDAO.getScheduleFItem(account, SOFTWARE_NAME_IBM, HOSTNAME, HW_OWNER, HWBOX_MACHINE_TYPE, HWBOX_SERIAL, MANUFACTURER_IBM);
    	assertNotNull(scheduleF);
    	assertEquals(SOFTWARE_NAME_IBM,scheduleF.getSoftwareName());//Software Name 'IBM Lotus Notes'
    	assertEquals(HWBOX_LEVEL,scheduleF.getLevel());//Schedule Level 'HWBOX'
    }
    
    @Test
    public void testGetScheduleFItem4HostnameLevel() {
    	Account account = accountService.getAccountByAccountNumber(35400L);
    	ScheduleF scheduleF = vSoftwareLparDAO.getScheduleFItem(account, SOFTWARE_NAME_IBM, HOSTNAME, HW_OWNER, HWBOX_MACHINE_TYPE, HWBOX_SERIAL, MANUFACTURER_IBM);
    	assertNotNull(scheduleF);
    	assertEquals(SOFTWARE_NAME_IBM,scheduleF.getSoftwareName());//Software Name 'IBM Lotus Notes'
    	assertEquals(HOSTNAME_LEVEL,scheduleF.getLevel());//Schedule Level 'HOSTNAME'
    }
    
    
    @Test
    public void testGetScheduleFItem4ManufacturerIBM_ITD(){
    	Account account = accountService.getAccountByAccountNumber(35400L);
    	ScheduleF scheduleF = vSoftwareLparDAO.getScheduleFItem(account, SOFTWARE_NAME_IBM_ITD, HOSTNAME, HW_OWNER, HWBOX_MACHINE_TYPE, HWBOX_SERIAL, MANUFACTURER_IBM_ITD);
    	assertNotNull(scheduleF);
    	assertEquals(MANUFACTURER_IBM_ITD,scheduleF.getManufacturer());//Manufacturer Name 'IBM_ITD'
    	assertEquals(MANUFACTURER_LEVEL,scheduleF.getLevel());//Schedule Level 'MANUFACTURER'
    }
}
