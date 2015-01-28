package com.ibm.asset.trails.test.fixtures;

import java.io.Closeable;
import java.io.IOException;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.LicenseService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class AccountFixtures {

	@Autowired
	private AccountService accountService;

	@Autowired
	private LicenseService licenseService;
	
	private License testLicense;
	private Account testAccount;	
	
	  @Before
	  public void setUp() {
		  setTestLicense(licenseService.findById(Long.valueOf(337239)));
		  setTestAccount(accountService.getAccount(Long.valueOf(2676)));	
	  }
	  
	  private void println(String string) {
		    System.out.println(string);
		  }
	  
	  @After
	  public void tearDown() throws IOException {
		  this.println("@After tearDown");
	  }
	  
	  @Test
      public void test(){}
	  
		public Account getTestAccount() {
			return testAccount;
		}

		public void setTestAccount(Account testAccount) {
			this.testAccount = testAccount;
		}
		
		public License getTestLicense() {
			return testLicense;
		}

		public void setTestLicense(License testLicense) {
			this.testLicense = testLicense;
		}
}
