package com.ibm.asset.trails.test.ws;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFView;
import com.ibm.asset.trails.ws.ScheduleFServiceEndpoint;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ScheduleFServiceEndpointTest {
	
	@Autowired
	private ScheduleFServiceEndpoint scheduleFServiceEndpoint;
	
	@Test
	public void testGetOnePageOfScheduleFView(){
	    WSMsg wsMsg = scheduleFServiceEndpoint.getAllScheduleFByAccount(1,10,"id","desc",2541L);
		Pagination page = (Pagination) wsMsg.getData();
	    if(null!=page){
	    	System.out.println("Get one page of ScheduleF List, current page is  "+page.getCurrentPage()+", pagaSize is "+page.getPageSize()+", total is "+page.getTotal()+";");
	    	assertTrue(1 ==page.getCurrentPage() && 10 == page.getPageSize());
	    }
	    assertTrue(null != page);
	}

	@Test
	public void testGetScheduleFViewbyId(){
		 WSMsg wsMsg = scheduleFServiceEndpoint.getScheduleFViewById(3002L,2541L);
		    if(null!=wsMsg){
		    	assertNotNull(wsMsg.getData());
		    	assertTrue(wsMsg.getData() instanceof ScheduleFView);
		    	System.out.println("wsMsg : " +wsMsg.getMsg());
		    }
	}
	
	@Test
	public void testAddToExistingSwScheduleF(){
		HttpServletRequest request = Mockito.mock(HttpServletRequest.class);
		Mockito.when(request.getRemoteUser()).thenReturn("zhysz@cn.ibm.com");
	    WSMsg wsMsg = scheduleFServiceEndpoint.saveUpdateScheduleF(	2541L,null,"IBM Lotus Notes","HWOWNER","IBM"
	    		,null,null,null,"IBM Lotus Notes","IBM","IBM owned, IBM managed","AMCB-SLM-16206-03","ACTIVE","IBM",true,"IBM","PE note","Test Duplicating ACTIVE sw level record"
	    		, request);
	    if(null!=wsMsg){
	    	assertTrue(wsMsg.getMsg().equals("Same entry with the given software name already exists."));
	    	System.out.println("wsMsg : " +wsMsg.getMsg());
	    }
	}
	
	@Test
	public void testAddToExistingManufacturerScheduleF(){
		HttpServletRequest request = Mockito.mock(HttpServletRequest.class);
		Mockito.when(request.getRemoteUser()).thenReturn("zhysz@cn.ibm.com");
	    WSMsg wsMsg = scheduleFServiceEndpoint.saveUpdateScheduleF(	2541L,null,"","MANUFACTURER",null
	    		,null,null,null,null,"CI SOLUTIONS","IBM owned, IBM managed","JMCB-SLM-10197-03","ACTIVE","IBM",true,"IBM","PE note","Test Duplicating ACTIVE manufacturer level record"
	    		, request);
	    if(null!=wsMsg){
	    	assertTrue(wsMsg.getMsg().equals("Same entry with the given manufacturer name already exists."));
	    	System.out.println("wsMsg : " +wsMsg.getMsg());
	    }
	}
	
	@Test
	public void testUpdateToExistingOtherScheduleF(){
		HttpServletRequest request = Mockito.mock(HttpServletRequest.class);
		Mockito.when(request.getRemoteUser()).thenReturn("zhysz@cn.ibm.com");
	    WSMsg wsMsg = scheduleFServiceEndpoint.saveUpdateScheduleF(	2541L,"3001","","MANUFACTURER",null
	    		,null,null,null,null,"CI SOLUTIONS","IBM owned, IBM managed","JMCB-SLM-10197-03","ACTIVE","IBM",true,"IBM","PE note","Test Duplicating ACTIVE manufacturer level record"
	    		, request);
	    if(null!=wsMsg){
	    	assertTrue(wsMsg.getMsg().equals("Same entry with the given manufacturer name already exists."));
	    	System.out.println("wsMsg : " +wsMsg.getMsg());
	    }
	}
	
	@Test
	public void testAddNotExistingSwButActiveScheduleF(){
		HttpServletRequest request = Mockito.mock(HttpServletRequest.class);
		Mockito.when(request.getRemoteUser()).thenReturn("zhysz@cn.ibm.com");
	    WSMsg wsMsg = scheduleFServiceEndpoint.saveUpdateScheduleF(	2541L,null,"IAM not Existing","PRODUCT",null
	    		,null,null,null,"IAM not Exists","IAM","IBM owned, IBM managed","IAM-SLM-19996-03","ACTIVE","IBM",true,"IBM","PE note","Test Not existing SW product but ACTIVE status of sw level record"
	    		, request);
	    if(null!=wsMsg){
	    	assertTrue(wsMsg.getMsg().equals("Software does not exist in catalog. It may already been removed in SWKB Toolkit."));
	    	System.out.println("wsMsg : " +wsMsg.getMsg());
	    }
	}
	
	@Test
	public void testAddNotExistingSwButInActiveScheduleF(){
		HttpServletRequest request = Mockito.mock(HttpServletRequest.class);
		Mockito.when(request.getRemoteUser()).thenReturn("zhysz@cn.ibm.com");
	    WSMsg wsMsg = scheduleFServiceEndpoint.saveUpdateScheduleF(	2541L,null,"IAM not Existing","PRODUCT",null
	    		,null,null,null,"IAM not Exists","IAM","IBM owned, IBM managed","INA-SLM-19996-03","INACTIVE","IBM",true,"IBM","PE note","Test Not existing SW product but INACTIVE status of sw level record"
	    		, request);
	    if(null!=wsMsg){
	    	assertTrue(wsMsg.getMsg().equals("Add/Update Schedule F success"));
	    	System.out.println("wsMsg : " +wsMsg.getMsg());
	    }
	}
	
	@Test
	public void testAddNotExistingManufacturerButActiveScheduleF(){
		HttpServletRequest request = Mockito.mock(HttpServletRequest.class);
		Mockito.when(request.getRemoteUser()).thenReturn("zhysz@cn.ibm.com");
	    WSMsg wsMsg = scheduleFServiceEndpoint.saveUpdateScheduleF(	2541L,null,"","MANUFACTURER",null
	    		,null,null,null,null,"IAM not Existing","IBM owned, IBM managed","IAM-SLM-19937-03","ACTIVE","IBM",true,"IBM","PE note","Test Not existing manufacturer but ACTIVE status of manufacturer level record"
	    		, request);
	    if(null!=wsMsg){
	    	assertTrue(wsMsg.getMsg().equals("Manufacturer does not exist in catalog. It may already been removed in SWKB Toolkit."));
	    	System.out.println("wsMsg : " +wsMsg.getMsg());
	    }
	}
	
	@Test
	public void testAddNotExistingManufacturerButInActiveScheduleF(){
		HttpServletRequest request = Mockito.mock(HttpServletRequest.class);
		Mockito.when(request.getRemoteUser()).thenReturn("zhysz@cn.ibm.com");
	    WSMsg wsMsg = scheduleFServiceEndpoint.saveUpdateScheduleF(	2541L,null,"","MANUFACTURER",null
	    		,null,null,null,null,"IAM not Existing","IBM owned, IBM managed","INA-SLM-19937-03","INACTIVE","IBM",true,"IBM","PE note","Test Not existing manufacturer but INACTIVE status of manufacturer level record"
	    		, request);
	    if(null!=wsMsg){
	    	assertTrue(wsMsg.getMsg().equals("Add/Update Schedule F success"));
	    	System.out.println("wsMsg : " +wsMsg.getMsg());
	    }
	}

}
