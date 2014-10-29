package com.ibm.asset.trails.action;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;

import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.tap.trails.framework.UserSession;

public class ReconAjaxAction implements ServletResponseAware, SessionAware {

	Logger log = Logger.getLogger(ReconAjaxAction.class);

	protected Map<String, Object> session;

	private HttpServletResponse response;

	private LicenseService licenseService;

	private String key;

	private String label;

	private String index;

	public void setServletResponse(HttpServletResponse response) {
		this.response = response;
	}

	public void setLicenseService(LicenseService licenseService) {
		this.licenseService = licenseService;
	}

	public void getCapcityTypes() {

		List<CapacityType> types = licenseService.getCapacityTypeList();

		StringBuffer result = new StringBuffer();
		result.append("<select name=\"filter[" + index + "].capcityType\">");
		result.append("<option value=-1 selected=\"selected\"></option>");
		for (CapacityType type : types) {
			result.append("<option value=" + type.getCode() + ">"
					+ type.getDescription() + "</option>");
		}
		result.append("</select>");
		feedback(result.toString());

	}

	private void feedback(String result) {
		try {
			this.response.getWriter().write(result);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
	}

	public synchronized void quickSearch() {

		UserSession usrSession = (UserSession) session
				.get(UserSession.USER_SESSION);
		List<String> list = null;
		if (label.indexOf("productName") != -1) {
			list = licenseService.getProductNameByAccount(
					usrSession.getAccount(), "%" + key.toUpperCase() + "%");
		} else if (label.indexOf("manufacturer") != -1) {
			list = licenseService.getManufacturerNameByAccount(
					usrSession.getAccount(), "%" + key.toUpperCase() + "%");

		}

		if (list == null || list.size() <= 0) {
			return;
		}

		StringBuffer result = new StringBuffer();
		result.append("<ul>");
		for (String line : list) {
			result.append("<li class='prompt'>" + line + "</li>");
		}
		result.append("</ul>");

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
