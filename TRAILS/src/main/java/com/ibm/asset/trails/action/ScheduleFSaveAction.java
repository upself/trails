package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.ListIterator;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.validation.SkipValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.domain.ProductInfo;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.form.ScheduleFForm;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.validator.annotations.Validations;
import com.opensymphony.xwork2.validator.annotations.VisitorFieldValidator;

@Controller
@ParentPackage("trails-struts-default")
@Namespace("/admin/scheduleF")
@Results({
        @Result(name = ActionSupport.INPUT, location = "tiles.admin.scheduleF.manage", type = "tiles"),
        @Result(name = ActionSupport.SUCCESS, location = "list", type = "redirectAction") })
public class ScheduleFSaveAction extends AccountBaseAction {
    private static final long serialVersionUID = 1L;

    private ScheduleFForm scheduleFForm;

    @Autowired
    private ScheduleFService scheduleFService;

    private Long scheduleFId;

    private ArrayList<Scope> scopeArrayList;

    private ArrayList<Source> sourceArrayList;

    private ArrayList<Status> statusArrayList;

    @SkipValidation
    @UserRole(userRole = UserRoleType.READER)
    @Action("manage")
    public String manage() {
        return INPUT;
    }

    @Action("save")
    @Validations(visitorFields = { @VisitorFieldValidator(fieldName = "scheduleFForm", appendPrefix = false) })
    public String doSave() {
        ArrayList<ProductInfo> lalProductInfo = getScheduleFService()
                .findProductInfoBySoftwareName(
                        getScheduleFForm().getSoftwareName());
        Long llScheduleFId = getScheduleF().getId();
        ScheduleF lsfExists = null;

        if (lalProductInfo.size() == 0) {
            addFieldError(
                    "scheduleFForm.softwareName",
                    "Software does not exist in catalog. It may already been removed in SWKB Toolkit.");
            return INPUT;
        } else {
            if (llScheduleFId == null) {
                lsfExists = getScheduleFService().findScheduleF(
                        getUserSession().getAccount(), lalProductInfo.get(0));
            } else {
                lsfExists = getScheduleFService().findScheduleF(llScheduleFId,
                        getUserSession().getAccount(), lalProductInfo.get(0));
            }

        }

        getScheduleF().setAccount(getUserSession().getAccount());
        getScheduleF().setProductInfo(lalProductInfo.get(0));
        getScheduleF().setSoftwareTitle(getScheduleFForm().getSoftwareTitle());
        getScheduleF().setSoftwareName(getScheduleFForm().getSoftwareName());
        getScheduleF().setManufacturer(getScheduleFForm().getManufacturer());
        getScheduleF().setScope(
                findScopeInList(getScheduleFForm().getScopeId(),
                        getScopeArrayList()));
        getScheduleF().setSource(
                findSourceInList(getScheduleFForm().getSourceId(),
                        getSourceArrayList()));
        getScheduleF()
                .setSourceLocation(getScheduleFForm().getSourceLocation());
        getScheduleF().setStatus(
                findStatusInList(getScheduleFForm().getStatusId(),
                        getStatusArrayList()));
        getScheduleF().setBusinessJustification(
                getScheduleFForm().getBusinessJustification());

        System.out.println("yo");
        if (lsfExists != null && lsfExists.equals(getScheduleF())) {
            addFieldError("scheduleFForm.softwareName",
                    "Same entry with the given software name already exists.");
            return INPUT;
        }
        try {
            getScheduleFService().saveScheduleF(getScheduleF(),
                    getUserSession().getRemoteUser());
        } catch (Exception e) {
            System.out.println(e.getCause());
            return INPUT;
        }
        return SUCCESS;
    }

    @SkipValidation
    public String doCancel() {
        return SUCCESS;
    }

