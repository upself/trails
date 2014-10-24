package com.ibm.asset.trails.reader;

import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.batch.core.BatchStatus;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.ParseException;
import org.springframework.batch.item.UnexpectedInputException;
import org.springframework.batch.item.xml.StaxEventItemReader;
import org.springframework.batch.test.JobLauncherTestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.oxm.xstream.XStreamMarshaller;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.ibm.asset.swkbt.schema.AliasType;
import com.ibm.asset.swkbt.schema.ManufacturerType;
import com.ibm.asset.swkbt.schema.PlatformType;
import com.ibm.asset.trails.batch.swkbt.service.AliasService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.SwkbtLoaderService;
import com.ibm.asset.trails.dao.jpa.ManufacturerDaoJpa;
import com.ibm.asset.trails.domain.Alias;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Platform;

@ContextConfiguration(locations = { "file:/opt/asset/conf/launch-context.xml" })
@RunWith(SpringJUnit4ClassRunner.class)
public class TestReader {
    protected static final String TX_MANAGER = "transactionManager";
        
    protected StepExecution stepExecution;
    
	@Autowired
	public AliasService aliasService;
	
	@Autowired
	public ManufacturerService manufacturerService;
	
	@Autowired
	public Jaxb2Marshaller swkbtMarshaller;
	
	
     
    
	@Test
	public void testReader() {
		StaxEventItemReader<PlatformType> canonicalReader2 = new StaxEventItemReader<PlatformType>();

		Resource resource = new FileSystemResource("/home/alexmois/swkbt/loader/platform.xml") ;
		canonicalReader2.setFragmentRootElementName("Platform");
		canonicalReader2.setResource(resource);
		canonicalReader2.setUnmarshaller(swkbtMarshaller);
		canonicalReader2.open(new ExecutionContext());
		try {
			PlatformType platform = (PlatformType)canonicalReader2.read();
			if ( platform == null ) {
				System.out.println("No Platform found");
			} else {
				System.out.println("Platform read " + platform.getName());
			}
		} catch (UnexpectedInputException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}	    
}
