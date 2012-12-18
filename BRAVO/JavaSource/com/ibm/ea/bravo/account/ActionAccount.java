package com.ibm.ea.bravo.account;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.contact.AccountContact;
import com.ibm.ea.bravo.contact.DelegateContact;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.properties.DelegateProperties;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.Hardware;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.hardwaresoftware.DelegateComposite;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.utils.EaUtils;

public class ActionAccount extends ActionBase {
    /**
     * Logger for this class
     */
    private static final Logger logger = Logger.getLogger(ActionAccount.class);

    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        logger.debug("ActionAccount.home");

        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward view(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        logger.debug("ActionAccount.view");
        ActionErrors errors = new ActionErrors();

        // get the id parameter
        String accountId = getParameter(request, Constants.ACCOUNT_ID);
        logger.debug(accountId);
        String hardwareStatus = getParameter(request, Constants.STATUS);

        // if the id parameter exists, we view the detail of one account
        if (!EaUtils.isBlank(accountId)) {
            // setup the account
            Account account = DelegateAccount.getAccount(accountId, request);

            if (account == null) {
                saveErrors(request, errors);
                return mapping.findForward(Constants.HOME);
            }
            request.setAttribute(Constants.Is_APMM_ACCOUNT, DelegateAccount
                    .isAPMMAccount(account.getCustomer().getCustomerName()));
            // determine if a multi report exists
            account.setMultiReport(DelegateAccount.getMultiReport(account));

            // At this point I need to return the Contact Account List
            // for this I need customerId
            List<AccountContact> list = new ArrayList<AccountContact>();
            if (account.getCustomer() != null) {
                String cid = account.getCustomer().getCustomerId().toString();
                long custId = Long.parseLong(cid);
                list = DelegateContact.getAccountContacts(custId);
            }

            // get the statistics
            AccountStatistics accountStatistics = new AccountStatistics();

            // skip the statistics if you have "accountStatistics = false" in
            // the BRAVO properties file
            String statisticsFlag = DelegateProperties.getProperty(
                    Constants.APP_PROPERTIES, Constants.ACCOUNT_STATISTICS);
            logger.debug("statisticsFlag = " + statisticsFlag);

            if (statisticsFlag == null
                    || statisticsFlag.equalsIgnoreCase(Constants.TRUE)) {
                accountStatistics = DelegateAccount.getStatistics(account);
            }

            hardwareStatus = EaUtils.isBlank(hardwareStatus) ? Constants.ACTIVE
                    : hardwareStatus;

            // pull the list based on the hardwareStatus
            List<String> hwStatus = new ArrayList<String>();
            if (hardwareStatus.equalsIgnoreCase(Constants.ACTIVE)
                    || hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
                hwStatus.add("");
                hwStatus.add(Constants.ACTIVE);
            }
            if (hardwareStatus.equalsIgnoreCase(Constants.INACTIVE)
                    || hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
                hwStatus.add(Constants.INACTIVE);
            }
            if (hardwareStatus.equalsIgnoreCase(Constants.HWCOUNT)
                    || hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
                hwStatus.add(Constants.HWCOUNT);
            }
            if (hardwareStatus.equalsIgnoreCase(Constants.ONHOLD)
                    || hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
                hwStatus.add(Constants.ONHOLD);
            }
            if (hardwareStatus.equalsIgnoreCase(Constants.REMOVED)
                    || hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
                hwStatus.add(Constants.REMOVED);
            }

            List<String> status = new ArrayList<String>();
            status.add(Constants.ACTIVE);
            if (hardwareStatus.equalsIgnoreCase(Constants.ALL)) {
                status.add(Constants.INACTIVE);
            }

            // Get all composites
            Long count = DelegateComposite.getCompositeByCustomerSize(account,
                    hwStatus);
            Long countTwo = DelegateSoftware
                    .getLparNoCompositeByCustomerByStatusSize(account, status);
            Long countThree = DelegateHardware
                    .getLparNoCompositeByCustomerByStatusSize(account, status,
                            hwStatus);
            Long countFour = DelegateHardware
                    .getHardwaresNoLparsByCustomerByStatusSize(account,
                            hwStatus);

            if (count.intValue() + countTwo.intValue() + countThree.intValue()
                    + countFour.intValue() > Constants.MAX_SEARCH_RESULT_SIZE) {
                errors.add(Constants.SEARCH, new ActionMessage(
                        Constants.SEARCH_TOO_LARGE));
            }

            List<HardwareLpar> composites = null;
            List<SoftwareLpar> softwareLpars = null;
            List<HardwareLpar> hardwareLpars = null;
            List<Hardware> hardwares = null;

            // if the result size is invalid, return an error
            if (!errors.isEmpty()) {
                saveErrors(request, errors);
            } else {
                composites = DelegateComposite.getCompositeByCustomer(account,
                        hwStatus);
                softwareLpars = DelegateSoftware
                        .getLparNoCompositeByCustomerByStatus(account, status);
                hardwareLpars = DelegateHardware
                        .getLparNoCompositeByCustomerByStatus(account, status,
                                hwStatus);
                hardwares = DelegateHardware
                        .getHardwaresNoLparsByCustomerByStatus(account
                                .getCustomer(), hwStatus);
            }

            request.setAttribute(Constants.ACCOUNT, account);
            request.setAttribute(Constants.ACCOUNT_STATISTICS,
                    accountStatistics);
            request.setAttribute(Constants.CONTACT_LIST, list);
            request.setAttribute("composites", composites);
            request.setAttribute("hardwareLpars", hardwareLpars);
            request.setAttribute("softwareLpars", softwareLpars);
            request.setAttribute("hardwares", hardwares);
        }

        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward search(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        logger.debug("ActionAccount.search");

        ActionErrors errors = new ActionErrors();

        // cast the form
        FormAccountSearch searchForm = (FormAccountSearch) form;
        logger.debug("searchForm.context = " + searchForm.getContext());

        // validate the form
        errors = searchForm.validate(mapping, request);
        if (!errors.isEmpty()) {
            saveErrors(request, errors);
            return mapping.findForward(Constants.ERROR);
        }

        String image = Constants.IMAGE_LOCKED;
        request.setAttribute(Constants.IMAGETAG, image);

        // get customer list
        if (searchForm.getType().equals("ACCOUNT")) {
            List<Account> accountList = DelegateAccount.search(searchForm
                    .getSearch().toUpperCase());
            if (accountList.size() > Constants.MAX_SEARCH_RESULT_SIZE) {
                errors.add(Constants.SEARCH, new ActionMessage(
                        Constants.SEARCH_TOO_LARGE));
                accountList.clear();
            }

            request.setAttribute(Constants.LIST, accountList);

            // if the result size is invalid, return an error
            if (!errors.isEmpty()) {
                saveErrors(request, errors);
            }

            return mapping.findForward(Constants.SUCCESS);
        }

        if (searchForm.getType().equals("SOFTWARELPAR")) {
            // Get the count
            Integer count = DelegateComposite.searchSoftwareLparSize(searchForm
                    .getSearch().toUpperCase());

            Integer countTwo = DelegateSoftware
                    .searchLparNoCompositeSize(searchForm.getSearch()
                            .toUpperCase());

            if (count.intValue() + countTwo.intValue() > Constants.MAX_SEARCH_RESULT_SIZE) {
                errors.add(Constants.SEARCH, new ActionMessage(
                        Constants.SEARCH_TOO_LARGE));
            }

            // if the result size is invalid, return an error
            if (!errors.isEmpty()) {
                saveErrors(request, errors);

            } else {
                // Get all with a composite
                List<HardwareLpar> composites = DelegateComposite
                        .searchSoftwareLpar(searchForm.getSearch()
                                .toUpperCase());
                // get software lpars with no composite
                List<SoftwareLpar> softwareLpars = DelegateSoftware
                        .searchLparNoComposite(searchForm.getSearch()
                                .toUpperCase());

                request.setAttribute("composites", composites);
                request.setAttribute("softwareLpars", softwareLpars);
            }

            return mapping.findForward("software");
        }

        if (searchForm.getType().equals("HARDWARELPAR")) {

            // Get the count
            Integer count = DelegateComposite.searchHardwareLparSize(searchForm
                    .getSearch().toUpperCase());

            Integer countTwo = DelegateHardware
                    .searchLparNoCompositeSize(searchForm.getSearch()
                            .toUpperCase());

            Integer countThree = DelegateHardware
                    .searchHardwareNoLparsSize(searchForm.getSearch()
                            .toUpperCase());

            if (count.intValue() + countTwo.intValue() + countThree.intValue() > Constants.MAX_SEARCH_RESULT_SIZE) {
                errors.add(Constants.SEARCH, new ActionMessage(
                        Constants.SEARCH_TOO_LARGE));
            }

            // if the result size is invalid, return an error
            if (!errors.isEmpty()) {
                saveErrors(request, errors);
            } else {

                // Get all with a composite
                List<HardwareLpar> composites = DelegateComposite
                        .searchHardwareLpar(searchForm.getSearch()
                                .toUpperCase());

                // get hardware lpars with no composite
                List<HardwareLpar> hardwareLpars = DelegateHardware
                        .searchLparNoComposite(searchForm.getSearch()
                                .toUpperCase());

                // get hardware with no hardware lpars
                List<Hardware> hardware = DelegateHardware
                        .searchHardwareNoLpars(searchForm.getSearch()
                                .toUpperCase());

                request.setAttribute("composites", composites);
                request.setAttribute("hardwareLpars", hardwareLpars);
                request.setAttribute("hardware", hardware);
            }

            return mapping.findForward("hardware");
        }

        // if the result size is invalid, return an error
        if (!errors.isEmpty()) {
            saveErrors(request, errors);
        }

        return mapping.findForward(Constants.SUCCESS);
    }

}
