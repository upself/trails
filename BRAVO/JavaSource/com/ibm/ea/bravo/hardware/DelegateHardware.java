package com.ibm.ea.bravo.hardware;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.hardwaresoftware.DelegateComposite;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.utils.EaUtils;

public abstract class DelegateHardware extends HibernateDelegate {

    private static final Logger logger = Logger
                                               .getLogger(DelegateHardware.class);

    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> search(String search, Account account,
            List<String> hardwareStatus, List<String> status) throws Exception {
        logger.debug("DelegateHardware.search search = " + search);
        List<HardwareLpar> list = null;

        Session session = getSession();

        list = session.getNamedQuery("hardwareLparsSearch").setEntity(
                "customer", account.getCustomer()).setString("name",
                "%" + search.toUpperCase() + "%").setString("serial",
                "%" + search.toUpperCase() + "%").setParameterList(
                "hardwareStatus", hardwareStatus).setParameterList("status",
                status).list();

        closeSession(session);

        return list;
    }

    /**
     * @param search
     * @return
     */
    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> search(String search) throws Exception {
        logger.debug("DelegateHardware.search search = " + search);
        List<HardwareLpar> list = null;

        Session session = getSession();

        list = session.getNamedQuery("hardwareLparsSearchAll").setString(
                "name", "%" + search.toUpperCase() + "%").setString("serial",
                "%" + search.toUpperCase() + "%").list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> searchHardwareNoLpars(String search,
            Account account, List<String> status) throws Exception {
        logger.debug("DelegateHardware.search search = " + search
                + ", account = " + account.getCustomer().getAccountNumber());
        List<Hardware> list = null;

        Session session = getSession();

        list = session.getNamedQuery("hardwareNoLparsSearch").setEntity(
                "customer", account.getCustomer()).setString("serial",
                "%" + search.toUpperCase() + "%").setParameterList("status",
                status).list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> searchHardwareNoLpars(String search,
            Account account, List<String> hwStatus, List<String> status)
            throws HibernateException, Exception {
        List<Hardware> list = null;

        Session session = getSession();

        list = session
                .getNamedQuery("hardwaresNoLparsByCustomerByStatusSearch")
                .setEntity("customer", account.getCustomer()).setString(
                        "serial", "%" + search.toUpperCase() + "%")
                .setParameterList("status", status).setParameterList(
                        "hwStatus", hwStatus).list();

        closeSession(session);

        return list;
    }

    public static Integer searchHardwareNoLparsSize(String search)
            throws HibernateException, Exception {
        Integer count = null;

        Session session = getSession();

        count = (Integer) session.createCriteria(Hardware.class).setProjection(
                Projections.rowCount()).setFetchMode("machineType",
                FetchMode.JOIN).add(Restrictions.isEmpty("hardwareLpars")).add(
                Restrictions.like("serial", search, MatchMode.ANYWHERE))
                .uniqueResult();

        closeSession(session);

        return count;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> searchHardwareNoLpars(String search)
            throws Exception {
        logger.debug("DelegateHardware.search search = " + search);
        List<Hardware> list = null;

        Session session = getSession();

        list = session.createCriteria(Hardware.class).setFetchMode(
                "machineType", FetchMode.JOIN).add(
                Restrictions.isEmpty("hardwareLpars")).add(
                Restrictions.like("serial", search, MatchMode.ANYWHERE)).list();

        session.close();

        return list;
    }

    public static Integer searchLparNoCompositeSize(String search)
            throws HibernateException, Exception {
        Integer count = null;

        Session session = getSession();

        count = (Integer) session.createCriteria(HardwareLpar.class)
                .setProjection(Projections.rowCount()).createAlias("hardware",
                        "h", CriteriaSpecification.LEFT_JOIN).setFetchMode(
                        "hardware", FetchMode.JOIN).setFetchMode(
                        "hardware.machineType", FetchMode.JOIN).setFetchMode(
                        "customer", FetchMode.JOIN).add(
                        Restrictions.isNull("softwareLpar")).add(
                        Restrictions.disjunction().add(
                                Restrictions.like("name", search,
                                        MatchMode.ANYWHERE)).add(
                                Restrictions.like("h.serial", search,
                                        MatchMode.ANYWHERE))).uniqueResult();

        closeSession(session);

        return count;
    }

    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> searchLparNoComposite(String search)
            throws Exception {
        logger.debug("DelegateHardware.search search = " + search);
        List<HardwareLpar> list = null;

        Session session = getSession();

        list = session.createCriteria(HardwareLpar.class).createAlias(
                "hardware", "h", CriteriaSpecification.LEFT_JOIN).setFetchMode(
                "hardware", FetchMode.JOIN).setFetchMode(
                "hardware.machineType", FetchMode.JOIN).setFetchMode(
                "customer", FetchMode.JOIN).add(
                Restrictions.isNull("softwareLpar")).add(
                Restrictions.disjunction().add(
                        Restrictions.like("name", search, MatchMode.ANYWHERE))
                        .add(
                                Restrictions.like("h.serial", search,
                                        MatchMode.ANYWHERE))).list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> searchLparNoComposite(String search,
            Account account, List<String> hwStatus, List<String> status)
            throws HibernateException, Exception {
        List<HardwareLpar> list = null;

        Session session = getSession();
        if (search.length() >= 3) {
            list = session.createCriteria(HardwareLpar.class).createAlias(
                    "hardware", "h").setFetchMode("hardware", FetchMode.JOIN)
                    .setFetchMode("hardware.machineType", FetchMode.JOIN).add(
                            Restrictions.eq("customer", account.getCustomer()))
                    .add(Restrictions.in("h.hardwareStatus", hwStatus)).add(
                            Restrictions.in("status", status)).add(
                            Restrictions.isNull("softwareLpar")).add(
                            Restrictions.disjunction().add(
                                    Restrictions.like("name", search,
                                            MatchMode.ANYWHERE).ignoreCase())
                                    .add(
                                            Restrictions.like("h.serial",
                                                    search, MatchMode.ANYWHERE)
                                                    .ignoreCase())).list();
        } else {
            list = session.createCriteria(HardwareLpar.class).createAlias(
                    "hardware", "h").setFetchMode("hardware", FetchMode.JOIN)
                    .setFetchMode("hardware.machineType", FetchMode.JOIN).add(
                            Restrictions.eq("customer", account.getCustomer()))
                    .add(Restrictions.in("h.hardwareStatus", hwStatus)).add(
                            Restrictions.in("status", status)).add(
                            Restrictions.isNull("softwareLpar")).add(
                            Restrictions.disjunction().add(
                                    Restrictions.eq("name", search)
                                            .ignoreCase()).add(
                                    Restrictions.eq("h.serial", search)
                                            .ignoreCase())).list();
        }
        closeSession(session);

        return list;
    }

    public static Hardware getHardware(long hardwareId) throws Exception {
        logger.debug("DelegateHardware.getHardware");

        Session session = getSession();

        Hardware hw = (Hardware) session.getNamedQuery("hardwareByID").setLong(
                "hardwareId", hardwareId).uniqueResult();

        closeSession(session);

        return hw;
    }

    public static Hardware getHardware(Account account, String mt, String sn5)
            throws Exception {
        logger.debug("DelegateHardware.getHardware");

        Session session = getSession();

        Hardware hw = (Hardware) session.getNamedQuery(
                "hardwareByAccountByMtBySn5").setEntity("customer",
                account.getCustomer())
                .setString("sn5", "%" + sn5.toUpperCase()).setString("mt", mt)
                .uniqueResult();

        closeSession(session);

        return hw;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> getHardwaresNoLpars(Account account) {
        logger.debug("DelegateHardware.getHardwareNoLpars");
        List<Hardware> list = null;

        try {
            Session session = getSession();

            list = session.getNamedQuery("hardwaresNoLparsByCustomer")
                    .setEntity("customer", account.getCustomer()).list();

            closeSession(session);
        } catch (Exception e) {
            logger.error(e, e);
        }

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> getHardwaresNoLpars(Account account,
            List<String> status) {
        logger.debug("DelegateHardware.getHardwareNoLpars");
        List<Hardware> list = null;

        try {
            Session session = getSession();

            list = session.getNamedQuery("hardwaresNoLparsByCustomerByStatus")
                    .setEntity("customer", account.getCustomer())
                    .setParameterList("status", status).list();

            closeSession(session);
        } catch (Exception e) {
            logger.error(e, e);
        }

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> getHardwareLpars(Account account) {
        logger.debug("DelegateHardware.getHardwareLpars");
        List<HardwareLpar> list = null;

        try {
            Session session = getSession();

            list = session.getNamedQuery("hardwareLparsByAccount").setEntity(
                    "customer", account.getCustomer()).list();

            closeSession(session);
        } catch (Exception e) {
            logger.error(e, e);
        }

        return list;
    }

    public static HardwareLpar getHardwareLpar(String hardwareLparId)
            throws Exception {

        if (EaUtils.isBlank(hardwareLparId))
            return null;

        return getHardwareLpar(Long.parseLong(hardwareLparId));
    }

    public static HardwareLpar getHardwareLpar(long hardwareLparId)
            throws Exception {
        HardwareLpar hardwareLpar = null;

        Session session = getSession();

        hardwareLpar = (HardwareLpar) session.getNamedQuery("hardwareLparById")
                .setLong("hardwareLparId", hardwareLparId).uniqueResult();

        closeSession(session);

        return hardwareLpar;
    }

    public static HardwareLpar getHardwareLpar(String lparName,
            String accountId, HttpServletRequest request)
            throws ExceptionAccountAccess {

        Account account = DelegateAccount.getAccount(accountId, request);

        return getHardwareLpar(lparName, account);
    }

    public static HardwareLpar getHardwareLpar(String lparName, Account account) {
        HardwareLpar hardwareLpar = null;
        if (account == null)
            return hardwareLpar;

        try {
            Session session = getSession();

            hardwareLpar = (HardwareLpar) session.getNamedQuery(
                    "hardwareLparByAccountByName").setEntity("customer",
                    account.getCustomer()).setString("name",
                    lparName.toUpperCase()).uniqueResult();

            closeSession(session);

        } catch (Exception e) {
            logger.error(e, e);
        }

        return hardwareLpar;
    }

    public static int getCountAccountHardware(int customerid) {

        Integer count = new Integer(0);

        try {
            Session session = getSession();

            count = (Integer) session.getNamedQuery("hardwareByAccountCount")
                    .setInteger("customerid", customerid).uniqueResult();

            closeSession(session);
        } catch (HibernateException e) {
            logger.error("getCountAccountHardware(HibernateException)", e);
        } catch (Exception e) {
            logger.error("getCountAccountHardware(Exception)", e);
        }

        return count.intValue();
    }

    public static void search(String type, String search) {

    }

    public static FormHardware save(FormHardware hardware,
            HttpServletRequest request) {
        logger.debug("DelegateHardware.save");
        FormHardware dbHardware = null;

        // create the pojo
        HardwareLpar hardwareLpar = new HardwareLpar();
        hardwareLpar.setName(hardware.getLparName().toUpperCase());
        hardwareLpar.setCustomer(hardware.getCustomer());
        hardwareLpar.setHardware(hardware.getHardware());
        hardwareLpar.setRemoteUser(hardware.getRemoteUser());
        hardwareLpar.setStatus(hardware.getStatus());
        hardwareLpar.setRecordTime(new Date());

        if (!EaUtils.isBlank(hardware.getId()))
            hardwareLpar.setId(new Long(hardware.getId()));

        try {
            Session session = getSession();
            Transaction tx = session.beginTransaction();

            // save or update the hardware
            session.saveOrUpdate(hardwareLpar);

            // pull the saved record from the database
            dbHardware = new FormHardware(hardwareLpar.getId().toString(),
                    hardwareLpar.getCustomer().getAccountNumber().toString());

            tx.commit();
            closeSession(session);

            // get the composite record for this hardwareLpar
            DelegateComposite.save(hardwareLpar, request);

        } catch (Exception e) {
            logger.error(e, e);
        }

        return dbHardware;
    }

    public static SCRTRecord saveSCRTRecord(SCRTRecord scrtRecord,
            HttpServletRequest request) throws Exception {
        logger.debug("DelegateHardware.saveSCRTRecord");

        SCRTRecord dbScrtRecord = null;

        try {
            // get session object
            Session session = getSession();

            // check if record already exists
            dbScrtRecord = (SCRTRecord) session.getNamedQuery(
                    "scrtRecordByHardwareByYearByMonthByLpar").setEntity("hw",
                    scrtRecord.getHardware()).setInteger("year",
                    scrtRecord.getYear().intValue()).setInteger("month",
                    scrtRecord.getMonth().intValue()).setString("lpar",
                    scrtRecord.getLpar()).uniqueResult();

            // save or update the scrt record
            if (dbScrtRecord == null) {
                Transaction tx = session.beginTransaction();
                session.saveOrUpdate(scrtRecord);
                tx.commit();
            } else {
                dbScrtRecord.setCpc(scrtRecord.getCpc());
                dbScrtRecord.setMsu(scrtRecord.getMsu());
                dbScrtRecord.setScrtReportFile(scrtRecord.getScrtReportFile());
                dbScrtRecord.setRemoteUser(scrtRecord.getRemoteUser());
                Transaction tx = session.beginTransaction();
                session.saveOrUpdate(dbScrtRecord);
                tx.commit();
            }

            // pull the saved record from the database
            dbScrtRecord = (SCRTRecord) session.getNamedQuery(
                    "scrtRecordByHardwareByYearByMonthByLpar").setEntity("hw",
                    scrtRecord.getHardware()).setInteger("year",
                    scrtRecord.getYear().intValue()).setInteger("month",
                    scrtRecord.getMonth().intValue()).setString("lpar",
                    scrtRecord.getLpar()).uniqueResult();

            // close session
            closeSession(session);

        } catch (Exception e) {
            throw e;
        }

        return dbScrtRecord;
    }

    public static boolean deleteSCRTRecord(Hardware hw, String reportYear,
            String reportMonth, String lpar) throws Exception {
        logger.debug("DelegateHardware.saveSCRTRecord");

        SCRTRecord dbScrtRecord = null;
        boolean success = false;

        try {
            // get session object
            Session session = getSession();

            // check if record exists
            dbScrtRecord = (SCRTRecord) session.getNamedQuery(
                    "scrtRecordByHardwareByYearByMonthByLpar").setEntity("hw",
                    hw).setInteger("year", new Integer(reportYear).intValue())
                    .setInteger("month", new Integer(reportMonth).intValue())
                    .setString("lpar", lpar).uniqueResult();

            // delete the scrt record
            if (dbScrtRecord != null) {
                Transaction tx = session.beginTransaction();
                session.delete(dbScrtRecord);
                tx.commit();
            }

            // close session
            closeSession(session);

            success = true;

        } catch (Exception e) {
            throw e;
        }

        return success;
    }

    @SuppressWarnings("unchecked")
    public static List<SCRTRecord> getSCRTRecords(Hardware hw,
            String reportYear, String reportMonth) throws Exception {
        logger.debug("DelegateHardware.getSCRTRecords");
        List<SCRTRecord> list = null;

        Session session = getSession();

        list = session.getNamedQuery("scrtRecordsByHardwareByYearByMonth")
                .setEntity("hw", hw).setInteger("year",
                        new Integer(reportYear).intValue()).setInteger("month",
                        new Integer(reportMonth).intValue()).list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<SCRTRecord> getSCRTRecords(Hardware hw) throws Exception {
        logger.debug("DelegateHardware.getSCRTRecords");
        List<SCRTRecord> list = null;

        Session session = getSession();

        list = session.getNamedQuery("scrtRecordsByHardware").setEntity("hw",
                hw).list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static Collection<HardwareLpar> getHardwareLparsWithoutSoftware(
            Account account) throws HibernateException, Exception {
        List<HardwareLpar> list = null;

        Session session = getSession();

        list = session.getNamedQuery("hardwareLparsWithoutSoftware").setEntity(
                "customer", account.getCustomer()).list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> getHardwaresNoLparsByCustomer(Account account)
            throws HibernateException, Exception {
        List<Hardware> list = null;

        Session session = getSession();

        list = session.getNamedQuery("hardwaresNoLparsByCustomerNoRemove")
                .setEntity("customer", account.getCustomer()).list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> getHardwaresNoActiveLparsByCustomer(
            Account account) throws HibernateException, Exception {
        List<Hardware> list = null;

        Session session = getSession();

        list = session
                .getNamedQuery("hardwaresNoActiveLparsByCustomerNoRemove")
                .setEntity("customer", account.getCustomer()).list();

        closeSession(session);

        return list;
    }

    public static Long getLparNoCompositeByCustomerByStatusSize(
            Account account, List<String> status, List<String> hwStatus)
            throws HibernateException, Exception {
        Long count = null;

        Session session = getSession();

        count = (Long) session.getNamedQuery(
                "getLparNoCompositeByCustomerByStatusSize").setEntity(
                "customer", account.getCustomer()).setParameterList("status",
                status).setParameterList("hardwareStatus", hwStatus)
                .uniqueResult();

        closeSession(session);

        return count;
    }

    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> getLparNoCompositeByCustomerByStatus(
            Account account, List<String> status, List<String> hwStatus)
            throws HibernateException, Exception {
        List<HardwareLpar> list = null;

        Session session = getSession();

        list = session.getNamedQuery("getLparNoCompositeByCustomerByStatus")
                .setEntity("customer", account.getCustomer()).setParameterList(
                        "status", status).setParameterList("hardwareStatus",
                        hwStatus).list();

        closeSession(session);

        return list;
    }

    public static Long getHardwaresNoLparsByCustomerByStatusSize(
            Account account, List<String> hwStatus) throws HibernateException,
            Exception {
        Long count = null;

        Session session = getSession();

        count = (Long) session.getNamedQuery(
                "getHardwaresNoLparsByCustomerByStatusSize").setEntity(
                "customer", account.getCustomer()).setParameterList(
                "hardwareStatus", hwStatus).uniqueResult();

        closeSession(session);

        return count;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> getHardwaresNoLparsByCustomerByStatus(Customer customer,
            List<String> hwStatus) throws HibernateException, Exception {
        List<Hardware> list = null;

        Session session = getSession();

        list = session.getNamedQuery("getHardwaresNoLparsByCustomerByStatus")
                .setEntity("customer", customer).setParameterList(
                        "hardwareStatus", hwStatus).list();

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<Hardware> getHardwaresNoLparsByCustomerByStatusSerial(
            Customer customer, List<String> hwStatus, String serial)
            throws HibernateException, Exception {
        List<Hardware> list = null;

        Session session = getSession();
        if (serial.length() >= 3) {
            list = session.getNamedQuery(
                    "hardwaresNoLparsByCustomerByStatusSerial").setEntity(
                    "customer", customer).setString("serial",
                    "%" + serial + "%").setParameterList("status", hwStatus)
                    .list();
        } else {
            list = session.getNamedQuery(
                    "hardwaresNoLparsByCustomerByStatusSerial").setEntity(
                    "customer", customer).setString("serial", serial)
                    .setParameterList("status", hwStatus).list();
        }
        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> searchHardwareLparsByCustomer(
            String search, Account account) throws Exception {
        logger.debug("DelegateHardware.search search = " + search);
        List<HardwareLpar> list = null;

        Session session = getSession();
        if (search.length() >= 3) {
            list = session.createCriteria(HardwareLpar.class).createAlias(
                    "hardware", "h").setFetchMode("hardware", FetchMode.JOIN)
                    .setFetchMode("hardware.machineType", FetchMode.JOIN).add(
                            Restrictions.eq("customer", account.getCustomer()))
                    .add(
                            Restrictions.disjunction().add(
                                    Restrictions.like("name", search,
                                            MatchMode.ANYWHERE).ignoreCase())
                                    .add(
                                            Restrictions.like("h.serial",
                                                    search, MatchMode.ANYWHERE)
                                                    .ignoreCase())).list();
        } else {
            list = session.createCriteria(HardwareLpar.class).createAlias(
                    "hardware", "h").setFetchMode("hardware", FetchMode.JOIN)
                    .setFetchMode("hardware.machineType", FetchMode.JOIN).add(
                            Restrictions.eq("customer", account.getCustomer()))
                    .add(
                            Restrictions.disjunction().add(
                                    Restrictions.eq("name", search)
                                            .ignoreCase()).add(
                                    Restrictions.eq("h.serial", search)
                                            .ignoreCase())).list();
        }

        closeSession(session);

        return list;
    }

    @SuppressWarnings("unchecked")
    public static List<HardwareLpar> searchHardwareLparsWithAuthorizedProductsByCustomer(
            String search, Account account) throws HibernateException,
            Exception {
        logger.debug("DelegateHardware.search search = " + search);
        List<HardwareLpar> list = null;

        Session session = getSession();
        if (search.length() >= 3) {
            list = session.createCriteria(HardwareLpar.class).createAlias(
                    "hardware", "h").add(
                    Restrictions.eq("customer", account.getCustomer())).add(
                    Restrictions.isNotEmpty("authorizedProducts")).add(
                    Restrictions.disjunction().add(
                            Restrictions.like("name", search,
                                    MatchMode.ANYWHERE).ignoreCase()).add(
                            Restrictions.like("h.serial", search,
                                    MatchMode.ANYWHERE).ignoreCase())).list();
        } else {
            list = session.createCriteria(HardwareLpar.class).createAlias(
                    "hardware", "h").add(
                    Restrictions.isNotEmpty("authorizedProducts")).add(
                    Restrictions.eq("customer", account.getCustomer())).add(
                    Restrictions.disjunction().add(
                            Restrictions.eq("name", search).ignoreCase()).add(
                            Restrictions.eq("h.serial", search).ignoreCase()))
                    .list();
        }

        closeSession(session);

        return list;
    }
}