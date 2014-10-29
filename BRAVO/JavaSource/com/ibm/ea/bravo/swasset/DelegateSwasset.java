package com.ibm.ea.bravo.swasset;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.ManualQueue;

public abstract class DelegateSwasset extends HibernateDelegate {

	private static final Logger logger = Logger
			.getLogger(DelegateSwasset.class);

	@SuppressWarnings("unchecked")
    public static List<Swasset> getSwassetData(Account account) {
		logger.debug("DelegateSwasset.getSwassetData(Account) = " + account);
		List<Swasset> list = null;

		try {
			Session session = getSession();

			SQLQuery query = (SQLQuery)session.getNamedQuery("swassetDataByCustomer");			
			query.setResultTransformer( Transformers.aliasToBean(Swasset.class) );
			query.setLong("customerId", account.getCustomer().getCustomerId());
			query.setString("swLparName", "%");

			list = query.list();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
    public static List<Swasset> getSwassetData(Account account, String search) {
		logger.debug("DelegateSwasset.getSwassetData(Account, String) search = " + search);
		List<Swasset> list = null;
		
		if (search == null) {
			search = "";
		}

		try {
			Session session = getSession();

			SQLQuery query = (SQLQuery)session.getNamedQuery("swassetDataByCustomer");			
			query.setResultTransformer( Transformers.aliasToBean(Swasset.class) );
			query.setLong("customerId", account.getCustomer().getCustomerId());
			query.setString("swLparName", search.toUpperCase()+"%");

			list = query.list();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}
	
	public static Integer getSwassetDataSize(Account account) {
		logger.debug("DelegateSwasset.getSwassetDataSize(Account) = " + account);
		Integer numSwassets = null;

		try {
			Session session = getSession();

			numSwassets = (Integer) session.getNamedQuery("swassetDataSizeByCustomer").setLong(
					"customerId", account.getCustomer().getCustomerId()).setString(
							"swLparName", "%").uniqueResult();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return numSwassets;
	}

	public static Integer getSwassetDataSize(Account account, String search) {
		logger.debug("DelegateSwasset.getSwassetDataSize(Account, String) = " + account);
		Integer numSwassets = null;

		try {
			Session session = getSession();

			numSwassets = (Integer) session.getNamedQuery("swassetDataSizeByCustomer").setLong(
					"customerId", account.getCustomer().getCustomerId()).setString(
							"swLparName", search.toUpperCase()+"%").uniqueResult();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return numSwassets;
	}

	public static void saveSwassetQueue(SwassetQueue queue)
	throws Exception {

		logger.debug("DelegateSwasset.saveSwassetQueue");
		
		Session session = getSession();
		Transaction tx = session.beginTransaction();

		try {
			// save or update the swasset queue
			session.saveOrUpdate(queue);
			tx.commit();
		} catch (Exception e) {
			logger.error("Error inserting into swasset_queue table", e);
			tx.rollback();
		}
		finally {
			closeSession(session);
		}
	}
	public static SwassetQueue getSwassetQueue(Long softwareLparId,
			String type) {
		SwassetQueue swassetQueue = null;

		try {
			Session session = getSession();
			swassetQueue =(SwassetQueue)session.createCriteria(SwassetQueue.class).add(Restrictions.eq("softwareLparId",softwareLparId))
			.add(Restrictions.eq("type",type)).uniqueResult();
			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}
		return swassetQueue;

	}

}