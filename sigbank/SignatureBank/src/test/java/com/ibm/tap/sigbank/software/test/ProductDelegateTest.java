package com.ibm.tap.sigbank.software.test;

import static org.junit.Assert.*;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.junit.Test;

import com.ibm.asset.swkbt.domain.Product;
import com.ibm.asset.swkbt.domain.ProductBrief;
import com.ibm.tap.sigbank.framework.common.HibernateUtils;
import com.ibm.tap.sigbank.software.ProductDelegate;

public class ProductDelegateTest {

	private final static String SOFTWARE_GUID = "a5cda1bb38d747a9ce8f153aeb5e3785";
	private final static String SOFTWARE_NAME = "zSecure Command Verifier";

	@Test
	@SuppressWarnings("rawtypes")
	public void testGetProductBriefs() {

		List softwareProductList = null;
		try {
			softwareProductList = ProductDelegate.getProductBriefs();
		} catch (HibernateException e) {
			System.out.println(e.getMessage());
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		assertNotNull(softwareProductList);
		assertTrue(softwareProductList.size() > 0);

		ProductBrief software = (ProductBrief) softwareProductList.get(softwareProductList.size() - 1);
		assertNotNull(software);
		assertNotNull(software.getName());
		System.out.println("The Last Software Name: " + software.getName());
		assertTrue(software.getName().toUpperCase().startsWith("Z"));
	}

	@Test
	public void testGetProductByName() {
		Product software = null;

		try {
			software = ProductDelegate.getProductByName(SOFTWARE_NAME);
		} catch (HibernateException e) {
			System.out.println(e.getMessage());
		} catch (NamingException e) {
			System.out.println(e.getMessage());
		}

		assertNotNull(software);
		assertNotNull(software.getGuid());
		System.out.println("The Software GUID: " + software.getGuid());
		assertNotNull(software.getName());
		System.out.println("The Software Name: " + software.getName());
	}

	@Test
	public void testSearchProductByGuid() {
		Product software = null;
		try {
			software = ProductDelegate.searchProductByGuid(SOFTWARE_GUID, null, HibernateUtils.getSession());
		} catch (HibernateException e) {
			System.out.println(e.getMessage());
		} catch (NamingException e) {
			System.out.println(e.getMessage());
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		assertNotNull(software);
		assertNotNull(software.getGuid());
		System.out.println("The Software GUID: " + software.getGuid());
		assertNotNull(software.getName());
		System.out.println("The Software Name: " + software.getName());
	}

}
