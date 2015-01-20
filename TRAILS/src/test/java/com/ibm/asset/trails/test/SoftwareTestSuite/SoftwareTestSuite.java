package com.ibm.asset.trails.test.SoftwareTestSuite;

import static org.junit.Assert.*;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import com.ibm.asset.trails.test.dao.jpa.AlertUnlicensedSoftwareDAOJpaTest;
import com.ibm.asset.trails.test.dao.jpa.LicenseDAOJpaTest;
import com.ibm.asset.trails.test.dao.jpa.SoftwareDAOJpaTest;

@RunWith(Suite.class)
@SuiteClasses({AlertUnlicensedSoftwareDAOJpaTest.class,LicenseDAOJpaTest.class, SoftwareDAOJpaTest.class})
public class SoftwareTestSuite {
	
	  @BeforeClass 
	  public static void setUpClass() {      
	        System.out.println("Master setup");

	    }

	  @AfterClass 
	  public static void tearDownClass() { 
	        System.out.println("Master tearDown");
	    }
      @Test(timeout=100)
      public void testTimeout(){}

}
