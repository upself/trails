package com.ibm.asset.trails.action;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.validation.SkipValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.service.ScheduleFService;
import com.opensymphony.xwork2.ActionSupport;

@Controller
@ParentPackage("trails-struts-default")
@Namespace("/admin/scheduleF")
@Results({
        @Result(name = ActionSupport.SUCCESS, type = "stream", params = {
                "contentType", "application/vnd.ms-excel",
                "contentDisposition", "attachment;filename='results.xls'",
                "bufferSize", "1024" }),
        @Result(name = ActionSupport.INPUT, location = "tiles.admin.scheduleF.upload", type = "tiles") })
public class ScheduleFUploadAction extends FileUploadAction implements
        ServletRequestAware {

    private static final long serialVersionUID = 1L;

    @Autowired
    private ScheduleFService scheduleFService;
    private HttpServletRequest request;

    private InputStream inputStream;

    @Override
    @Action("upload")
    public String execute() throws Exception {
        return SUCCESS;
    }

    @Action("showUpload")
    @SkipValidation
    public String showUpload() {
        return INPUT;
    }

    public InputStream getInputStream() throws IOException {
        return new ByteArrayInputStream(getScheduleFService().loadSpreadsheet(
                getUpload(), request.getRemoteUser()).toByteArray());
    }

    public ScheduleFService getScheduleFService() {
        return scheduleFService;
    }

    public void setScheduleFService(ScheduleFService scheduleFService) {
        this.scheduleFService = scheduleFService;
    }

    public void setServletRequest(HttpServletRequest request) {
        this.request = request;
    }

    public HttpServletRequest getRequest() {
        return this.request;
    }

}
