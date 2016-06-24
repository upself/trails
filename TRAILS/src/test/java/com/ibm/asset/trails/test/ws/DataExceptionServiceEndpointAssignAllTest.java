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

	@Test
	public void testNoDataExpTypePassedIn() {
		final Long accountId = 999L;
		final String comments = "";

		WSMsg wsmsg = endpoint.assignAllDataExceptionDataList(null, accountId, comments, request);

		verify(dataExpSoftwareLparService, never()).assignAll(anyLong(), anyString(), anyString(), anyString());

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());
	}

	@Test
	public void testNoValuesPassedIn() {

		//we are not writing any dependencies because we want to verify that we validate invalid input right away in the response
		
		WSMsg wsmsg = endpoint.assignAllDataExceptionDataList(null, null, null, null);

		verify(dataExpSoftwareLparService, never()).assignAll(anyLong(), anyString(), anyString(), anyString());

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());
	}

	@SuppressWarnings("unchecked")
//	@Test
	public void testDataExcepTypeDeclared() {
		final String exceptionTypeSw = "NULLTIME";
//		final String exceptionTypeHw = "HWNCHP";
//		final String exceptionTypeIS = "SWDSCEXP";
		final Long accountId = 35400L;
		final String comments = "comment";
		
		WSMsg wsmsgMocked = mock(WSMsg.class);
		
		//when can't be used when method returns void
//		when(dataExpSoftwareLparService.assignAll(anyLong(), anyString(), anyString(), anyString()))
		
		verify(dataExpSoftwareLparService, atLeastOnce()).assignAll(anyLong(), anyString(), anyString(), anyString());
		
		WSMsg wsmsg = endpoint.assignAllDataExceptionDataList(exceptionTypeSw, accountId, comments, request);
		
//		verify(dataExpSoftwareLparService, atLeastOnce()).assignAll(anyLong(), anyString(), anyString(), anyString());
		verify(dataExpHardwareLparService, never()).assignAll(anyLong(), anyString(), anyString(), anyString());
		
		System.out.println("wsmsg.getMsg(): " + wsmsg.getMsg());
		
		assertNotNull(wsmsg);
		assertNotNull(wsmsg.getMsg());
//		assertNotNull(wsmsg.getData());
//		assertNotNull(wsmsg.getDataList());
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
	}

	/*
	@POST
	@Path("/{dataExpType}/assign")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg assignDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("comments") String comments,
			@FormParam("assignIds") String assignIds, @Context HttpServletRequest request) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == assignIds || "".equals(assignIds.trim())) {
			return WSMsg.failMessage("Assign Ids List is required");
		} else if (null == comments || "".equals(comments.trim())) {
			return WSMsg.failMessage("Comment is required");
		} else {
			try {
				List<Long> assignList = new ArrayList<Long>();
				for (String idStr : assignIds.split(",")) {
					assignList.add(Long.valueOf(idStr));
				}

				dataExpType = dataExpType.trim().toUpperCase();
				if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {// Software
																						// Lpar
																						// Data
																						// Exception
																						// Type
					dataExpSoftwareLparService.assign(assignList, request.getRemoteUser(), comments);
				} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {// Hardware
																								// Lpar
																								// Data
																								// Exception
																								// Type
					dataExpHardwareLparService.assign(assignList, request.getRemoteUser(), comments);
				} else {
					return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
				}

				return WSMsg.successMessage("Assign success");
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Assign failed");
			}
		}
	}
	*/

}
