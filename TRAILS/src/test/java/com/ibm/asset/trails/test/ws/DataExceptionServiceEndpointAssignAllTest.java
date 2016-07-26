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
import org.mockito.stubbing.Answer;

import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.DataExceptionServiceEndpoint;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(MockitoJUnitRunner.class)
public class DataExceptionServiceEndpointAssignAllTest {

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
	public void testNoDataExpTypePassedIn() {
		final String swLparExceptionType = null;
		final Long accountId = 999L;
		final String comments = "comment";

		WSMsg wsmsg = endpoint.assignAllDataExceptionDataList(swLparExceptionType, accountId, comments, request);

		assertWSMsgIsFail(wsmsg);
	}
	
	@Test
	public void testNoAccountIdPassedIn() {
		final String swLparExceptionType = getKnownValidSwLparExceptionType();
		final Long accountId = null;
		final String comments = "comment";

		WSMsg wsmsg = endpoint.assignAllDataExceptionDataList(swLparExceptionType, accountId, comments, request);

		assertWSMsgIsFail(wsmsg);
	}
	
	@Test
	public void testNoCommentsPassedIn() {
		final String swLparExceptionType = getKnownValidSwLparExceptionType();
		final Long accountId = 999L;
		final String comments = null;

		WSMsg wsmsg = endpoint.assignAllDataExceptionDataList(swLparExceptionType, accountId, comments, request);

		assertWSMsgIsFail(wsmsg);
	}

	@SuppressWarnings("unchecked")
	@Test
	public void testAssignedAllSuccessfully() {
		final String exceptionTypeSw = getKnownValidSwLparExceptionType();
//		final String exceptionTypeHw = "HWNCHP";
//		final String exceptionTypeIS = "SWDSCEXP";
		final Long accountId = 2541L;
		final String comments = "comment";
		
		WSMsg wsmsgMocked = mock(WSMsg.class);
		Account accountMocked = mock(Account.class);
		
		//when can't be used when method returns void
//		when(dataExpSoftwareLparService.assignAll(anyLong(), anyString(), anyString(), anyString()))
		
		WSMsg wsmsg = endpoint.assignAllDataExceptionDataList(exceptionTypeSw, accountMocked.getAccount(), comments, request);
		//ACCOUNT DOESN'T EXIST
		System.out.println("wsmsg.getMsg(): " + wsmsg.getMsg());
		
		verify(dataExpSoftwareLparService, atLeastOnce()).assignAll(anyLong(), anyString(), anyString(), anyString());
		verify(dataExpHardwareLparService, never()).assignAll(anyLong(), anyString(), anyString(), anyString());
		
		System.out.println("wsmsg.getMsg(): " + wsmsg.getMsg());
		
		assertNotNull(wsmsg);
		assertNotNull(wsmsg.getMsg());
//		assertNotNull(wsmsg.getData());
//		assertNotNull(wsmsg.getDataList());
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
	}
	
    private void assertWSMsgIsFail(WSMsg wsmsg){

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());

    }

	/*
	@POST
	@Path("/{dataExpType}/assignAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg assignAllDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("accountId") Long accountId,
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
						dataExpSoftwareLparService.assignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Hardware
																									// Lpar
																									// Data
																									// Exception
																									// Type
						dataExpHardwareLparService.assignAll(customerId, dataExpType, request.getRemoteUser(), comments);
					} else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.contains(dataExpType)) {// Installed Software Data Exception 
						
						dataExpInstalledSwService.assignAll(customerId, dataExpType, request.getRemoteUser(), comments);
	                } else {
						return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
					}

					return WSMsg.successMessage("Assign success");
				}
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Assign failed");
			}
		}
	}
	*/

}
