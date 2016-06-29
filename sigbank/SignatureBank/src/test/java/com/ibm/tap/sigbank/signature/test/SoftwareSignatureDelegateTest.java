package com.ibm.tap.sigbank.signature.test;

import static org.junit.Assert.*;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.junit.Test;

import com.ibm.tap.sigbank.signature.SoftwareSignature;
import com.ibm.tap.sigbank.signature.SoftwareSignatureDelegate;
import com.ibm.tap.sigbank.signature.SoftwareSignatureH;

public class SoftwareSignatureDelegateTest {
	private final static String SOFTWARE_SIGNATURE_ID = "234425";// bmc.dll
	private final static String SOFTWARE_SIGNATURE_FILE_NAME = "bmc.dll";
	private final static int SOFTWARE_SIGNATURE_FILE_SIZE = 249942;

	@Test
	public void testGetSoftwareSignature() {
		SoftwareSignature softwareSignature = null;
		try {
			softwareSignature = SoftwareSignatureDelegate.getSoftwareSignature(SOFTWARE_SIGNATURE_ID);
		} catch (HibernateException e) {
			System.out.println("HibernateException happened with message: " + e.getMessage());
		} catch (NamingException e) {
			System.out.println("NamingException happened with message: " + e.getMessage());
		}

		assertNotNull(softwareSignature);
		assertNotNull(softwareSignature.getSoftwareSignatureId());
		System.out.println("Software Signature Id: " + softwareSignature.getSoftwareSignatureId());
		assertNotNull(softwareSignature.getFileName());
		System.out.println("Software Signature File Name: " + softwareSignature.getFileName());
		assertNotNull(softwareSignature.getFileSize());
		System.out.println("Software Signature File Size: " + softwareSignature.getFileSize().toString());
	}

	@Test
	@SuppressWarnings("rawtypes")
	public void testGetSoftwareSignatureHistory() {
		List softwareSignatureList = null;
		try {
			softwareSignatureList = SoftwareSignatureDelegate.getSoftwareSignatureHistory(SOFTWARE_SIGNATURE_ID);
		} catch (HibernateException e) {
			System.out.println("HibernateException happened with message: " + e.getMessage());
		} catch (NamingException e) {
			System.out.println("NamingException happened with message: " + e.getMessage());
		}

		assertNotNull(softwareSignatureList);
		assertTrue(softwareSignatureList.size() > 0);
		SoftwareSignatureH softwareSignatureH = (SoftwareSignatureH) softwareSignatureList.get(0);
		assertNotNull(softwareSignatureH.getSoftwareSignatureHId());
		System.out.println("Software Signature History Id : " + softwareSignatureH.getSoftwareSignatureHId().intValue());
		assertNotNull(softwareSignatureH.getSoftwareSignature());
		System.out.println("Software Signature Id : " + softwareSignatureH.getSoftwareSignature().getSoftwareSignatureId().intValue());
		assertNotNull(softwareSignatureH.getFileName());
		System.out.println("Software Signature History File Name : " + softwareSignatureH.getFileName());
		assertNotNull(softwareSignatureH.getFileSize());
		System.out.println("Software Signature History File Size : " + softwareSignatureH.getFileSize());
		assertNotNull(softwareSignatureH.getStatus());
		System.out.println("Software Signature History Status : " + softwareSignatureH.getStatus());
	}

	@Test
	public void testGetSoftwareSignatureByFileNameAndFileSize() {
		SoftwareSignature softwareSignature = null;
		try {
			softwareSignature = SoftwareSignatureDelegate.getSoftwareSignature(SOFTWARE_SIGNATURE_FILE_NAME, SOFTWARE_SIGNATURE_FILE_SIZE);
		} catch (HibernateException e) {
			System.out.println("HibernateException happened with message: " + e.getMessage());
		} catch (NamingException e) {
			System.out.println("NamingException happened with message: " + e.getMessage());
		}

		assertNotNull(softwareSignature);
		assertNotNull(softwareSignature.getSoftwareSignatureId());
		System.out.println("Software Signature Id : " + softwareSignature.getSoftwareSignatureId().intValue());
		assertNotNull(softwareSignature.getFileName());
		System.out.println("Software Signature File Name : " + softwareSignature.getFileName());
		assertNotNull(softwareSignature.getFileSize());
		System.out.println("Software Signature File Size : " + softwareSignature.getFileSize());
	}
}
