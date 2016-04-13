package com.ibm.asset.trails.test.ws;

import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.ws.ScheduleFServiceEndpoint;
import com.ibm.asset.trails.ws.common.Pagination;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ScheduleFServiceEndpointTest {
	
	private static final String RESTFUL_SERVICE_ROOT_URL = "http://localhost:8080/TRAILS/ws";//Local Restful Service Root
	
	@Autowired
	private ScheduleFServiceEndpoint scheduleFServiceEndpoint;
	
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
	
	@Test
	@SuppressWarnings("unchecked")
	public void testGetOnePageOfScheduleFView(){
	    WSMsg wsMsg = scheduleFServiceEndpoint.getAllScheduleFByAccount(1,10,"id","desc",2541L);
		Pagination page = (Pagination) wsMsg.getData();
	    if(null!=page){
	    	System.out.println("Get one page of ScheduleF List, current page is  "+page.getCurrentPage()+", pagaSize is "+page.getPageSize()+", total is "+page.getTotal()+";");
	    	assertTrue(1 ==page.getCurrentPage() && 10 == page.getPageSize());
	    }
	    assertTrue(null != page);
	}
	
	@SuppressWarnings("deprecation")
	//@Test
	public void testGetScheduleFbyId(){
		int httpStatusCode = -1;
		WSMsg returnWSMsgObj = null;
		String appStatusCode = "";
		String sfid = "1300133";
        
		try {
			@SuppressWarnings("resource")
			HttpClient httpClient = new DefaultHttpClient();
			HttpGet httpGet = new HttpGet(RESTFUL_SERVICE_ROOT_URL+"/scheduleF/"+sfid);
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
		
		System.out.println("httpStatusCode "+httpStatusCode +"appStatusCode"+appStatusCode);
		assertTrue(httpStatusCode == 200 && appStatusCode!=null && appStatusCode.trim().equals(WSMsg.SUCCESS));
		
	}

}
