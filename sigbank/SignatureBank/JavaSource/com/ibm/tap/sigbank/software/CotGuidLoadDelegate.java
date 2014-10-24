package com.ibm.tap.sigbank.software;

import java.io.BufferedWriter;
import java.lang.reflect.InvocationTargetException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.sigbank.framework.common.Delegate;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.software.ProductDelegate;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class CotGuidLoadDelegate extends Delegate {

	static Logger logger = Logger.getLogger(CotGuidLoadDelegate.class);



	@SuppressWarnings("null")
	public static String massLoadCotGuid(String str, BufferedWriter bw,String remoteUser, int i)
			throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		String patternStr = "	";
		String[] f = str.split(patternStr);

		if (f.length > 1) {
			return "Invalid number of columns on line " + i + "\n";
		}

		Session session = getHibernateSession();

		String guid = f[0].trim();
		

		Product product = null;	
		if( guid!=null || guid != ""){
		product = ProductDelegate.searchProductByGuid(guid, product, session);}
		if (product != null) {
			if (product.getDeleted()) {
				try {
					bw.write(product.getGuid().toString());
					bw.write("\t");
					bw.write(product.getName().toString());
					bw.write("\t");
					bw.write(product.getManufacturer().getManufacturerName().toString());
					bw.write("\t");
					bw.write(product.getProductRole().toString());
					bw.write("\t");
					bw.write("INACTIVE");
					session.close();
				} catch (Exception e) {
				    e.printStackTrace();
				    session.close();
				}	
				return "ERROR [" + i + "]: " + "Software Product is inactive: "
				+ product.getName() + " is inactive\n";
			}
			try {
				bw.write(product.getGuid().toString());
				bw.write("\t");
				bw.write(product.getName().toString());
				bw.write("\t");
				bw.write(product.getManufacturer().getManufacturerName().toString());
				bw.write("\t");
				bw.write(product.getProductRole().toString());
				bw.write("\t");
				bw.write("ACTIVE");
				session.close();
			} catch (Exception e) {
			    e.printStackTrace();
			    session.close();
			}		
		} else {
			session.close();
			return "ERROR [" + i + "]: " + "Software Product Does Not Exist: "
			+ f[0] + " does not exist\n";
		}
		return "Successful update line " + i + " \n";
	}

}