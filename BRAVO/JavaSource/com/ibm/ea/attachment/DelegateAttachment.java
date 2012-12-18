package com.ibm.ea.attachment;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

public abstract class DelegateAttachment extends HibernateDelegate {

    private static final Logger logger = Logger
                                               .getLogger(DelegateAttachment.class);

    public static void save(Attachment attachment) {
        logger.debug("DelegateAttachment.save");

        try {
            Session session = getSession();
            Transaction tx = session.beginTransaction();

            // save or update the hardware
            session.saveOrUpdate(attachment);

            tx.commit();
            closeSession(session);

        } catch (Exception e) {
            logger.error(e, e);
        }
    }

    @SuppressWarnings("unchecked")
    public static List<Attachment> list(String status) throws Exception {
        List<Attachment> list = null;

        Session session = getSession();

        list = session.getNamedQuery("attachmentsByStatus").setString("status",
                status).list();

        closeSession(session);

        return list;
    }

    public static Attachment get(String idParam) throws Exception {
        Attachment attachment = null;
        long id = Long.parseLong(idParam);

        Session session = getSession();

        attachment = (Attachment) session.getNamedQuery("attachmentById")
                .setLong("id", id).uniqueResult();

        closeSession(session);

        return attachment;
    }
}