    @SkipValidation
    @Override
    public void prepare() {
        super.prepare();

        if (getScheduleFForm() == null) {
            ScheduleFForm lsffManage = new ScheduleFForm();

            if (getScheduleFId() == null) {
                setScheduleF(new ScheduleF());
            } else {
                setScheduleF(getScheduleFService().getScheduleFDetails(
                        getScheduleFId()));
                lsffManage.setSoftwareTitle(getScheduleF().getSoftwareTitle());
                lsffManage.setSoftwareName(getScheduleF().getSoftwareName());
                lsffManage.setManufacturer(getScheduleF().getManufacturer());
                lsffManage.setScopeId(getScheduleF().getScope().getId());
                lsffManage.setSourceId(getScheduleF().getSource().getId());
                lsffManage
                        .setSourceLocation(getScheduleF().getSourceLocation());
                lsffManage.setStatusId(getScheduleF().getStatus().getId());
            }
            lsffManage
                    .setComplianceReporting(getAccount()
                            .getSoftwareFinancialManagement().equalsIgnoreCase(
                                    "YES") ? "YES" : "NO");
            setScheduleFForm(lsffManage);
        }

        if (getScopeArrayList() == null) {
            setScopeArrayList(getScheduleFService().getScopeList());
        }
        if (getSourceArrayList() == null) {
            setSourceArrayList(getScheduleFService().getSourceList());
        }
        if (getStatusArrayList() == null) {
            setStatusArrayList(getScheduleFService().getStatusList());
        }
    }

    private Scope findScopeInList(Long plScopeId, ArrayList<Scope> plFind) {
        ListIterator<Scope> lliFind = plFind.listIterator();
        Scope lsFind = null;

        while (lliFind.hasNext()) {
            lsFind = lliFind.next();

            if (lsFind.getId().longValue() == plScopeId.longValue()) {
                break;
            }
        }

        return lsFind;
    }

    private Source findSourceInList(Long plSourceId, ArrayList<Source> plFind) {
        ListIterator<Source> lliFind = plFind.listIterator();
        Source lsFind = null;

        while (lliFind.hasNext()) {
            lsFind = lliFind.next();

            if (lsFind.getId().longValue() == plSourceId.longValue()) {
                break;
            }
        }

        return lsFind;
    }

    private Status findStatusInList(Long plStatusId, ArrayList<Status> plFind) {
        ListIterator<Status> lliFind = plFind.listIterator();
        Status lsFind = null;

        while (lliFind.hasNext()) {
            lsFind = lliFind.next();

            if (lsFind.getId().longValue() == plStatusId.longValue()) {
                break;
            }
        }

        return lsFind;
    }

    public ScheduleF getScheduleF() {
        return (ScheduleF) getSession().get("scheduleF");
    }

    public void setScheduleF(ScheduleF scheduleF) {
        getSession().put("scheduleF", scheduleF);
    }

    public ScheduleFForm getScheduleFForm() {
        return scheduleFForm;
    }

    public void setScheduleFForm(ScheduleFForm scheduleFForm) {
        this.scheduleFForm = scheduleFForm;
    }

    public Long getScheduleFId() {
        return scheduleFId;
    }

    public void setScheduleFId(Long scheduleFId) {
        this.scheduleFId = scheduleFId;
    }

    public ScheduleFService getScheduleFService() {
        return scheduleFService;
    }

    public void setScheduleFService(ScheduleFService scheduleFService) {
        this.scheduleFService = scheduleFService;
    }

    public ArrayList<Scope> getScopeArrayList() {
        return scopeArrayList;
    }

    public void setScopeArrayList(ArrayList<Scope> scopeArrayList) {
        this.scopeArrayList = scopeArrayList;
    }

    public ArrayList<Source> getSourceArrayList() {
        return sourceArrayList;
    }

    public void setSourceArrayList(ArrayList<Source> sourceArrayList) {
        this.sourceArrayList = sourceArrayList;
    }

    public ArrayList<Status> getStatusArrayList() {
        return statusArrayList;
    }

    public void setStatusArrayList(ArrayList<Status> statusArrayList) {
        this.statusArrayList = statusArrayList;
    }
}
