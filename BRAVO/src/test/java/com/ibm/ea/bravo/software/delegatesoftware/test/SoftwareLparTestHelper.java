package com.ibm.ea.bravo.software.delegatesoftware.test;



import java.util.Date;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.SoftwareLpar;


public class SoftwareLparTestHelper {
	
	public static SoftwareLpar createAsActive() {
		SoftwareLpar softwareLpar = new SoftwareLpar();
		softwareLpar.setComputerId("computerId");
		softwareLpar.setStatus("ACTIVE");
		softwareLpar.setRecordTime(new Date());
		softwareLpar.setScantime(new Date());
		softwareLpar.setAcquisitionTime(new Date());
		softwareLpar.setRemoteUser("STAGING");
		softwareLpar.setProcessorCount(1);
		softwareLpar.setName("softwareLparName");
		softwareLpar.setCustomer(CustomerTestHelper.getAnyRecord());
		
		//Transaction(the rollback, mainly) is probably not needed for one save operation
		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
		    tx = session.beginTransaction();
		     
		    session.save(softwareLpar);
		    
		    tx.commit();
		 }
		 catch (Exception e) {
		     if (tx != null) tx.rollback();
		     e.printStackTrace();
		 }
		 finally {
			 session.close();
		 }
		return softwareLpar;
		
	}

	public static void deleteRecord(Long softwareLparId) {
		// TODO Auto-generated method stub
		
	}
}
