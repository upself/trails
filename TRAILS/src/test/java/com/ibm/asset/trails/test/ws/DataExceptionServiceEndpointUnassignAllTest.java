package com.ibm.asset.trails.test.ws;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyList;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.atLeastOnce;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

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
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.DataExceptionServiceEndpoint;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(MockitoJUnitRunner.class)
public class DataExceptionServiceEndpointUnassignAllTest {

	// DEPENDENCIES
	@Mock
	private DataExceptionService dataExpSoftwareLparService;

	@Mock
	private DataExceptionReportService dataExceptionReportService;

	@Mock
	private AccountService accountService;

	@Mock
	private DataExceptionHistoryDao alertHistoryDao;

	@Mock
	private HttpServletRequest request;

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
	public void testSwLparUnassignedAllSuccessfully(){
		final String swLparExceptionType = getKnownValidSwLparExceptionType();
		final Long accountId = 999L;
		final String comments = "comment";

		//can't, assign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.unassignAllDataExceptionDataList(swLparExceptionType, accountId, comments, request);
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		System.out.println("wsmsg.getMsg(): " + wsmsg.getMsg());
		//wsmsg.getMsg(): Account doesn't exist = I can't mock, 
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Assign success");
		
	}
	
	private String getKnownValidHwLparExceptionType(){
    	return endpoint.HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }
	
	@Test
	public void testHwLparUnassignedAllSuccessfully(){
		final String hwLparExceptionType = getKnownValidHwLparExceptionType();
		final Long accountId = 999L;
		final String comments = "comment";

		//can't, assign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.unassignAllDataExceptionDataList(hwLparExceptionType, accountId, comments, request);
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());		
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Assign success");
		
	}
	
    private String getKnownValidInstalledSwExceptionType(){
    	return endpoint.INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }
	
	@Test
	public void testInstalledSwUnassignedAllSuccessfully(){
		final String installedSwExceptionType = getKnownValidInstalledSwExceptionType();
		final Long accountId = 999L;
		final String comments = "comment";

		//can't, assign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.unassignAllDataExceptionDataList(installedSwExceptionType, accountId, comments, request);
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());		
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Assign success");
		
	}
	
	@Test
	public void testNoDataExpTypePassedIn() {
		final Long accountId = 999L;
		final String comments = "";

		WSMsg wsmsg = endpoint.unassignAllDataExceptionDataList(null, accountId, comments, request);

		verify(dataExpSoftwareLparService, never()).unassignAll(anyLong(), anyString(), anyString(), anyString());

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Data Exception Type is required");
	}

//	@SuppressWarnings("unchecked")
	@Test
	public void testNoValuesPassedIn() {

		WSMsg wsmsg = endpoint.unassignAllDataExceptionDataList(null, null, null, request);

		verify(dataExpSoftwareLparService, never()).unassignAll(anyLong(), anyString(), anyString(), anyString());

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Data Exception Type is required");
	}

	/*
	@POST
	@Path("/{dataExpType}/unassignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg unassignAllDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("accountId") Long accountId,
			@FormParam("comments") String comments, @Context HttpServletRequest request) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == accountId) {
			return WSMsg.failMessage("Account ID is required");
		} else if (null == comments || "".equals(comments.trim())) {
			return WSMsg.failMessage("Comment is required");
		} else {
			try {
				Account account = accountService.getAccount(accountId);
				if (null == account) {
					return WSMsg.failMessage("Account doesn't exist");
				} else {
					Long customerId = account.getId();
					dataExpType = dataExpType.trim().toUpperCase();
					if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Software
																							// Lpar
																							// Data
																							// Exception
																							// Type
						dataExpSoftwareLparService.unassignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Hardware
																									// Lpar
																									// Data
																									// Exception
																									// Type
						dataExpHardwareLparService.unassignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					}  else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Installed Software Data Exception 
						
						dataExpInstalledSwService.unassignAll(customerId, dataExpType, request.getRemoteUser(), comments);
	                } else {
						return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
					}

					return WSMsg.successMessage("Unassign success");
				}
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Unassign failed");
			}
		}
	}
	*/
}
