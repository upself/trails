package com.ibm.asset.trails.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.ReportDeliveryTrackingHistory;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.service.ManufacturerService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;


public class ScheduleFAjaxAction implements ServletResponseAware, SessionAware {

	Logger log = Logger.getLogger(ScheduleFAjaxAction.class);

	protected Map<String, Object> session;

	private HttpServletResponse response;

	private ScheduleFService scheduleFService;
	
	private ManufacturerService manufacturerService;

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
	
	@UserRole(userRole = UserRoleType.READER)
	public String getManufacturerByNameJson() throws IOException {
		String str = ServletActionContext.getRequest().getParameter("q");

		if (str == null || str == "") {
			return com.opensymphony.xwork2.Action.NONE;
		}
		str = "%" + str + "%";
		str = str.toUpperCase();

		List<Manufacturer> list = manufacturerService.findByNameLike(str);

		PrintWriter writer = ServletActionContext.getResponse().getWriter();
		if (list == null || list.size() == 0) {
			writer.write("{}");
		} else {
			GsonBuilder builder = new GsonBuilder();
			Gson gson = builder.registerTypeAdapter(
					ReportDeliveryTrackingHistory.class,
					new JsonSerializer<Manufacturer>() {

						public JsonElement serialize(Manufacturer src,
								Type typeOfSrc, JsonSerializationContext context) {
							JsonObject obj = new JsonObject();
							obj.addProperty("id", src.getId());
							obj.addProperty("name", src.getManufacturerName());

							return obj;
						}
					}).create();
			writer.write(gson.toJson(list));
		}

		return com.opensymphony.xwork2.Action.NONE;

	}
	
	public void setManufacturerService(ManufacturerService manufacturerService) {
		this.manufacturerService = manufacturerService;
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
