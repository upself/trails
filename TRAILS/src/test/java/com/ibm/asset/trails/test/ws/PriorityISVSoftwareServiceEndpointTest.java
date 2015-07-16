package com.ibm.asset.trails.test.ws;

import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.core.MediaType;

import org.apache.cxf.endpoint.Server;
import org.apache.cxf.interceptor.LoggingInInterceptor;
import org.apache.cxf.interceptor.LoggingOutInterceptor;
import org.apache.cxf.jaxrs.JAXRSServerFactoryBean;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.jaxrs.json.JacksonJaxbJsonProvider;
import com.fasterxml.jackson.jaxrs.xml.JacksonJaxbXMLProvider;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;
import com.ibm.asset.trails.ws.PriorityISVSoftwareServiceEndpoint;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class PriorityISVSoftwareServiceEndpointTest {
	
    private static final String RESTFUL_SERVICE_ROOT_URL = "http://localhost:8090/TRAILS/ws";//Local Restful Service Root
	
	@Autowired
	private PriorityISVSoftwareServiceEndpoint priorityISVSoftwareServiceEndpoint;
    
	@Test
	public void initData(){
	  //Create JAXRS Server Factory Bean and Startup Restul Service	
	  JAXRSServerFactoryBean rsFactory = new JAXRSServerFactoryBean();
	  rsFactory.setServiceBean(priorityISVSoftwareServiceEndpoint);
	  rsFactory.setAddress(RESTFUL_SERVICE_ROOT_URL);
	  rsFactory.getInInterceptors().add(new LoggingInInterceptor());
	  rsFactory.getOutInterceptors().add(new LoggingOutInterceptor());
	  List<Object> providers = new ArrayList<Object>();
	  providers.add(new JacksonJaxbJsonProvider());//Support JSON Data Format
	  providers.add(new JacksonJaxbXMLProvider());//Support XML Data Format
	  rsFactory.setProviders(providers);
	  Server localServer = rsFactory.create();
	  
	  assertTrue(localServer!=null); 
	}

	@Test
	@SuppressWarnings("unchecked")
	public void testGetAllPriorityISVSoftwareDisplays(){
	    WSMsg wsMsg = priorityISVSoftwareServiceEndpoint.getAllPriorityISVSoftwareDisplays();
	   
		List<PriorityISVSoftwareDisplay> results =  (List<PriorityISVSoftwareDisplay>) wsMsg.getDataList();
	    if(null!=results){
	    	System.out.println("Total Priority ISV Software Record Count: "+results.size());
	    }
	    assertTrue(null!=results && results.size()>=0);
	}
	
    //@Test
	@SuppressWarnings({"resource"})
	public void testGetAllPriorityISVSoftwareDisplaysByHttpMode() {
		int httpStatusCode = -1;
		WSMsg returnWSMsgObj = null;
		String appStatusCode = "";
        
		try {
			HttpClient httpClient = new DefaultHttpClient();
			HttpGet httpGet = new HttpGet(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv/all");
			httpGet.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			
			HttpResponse response = httpClient.execute(httpGet);
			StatusLine statusLine = response.getStatusLine();
			httpStatusCode = statusLine.getStatusCode();
			
			if(httpStatusCode == 200){
				returnWSMsgObj = this.generateReturnWSMsgObject(response.getEntity());
				if(returnWSMsgObj!=null){
					appStatusCode = returnWSMsgObj.getStatus();
				}
			}
		  } 
		catch (Exception e) {
			System.out.println("Exception: "+e.getMessage());
		}
		
		assertTrue(httpStatusCode == 200 && appStatusCode!=null && appStatusCode.trim().equals(WSMsg.SUCCESS));
	}
	
	
	//@Test
	public void testGetPriorityISVSoftwareDisplayById(){
		Long isvId = new Long(10);//Please change this value based on actual situation
	    WSMsg wsMsg = priorityISVSoftwareServiceEndpoint.getPriorityISVSoftwareDisplayById(isvId);
	   
		PriorityISVSoftwareDisplay priorityISVSoftwareDisplay = (PriorityISVSoftwareDisplay)wsMsg.getData();
	    if(null!=priorityISVSoftwareDisplay){
	    	System.out.println("Prority ISV Software Record has been found for id: "+isvId.intValue());
	    }
	    assertTrue(null!=priorityISVSoftwareDisplay);
	}
	
	//@Test
	public void testGetPriorityISVSoftwareDisplayByIdByHttpMode(){
		int httpStatusCode = -1;
		WSMsg returnWSMsgObj = null;
		String appStatusCode = "";
        String isvid = "10";//Please change this value based on actual situation
		
		try {
			HttpClient httpClient = new DefaultHttpClient();
			HttpGet httpGet = new HttpGet(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv/"+isvid);
			httpGet.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			
			HttpResponse response = httpClient.execute(httpGet);
			StatusLine statusLine = response.getStatusLine();
			httpStatusCode = statusLine.getStatusCode();
			
			if(httpStatusCode == 200){
				returnWSMsgObj = this.generateReturnWSMsgObject(response.getEntity());
				if(returnWSMsgObj!=null){
					appStatusCode = returnWSMsgObj.getStatus();
				}
			}
		  } 
		catch (Exception e) {
			System.out.println("Exception: "+e.getMessage());
		}
		
		assertTrue(httpStatusCode == 200 && appStatusCode!=null && appStatusCode.trim().equals(WSMsg.SUCCESS));	
	}
	
	//@Test
	@SuppressWarnings("unchecked")
	public void tesGetPriorityISVSoftwareHDisplaysByISVSoftwareId(){
		Long isvId = new Long(10);//Please change this value based on actual situation
	    WSMsg wsMsg = priorityISVSoftwareServiceEndpoint.getPriorityISVSoftwareHDisplaysByISVSoftwareId(isvId);
	   
		List<PriorityISVSoftwareHDisplay> results =  (List<PriorityISVSoftwareHDisplay>) wsMsg.getDataList();
	    if(null!=results){
	    	System.out.println("There are "+results.size()+" Priority ISV Software History Records found for Priority ISV id: "+isvId.intValue()+"");
	    }
	    
	    assertTrue(null!=results && results.size()>=0);
	}
	
	//@Test
	public void tesGetPriorityISVSoftwareHDisplaysByISVSoftwareIdByHttpMode(){
		int httpStatusCode = -1;
		WSMsg returnWSMsgObj = null;
		String appStatusCode = "";
		String isvid = "10";//Please change this value based on actual situation
        
		try {
			HttpClient httpClient = new DefaultHttpClient();
			HttpGet httpGet = new HttpGet(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isvh/"+isvid);
			httpGet.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			
			HttpResponse response = httpClient.execute(httpGet);
			StatusLine statusLine = response.getStatusLine();
			httpStatusCode = statusLine.getStatusCode();
			
			if(httpStatusCode == 200){
				returnWSMsgObj = this.generateReturnWSMsgObject(response.getEntity());
				if(returnWSMsgObj!=null){
					appStatusCode = returnWSMsgObj.getStatus();
				}
			}
		  } 
		catch (Exception e) {
			System.out.println("Exception: "+e.getMessage());
		}
		
		assertTrue(httpStatusCode == 200 && appStatusCode!=null && appStatusCode.trim().equals(WSMsg.SUCCESS));	
	}
	
	//@Test
	public void tesAddPriorityISVSoftwareByHttpMode(){
		int httpStatusCode = -1;
		WSMsg returnWSMsgObj = null;
		String appStatusCode = "";
		
		try {
			HttpClient httpClient = new DefaultHttpClient();
			HttpPut httpPut = new HttpPut(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv");
			httpPut.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			
			JSONObject addJSONObject = this.buildAddISVJSONObject();
			String addJSONObjectString = addJSONObject.toString();
			System.out.println("Add ISV Object JSON String: "+addJSONObjectString);
			
			StringEntity se = new StringEntity(addJSONObjectString);
			se.setContentType(MediaType.APPLICATION_JSON);
					
			httpPut.setEntity(se);
			HttpResponse response = httpClient.execute(httpPut);
			StatusLine statusLine = response.getStatusLine();
			httpStatusCode = statusLine.getStatusCode();
			
			if(httpStatusCode == 200){
			  returnWSMsgObj = this.generateReturnWSMsgObject(response.getEntity());
			  appStatusCode = returnWSMsgObj.getStatus();
			}
            
		  } 
		catch (Exception e) {
			System.out.println("Exception: "+e.getMessage());
		}
		
		assertTrue(httpStatusCode == 200 && appStatusCode!=null && appStatusCode.trim().equals(WSMsg.SUCCESS));
	}
	
	//@Test
	public void tesUpdatePriorityISVSoftwareByHttpMode(){
		int httpStatusCode = -1;
		WSMsg returnWSMsgObj = null;
		String appStatusCode = "";
		String isvid = "17";//Please change this value based on actual situation
		
		try {
			HttpClient httpClient = new DefaultHttpClient();
			HttpPut httpPut = new HttpPut(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv/"+isvid);
			httpPut.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			
			JSONObject updateJSONObject = this.buildUpdateISVJSONObject();
			String updateJSONObjectString = updateJSONObject.toString();
			System.out.println("Update ISV Object JSON String: "+updateJSONObjectString);
			
			StringEntity se = new StringEntity(updateJSONObjectString);
			se.setContentType(MediaType.APPLICATION_JSON);
					
			httpPut.setEntity(se);
			HttpResponse response = httpClient.execute(httpPut);
			StatusLine statusLine = response.getStatusLine();
			httpStatusCode = statusLine.getStatusCode();
			
			if(httpStatusCode == 200){
			  returnWSMsgObj = this.generateReturnWSMsgObject(response.getEntity());
			  appStatusCode = returnWSMsgObj.getStatus();
			}
            
		  } 
		catch (Exception e) {
			System.out.println("Exception: "+e.getMessage());
		}
		
		assertTrue(httpStatusCode == 200 && appStatusCode!=null && appStatusCode.trim().equals(WSMsg.SUCCESS));
	}
	
	@Test
	public void tesCrossLevelPriorityISVSoftwareByHttpMode(){
		int httpStatusCode = -1;
		int httpStatusCode2 = -1;
		int httpStatusCode3 = -1;
		int httpStatusCode4 = -1;
		WSMsg returnWSMsgObj = null;
		String appStatusCode = "";
		WSMsg returnWSMsgObj2 = null;
		String appStatusCode2 = "";
		
		try {
			@SuppressWarnings("resource")
			HttpClient httpClient = new DefaultHttpClient();
			HttpPut httpPut = new HttpPut(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv");
			httpPut.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			
			JSONObject addJSONObject = this.buildAddISVJSONObject();
			String addJSONObjectString = addJSONObject.toString();
			System.out.println("Add ISV Object JSON String: "+addJSONObjectString);
			
			StringEntity se = new StringEntity(addJSONObjectString);
			se.setContentType(MediaType.APPLICATION_JSON);
					
			httpPut.setEntity(se);
			HttpResponse response = httpClient.execute(httpPut);
			StatusLine statusLine = response.getStatusLine();
			httpStatusCode = statusLine.getStatusCode();
			
			
			@SuppressWarnings("resource")
			HttpClient httpClient2 = new DefaultHttpClient();
			HttpPut httpPut2 = new HttpPut(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv");
			httpPut2.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			JSONObject addGLBJSONObject = this.buildGlobalISVJSONObject();
			String addGLBJSONObjectString = addGLBJSONObject.toString();
			System.out.println("Add ISV Object JSON String: "+addGLBJSONObjectString);
			
			StringEntity se2 = new StringEntity(addGLBJSONObjectString);
			se2.setContentType(MediaType.APPLICATION_JSON);
					
			httpPut2.setEntity(se2);
			HttpResponse response2 = httpClient2.execute(httpPut2);
			StatusLine statusLine2 = response2.getStatusLine();
			httpStatusCode2 = statusLine2.getStatusCode();
			if(httpStatusCode2 == 200){
			returnWSMsgObj = this.generateReturnWSMsgObject(response2.getEntity());
			appStatusCode = returnWSMsgObj.getStatus();
			}
            
			@SuppressWarnings("resource")
			HttpClient httpClient3 = new DefaultHttpClient();
			HttpPut httpPut3 = new HttpPut(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv");
			httpPut3.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			
			JSONObject addJSONObject3 = this.buildGlobalISVJSONObject2();
			String addJSONObjectString3 = addJSONObject3.toString();
			System.out.println("Add ISV Object JSON String: "+addJSONObjectString3);
			
			StringEntity se3 = new StringEntity(addJSONObjectString3);
			se3.setContentType(MediaType.APPLICATION_JSON);
					
			httpPut3.setEntity(se3);
			HttpResponse response3 = httpClient3.execute(httpPut3);
			StatusLine statusLine3 = response3.getStatusLine();
			httpStatusCode3 = statusLine3.getStatusCode();
			
			
			@SuppressWarnings("resource")
			HttpClient httpClient4 = new DefaultHttpClient();
			HttpPut httpPut4 = new HttpPut(RESTFUL_SERVICE_ROOT_URL+"/priorityISV/isv");
			httpPut4.addHeader("ACCEPT", MediaType.APPLICATION_JSON);
			JSONObject addGLBJSONObject4 = this.buildAccISVJSONObject();
			String addGLBJSONObjectString4 = addGLBJSONObject4.toString();
			System.out.println("Add ISV Object JSON String: "+addGLBJSONObjectString4);
			
			StringEntity se4 = new StringEntity(addGLBJSONObjectString4);
			se4.setContentType(MediaType.APPLICATION_JSON);
					
			httpPut4.setEntity(se4);
			HttpResponse response4 = httpClient4.execute(httpPut4);
			StatusLine statusLine4 = response4.getStatusLine();
			httpStatusCode4 = statusLine4.getStatusCode();
			if(httpStatusCode4 == 200){
			returnWSMsgObj2 = this.generateReturnWSMsgObject(response4.getEntity());
			appStatusCode2 = returnWSMsgObj2.getStatus();
			}
			
		  } 
		catch (Exception e) {
			System.out.println("Exception: "+e.getMessage());
		}
		System.out.println("Add Crossing level Priority ISV SW Object failed message : "+returnWSMsgObj.getMsg());
		assertTrue(httpStatusCode2 == 200 && appStatusCode!=null && appStatusCode.trim().equals(WSMsg.FAIL));
		assertTrue(returnWSMsgObj.getMsg().equals("Priority ISV Software has already existed for [Level = GLOBAL, Customer Id = null, Manufacturer Id = 18]"));
		System.out.println("Add Crossing level Priority ISV SW Object failed message : "+returnWSMsgObj2.getMsg());
		assertTrue(httpStatusCode4 == 200 && appStatusCode2!=null && appStatusCode2.trim().equals(WSMsg.FAIL));
		assertTrue(returnWSMsgObj2.getMsg().equals("Priority ISV Software has already existed for [Level = ACCOUNT, Customer Id = 2541, Manufacturer Id = 21]"));
	
	}
	
	private WSMsg generateReturnWSMsgObject(HttpEntity entity) throws IllegalStateException, IOException, JSONException{
		String responseEntityString="";  
        String responseLineString="";
        InputStream inputStream=entity.getContent();
		BufferedReader reader=new BufferedReader(new InputStreamReader(inputStream));  
		
        while((responseLineString=reader.readLine())!=null){  
        	responseEntityString+=responseLineString;  
        }
        
        JSONObject wsMsgJSONObject = new JSONObject(responseEntityString);
        String appStatusCode = wsMsgJSONObject.getString("status");
        String appMessage = wsMsgJSONObject.getString("msg");
        WSMsg wsMsgObject = null;
        
        if(appStatusCode!=null && appStatusCode.trim().equals(WSMsg.SUCCESS)){
          wsMsgObject = WSMsg.successMessage(appMessage);
        }
        else{
          wsMsgObject = WSMsg.failMessage(appMessage);
        }
       
		return wsMsgObject;
	}
	
	private JSONObject buildAddISVJSONObject() throws JSONException{
		JSONObject addJSONObject = new JSONObject();
		addJSONObject.put("level", "ACCOUNT");//Please change this value based on actual situation
		addJSONObject.put("customerId", 16793);//Please change this value based on actual situation
		addJSONObject.put("manufacturerId", 18);//Please change this value based on actual situation
		addJSONObject.put("evidenceLocation", "TDD Testing for Add");
		addJSONObject.put("statusId", 2);
		addJSONObject.put("businessJustification", "TDD Testing for Add");
		addJSONObject.put("remoteUser", "TDD Testing User");
		return addJSONObject;
	}
	
	private JSONObject buildGlobalISVJSONObject() throws JSONException{
		JSONObject GLBJSONObject = new JSONObject();
		GLBJSONObject.put("level", "GLOBAL");//Please change this value based on actual situation
		GLBJSONObject.put("manufacturerId", 18);//Please change this value based on actual situation
		GLBJSONObject.put("evidenceLocation", "TDD Testing for crossing level Add");
		GLBJSONObject.put("statusId", 2);
		GLBJSONObject.put("businessJustification", "TDD Testing for crossing level Add");
		GLBJSONObject.put("remoteUser", "TDD Testing User");
		return GLBJSONObject;
	}
	
	private JSONObject buildGlobalISVJSONObject2() throws JSONException{
		JSONObject GLBJSONObject = new JSONObject();
		GLBJSONObject.put("level", "GLOBAL");//Please change this value based on actual situation
		GLBJSONObject.put("manufacturerId", 21);//Please change this value based on actual situation
		GLBJSONObject.put("evidenceLocation", "TDD Testing for crossing level Add");
		GLBJSONObject.put("statusId", 2);
		GLBJSONObject.put("businessJustification", "TDD Testing for crossing level Add");
		GLBJSONObject.put("remoteUser", "TDD Testing User");
		return GLBJSONObject;
	}
	
	private JSONObject buildAccISVJSONObject() throws JSONException{
		JSONObject dupJSONObject = new JSONObject();
		dupJSONObject.put("level", "ACCOUNT");
		dupJSONObject.put("customerId", 2541);
		dupJSONObject.put("manufacturerId", 21);
		dupJSONObject.put("evidenceLocation", "TDD Testing for Update");
		dupJSONObject.put("statusId", 2);
		dupJSONObject.put("businessJustification", "TDD Testing for Update");
		dupJSONObject.put("remoteUser", "TDD Testing User");
		return dupJSONObject;
	}
	
	private JSONObject buildUpdateISVJSONObject() throws JSONException{
		JSONObject updateJSONObject = new JSONObject();
		updateJSONObject.put("level", "ACCOUNT");
		updateJSONObject.put("customerId", 16793);
		updateJSONObject.put("manufacturerId", 20);
		updateJSONObject.put("evidenceLocation", "TDD Testing for Update");
		updateJSONObject.put("statusId", 2);
		updateJSONObject.put("businessJustification", "TDD Testing for Update");
		updateJSONObject.put("remoteUser", "TDD Testing User");
		return updateJSONObject;
	}
}
