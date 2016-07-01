package com.ibm.asset.trails.test.ws;

//import static org.junit.Assert.assertEquals;
//import static org.junit.Assert.assertNotNull;
//import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyList;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.atLeastOnce;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;

import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.DataExceptionHardwareLpar;
import com.ibm.asset.trails.domain.DataExceptionInstalledSw;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.domain.Hardware;
import com.ibm.asset.trails.domain.HardwareLpar;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.SoftwareLpar;
import com.ibm.asset.trails.domain.VSoftwareLpar;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.DataExceptionServiceEndpoint;
import com.ibm.asset.trails.ws.common.Pagination;
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
    
    private String getKnownValidSwLparExceptionType(){
    	return endpoint.SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }
    
    @Test
    public void testSwLparReturnsSuccessfulListWithItems() {

        // (1) test setup
    	final String swLparExceptionType = getKnownValidSwLparExceptionType();
        final Long accountId = 1000L;
        final Integer currentPage = 100;
        final Integer pageSize = 99;
        final String sort = "sorting";
        final String dir = "ascending";
     // return a list of 3 items
        final int expectedResultListSize = 3;
        final Integer expectedTotalResultSize = expectedResultListSize;

        Account accountMocked = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(accountMocked);
        when(dataExpSoftwareLparService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        List<DataExceptionSoftwareLpar> list = new ArrayList<>();
        for (int i = 0; i < expectedResultListSize; i++) {
            list.add(buildTestDataExceptionSoftwareLparItem());
        }

        //doReturn b/c of List<? extends DataException>
        doReturn(list).when(dataExpSoftwareLparService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());
        
        // (2) execute what we are testing
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(swLparExceptionType, accountId, currentPage, pageSize, sort, dir);

        // (3) assertions (did we get what we expected to get?)
        // other types of services were not called
        verify(dataExpHardwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpInstalledSwService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpSoftwareLparService, atLeastOnce()).getAlertListSize(any(Account.class), any(AlertType.class));

        assertNotNull(wsmsg);
        assertNotNull(wsmsg.getMsg());
        assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());

        // checking the data object
        assertNotNull(wsmsg.getData());
        assertTrue(wsmsg.getData() instanceof Pagination);
        // the result is the data(not DataList), as an Pagination object
        final Pagination pagination = (Pagination) wsmsg.getData();
        assertEquals(pageSize.intValue(), pagination.getPageSize().intValue());
        assertEquals(currentPage.intValue(), pagination.getCurrentPage().intValue());
        assertEquals(expectedTotalResultSize.intValue(), pagination.getTotal().intValue());
        assertNotNull(pagination.getList());
     // check the actual amount of results (DataExceptions in this case) inside the Pagination object
        assertEquals(expectedResultListSize, pagination.getList().size());

        // checking the data list object
        // wsmsg.getDataList() does not get populated, instead, wsmsg.setData(being a Pagination object) is being set in
        // so these assertions can't work. Reverse the assertions to assertNull?
//        assertNotNull(wsmsg.getDataList());
//        assertEquals(expectedResultListSize, wsmsg.getDataList().size());

    }
    
    
    private String getKnownValidHwLparExceptionType(){
    	return endpoint.HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }

    @Test
    public void testHwLparReturnsSuccessfulListWithItems() {

        // (1) test setup
    	final String hwLparExceptionType = getKnownValidHwLparExceptionType();
        final Long accountId = 1000L;
        final Integer currentPage = 100;
        final Integer pageSize = 99;
        final String sort = "sorting";
        final String dir = "ascending";
        final int expectedResultListSize = 3;
        final Integer expectedTotalResultSize = expectedResultListSize;

        // return a list of 3 items

        Account accountMocked = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(accountMocked);

        when(dataExpHardwareLparService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        List<DataExceptionHardwareLpar> list = new ArrayList<>();
        for (int i = 0; i < expectedResultListSize; i++) {
            list.add(buildTestDataExceptionHardwareLparItem());
        }

        //doReturn b/c of List<? extends DataException>
        doReturn(list).when(dataExpHardwareLparService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());

        // (2) execute what we are testing
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(hwLparExceptionType, accountId, currentPage, pageSize, sort, dir);

        // (3) assertions (did we get what we expected to get)       
        verify(dataExpSoftwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpInstalledSwService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpHardwareLparService, atLeastOnce()).getAlertListSize(any(Account.class), any(AlertType.class));

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
        // wsmsg.getDataList() does not get populated, instead, wsmsg.setData(being a Pagination object) is being set in
        // so these assertions can't work. Reverse the assertions to assertNull?
//        assertNotNull(wsmsg.getDataList());
//        assertEquals(expectedResultListSize, wsmsg.getDataList().size());

    }

    private String getKnownValidInstalledSwExceptionType(){
    	return endpoint.INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }
    
    @Test
    public void testInstalledSwReturnsSuccessfulListWithItems() {

        // (1) test setup
    	final String installedSwExceptionType = getKnownValidInstalledSwExceptionType();
        final Long accountId = 1000L;
        final Integer currentPage = 100;
        final Integer pageSize = 99;
        final String sort = "sorting";
        final String dir = "ascending";
        final int expectedResultListSize = 3;
        final Integer expectedTotalResultSize = expectedResultListSize;

        // return a list of 3 items

        Account accountMocked = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(accountMocked);
        when(dataExpInstalledSwService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        List<DataExceptionInstalledSw> list = new ArrayList<>();
        for (int i = 0; i < expectedResultListSize; i++) {
            list.add(buildTestDataExceptionInstalledSwItem());
        }
        
        //"doReturn" is being used b/c of List<? extends DataException>
        doReturn(list).when(dataExpInstalledSwService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());

        // (2) execute what we are testing
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(installedSwExceptionType, accountId, currentPage, pageSize, sort, dir);

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
        // wsmsg.getDataList() does not get populated, instead, wsmsg.setData(being a Pagination object) is being set in
        // so these assertions can't work. Reverse the assertions to assertNull?
//        assertNotNull(wsmsg.getDataList());
//        assertEquals(expectedResultListSize, wsmsg.getDataList().size());

    }

    private DataExceptionSoftwareLpar buildTestDataExceptionSoftwareLparItem() {
        DataExceptionSoftwareLpar testItem = mock(DataExceptionSoftwareLpar.class);
        when(testItem.getId()).thenReturn(1L);
        SoftwareLpar swlpar = mock(SoftwareLpar.class);
        when(swlpar.getId()).thenReturn(2L);

        when(swlpar.getProcessorCount()).thenReturn(1);
        when(swlpar.getModel()).thenReturn("model");
        when(swlpar.getName()).thenReturn("name");
        when(swlpar.getOsName()).thenReturn("OsName");
        when(swlpar.getExtId()).thenReturn("extId");
        when(swlpar.getSerial()).thenReturn("serial");
        when(swlpar.getStatus()).thenReturn("status");
        when(swlpar.getTechImgId()).thenReturn("techId");

        AlertType alertType = mock(AlertType.class);
        when(alertType.getId()).thenReturn(1L);
        when(alertType.getName()).thenReturn("name");
        when(alertType.getCode()).thenReturn("code");
        when(testItem.getAlertType()).thenReturn(alertType);

        Account account = mock(Account.class);
        when(account.getAccount()).thenReturn(3L);
        when(swlpar.getAccount()).thenReturn(account);

        when(testItem.getSoftwareLpar()).thenReturn(swlpar);

        return testItem;
    }
    
    private DataExceptionHardwareLpar buildTestDataExceptionHardwareLparItem() {
    	DataExceptionHardwareLpar testItem = mock(DataExceptionHardwareLpar.class);
        when(testItem.getId()).thenReturn(1L);
        
        HardwareLpar hwlpar = mock(HardwareLpar.class);
        when(hwlpar.getId()).thenReturn(2L);

        AlertType alertType = mock(AlertType.class);
        when(alertType.getId()).thenReturn(1L);
        when(alertType.getName()).thenReturn("name");
        when(alertType.getCode()).thenReturn("code");
        when(testItem.getAlertType()).thenReturn(alertType);

        
        Hardware hardware = mock(Hardware.class);
        when(hardware.getSerial()).thenReturn("serial");      
        
        Account account = mock(Account.class);
        when(account.getAccount()).thenReturn(3L);

        when(hwlpar.getAccount()).thenReturn(account);

        when(testItem.getHardwareLpar()).thenReturn(hwlpar);
        when(testItem.getHardwareLpar().getHardware()).thenReturn(hardware);
        
        return testItem;
    }
    
    private DataExceptionInstalledSw buildTestDataExceptionInstalledSwItem() {
        DataExceptionInstalledSw testItem = mock(DataExceptionInstalledSw.class);
        when(testItem.getId()).thenReturn(1L);
        
        InstalledSoftware installedSoftware = mock(InstalledSoftware.class);
        when(installedSoftware.getId()).thenReturn(2L);
        when(installedSoftware.getProcessorCount()).thenReturn(1);
        when(installedSoftware.getRecordTime()).thenReturn(new Date());
        when(installedSoftware.getRemoteUser()).thenReturn("remoteUser");
        when(installedSoftware.getStatus()).thenReturn("status");
        when(installedSoftware.getUsers()).thenReturn(1);

        AlertType alertType = mock(AlertType.class);
        when(alertType.getId()).thenReturn(1L);
        when(alertType.getName()).thenReturn("name");
        when(alertType.getCode()).thenReturn("code");
        when(testItem.getAlertType()).thenReturn(alertType);

        VSoftwareLpar vSwlpar = mock(VSoftwareLpar.class);
        when(vSwlpar.getId()).thenReturn(2L);
        when(vSwlpar.getProcessorCount()).thenReturn(1);
        when(vSwlpar.getName()).thenReturn("name");
        when(vSwlpar.getName()).thenReturn("name");
        when(vSwlpar.getStatus()).thenReturn("status");

        Account account = mock(Account.class);
        when(account.getAccount()).thenReturn(3L);
        when(vSwlpar.getAccount()).thenReturn(account);
        when(installedSoftware.getSoftwareLpar()).thenReturn(vSwlpar);
        
        Software software = mock(Software.class);
        when(software.getSoftwareName()).thenReturn("softwareName");
        when(installedSoftware.getSoftware()).thenReturn(software);

        when(testItem.getInstalledSw()).thenReturn(installedSoftware);

        return testItem;
    }
    
    @Test
    public void testSwLparReturnsEmptyListItems() {

    	final String swLparExceptionType = getKnownValidSwLparExceptionType();
        final Long accountId = 1000L;
        final Integer currentPage = 100;
        final Integer pageSize = 99;
        final String sort = "sorting";
        final String dir = "ascending";
        final int expectedResultListSize = 0;

        Account accountMocked = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(accountMocked);
        when(dataExpSoftwareLparService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        //doReturn b/c of List<? extends DataException>
        doReturn(null).when(dataExpSoftwareLparService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());
        
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(swLparExceptionType, accountId, currentPage, pageSize, sort, dir);

        verify(dataExpHardwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpInstalledSwService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpSoftwareLparService, atLeastOnce()).getAlertListSize(any(Account.class), any(AlertType.class));

        assertNotNull(wsmsg);
        assertNotNull(wsmsg.getMsg());
        assertEquals(WSMsg.FAIL, wsmsg.getStatus());
        assertNull(wsmsg.getData());
        assertNull(wsmsg.getDataList());

    }
    
    @Test
    public void testHwLparReturnsEmptyListItems() {

    	final String hwLparExceptionType = getKnownValidHwLparExceptionType();
        final Long accountId = 1000L;
        final Integer currentPage = 100;
        final Integer pageSize = 99;
        final String sort = "sorting";
        final String dir = "ascending";
        final int expectedResultListSize = 0;

        Account accountMocked = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(accountMocked);
        when(dataExpHardwareLparService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        //doReturn b/c of List<? extends DataException>
        doReturn(null).when(dataExpHardwareLparService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());
        
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(hwLparExceptionType, accountId, currentPage, pageSize, sort, dir);

        verify(dataExpSoftwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpInstalledSwService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpHardwareLparService, atLeastOnce()).getAlertListSize(any(Account.class), any(AlertType.class));

        assertNotNull(wsmsg);
        assertNotNull(wsmsg.getMsg());
        assertEquals(WSMsg.FAIL, wsmsg.getStatus());
        assertNull(wsmsg.getData());
        assertNull(wsmsg.getDataList());

    }
    
    @Test
    public void testInstalledSwReturnsEmptyListItems() {

    	final String installedSwExceptionType = getKnownValidInstalledSwExceptionType();
        final Long accountId = 1000L;
        final Integer currentPage = 100;
        final Integer pageSize = 99;
        final String sort = "sorting";
        final String dir = "ascending";
        final int expectedResultListSize = 0;

        Account accountMocked = mock(Account.class);
        when(accountService.getAccount(anyLong())).thenReturn(accountMocked);
        when(dataExpInstalledSwService.getAlertListSize(any(Account.class), any(AlertType.class))).thenReturn((long) expectedResultListSize);

        //doReturn b/c of List<? extends DataException>
        doReturn(null).when(dataExpInstalledSwService).paginatedList(any(Account.class), anyInt(), anyInt(), anyString(), anyString());
        
        final WSMsg wsmsg = endpoint.getDataExceptionDataList(installedSwExceptionType, accountId, currentPage, pageSize, sort, dir);

        verify(dataExpSoftwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpHardwareLparService, never()).getAlertListSize(any(Account.class), any(AlertType.class));
        verify(dataExpInstalledSwService, atLeastOnce()).getAlertListSize(any(Account.class), any(AlertType.class));

        assertNotNull(wsmsg);
        assertNotNull(wsmsg.getMsg());
        assertEquals(WSMsg.FAIL, wsmsg.getStatus());
        assertNull(wsmsg.getData());
        assertNull(wsmsg.getDataList());

    }
    
	@SuppressWarnings("unchecked")
	@Test
	public void testNoValuesPassedIn() {

		final WSMsg wsmsg = endpoint.getDataExceptionDataList(null, null, null, null, null, null);

//		verify(dataExpSoftwareLparService, never()).setAlertTypeCode(anyString());
//		verify(dataExpHardwareLparService, never()).setAlertTypeCode(anyString());
//		verify(dataExpInstalledSwService, never()).setAlertTypeCode(anyString());

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
				if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {
					dataExpSoftwareLparService.setAlertTypeCode(dataExpType);
					alertType = dataExpSoftwareLparService.getAlertType();
					total = new Long(dataExpSoftwareLparService.getAlertListSize(account, alertType));
					list = dataExpSoftwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.swLparDataExpsTransformer(list);
				} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {
					dataExpHardwareLparService.setAlertTypeCode(dataExpType);
					alertType = dataExpHardwareLparService.getAlertType();
					total = new Long(dataExpHardwareLparService.getAlertListSize(account, alertType));
					list = dataExpHardwareLparService.paginatedList(account, startIndex, pageSize, sort, dir);
					list = this.hwLparDataExpsTransformer(list);
				} else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {
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
