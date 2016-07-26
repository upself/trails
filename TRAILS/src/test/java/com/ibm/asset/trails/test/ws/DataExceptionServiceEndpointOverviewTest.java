package com.ibm.asset.trails.test.ws;

//import static org.junit.Assert.assertEquals;
//import static org.junit.Assert.assertNotNull;
//import static org.junit.Assert.assertNull;
import static org.junit.Assert.*;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.service.impl.AccountServiceImpl;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;


import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.form.DataExceptionReportActionForm;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.DataExceptionServiceEndpoint;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(MockitoJUnitRunner.class)
public class DataExceptionServiceEndpointOverviewTest {

    // DEPENDENCIES
    @Mock
    private DataExceptionService dataExpSoftwareLparService;

    @Mock
    private DataExceptionService dataExpHardwareLparService;

    @Mock
    private DataExceptionReportService dataExceptionReportService;

    @Mock
    private AccountService accountService;

    @Mock
    private DataExceptionHistoryDao alertHistoryDao;

    @InjectMocks
    private DataExceptionServiceEndpoint endpoint = new DataExceptionServiceEndpoint();

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }
    
    @Test
    public void testNoAccountIdPassedIn() {
        // THIS METHOD WILL NEVER BE CALLED!!!
        // accountSerivce.getAccount(anyLong())
        // 	when(accountService.getAccount(null)).thenReturn(null);

        // MOCK/FAKE => Create a fake copy of a dependency and ALTER its behavior
        // when(<some method call>).thenReturn(<whatever we want>)
        // when(<some method call>).thenThrow(<whatever we want>)

        // SPY!! => Check whether or not a method was called
        // WHAT WE ARE CHECKING... When an invalid value such as null is passed to the endpoint,
        // do NOT pass that invalid value to our dependecies....
        // LET'S WRITE A TEST TO VALIDATE
        WSMsg wsmsg = endpoint.exceptionOverview(null);


        verify(accountService, never()).getAccount(anyLong());
        verify(dataExceptionReportService, never()).getAlertsOverview(any(Account.class));

        assertWSMsgIsFail(wsmsg);
    }
    
    @Test
    public void testAccountFoundOneDataExceptionReportActionForm() {
    	final Long accountId = 999L;
    	final Account accountMocked = mock(Account.class);
    	List<DataExceptionReportActionForm> list = new ArrayList<>();
    	list.add(mock(DataExceptionReportActionForm.class));

    	when(accountService.getAccount(accountId)).thenReturn(accountMocked);
    	when(dataExceptionReportService.getAlertsOverview(accountMocked)).thenReturn(list);
    	
    	WSMsg wsmsg = endpoint.exceptionOverview(accountMocked.getAccount());
    	wsmsg.setDataList(list);
    	
    	assertNotNull(wsmsg);
    	assertNotNull(wsmsg.getDataList());
    	assertNotNull(wsmsg.getMsg());
    	assertTrue(wsmsg.getDataList().size() == 1);
    }

    @Test
    public void testAccountFoundNoDataExceptionReportActionForm() {
        when(accountService.getAccount(anyLong())).thenReturn(null);

        WSMsg wsmsg = endpoint.exceptionOverview(1L);

        assertWSMsgIsFail(wsmsg);
    }

    @Test
    public void testAccountFoundManyDataExceptionReportActionForm() {
    	final Long accountId = 999L;
    	final Account accountMocked = mock(Account.class);
    	final int expectedResultListSize = 3;
    	
    	//be careful when building a list of mockedObjects, they can't be interacted with later!(iterate through the list, call methods on em or w/e)
    	List<DataExceptionReportActionForm> list = new ArrayList<>();
    	for (int i = 0; i < expectedResultListSize; i++) {
    		list.add(mock(DataExceptionReportActionForm.class));
    	}

    	when(accountService.getAccount(accountId)).thenReturn(accountMocked);
    	when(dataExceptionReportService.getAlertsOverview(accountMocked)).thenReturn(list);
    	
    	WSMsg wsmsg = endpoint.exceptionOverview(accountId);
    	
    	assertNotNull(wsmsg);
    	assertNotNull(wsmsg.getDataList());
    	assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
    	assertNotNull(wsmsg.getMsg());
    	assertTrue(wsmsg.getDataList().size() == expectedResultListSize);
    	
    }
    
    private void assertWSMsgIsFail(WSMsg wsmsg){

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());

    }
    

/*
    @GET
    @Path("/overview/{accountId}")
    @Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
    public WSMsg exceptionOverview(@PathParam("accountId") Long accountId){
        if(null == accountId){
            return WSMsg.failMessage("Account ID is required");
        }else{
            Account account = accountService.getAccount(accountId);
            if(null == account){
                return WSMsg.failMessage("Account doesn't exist");
            }else{
                List<DataExceptionReportActionForm> dataList = dataExceptionReportService.getAlertsOverview(account);
                return WSMsg.successMessage("SUCCESS", dataList);
            }
        }
    }
*/

}
