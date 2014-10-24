package com.ibm.asset.trails.batch.writer;

import static org.junit.Assert.*;

import java.util.Iterator;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.batch.core.BatchStatus;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.test.JobLauncherTestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.ibm.asset.swkbt.schema.AliasType;
import com.ibm.asset.swkbt.schema.ManufacturerType;
import com.ibm.asset.trails.batch.swkbt.service.AliasService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.SwkbtLoaderService;
import com.ibm.asset.trails.dao.jpa.ManufacturerDaoJpa;
import com.ibm.asset.trails.domain.Alias;
import com.ibm.asset.trails.domain.Manufacturer;

@ContextConfiguration(locations = { "file:/opt/asset/conf/launch-context.xml" })
@RunWith(SpringJUnit4ClassRunner.class)
public class TestWriter {
    protected static final String TX_MANAGER = "transactionManager";
        
    protected StepExecution stepExecution;
    
	@Autowired
	public AliasService aliasService;
	
	@Autowired
	public ManufacturerService manufacturerService;
	
     
    
    //@Rollback(true)

    @Test
    public void testInsertNewAlias(){
    	AliasType aliasType = createAlias("NAME_0", true);
    	Alias alias = new Alias();
    	System.out.println(aliasType.toString());
    	aliasService.save(aliasType);
    	aliasService.update(alias, aliasType);
    	aliasService.merge(alias);
    	System.out.println(alias.toString());
    	
    	aliasService.flush();
    	
    }
    
    @Test
    public void testInsertNewManufacturor(){
    	ManufacturerType manufacturerType = createManufacturerType("NAME_0", "AADBE", "http://website");
    	Manufacturer manufacturer = new Manufacturer();
    	System.out.println(manufacturerType.toString());
    	Manufacturer man2 = manufacturerService.findById(1L);
    	System.out.println("Existing record: " + man2.getId());
    	manufacturerService.save(manufacturerType);
    	manufacturerService.update(manufacturer, manufacturerType);
    	System.out.println(manufacturer.toString());
    	ManufacturerDaoJpa manufacturerDaoJpa = new ManufacturerDaoJpa();
    	manufacturerDaoJpa.persist(manufacturer);
    }
    
    ManufacturerType createManufacturerType (String name, String guid, String website) {
    	ManufacturerType manufacturerType = new ManufacturerType();
    	manufacturerType.setName(name);
    	manufacturerType.setGuid(guid);
    	manufacturerType.setWebsite(website);
    	return manufacturerType;
    }
    AliasType createAlias(String name, boolean preferred) {
    	AliasType aliasType = new AliasType();
    	aliasType.setName(name);
    	aliasType.setPreferred(preferred);
    	return aliasType;
    	
    }
    
}
