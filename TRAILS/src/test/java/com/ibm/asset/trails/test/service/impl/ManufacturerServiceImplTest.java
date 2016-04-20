package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.service.ManufacturerService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ManufacturerServiceImplTest {
    
	@Autowired
	private ManufacturerService manufactuerService;
	private String manufacturerName = "CI SOLUTIONS";
	
	@Test
	public void testGetManufacturerByName(){
		Manufacturer manufacturer = manufactuerService
				.findManufacturerByName(manufacturerName);
		assertNotNull(manufacturer);
		System.out.println(manufacturer.getManufacturerName().toString());
	}

}
