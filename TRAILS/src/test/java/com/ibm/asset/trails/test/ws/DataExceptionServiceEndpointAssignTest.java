package com.ibm.asset.trails.test.ws;

import static org.junit.Assert.*;
import static org.mockito.Matchers.*;
import static org.mockito.Mockito.*;

import javax.servlet.http.HttpServletRequest;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;

import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.asset.trails.ws.DataExceptionServiceEndpoint;
import com.ibm.asset.trails.ws.common.WSMsg;

@RunWith(MockitoJUnitRunner.class)
public class DataExceptionServiceEndpointAssignTest {

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

	@SuppressWarnings("unchecked")
	@Test
	public void testNoDataExpTypePassedIn() {
		final String assignIds = "1,2";
		final String comments = "";

		WSMsg wsmsg = endpoint.assignDataExceptionDataList(null, comments, assignIds, request);

		verify(dataExpSoftwareLparService, never()).assign(anyList(), anyString(), anyString());

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Data Exception Type is required");
	}

	@SuppressWarnings("unchecked")
	@Test
	public void testNoValuesPassedIn() {

		WSMsg wsmsg = endpoint.assignDataExceptionDataList(null, null, null, null);

		verify(dataExpSoftwareLparService, never()).assign(anyList(), anyString(), anyString());

		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());
		assertEquals(WSMsg.FAIL, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Data Exception Type is required");
	}

	private String getKnownValidSwLparExceptionType(){
    	return endpoint.SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }
	
	@SuppressWarnings("unchecked")
	@Test
	public void testSwLparAssignedSuccessfully(){
		final String swLparExceptionType = getKnownValidSwLparExceptionType();
		final String assignIds = "1,2";
		final String comments = "comment";

		//can't, assign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.assignDataExceptionDataList(swLparExceptionType, comments, assignIds, request);
		
		verify(dataExpSoftwareLparService, times(1)).assign(anyList(), anyString(), anyString());
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());		
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		//human readable messages shouldn't be tested, they would just make the test more brittle
//		assertEquals(wsmsg.getMsg(), "Assign success");
		
	}
	
	private String getKnownValidHwLparExceptionType(){
    	return endpoint.HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }
	
	@Test
	public void testHwLparAssignedSuccessfully(){
		final String hwLparExceptionType = getKnownValidHwLparExceptionType();
		final String assignIds = "1,2";
		final String comments = "comment";

		//can't, assign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.assignDataExceptionDataList(hwLparExceptionType, comments, assignIds, request);
		
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
	public void testInstalledSwAssignedSuccessfully(){
		final String installedSwExceptionType = getKnownValidInstalledSwExceptionType();
		final String assignIds = "1,2";
		final String comments = "comment";

		//can't, assign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.assignDataExceptionDataList(installedSwExceptionType, comments, assignIds, request);
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());		
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Assign success");
		
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
				} else if (INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {// Installed Software Data Exception 
					
					dataExpInstalledSwService.assign(assignList, request.getRemoteUser(), comments);
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
