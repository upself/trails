package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.ibm.asset.trails.domain.DataExceptionHardwareLpar;
import com.ibm.asset.trails.form.DataExceptionListForm;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class HardwareLparAjaxAction extends AccountBaseAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1029445855178235499L;

	private DataExceptionService alertHardwareLparService;

    private String comments;

    private List<DataExceptionListForm> list = new ArrayList<DataExceptionListForm>();

    public DataExceptionService getAlertHardwareLparService() {
        return alertHardwareLparService;
    }

    public void setAlertHardwareLparService(
            DataExceptionService alertHardwareLparService) {
        this.alertHardwareLparService = alertHardwareLparService;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public List<DataExceptionListForm> getList() {
        return list;
    }

    public void setList(List<DataExceptionListForm> list) {
        this.list = list;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String assign() {
        for (DataExceptionListForm obj : getList()) {
            if (obj != null) {
                performSingle(obj, true);
            }
        }
        return SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String assignAll() {
        performAll(true);
        return SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String unassign() {
        for (DataExceptionListForm obj : getList()) {
            if (obj != null) {
                performSingle(obj, false);
            }
        }
        return SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String unassignAll() {
        performAll(false);
        return SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    public String update() {
        assign(getList(), getUserSession().getRemoteUser(), getComments());
        return SUCCESS;
    }

    @UserRole(userRole = UserRoleType.READER)
    private void performAll(boolean assign) {
        for (Object obj : getList()) {
            if (obj != null) {
                ((DataExceptionListForm) obj).setAssign(assign);
            }
        }
        assign(getList(), getUserSession().getRemoteUser(), getComments());
    }

    private void performSingle(DataExceptionListForm obj, boolean assign) {
        DataExceptionListForm form = obj;

        form.setAssign(assign);
        form.setBeenAssigned(!assign);

        List<DataExceptionListForm> singleList = new ArrayList<DataExceptionListForm>();
        singleList.add(obj);

        assign(singleList, getUserSession().getRemoteUser(), getComments());

    }

    private void assign(List<DataExceptionListForm> list, String sessionUser,
            String comments) {

        Iterator<DataExceptionListForm> i = list.iterator();
        while (i.hasNext()) {
            Object obj = i.next();

            if (obj == null) {
                continue;
            }

            DataExceptionListForm alf = (DataExceptionListForm) obj;
            DataExceptionHardwareLpar ahl = (DataExceptionHardwareLpar) alertHardwareLparService
                    .getById(alf.getId());

            if (alf.isAssign() == alf.isBeenAssigned()) {
                // set current remote user into form.
                alf.setAssignee(ahl.getAssignee());
                continue;
            }

            if (alf.isAssign()) {
                alertHardwareLparService.updateAssignment(ahl, sessionUser,
                        comments, true);
            } else {
                alertHardwareLparService.updateAssignment(ahl, sessionUser,
                        comments, false);
            }

            // set current remote user into form.
            alf.setAssignee(ahl.getAssignee());
        }
    }
}
