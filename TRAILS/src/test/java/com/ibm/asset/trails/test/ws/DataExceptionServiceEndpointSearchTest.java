package com.ibm.asset.trails.test.ws;

//import static org.junit.Assert.assertEquals;
//import static org.junit.Assert.assertNotNull;
//import static org.junit.Assert.assertNull;

import static org.junit.Assert.*;
import static org.mockito.Matchers.anyList;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

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
    private DataExceptionService dataExpInstalledSwService;

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

        Account accountMocked = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(accountMocked);

        when(dataExpInstalledSwService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        List<DataExceptionSoftwareLpar> list = new ArrayList<>();
        for (int i = 0; i < expectedResultListSize; i++) {
            list.add(buildTestDataExceptionSoftwareLparItem());
        }

        //doReturn b/c of List<? extends DataException>
        doReturn(list).when(dataExpInstalledSwService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());

        // (2) execute what we are testing
        System.out.println("exceptionType, accountId, currentPage, pageSize, sort, dir: " + exceptionType + ", " +
        		accountId + ", " + currentPage + ", " + pageSize + ", " + sort + ", " + dir);
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(exceptionType, accountId, currentPage, pageSize, sort, dir);
        System.out.println("wsmsg.getMsg(): " + wsmsg.getMsg());

        // (3) assertions (did we get what we expected to get)

        verify(dataExpSoftwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpHardwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpInstalledSwService, atLeastOnce()).getAlertListSize(any(Account.class), any(AlertType.class));
        
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
    
//    private DataExceptionInstalledSw buildTestDataExceptionInstalledSwItem() {
//        DataExceptionInstalledSw testItem = mock(DataExceptionInstalledSw.class);
//        when(testItem.getId()).thenReturn(1L);
//        
//        InstalledSoftware installedSoftware = mock(InstalledSoftware.class);
//        when(installedSoftware.getId()).thenReturn(2L);
//        
////        SoftwareLpar swlpar = mock(SoftwareLpar.class);
////        when(swlpar.getId()).thenReturn(2L);
//
//        when(installedSoftware.get)
//        
//        when(swlpar.getProcessorCount()).thenReturn(1);
//        when(swlpar.getModel()).thenReturn("abc");
//        when(swlpar.getName()).thenReturn("abc");
//        when(swlpar.getOsName()).thenReturn("abc");
//        when(swlpar.getExtId()).thenReturn("abc");
//        when(swlpar.getSerial()).thenReturn("abc");
//        when(swlpar.getStatus()).thenReturn("abc");
//        when(swlpar.getTechImgId()).thenReturn("abc");
//        
//        
//
//        AlertType alertType = mock(AlertType.class);
//        when(alertType.getId()).thenReturn(1L);
//        when(alertType.getName()).thenReturn("aa");
//        when(alertType.getCode()).thenReturn("bb");
//        when(testItem.getAlertType()).thenReturn(alertType);
//
//        Account account = mock(Account.class);
//        when(account.getAccount()).thenReturn(3L);
//        when(swlpar.getAccount()).thenReturn(account);
//
//        when(testItem.getSoftwareLpar()).thenReturn(swlpar);
//
//        return testItem;
//    }
    
	@Test
	public void testNoValuesPassedIn() {

		final WSMsg wsmsg = endpoint.getDataExceptionDataList(null, null, null, null, null, null);

		verify(dataExpSoftwareLparService, never()).setAlertTypeCode(anyString());
		verify(dataExpSoftwareLparService, never()).getAlertType();
		verify(dataExpHardwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
		verify(dataExpHardwareLparService, never()).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());
	}
    
    /*
     @SuppressWarnings({ "rawtypes", "unchecked" })
	@POST
	@Path("/{dataExpType}/search")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("accountId") Long accountId,
			@FormParam("currentPage") Integer currentPage, @FormParam("pageSize") Integer pageSize, @FormParam("sort") String sort,
			@FormParam("dir") String dir) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == accountId) {
			return WSMsg.failMessage("Account ID is required");
		} else if (null == currentPage) {
			return WSMsg.failMessage("Current Page Parameter is required");
		} else if (null == pageSize) {
			return WSMsg.failMessage("Page Size Parameter is required");
		} else if (null == sort || "".equals(sort.trim())) {
			return WSMsg.failMessage("Sort Column Parameter is required");
		} else if (null == dir || "".equals(dir.trim())) {
			return WSMsg.failMessage("Sort Direction Parameter is required");
		} else {
			Account account = accountService.getAccount(accountId);
			if (null == account) {
				return WSMsg.failMessage("Account doesn't exist");
			} else {
				int startIndex = (currentPage - 1) * pageSize;

				Long total = null;
				List list = null;
				AlertType alertType = null;
				dataExpType = dataExpType.trim().toUpperCase();

				if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {
					dataExpSoftwareLparService.setAlertTypeCode(dataExpType);
					alertType = dataExpSoftwareLparService.getAlertType();
					total = new Long(dataExpSoftwareLparService.getAlertListSize(account, alertType));
					list = dataExpSoftwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.swLparDataExpsTransformer(list);
				} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {
					dataExpHardwareLparService.setAlertTypeCode(dataExpType);
					alertType = dataExpHardwareLparService.getAlertType();
					total = new Long(dataExpHardwareLparService.getAlertListSize(account, alertType));
					list = dataExpHardwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.hwLparDataExpsTransformer(list);
				} else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {
					dataExpInstalledSwService.setAlertTypeCode(dataExpType);
					alertType = dataExpInstalledSwService.getAlertType();
					total = new Long(dataExpInstalledSwService.getAlertListSize(account, alertType));
					list = dataExpInstalledSwService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.installedSwDataExpsTransformer(list);
				} else {
					return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
				}

				Pagination page = new Pagination();
				page.setPageSize(pageSize.longValue());
				page.setTotal(total);
				page.setCurrentPage(currentPage.longValue());
				page.setList(list);
				return WSMsg.successMessage("SUCCESS", page);
			}
		}
	}
    */
    
}
