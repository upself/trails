package com.ibm.asset.trails.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.ibm.asset.trails.domain.ReportDeliveryTracking;
import com.ibm.asset.trails.domain.ReportDeliveryTrackingHistory;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.form.ReportDeliveryTrackingForm;
import com.ibm.asset.trails.service.ReportDeliveryTrackingService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.ActionSupport;

@Controller
@ParentPackage("trails-struts-default")
@Namespace("/admin/scheduleF")
@Results({
		@Result(name = ActionSupport.ERROR, location = "tiles.admin.scheduleF.listError", type = "tiles"),
		@Result(name = ActionSupport.SUCCESS, location = "tiles.admin.scheduleF.list", type = "tiles") })
public class ScheduleFAction extends AccountBaseAction {
	private static final long serialVersionUID = 1L;

	@Autowired
	private ScheduleFService scheduleFService;

	@Autowired
	private ReportDeliveryTrackingService reperDeliveryTrackingService;

	private Long scheduleFId;

	private ScheduleF scheduleF;

	private ReportDeliveryTrackingForm reportForm;

	@Override
	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {
		super.prepare();

		if (getSort() == null) {
			setSort("SF.softwareName,SF.level,SF.hwOwner,SF.hostname,SF.serial,SF.machineType");
			setDir("ASC");
		}
	}

	@UserRole(userRole = UserRoleType.READER)
	@Action("list")
	public String doList() {
		if (getAccount() == null) {
			return ERROR;
		} else {
			return SUCCESS;
		}
	}

	@UserRole(userRole = UserRoleType.READER)
	@Action("mergeReportTracking")
	public String doMergeReportTracking() throws ParseException, IOException {
		ReportDeliveryTracking rdt = new ReportDeliveryTracking();
		rdt.setAccount(getUserSession().getAccount());
		rdt.setRemoteUser(getUserSession().getRemoteUser());
		rdt.setRecordTime(new Date());

		SimpleDateFormat dFormat = new SimpleDateFormat("MM/dd/yy");
		rdt.setLastDeliveryTime(dFormat.parse(getReportForm()
				.getLastReportDeliveryDate()));
		rdt.setNextDeliveryTime(dFormat.parse(getReportForm()
				.getNextReportDeliveryDate()));

		rdt.setQmxReference(getReportForm().getQmxReference());
		rdt.setReportingCycle(getReportForm().getReportDeliveryCycle());

		int code = reperDeliveryTrackingService.merge(rdt);
		PrintWriter writer = ServletActionContext.getResponse().getWriter();

		if (code == ReportDeliveryTrackingService.ADD) {
			writer.write("added");
		} else if (code == ReportDeliveryTrackingService.UPDATE) {
			writer.write("updated");
		} else {
			writer.write("error");
		}

		return com.opensymphony.xwork2.Action.NONE;
	}

	@UserRole(userRole = UserRoleType.READER)
	@Action("getReportTracking")
	public String doGetReportTracking() throws IOException {

		ReportDeliveryTracking tracking = reperDeliveryTrackingService
				.getByAccount(getAccount());

		PrintWriter writer = ServletActionContext.getResponse().getWriter();

		if (tracking != null) {
			ReportDeliveryTrackingForm form = new ReportDeliveryTrackingForm();

			SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yy");
			form.setLastReportDeliveryDate(fmt.format(tracking
					.getLastDeliveryTime()));
			form.setNextReportDeliveryDate(fmt.format(tracking
					.getNextDeliveryTime()));

			form.setQmxReference(tracking.getQmxReference());
			form.setReportDeliveryCycle(tracking.getReportingCycle());

			Gson gson = new Gson();
			writer.write(gson.toJson(form));

		} else {
			writer.write("{\"empty\":\"true\"}");
		}

		return com.opensymphony.xwork2.Action.NONE;
	}

	@UserRole(userRole = UserRoleType.READER)
	@Action("getReportTrackingHistory")
	public String doGetReportTrackingHistory() throws IOException {
		ReportDeliveryTracking reportDeliveryTracking = reperDeliveryTrackingService
				.getByAccount(getAccount());
		List<ReportDeliveryTrackingHistory> historyList = reperDeliveryTrackingService
				.getHistory(reportDeliveryTracking);

		PrintWriter writer = ServletActionContext.getResponse().getWriter();

		if (historyList != null && historyList.size() > 0) {

			GsonBuilder builder = new GsonBuilder();
			Gson gson = builder.registerTypeAdapter(
					ReportDeliveryTrackingHistory.class,
					new JsonSerializer<ReportDeliveryTrackingHistory>() {

						public JsonElement serialize(
								ReportDeliveryTrackingHistory src,
								Type typeOfSrc, JsonSerializationContext context) {
							SimpleDateFormat fmt = new SimpleDateFormat(
									"MM/dd/yy");
							JsonObject obj = new JsonObject();
							obj.addProperty("lastDate",
									fmt.format(src.getLastDeliveryTime()));
							obj.addProperty("cycle", src.getReportingCycle());
							obj.addProperty("nextDate",
									fmt.format(src.getNextDeliveryTime()));
							obj.addProperty("qmx", src.getQmxReference());
							obj.addProperty("createdDate",
									fmt.format(src.getRecordTime()));
							obj.addProperty("user", src.getRemoteUser());
							return obj;
						}
					}).create();

			writer.write(gson.toJson(historyList));

		} else {
			writer.write("{\"empty\":\"true\"}");
		}

		return com.opensymphony.xwork2.Action.NONE;
	}

	public ReportDeliveryTrackingForm getReportForm() {
		return reportForm;
	}

	public void setReportForm(ReportDeliveryTrackingForm reportForm) {
		this.reportForm = reportForm;
	}

	public ScheduleFService getScheduleFService() {
		return scheduleFService;
	}

	public void setScheduleFService(ScheduleFService scheduleFService) {
		this.scheduleFService = scheduleFService;
	}

	public Long getScheduleFId() {
		return scheduleFId;
	}

	public void setScheduleFId(Long scheduleFId) {
		this.scheduleFId = scheduleFId;
	}

	public ScheduleF getScheduleF() {
		return scheduleF;
	}

	public void setScheduleF(ScheduleF scheduleF) {
		this.scheduleF = scheduleF;
	}
}
