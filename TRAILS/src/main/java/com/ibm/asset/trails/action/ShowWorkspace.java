package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;

import org.apache.struts2.ServletActionContext;

import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.asset.trails.domain.Report;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class ShowWorkspace extends AccountReportBaseAction {

    private static final long serialVersionUID = 1L;

    private ReconWorkspaceService reconWorkspaceService;

    private List<ReconcileType> reconcileTypes;

    private Recon recon = new Recon();

    @Override
    @UserRole(userRole = UserRoleType.READER)
    public void prepare() {
        super.prepare();

        List<Report> lReport = new ArrayList<Report>();

        if (getSort() == null) {
            setSort("aus.alertAge");
        }

        if (getUserSession().getReconSetting() != null) {
            getReconWorkspaceService().paginatedList(getData(),
                    getUserSession().getAccount(),
                    getUserSession().getReconSetting(), getStartIndex(),
                    getData().getObjectsPerPage(), getSort(), getDir());
        }

        lReport.add(new Report("Full reconciliation", "fullReconciliation"));
        super.setReportList(lReport);
    }
    
	@Override
    @UserRole(userRole = UserRoleType.READER)
    public String execute() {

        if (getUserSession().getReconSetting() == null) {
            return ERROR;
        }

        reconcileTypes = getReconWorkspaceService().reconcileTypes(true);
        
        //AB added
        String schedulefFlag=getUserSession().getSchedulefDefExistingIdentify();
        if(schedulefFlag!=null && schedulefFlag.equalsIgnoreCase("N")){
        	addActionError("Schedule F not defined.");
        }
        //clear the identify to avoid it to existing when refresh workspace page
        getUserSession().setSchedulefDefExistingIdentify(null);
        
        return SUCCESS;
    }

    public ReconWorkspaceService getReconWorkspaceService() {
        return reconWorkspaceService;
    }

    public void setReconWorkspaceService(
            ReconWorkspaceService reconWorkspaceService) {
        this.reconWorkspaceService = reconWorkspaceService;
    }

    public List<ReconcileType> getReconcileTypes() {
        return reconcileTypes;
    }

    public void setReconcileTypes(List<ReconcileType> reconcileTypes) {
        this.reconcileTypes = reconcileTypes;
    }

    public Recon getRecon() {
        return recon;
    }

    public void setRecon(Recon recon) {
        this.recon = recon;
    }

}
