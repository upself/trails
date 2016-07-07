package com.ibm.asset.trails.test.ws;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Matchers.anyList;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

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
public class DataExceptionServiceEndpointUnassignTest {

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
		final String unassignIds = "1,2";
		final String comments = "";

		WSMsg wsmsg = endpoint.unassignDataExceptionDataList(null, unassignIds, comments, request);

		verify(dataExpSoftwareLparService, never()).unassign(anyList(), anyString(), anyString());

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

		WSMsg wsmsg = endpoint.unassignDataExceptionDataList(null, null, null, null);

		verify(dataExpSoftwareLparService, never()).unassign(anyList(), anyString(), anyString());

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

	@Test
	public void testSwLparUnassignedSuccessfully(){
		final String swLparExceptionType = getKnownValidSwLparExceptionType();
		final String assignIds = "1,2";
		final String comments = "comment";

		//can't, unassign() returns void
//		when(dataExpSoftwareLparService.unassign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.unassignDataExceptionDataList(swLparExceptionType, assignIds, comments, request);
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());		
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Unassign success");
		
	}
	
	private String getKnownValidHwLparExceptionType(){
    	return endpoint.HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }

	@Test
	public void testHwLparUnassignedSuccessfully(){
		final String hwLparExceptionType = getKnownValidHwLparExceptionType();
		final String assignIds = "1,2";
		final String comments = "comment";

		//can't, unassign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.unassignDataExceptionDataList(hwLparExceptionType, assignIds, comments, request);
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());		
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Unassign success");
		
	}
	
    private String getKnownValidInstalledSwExceptionType(){
    	return endpoint.INSTALLED_SW_DATA_EXCEPTION_TYPE_CODE_LIST.toArray(new String[0])[0];
    }

	@Test
	public void testInstalledSwUnassignedSuccessfully(){
		final String installedSwExceptionType = getKnownValidInstalledSwExceptionType();
		final String assignIds = "1,2";
		final String comments = "comment";

		//can't, unassign() returns void
//		when(dataExpSoftwareLparService.assign(anyList(), anyString(), anyString()));
		
		WSMsg wsmsg = endpoint.unassignDataExceptionDataList(installedSwExceptionType, assignIds, comments, request);
		
		assertNotNull(wsmsg);
		assertNull(wsmsg.getData());
		assertNull(wsmsg.getDataList());
		assertNotNull(wsmsg.getMsg());		
		assertEquals(WSMsg.SUCCESS, wsmsg.getStatus());
		assertEquals(wsmsg.getMsg(), "Unassign success");
		
	}

	/*
	@POST
	@Path("/{dataExpType}/unassign")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg unassignDataExceptionDataList(@PathParam("dataExpType") String dataExpType, @FormParam("unassignIds") String unassignIds,
			@FormParam("comments") String comments, @Context HttpServletRequest request) {

		if (null == dataExpType || "".equals(dataExpType.trim())) {
			return WSMsg.failMessage("Data Exception Type is required");
		} else if (null == unassignIds || "".equals(unassignIds.trim())) {
			return WSMsg.failMessage("Unassign Ids List is required");
		} else if (null == comments || "".equals(comments.trim())) {
			return WSMsg.failMessage("Comment is required");
		} else {
			try {
				List<Long> unassignList = new ArrayList<Long>();
				for (String idStr : unassignIds.split(",")) {
					unassignList.add(Long.valueOf(idStr.trim()));
				}

				dataExpType = dataExpType.trim().toUpperCase();
				if (SW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {// Software
																						// Lpar
																						// Data
																						// Exception
																						// Type
					dataExpSoftwareLparService.unassign(unassignList, request.getRemoteUser(), comments);
				} else if (HW_LPAR_DATA_EXCEPTION_TYPE_CODE_LIST.indexOf(dataExpType) != -1) {// Hardware
																								// Lpar
																								// Data
																								// Exception
																								// Type
					dataExpHardwareLparService.unassign(unassignList, request.getRemoteUser(), comments);
				} else {
					return WSMsg.failMessage("Data Exception Type {" + dataExpType + "} doesn't exist");
				}

				return WSMsg.successMessage("Unassign success");
			} catch (Exception e) {
				e.printStackTrace();
				return WSMsg.failMessage("Unassign failed");
			}
		}
	}
	*/
}
