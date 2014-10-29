package com.ibm.asset.bravo.dao;

import java.util.List;

import org.hibernate.HibernateException;

import com.ibm.asset.bravo.domain.InstalledProduct;
import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.hardware.HardwareLpar;

public interface AuthorizedInstalledProductDao {
	List<? extends InstalledProduct> getAuthorizedProductByCustomer(
			Account account) throws HibernateException, Exception;
	List<? extends InstalledProduct> getAuthorizedProductByHwLpar(
			HardwareLpar hardwareLpar) throws HibernateException, Exception;
}
