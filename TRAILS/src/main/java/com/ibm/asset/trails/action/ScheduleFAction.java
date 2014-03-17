package com.ibm.asset.trails.action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.domain.ScheduleF;
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

    private Long scheduleFId;

    private ScheduleF scheduleF;

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
            getScheduleFService().paginatedList(getData(), getAccount(),
                    getStartIndex(), getData().getObjectsPerPage(), getSort(),
                    getDir());

            return SUCCESS;
        }
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
