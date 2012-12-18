package com.ibm.tap.misld.gui.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.sigbank.InstalledSoftware;
import com.ibm.tap.misld.delegate.baseline.MsInstalledSoftwareBaselineReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;

/**
 * @version 1.0
 * @author
 */
public class InstalledSoftwareBaselineAction extends BaseAction

{
	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
		}

		user.setLevelOneOpenLink("/PodView.do");
		user.setLevelTwoOpenLink("/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		List<InstalledSoftware> softwareList = (List<InstalledSoftware>) MsInstalledSoftwareBaselineReadDelegate
				.getMsInstalledSoftwareBaseline(user.getCustomer());
		List<InstalledSoftware> highestSoftwareList = new ArrayList<InstalledSoftware>();
		for (InstalledSoftware installedSoftware : softwareList) {
			if (!installedSoftware.getSoftware().getSoftwareCategory()
					.getSoftwareCategoryName().equals("UNKNOWN")) {
				List softwareVersions = MsInstalledSoftwareBaselineReadDelegate
						.getHigherSoftwareVersion(user.getCustomer(),
								installedSoftware.getSoftwareLpar(),
								installedSoftware.getSoftware()
										.getSoftwareCategory(),
								installedSoftware.getSoftware().getPriority());

				// if there is a higher version of the software, exclude this
				// version
				if (softwareVersions.size() > 0) {
					continue;
				}
			}
			highestSoftwareList.add(installedSoftware);
		}

		request.setAttribute(Constants.SOFTWARE_LIST, highestSoftwareList);

		return mapping.findForward(Constants.SUCCESS);
	}
}