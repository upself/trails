package com.ibm.asset.trails.action;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.apache.struts2.interceptor.validation.SkipValidation;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.service.CauseCodeService;
import com.ibm.ea.common.State;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.Preparable;

@Controller
@ParentPackage("trails-struts-default")
@Namespace("/account/causecodes")
@Results({
		@Result(name = ActionSupport.SUCCESS, type = "stream", params = {
				"contentType", "application/vnd.ms-excel",
				"contentDisposition", "attachment;filename=results.xls",
				"bufferSize", "1024" }),
		@Result(name = ActionSupport.INPUT, location = "tiles.account.causecodes.upload", type = "tiles"),
		@Result(name = ActionSupport.NONE, location = "home.htm", type = "redirect") })
public class CauseCodesUploadAction extends FileUploadAction implements
		ServletRequestAware, ServletResponseAware, Preparable, SessionAware {

	private static Logger log = Logger.getLogger(CauseCodesUploadAction.class);
	private static final long serialVersionUID = 8762282414570070793L;

	private static final String ACTION_ERROR = "causeCodesUploadActionError";

	@Autowired
	private CauseCodeService causeCodeService;
	private HttpServletRequest request;

	private HttpServletResponse reponse;

	private InputStream is;
	private Map<String, Object> session;

	public void prepare() throws Exception {
		if (getSession().containsKey(ACTION_ERROR)) {
			addActionError((String) getSession().get(ACTION_ERROR));
			getSession().remove(ACTION_ERROR);
		}
	}

	@Override
	@Action("upload")
	public String execute() {
		@SuppressWarnings("unchecked")
		List<State> steps = (List<State>) request.getSession().getAttribute(
				State.ATTR_STEPS);
		if (getUpload() == null) {
			getSession().put(ACTION_ERROR, "Error: File is required");
			return NONE;
		}

		try {
			is = new ByteArrayInputStream(getCauseCodeService()
					.loadSpreadsheet(getUpload(), request.getRemoteUser(),
							steps).toByteArray());
		} catch (IOException e) {
			getSession().put(ACTION_ERROR, e.getMessage().toString());
			return NONE;
		}

		return SUCCESS;
	}

	@Action("home")
	@SkipValidation
	public String home() {
		return INPUT;
	}

	@Action("progress")
	@SkipValidation
	public void progress() {
		@SuppressWarnings("unchecked")
		List<State> steps = (List<State>) request.getSession().getAttribute(
				State.ATTR_STEPS);

		ObjectMapper jsonMapper = new ObjectMapper();
		try {
			String value = jsonMapper.writeValueAsString(steps);
			reponse.getWriter().write(value);

		} catch (JsonGenerationException e) {
			log.error(e.getMessage(), e);
		} catch (JsonMappingException e) {
			log.error(e.getMessage(), e);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}

	}

	@Action("clearsteps")
	@SkipValidation
	public void clearSteps() {
		@SuppressWarnings("unchecked")
		List<State> steps = (List<State>) request.getSession().getAttribute(
				State.ATTR_STEPS);
		if (steps != null) {
			steps.clear();
		}

	}

	public InputStream getInputStream() throws IOException {
		@SuppressWarnings("unchecked")
		List<State> steps = (List<State>) request.getSession().getAttribute(
				State.ATTR_STEPS);
		State stopState = new State();
		stopState.setFinalState(true);
		stopState.setFinalStatus(steps);

		steps.add(stopState);
		return is;
	}

	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}

	public HttpServletRequest getRequest() {
		return this.request;
	}

	public CauseCodeService getCauseCodeService() {
		return causeCodeService;
	}

	public void setCauseCodeService(CauseCodeService causeCodeService) {
		this.causeCodeService = causeCodeService;
	}

	public void setServletResponse(HttpServletResponse response) {
		this.reponse = response;
	}

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public Map<String, Object> getSession() {
		return session;
	}

}
