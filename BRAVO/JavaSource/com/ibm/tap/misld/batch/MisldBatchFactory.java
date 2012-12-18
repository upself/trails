/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import com.ibm.batch.IBatch;
import com.ibm.tap.misld.framework.exceptions.EmailDeliveryException;
import com.ibm.tap.misld.framework.fileLoader.MisldFormFile;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author newtont
 * 
 * This object is used as a breeding ground for batch objects.
 */
public abstract class MisldBatchFactory {

	/**
	 * @param remoteUser
	 * @param dir
	 * @param misldFormFile
	 * @return
	 * @throws Exception
	 */
	public static IBatch getPriceListLoaderBatch(String remoteUser, String dir,
			MisldFormFile misldFormFile) throws Exception {

		return new PriceListLoaderBatch(remoteUser, dir, misldFormFile);
	}

	/**
	 * @param remoteUser
	 * @param dir
	 * @param misldFormFile
	 * @return
	 * @throws Exception
	 */
	public static IBatch getMappingLoaderBatch(String remoteUser, String dir,
			MisldFormFile misldFormFile) throws Exception {
		return new MappingLoaderBatch(remoteUser, dir, misldFormFile);
	}

	/**
	 * @param remoteUser
	 * @param customer
	 * @return
	 */
	public static IBatch getMsHardwareBaselineReportBatch(String remoteUser,
			Customer customer) 
		throws EmailDeliveryException {
		
		return new MsHardwareBaselineReportBatch(customer, remoteUser);
	}

	/**
	 * @param remoteUser
	 * @param customer
	 * @return
	 */
	public static IBatch getMsInstalledSoftwareBaselineReportBatch(
			String remoteUser, Customer customer) 
		throws EmailDeliveryException {
		
		return new MsInstalledSoftwareBaselineReportBatch(customer, remoteUser);
	}

	/**
	 * @param remoteUser
	 * @param dir
	 * @param misldFormFile
	 * @param customer
	 * @return
	 * @throws Exception
	 */
	public static IBatch getHardwareLoaderBatch(String remoteUser, String dir,
			MisldFormFile misldFormFile, Customer customer) throws Exception {
		// TODO Auto-generated method stub
		return new MsHardwareBaselineLoaderBatch(remoteUser, dir,
				misldFormFile, customer);
	}

	/**
	 * @param remoteUser
	 * @param dir
	 * @param misldFormFile
	 * @param customer
	 * @return
	 * @throws Exception
	 */
	public static IBatch getSoftwareLoaderBatch(String remoteUser, String dir,
			MisldFormFile misldFormFile, Customer customer) throws Exception {
		// TODO Auto-generated method stub
		return new MsInstalledSoftwareBaselineLoaderBatch(remoteUser, dir,
				misldFormFile, customer);
	}

	/**
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getEsplaPoReportBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new EsplaPoReportBatch(remoteUser);
	}

	/**
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getSplaPoReportBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new SplaPoReportBatch(remoteUser);
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getSPLAAccountReportBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new SPLAAccountReportBatch(remoteUser);
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getPriceReportApprovalStatusBatch(String remoteUser) 
		throws EmailDeliveryException {
		return new PriceReportApprovalStatusBatch(remoteUser);
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getPriceReportBatch(Customer customer,
			String remoteUser) 
		throws EmailDeliveryException {
		
		return new PriceReportBatch(customer, remoteUser);
	}

	/**
	 * @param podName
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getPodHardwareBaselineBatch(String podName,
			String remoteUser) 
		throws EmailDeliveryException {
		
		return new PodHardwareBaselineReportBatch(podName, remoteUser);
	}

	/**
	 * @param podName
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getPodInstalledSoftwareBaselineBatch(String podName,
			String remoteUser) 
		throws EmailDeliveryException {
		
		return new PodInstalledSoftwareBaselineReportBatch(podName, remoteUser);
	}

	/**
	 * @param remoteUser
	 * @param usageDate
	 * @return
	 */
	public static IBatch getSplaMoetReportBatch(String remoteUser,
			String usageDate) 
		throws EmailDeliveryException {
		
		return new SplaMoetReportBatch(remoteUser, usageDate);
	}

	/**
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getDuplicateHostnameReportBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new DuplicateHostnameReportBatch(remoteUser);
	}

	/**
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getDuplicatePrefixReportBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new DuplicatePrefixReportBatch(remoteUser);
	}

	/**
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getMassPriceReportArchiveBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new MassPriceReportArchiveBatch(remoteUser);
	}

	/**
	 * @param remoteUser
	 * @param customerMisld
	 * @return
	 */
	public static IBatch getMassNotificationBatch(String remoteUser,
			Customer customerMisld) 
		throws EmailDeliveryException {
		
		return new MassNotificationBatch(customerMisld, remoteUser);
	}

	/**
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getMissingScanReportBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new MissingScanReportBatch(remoteUser);
	}

	/**
	 * @param remoteUser
	 * @return
	 */
	public static IBatch getUnlockedReportBatch(String remoteUser) 
		throws EmailDeliveryException {
		
		return new UnlockedReportBatch(remoteUser);
	}

}