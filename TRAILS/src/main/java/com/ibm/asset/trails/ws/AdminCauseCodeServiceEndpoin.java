package com.ibm.asset.trails.ws;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.AlertTypeCause;
import com.ibm.asset.trails.service.AlertCauseResponsibilityService;
import com.ibm.asset.trails.service.AlertTypeCauseService;
import com.ibm.asset.trails.service.DataExceptionCauseService;
import com.ibm.asset.trails.service.DataExceptionTypeService;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/adminCauseCode")
public class AdminCauseCodeServiceEndpoin {

	@Autowired
	private DataExceptionCauseService alertCauseService;
	
	@Autowired
	private AlertTypeCauseService alertTypeCauseService;
	
	@Autowired
	private AlertCauseResponsibilityService alertCauseResponsibilityService;
	
	@Autowired
	private DataExceptionTypeService alertTypeService;
	
	@GET
	@Path("/list")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAlertCauseList(){
				List<AlertTypeCause> list = alertCauseService.listWithTypeJoin();
				return WSMsg.successMessage("SUCCESS", list);	
	}
	
	@GET
	@Path("/detail/cause/{alertCauseId}/type/{alertTypeId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAlertCauseDetail(@PathParam("alertCauseId") Long alertCauseId,@PathParam("alertTypeId") Long alertTypeId) {
		AlertTypeCause alertTypeCause = alertTypeCauseService.getByTypeCauseId(
				alertTypeId, alertCauseId);
		return WSMsg.successMessage("SUCCESS", alertTypeCause);    
	}
	
	@POST
	@Path("/saveOrUpdate")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg saveOrUpdateAlertCause(@FormParam("id") String id,@FormParam("alertCauseId") Long alertCauseId,@FormParam("alertTypeId") Long alertTypeId,@FormParam("responsibilityId") Long responsibilityId,@FormParam("alertCauseName") String alertCauseName,@FormParam("status") String alertTypeCauseStatus,
			@Context HttpServletRequest request) {
       if (id == null) {
   
    		if (null == alertCauseName || "".equals(alertCauseName)) {
    			return WSMsg.failMessage("Name is required");
    		}

    		AlertCause alertCause = alertCauseService.findByName(alertCauseName);
    		AlertCauseResponsibility alertCauseResponsibility = alertCauseResponsibilityService
    				.findById(responsibilityId);
    		if (alertCause == null
    				|| !alertCause.getAlertCauseResponsibility().equals(
    						alertCauseResponsibility)) {
    			alertCause = new AlertCause();
    			alertCause.setName(alertCauseName);
    			alertCause.setShowInGui(true);
    			alertCause.setAlertCauseResponsibility(alertCauseResponsibility);
    			alertCauseService.save(alertCause);

    			AlertTypeCause alertTypeCause = new AlertTypeCause();
    			alertTypeCause.setStatus(alertTypeCauseStatus);
    			alertTypeCause.getPk().setAlertCause(alertCause);
    			AlertType alertType = alertTypeService.findById(alertTypeId);
    			alertTypeCause.getPk().setAlertType(alertType);
    			alertTypeCauseService.add(alertTypeCause);
    			return WSMsg.successMessage("Save Cause Code success");
    		}

    		AlertTypeCause exists = alertTypeCauseService.getByTypeCauseId(
    				alertTypeId, alertCause.getId());
    		if (exists == null) {
    			AlertTypeCause alertTypeCause = new AlertTypeCause();
    			alertTypeCause.setStatus(alertTypeCauseStatus);
    			alertTypeCause.getPk().setAlertCause(alertCause);
    			AlertType alertType = alertTypeService.findById(alertTypeId);
    			alertTypeCause.getPk().setAlertType(alertType);
    			alertTypeCauseService.add(alertTypeCause);

    			return WSMsg.successMessage("Save Cause Code success");
    		}

    		return WSMsg
					.failMessage("Cause Code is already exist for [alertTypeId = "
							+ alertTypeId.toString()
							+ ", alertCauseId = "
							+ alertCause.getId().toString() + "]");
       } else {
    	
    		if (alertCauseName == null || "".equals(alertCauseName)) {
    			return WSMsg.failMessage("Name is required");
    		}

    		AlertCause alertCause = alertCauseService.find(alertCauseId);
    		AlertCauseResponsibility alertCauseResponsibility = alertCauseResponsibilityService
    				.findById(responsibilityId);

    		boolean changed = false;
    		if (!alertCause.getName().equalsIgnoreCase(alertCauseName)
    				|| !alertCause.getAlertCauseResponsibility().equals(
    						alertCauseResponsibility)) {

    			AlertCause exists = alertCauseService.findByNameResposibility(
    					alertCauseName, alertCauseResponsibility);

    			if (exists == null) {
    				alertCause.setName(alertCauseName);
    				alertCause
    						.setAlertCauseResponsibility(alertCauseResponsibility);
    				alertCauseService.update(alertCause);
    				changed = true;
    			} else {
    				return WSMsg
    						.failMessage("Cause Code  name and responsibily pair already exists for [alertCauseName = "
    								+ alertCauseName
    								+ ", alertCauseResponsibility = "
    								+ alertCauseResponsibility + "]");
    			}
    		}

    		AlertTypeCause alertTypeCause = alertTypeCauseService.getByTypeCauseId(
    				alertTypeId, alertCauseId);

    		if (!alertTypeCause.getStatus().equals(alertTypeCauseStatus)) {
    			alertTypeCause.setStatus(alertTypeCauseStatus);
    			alertTypeCauseService.update(alertTypeCause);
    			changed = true;
    		}

    		if (changed) {
    			return WSMsg.successMessage("Update Alert Cause Code success");
    		}
    		return WSMsg.successMessage("Nothing Changeed");		
       }
	}

}
