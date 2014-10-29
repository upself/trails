/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.purchaseOrderReport;

import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.purchaseOrderReport.PurchaseOrderReport;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PurchaseOrderReportReadDelegate extends Delegate {

	/**
	 * @param remoteUser
	 * @return
	 * @throws HibernateException
	 * @throws NamingException
	 */
	public static List getPoReport(String licenseAgreementTypeName,
			String remoteUser) throws HibernateException, NamingException {

		List poReport = null;

		Session session = getHibernateSession();

		poReport = session.getNamedQuery("getPurchaseOrderReport").setString(
				"licenseAgreementTypeName", licenseAgreementTypeName).list();

		Vector poReportVector = new Vector();

		if (poReport != null) {
			Iterator j = poReport.iterator();

			while (j.hasNext()) {
				PurchaseOrderReport purchaseOrderReport = (PurchaseOrderReport) j
						.next();

				Vector tempList = new Vector();
				tempList.add(purchaseOrderReport.getCustomer().getPod()
						.getPodName());
				tempList.add(purchaseOrderReport.getCustomer().getIndustry()
						.getIndustryName());
				tempList.add(purchaseOrderReport.getCustomer().getIndustry()
						.getSector().getSectorName());
				tempList.add(purchaseOrderReport.getCustomer()
						.getCustomerType().getCustomerTypeName());
				tempList.add(purchaseOrderReport.getCustomer()
						.getMisldAccountSettings().getLicenseAgreementType()
						.getLicenseAgreementTypeName());
				tempList
						.add(new String(""
								+ purchaseOrderReport.getCustomer()
										.getAccountNumber()));
				tempList.add(purchaseOrderReport.getCustomer()
						.getCustomerName());

				tempList.add(new String(""
						+ purchaseOrderReport.getTotalPrice()));

				List poList = null;

				poList = session.getNamedQuery("getCustomerPoNumbers")
						.setEntity("customer",
								purchaseOrderReport.getCustomer()).list();

				Iterator k = poList.iterator();

				while (k.hasNext()) {
					tempList.add((String) k.next());
				}

				poReportVector.add(tempList);
			}
		}

		session.close();
		return poReportVector;
	}
}