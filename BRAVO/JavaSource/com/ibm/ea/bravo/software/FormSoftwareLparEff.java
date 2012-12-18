/*
 * Created on Jun 2, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.FormBase;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class FormSoftwareLparEff extends FormBase {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String lparId;

	private String lparName;

	private String accountId;

	private String id;

	private String processorCount;

	private String status;

	private String remoteUser;

	private String recordTime;

	private String action;

	private List<String> statusList = new ArrayList<String>();

	public FormSoftwareLparEff() {
	}

	/**
	 * @param softwareLpar
	 */
	public FormSoftwareLparEff(SoftwareLpar softwareLpar) {
		lparId = softwareLpar.getId().toString();
		lparName = softwareLpar.getName();
		accountId = softwareLpar.getCustomer().getAccountNumber().toString();
		
		if(softwareLpar.getSoftwareLparEff() != null) {
			id = softwareLpar.getSoftwareLparEff().getId().toString();
			if ( softwareLpar.getSoftwareLparEff().getProcessorCount() != null ) {
				processorCount = softwareLpar.getSoftwareLparEff().getProcessorCount().toString();
			} else {
				processorCount = "";
			}
			status = softwareLpar.getSoftwareLparEff().getStatus();
		}
		
	}

	public ActionErrors init(HttpServletRequest request) throws Exception {
		ActionErrors errors = new ActionErrors();

		// initialize drop downs
		statusList.add("ACTIVE");
		statusList.add("INACTIVE");

		return errors;
	}

	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();

		// processor count is required
		if (EaUtils.isBlank(processorCount)) {
			errors.add(Constants.PROCESSOR_COUNT, new ActionMessage(
					Constants.REQUIRED));
		} else if (!EaUtils.isPositiveInteger(processorCount)) {
			errors.add(Constants.PROCESSOR_COUNT, new ActionMessage(
					Constants.POSITIVE_NUMBER));
		} else if (EaUtils.isBlank(status)) {
			errors.add(Constants.STATUS, new ActionMessage(Constants.REQUIRED));
		} else if (action.equalsIgnoreCase(Constants.CRUD_CREATE)) {
			try {
				if (DelegateSoftware.getSoftwareLpar(lparId)
						.getSoftwareLparEff() != null) {
					errors.add(Constants.SOFTWARE_LPAR_EFF, new ActionMessage(
							Constants.SOFTWARE_LPAR_EFF_EXISTS));
				}
			} catch (ExceptionAccountAccess e) {
				errors.add(Constants.SOFTWARE_LPAR_EFF, new ActionMessage(
						Constants.ACCOUNT_ACCESS));
			} catch (Exception e) {
				errors.add(Constants.SOFTWARE_LPAR_EFF, new ActionMessage(
						Constants.ACCOUNT_ACCESS));
			}
		} else if (action.equalsIgnoreCase(Constants.CRUD_UPDATE)) {
			if (EaUtils.isBlank(id)) {
				errors.add(Constants.ID, new ActionMessage(Constants.REQUIRED));
			}
		}

		return errors;
	}

	/**
	 * @return Returns the action.
	 */
	public String getAction() {
		return action;
	}

	/**
	 * @param action
	 *            The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}

	/**
	 * @return Returns the id.
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return Returns the lparId.
	 */
	public String getLparId() {
		return lparId;
	}

	/**
	 * @param lparId
	 *            The lparId to set.
	 */
	public void setLparId(String lparId) {
		this.lparId = lparId;
	}

	/**
	 * @return Returns the processorCount.
	 */
	public String getProcessorCount() {
		return processorCount;
	}

	/**
	 * @param processorCount
	 *            The processorCount to set.
	 */
	public void setProcessorCount(String processorCount) {
		this.processorCount = processorCount;
	}

	/**
	 * @return Returns the recordTime.
	 */
	public String getRecordTime() {
		return recordTime;
	}

	/**
	 * @param recordTime
	 *            The recordTime to set.
	 */
	public void setRecordTime(String recordTime) {
		this.recordTime = recordTime;
	}

	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @param remoteUser
	 *            The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}


	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @param status
	 *            The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 * @return Returns the lparName.
	 */
	public String getLparName() {
		return lparName;
	}

	/**
	 * @param lparName
	 *            The lparName to set.
	 */
	public void setLparName(String lparName) {
		this.lparName = lparName;
	}

	/**
	 * @return Returns the accountId.
	 */
	public String getAccountId() {
		return accountId;
	}

	/**
	 * @param accountId
	 *            The accountId to set.
	 */
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}


	/**
	 * @return Returns the statusList.
	 */
	public List<String> getStatusList() {
		return statusList;
	}

	/**
	 * @param statusList
	 *            The statusList to set.
	 */
	public void setStatusList(List<String> statusList) {
		this.statusList = statusList;
	}
}
