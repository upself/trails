package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;

import org.apache.struts2.interceptor.validation.SkipValidation;

import com.ibm.asset.trails.service.AlertService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.validator.annotations.RequiredStringValidator;
import com.opensymphony.xwork2.validator.annotations.ValidatorType;

public class AlertAssignment extends AccountBaseAction {

    private static final long serialVersionUID = 1L;

    private AlertService alertService;

    private List list = new ArrayList();

    private String comments;

    // TODO I don't really like this for a few reasons
    // Because we are using a view to query, it is actually making 2 trips to
    // the
    // software lpar table in the query
    // When they hit submit, it issues the query again even upon validation
    // I would rather just have the data in scope to refresh the screen
    // This isn't good....
    // Probably be best if the whole view was a form
    @Override
    @UserRole(userRole = UserRoleType.READER)
    public void prepare() {
        super.prepare();

        if (getSort() == null) {
            setSort("alertAge");
        }

        getData().setList(
                getAlertService().paginatedList(getUserSession().getAccount(),
                        getStartIndex(), getData().getObjectsPerPage(),
                        getSort(), getDir()));

        System.out.println("1=" + getAlertService().total(getUserSession().getAccount()));
        System.out.println("2=" + getAlertService().total(getUserSession().getAccount()).intValue());
        getData().setFullListSize(
                getAlertService().total(getUserSession().getAccount())
                        .intValue());
    }

    @Override
    @SkipValidation
    @UserRole(userRole = UserRoleType.READER)
    public String input() {
        return Action.INPUT;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String update() {
        getAlertService().assign(getList(), getUserSession().getRemoteUser(),
                getComments());

        return SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String assignAll() {
        getAlertService().assignAll(getUserSession().getAccount(),
                getUserSession().getRemoteUser(), getComments());

        return SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String unassignAll() {
        getAlertService().unassignAll(getUserSession().getAccount(),
                getUserSession().getRemoteUser(), getComments());

        return SUCCESS;
    }

    public AlertService getAlertService() {
        return alertService;
    }

    public void setAlertService(AlertService alertService) {
        this.alertService = alertService;
    }

    public List getList() {
        return list;
    }

    public void setList(List list) {
        this.list = list;
    }

    public String getComments() {
        return comments;
    }

    @RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "A comment is required")
    public void setComments(String comments) {
        if (this.comments == null) {
            this.comments = comments;
        } else {
            this.comments = comments.replaceAll("\\s\\s+|\\n|\\r|\\t", " ");
        }
    }
}
