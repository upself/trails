package com.ibm.asset.trails.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.util.List;

import org.apache.struts2.ServletActionContext;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.ReportDeliveryTrackingHistory;
import com.ibm.asset.trails.service.ManufacturerService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class PriorityISVAction extends AccountBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1366278014947818495L;

	private Long priorityISVSoftwareId;

	private ManufacturerService manufacturerService;

	private long id;

	@UserRole(userRole = UserRoleType.READER)
	public String reader() throws Exception {
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.ADMIN)
	public String admin() throws Exception {
		return SUCCESS;
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
							obj.addProperty("definitionSource", src.getDefinitionSource());

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

	public Long getPriorityISVSoftwareId() {
		return priorityISVSoftwareId;
	}

	public void setPriorityISVSoftwareId(Long priorityISVSoftwareId) {
		this.priorityISVSoftwareId = priorityISVSoftwareId;

	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

}
