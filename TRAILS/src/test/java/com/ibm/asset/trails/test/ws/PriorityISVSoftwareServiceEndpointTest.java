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
	
    @Test
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
