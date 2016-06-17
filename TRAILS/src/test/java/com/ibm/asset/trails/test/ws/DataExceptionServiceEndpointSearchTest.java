package com.ibm.asset.trails.test.ws;

//import static org.junit.Assert.assertEquals;
//import static org.junit.Assert.assertNotNull;
//import static org.junit.Assert.assertNull;

import static org.junit.Assert.*;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.*;
import com.ibm.asset.trails.service.impl.AccountServiceImpl;
import com.ibm.asset.trails.ws.common.Pagination;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;


import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.form.DataExceptionReportActionForm;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.DataExceptionServiceEndpoint;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(MockitoJUnitRunner.class)
public class DataExceptionServiceEndpointSearchTest {

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
    public void testSWDSCEXPReturnsSuccessfulListWithItems() {

        // (1) test setup
        final String exceptionType = "SWDSCEXP";
        final Long accountId = 1000L;
        final Integer currentPage = 100;
        final Integer pageSize = 99;
        final String sort = "something";
        final String dir = "what is this?";
        final int expectedResultListSize = 3;
        final Integer expectedTotalResultSize = expectedResultListSize;

        // return a list of 3 items

        Account mockedAccount = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(mockedAccount);

        when(dataExpSoftwareLparService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        List<DataExceptionSoftwareLpar> list = new ArrayList<>();
        for (int i = 0; i < expectedResultListSize; i++) {
            list.add(buildTestDataExceptionSoftwareLparItem());
        }

        doReturn(list).when(dataExpSoftwareLparService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());

        // (2) execute what we are testing
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(exceptionType, accountId, currentPage, pageSize, sort, dir);

        // (3) assertions (did we get what we expected to get)
        verify(dataExpHardwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));

        assertNotNull(wsmsg);
        assertNotNull(wsmsg.getMsg());
        assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());

        // checking the data object
        assertNotNull(wsmsg.getData());
        assertTrue(wsmsg.getData() instanceof Pagination);
        final Pagination pagination = (Pagination) wsmsg.getData();
        assertEquals(pageSize.intValue(), pagination.getPageSize().intValue());
        assertEquals(currentPage.intValue(), pagination.getCurrentPage().intValue());
        assertEquals(expectedTotalResultSize.intValue(), pagination.getTotal().intValue());
        assertNotNull(pagination.getList());
        assertEquals(expectedResultListSize, pagination.getList().size());

        // checking the data list object
        assertNotNull(wsmsg.getDataList());
        assertEquals(expectedResultListSize, wsmsg.getDataList().size());

    }

    private DataExceptionSoftwareLpar buildTestDataExceptionSoftwareLparItem() {
        DataExceptionSoftwareLpar testItem = mock(DataExceptionSoftwareLpar.class);
        when(testItem.getId()).thenReturn(1L);
        SoftwareLpar swlpar = mock(SoftwareLpar.class);
        when(swlpar.getId()).thenReturn(2L);

        when(swlpar.getProcessorCount()).thenReturn(1);
        when(swlpar.getModel()).thenReturn("abc");
        when(swlpar.getName()).thenReturn("abc");
        when(swlpar.getOsName()).thenReturn("abc");
        when(swlpar.getExtId()).thenReturn("abc");
        when(swlpar.getSerial()).thenReturn("abc");
        when(swlpar.getStatus()).thenReturn("abc");
        when(swlpar.getTechImgId()).thenReturn("abc");

        AlertType alertType = mock(AlertType.class);
        when(alertType.getId()).thenReturn(1L);
        when(alertType.getName()).thenReturn("aa");
        when(alertType.getCode()).thenReturn("bb");
        when(testItem.getAlertType()).thenReturn(alertType);

        Account account = mock(Account.class);
        when(account.getAccount()).thenReturn(3L);
        when(swlpar.getAccount()).thenReturn(account);

        when(testItem.getSoftwareLpar()).thenReturn(swlpar);

        return testItem;
    }
}
