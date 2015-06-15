package com.ibm.asset.trails.action;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.service.NonInstanceService;

public class NonInstanceAjaxAction implements ServletResponseAware,
		SessionAware {

	Logger log = Logger.getLogger(NonInstanceAjaxAction.class);

	protected Map<String, Object> session;

	private HttpServletResponse response;

	private NonInstanceService nonInstanceService;

	private String key;

	private String label;

	private String index;

	private void feedback(String result) {
		try {
			this.response.getWriter().write(result);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
	}

	public synchronized void liveSearch() {

		String status = null;
		String role = null;
		StringBuffer result = new StringBuffer();
		if (label.indexOf("softwareName") != -1) {
			List<Software> swList = null;
			swList = nonInstanceService.findSoftwareBySoftwareNameLike(key.toUpperCase(),10);
			if (swList == null || swList.size() <= 0) {
				return;
			} else {
				
				result.append("<ul>");
				for (Software sw : swList) {
					
					//config status
					if (sw.getStatus().equalsIgnoreCase("ACTIVE")) {
						status = "IsACTIVE";
					} else {
						status = "INACTIVE";
					}
					
					//config role
					role = sw.getProductRole().toString().equals("SOFTWARE_PRODUCT") ? "SWPRODUCT" : "COMPONENT";
					
					
					//config html
					result.append("<li class='prompt'>")
					.append("(")
					.append(role)
					.append(")")
					.append(sw.getSoftwareName())
					.append("(")
					.append(status)
					.append(")</li>");
				}
				result.append("</ul>");
			}
		} else if (label.indexOf("manufacturerName") != -1) {
			List<Manufacturer> mfList = null;
			mfList = nonInstanceService.findManufacturerByNameLike(key,20);
			
			if (mfList == null || mfList.size() <= 0) {
				return;
			} else {
				result.append("<ul>");
				for (Manufacturer mf : mfList) {
					
					result.append("<li class='prompt'>")
					.append(mf.getManufacturerName())
					.append("</li>");
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

	public void setNonInstanceService(NonInstanceService nonInstanceService) {
		this.nonInstanceService = nonInstanceService;
	}

	public void setServletResponse(HttpServletResponse response) {
		// TODO Auto-generated method stub
		this.response = response;
	}
}
