package com.ibm.asset.bravo.dao.jpa;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

import com.ibm.asset.bravo.dao.AuthorizedInstalledProductDao;
import com.ibm.asset.bravo.domain.AuthorizedProduct;
import com.ibm.asset.bravo.domain.InstalledProduct;
import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.hardware.HardwareLpar;

public class AuthorizedInstalledProductDaoJpa extends HibernateDelegate
        implements AuthorizedInstalledProductDao {

    private static final Logger logger = Logger
                                               .getLogger(AuthorizedInstalledProductDaoJpa.class);

    @SuppressWarnings("unchecked")
    public List<? extends InstalledProduct> getAuthorizedProductByCustomer(
            Account account) throws HibernateException, Exception {
        logger
                .debug("AuthorizedInstalledProductDaoJpa.getAuthorizedProductByCustomer");
        List<? extends InstalledProduct> result = null;
        Session session = getSession();
        result = session.createCriteria(AuthorizedProduct.class).createAlias(
                "hardwareLpar", "hl").setFetchMode("product", FetchMode.JOIN)
                .add(Restrictions.eq("hl.customer", account.getCustomer()))
                .list();
        closeSession(session);
        return result;
    }

    @SuppressWarnings("unchecked")
    public List<? extends InstalledProduct> getAuthorizedProductByHwLpar(
            HardwareLpar hardwareLpar) throws HibernateException, Exception {
        logger
                .debug("AuthorizedInstalledProductDaoJpa.getAuthorizedProductByHwLpar");
        List<? extends InstalledProduct> result = null;
        Session session = getSession();
        result = session.createCriteria(AuthorizedProduct.class).setFetchMode(
                "product", FetchMode.JOIN).add(
                Restrictions.eq("hardwareLpar", hardwareLpar)).list();
        return result;
    }

}
