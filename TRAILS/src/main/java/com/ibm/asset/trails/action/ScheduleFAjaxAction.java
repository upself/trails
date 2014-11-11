package com.ibm.asset.trails.action;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;

import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.service.ScheduleFService;


public class ScheduleFAjaxAction implements ServletResponseAware, SessionAware {

	Logger log = Logger.getLogger(ScheduleFAjaxAction.class);

	protected Map<String, Object> session;

	private HttpServletResponse response;

	private ScheduleFService scheduleFService;

	private String key;

	private String label;

	private String index;

	public void setServletResponse(HttpServletResponse response) {
		this.response = response;
	}

	public void setScheduleFService(ScheduleFService scheduleFService) {
		this.scheduleFService = scheduleFService;
	}

	private void feedback(String result) {
		try {
			this.response.getWriter().write(result);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
	}

	public synchronized void liveSearch() {

		StringBuffer result = new StringBuffer();
		if (label.indexOf("softwareName") != -1) {
			List<Software> pilist = null;
			pilist = scheduleFService.findSoftwareBySoftwareName(
					  key.toUpperCase() );
			result.append("<ul>");
			if (pilist == null || pilist.size() <= 0) {
				return;
			} else {
			for (Software line : pilist) {
				String status ;
				if (line.getStatus().equalsIgnoreCase("ACTIVE")){
					status = "IsACTIVE";
				} else {
					status = "INACTIVE";
				}
				String role = line.getProductRole().toString().equals("SOFTWARE_PRODUCT")?"SWPRODUCT":"COMPONENT";
				result.append("<li class='prompt'>" + "("+role+")"+line.getSoftwareName().toString()+"(" +status+")"+ "</li>");
			}
			result.append("</ul>");
			}
		} else if (label.indexOf("machineType") != -1) {
		    List<MachineType> mtlist = null;
			mtlist = scheduleFService.findMachineTypebyName(
					 key );
			if (mtlist == null || mtlist.size() <= 0) {
				return;
			} else {
			for (MachineType line : mtlist) {
				result.append("<li class='prompt'>" + line.getName().toString() + "</li>");
			}
			result.append("</ul>");
			}
		}
	
		feedback(result.toString());
	}

	public void setKey(String key) {
		this.key = key;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public void setIndex(String index) {
		this.index = index;
	}
}
