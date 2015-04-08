/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.report;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.apache.struts.util.LabelValueBean;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.jfree.data.category.DefaultCategoryDataset;

import com.ibm.ea.cndb.Contact;
import com.ibm.ea.cndb.Lpid;
import com.ibm.ea.sigbank.InstalledSoftware;
import com.ibm.tap.delegate.acl.BluegroupsDelegate;
import com.ibm.tap.misld.batch.Moet;
import com.ibm.tap.misld.delegate.baseline.MsInstalledSoftwareBaselineReadDelegate;
import com.ibm.tap.misld.delegate.cndb.CustomerReadDelegate;
import com.ibm.tap.misld.delegate.cndb.LpidReadDelegate;
import com.ibm.tap.misld.delegate.consent.ConsentLetterReadDelegate;
import com.ibm.tap.misld.delegate.consent.ConsentTypeReadDelegate;
import com.ibm.tap.misld.delegate.holiday.HolidayReadDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftPriceListReadDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftProductMapReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.email.EmailDelegate;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.consent.ConsentLetter;
import com.ibm.tap.misld.om.consent.ConsentType;
import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftPriceList;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProduct;
import com.ibm.tap.misld.om.notification.Notification;
import com.ibm.tap.misld.om.priceReportCycle.PriceReportArchive;
import com.ibm.tap.misld.om.priceReportCycle.PriceReportCycle;

/**
 * @author alexmois
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class PriceReportDelegate extends Delegate {

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	private static final Logger logger = Logger
			.getLogger(PriceReportDelegate.class);

	public static PriceReport getPriceReport(Customer customer)
			throws HibernateException, NamingException {

		/*
		 * When we get to this we should only be accessing customers that have a
		 * license agreement(SPLA/ESPLA), are in scope, and account settings are
		 * complete
		 */

		// Initialize variables
		PriceReport priceReport = new PriceReport();
		PriceReportSummary priceReportSummary = null;

		HashMap summaryHashMap = new HashMap();

		priceReport.setAccountNumber(customer.getAccountNumber());
		priceReport.setCustomerAgreementType(customer.getMisldAccountSettings()
				.getLicenseAgreementType().getLicenseAgreementTypeName());
		priceReport.setCustomerName(customer.getCustomerName());
		priceReport.setCustomerType(customer.getCustomerType()
				.getCustomerTypeName());
		priceReport.setIndustry(customer.getIndustry().getIndustryName());
		priceReport.setPod(customer.getPod().getPodName());
		priceReport.setSector(customer.getIndustry().getSector()
				.getSectorName());
		priceReport.setPodId("" + customer.getPod().getPodId());
		if (customer.getMisldAccountSettings().getDefaultLpid() != null) {
			priceReport.setLpid(customer.getMisldAccountSettings()
					.getDefaultLpid().getLpidId().toString());
		}

		// To date all spla prices are corporate so we will set it here
		priceReport.setQualifiedDiscount("CORPORATE");
		priceReport.setPriceLevel("");

		// Set up the price level if customer is espla
		if (priceReport.getCustomerAgreementType().equals(Constants.ESPLA)) {
			priceReport.setQualifiedDiscount("NONE");
			ConsentType consentType = ConsentTypeReadDelegate
					.getConsentTypeByName(Constants.ESPLA_ENROLLMENT_FORM);

			ConsentLetter consentLetter = ConsentLetterReadDelegate
					.getConsentLetter(consentType, customer);

			if (Util.isBlankString(consentLetter.getPriceLevel()
					.getPriceLevel())) {
				priceReport.setPriceLevel("A");
				priceReport.setPriceLevelFlag(true);
			} else {
				priceReport.setPriceLevel(consentLetter.getPriceLevel()
						.getPriceLevel());
			}
		}

		// Now we need to get the active hardware/software
		List softwareList = MsInstalledSoftwareBaselineReadDelegate
				.getActiveMsInstalledSoftwareBaseline(customer);

		String countryCode = customer.getCountryCode().getCode();

		// Lets put the microsoftproduct map into a hash
		HashMap microsoftProductMapHash = MicrosoftProductMapReadDelegate
				.getMicrosoftProductMapHash();

		Iterator i = softwareList.iterator();

		while (i.hasNext()) {
			InstalledSoftware software = (InstalledSoftware) i.next();

			if (!software.getSoftware().getSoftwareCategory()
					.getSoftwareCategoryName().equals("UNKNOWN")) {
				List softwareVersions = MsInstalledSoftwareBaselineReadDelegate
						.getHigherSoftwareVersion(customer, software
								.getSoftwareLpar(), software.getSoftware()
								.getSoftwareCategory(), software.getSoftware()
								.getPriority());

				// if there is a higher version of the software, exclude this
				// version
				if (softwareVersions.size() > 0) {
					continue;
				}
			}

			PriceReportDetail priceReportDetail = new PriceReportDetail();

			// Setup initial price report detail
			priceReportDetail.setCountry(countryCode);
			priceReportDetail.setNodeName(software.getSoftwareLpar().getName());
			priceReportDetail.setSerialNumber(software.getSoftwareLpar()
					.getBiosSerial());
			priceReportDetail.setMachineType("");
			// software.getSoftwareLpar()..getMachineType());
			priceReportDetail.setMachineModel(software.getSoftwareLpar()
					.getModel());
			priceReportDetail.setScanDate(software.getSoftwareLpar()
					.getScantime());

			// if (Util.isBlankString(software.getMsHardwareBaseline()
			// .getNodeOwner())) {
			// priceReportDetail.setNodeOwner(Constants.IBM);
			// priceReportDetail.setNodeOwnerFlag("*");
			// priceReport.setOverallNodeOwnerFlag(true);
			// } else {
			// priceReportDetail.setNodeOwner(software.getMsHardwareBaseline()
			// .getNodeOwner());
			// }

			// If customer is owner or buyer, we don't want to calculate this
			// product
			// If owner or buyer is blank, assume IBM
			if (software.getInstalledSoftwareEff() != null
					&& software.getInstalledSoftwareEff().getOwner() != null
					&& !Util.isBlankString(software.getInstalledSoftwareEff()
							.getOwner())) {

				priceReportDetail.setSoftwareOwner(software
						.getInstalledSoftwareEff().getOwner());

			} else {
				if (Util.isBlankString(software.getSoftwareOwner())) {

					priceReportDetail.setSoftwareOwner(Constants.IBM);
					priceReportDetail.setSoftwareOwnerFlag("*");
					priceReport.setOverallIbmOwnFlag(true);

				} else {
					logger.debug("it should never come here");
					priceReportDetail.setSoftwareOwner(software
							.getSoftwareOwner());
				}
			}

			// if (Util.isBlankString(software.getSoftwareBuyer())) {
			// priceReportDetail.setSoftwareBuyer(Constants.IBM);
			// } else {
			// priceReportDetail.setSoftwareBuyer(software.getSoftwareBuyer());
			// }

			if (priceReportDetail.getSoftwareOwner().equals("CUSTOMER")) {
				continue;
			}

			if (priceReportDetail.getSoftwareOwner().equals("INTERNAL USE")) {
				continue;
			}

			String auth = null;
			// If an operating system we need to make an authentication
			// assumption
			if (software.getSoftware().getSoftwareCategory()
					.getSoftwareCategoryName().contains(
							Constants.OPERATING_SYSTEMS)) {

				if (software.getInstalledSoftwareEff() == null
						|| software.getInstalledSoftwareEff()
								.getAuthenticated() == null) {
					auth = software.getAuthenticated().toString();
				} else {
					auth = software.getInstalledSoftwareEff()
							.getAuthenticated().toString();
				}

				if (Util.isBlankString(auth) || auth.equals("2")) {
					auth = "Y";
					priceReportDetail.setAuthenticatedFlag("*");
					priceReport.setOverallOsAuthFlag(true);
				} else {
					if (auth.equals("1")) {
						auth = "Y";
					} else {
						auth = "N";
					}
				}

			}
			priceReportDetail.setAuthenticated(auth);

			// If no operating system, let the user know this is basically an
			// assumption
			if (software.getSoftware().getSoftwareName().equalsIgnoreCase(
					"NO OPERATING SYSTEM")) {
				priceReportDetail.setNoOsFlag("*");
				priceReport.setOverallSoftwareFlag(true);
			}

			// If processor count is 0 or null set it up as assumption else set
			// the multiplier
			if ((software.getSoftwareLpar() == null || (software
					.getSoftwareLpar().getProcessorCount() == null || software
					.getSoftwareLpar().getProcessorCount().intValue() < 1))
					&& (software.getSoftwareLpar().getSoftwareLparEff() == null
							||software.getSoftwareLpar().getSoftwareLparEff().getStatus().equals("INACTIVE") 
							|| software.getSoftwareLpar().getSoftwareLparEff()
									.getProcessorCount() == null || software
							.getSoftwareLpar().getSoftwareLparEff()
							.getProcessorCount().intValue() < 1)) {

				priceReportDetail.setProcessorCount(2);
				priceReportDetail.setProcessorFlag("*");
				priceReport.setOverallProcessorFlag(true);

			} else {
				if (software.getSoftwareLpar() == null
						|| software.getSoftwareLpar().getSoftwareLparEff() == null
						|| software.getSoftwareLpar().getSoftwareLparEff().getStatus().equals("INACTIVE")
						|| software.getSoftwareLpar().getSoftwareLparEff()
								.getProcessorCount() == null
						|| software.getSoftwareLpar().getSoftwareLparEff()
								.getProcessorCount().intValue() < 1) {

					priceReportDetail.setProcessorCount(software
							.getSoftwareLpar().getProcessorCount().intValue());

				} else {
					priceReportDetail.setProcessorCount(software
							.getSoftwareLpar().getSoftwareLparEff()
							.getProcessorCount().intValue());
				}
			}

			// If user count is 0 or null set it up as assumption else set the
			// multiplier
			if ((software.getInstalledSoftwareEff() == null || ((software
					.getInstalledSoftwareEff() != null) && (software
					.getInstalledSoftwareEff().getUserCount() == null || software
					.getInstalledSoftwareEff().getUserCount().intValue() < 1)))) {

				priceReportDetail.setUserCount(1000);
				priceReportDetail.setUserFlag("*");
				priceReport.setOverallUserFlag(true);

			} else {
				// otherwise, use InstalledSoftwareEff value
				priceReportDetail.setUserCount(software
						.getInstalledSoftwareEff().getUserCount().intValue());
			}

			// Grab the microsoft product map for this software
			MicrosoftProduct microsoftProduct = (MicrosoftProduct) microsoftProductMapHash
					.get(software.getSoftware().getSoftwareId());

			// If there is no product then we dismiss per requirements
			if (microsoftProduct == null) {
				continue;
			}

			// Get the list of price list objects that this pertains
			List priceList = MicrosoftPriceListReadDelegate
					.getMicrosoftPriceListByProduct(microsoftProduct);

			// If no associated priceList, then we create error report
			if (priceList.isEmpty()) {
				priceReport.addToDetails(priceReportDetail);
				continue;
			}

			MicrosoftPriceList userBased = null;
			MicrosoftPriceList processorBased = null;
			MicrosoftPriceList finalPriceList = null;

			userBased = getLicense(Constants.USER_LICENSE_TYPE, priceList,
					priceReport.getCustomerAgreementType(), priceReportDetail
							.getAuthenticated(), priceReport.getPriceLevel(),
					priceReport.getQualifiedDiscount());

			processorBased = getLicense(Constants.PROCESSOR_BASED_LICENSE,
					priceList, priceReport.getCustomerAgreementType(),
					priceReportDetail.getAuthenticated(), priceReport
							.getPriceLevel(), priceReport
							.getQualifiedDiscount());

			// if both licenses are null then lets switch up the agreement type
			if (userBased == null && processorBased == null) {
				if (customer.getMisldAccountSettings()
						.getLicenseAgreementType().equals(Constants.SPLA)) {
					userBased = getLicense(Constants.USER_LICENSE_TYPE,
							priceList, Constants.ESPLA, priceReportDetail
									.getAuthenticated(), "A", "NONE");

					processorBased = getLicense(
							Constants.PROCESSOR_BASED_LICENSE, priceList,
							Constants.ESPLA, priceReportDetail
									.getAuthenticated(), "A", "NONE");
				} else {

					userBased = getLicense(Constants.USER_LICENSE_TYPE,
							priceList, Constants.SPLA, priceReportDetail
									.getAuthenticated(), "", "CORPORATE");

					processorBased = getLicense(
							Constants.PROCESSOR_BASED_LICENSE, priceList,
							Constants.SPLA, priceReportDetail
									.getAuthenticated(), "", "CORPORATE");
				}
				priceReportDetail.setLicenseAgreementTypeFlag("*");
				priceReport.setOverallAgreementFlag(true);
			}

			if (userBased == null && processorBased == null) {
				priceReportDetail = generateErrorReportRow(priceReportDetail);
				priceReport.addToDetails(priceReportDetail);
				continue;
			} else if (userBased == null && processorBased != null) {
				finalPriceList = processorBased;
			} else if (processorBased == null & userBased != null) {
				finalPriceList = userBased;
			} else {
				if (new BigDecimal(processorBased.getUnitPrice().floatValue())
						.multiply(
								new BigDecimal(priceReportDetail
										.getProcessorCount())).compareTo(
								new BigDecimal(userBased.getUnitPrice()
										.floatValue()).multiply(new BigDecimal(
										priceReportDetail.getUserCount()))) <= 0) {
					finalPriceList = processorBased;
				} else {
					finalPriceList = userBased;
				}
			}

			if (finalPriceList != null) {
				if (finalPriceList.getLicenseAgreementType()
						.getLicenseAgreementTypeName().equals(Constants.SPLA)) {
					if (finalPriceList.getLicenseType().getLicenseTypeName()
							.equals(Constants.USER_LICENSE_TYPE)) {
						priceReportDetail
								.setSplaQuarterlyPrice(new BigDecimal(
										finalPriceList.getUnitPrice()
												.floatValue()).multiply(
										new BigDecimal(priceReportDetail
												.getUserCount()))
										.multiply(
												new BigDecimal(finalPriceList
														.getUnit())));

					} else {
						priceReportDetail
								.setSplaQuarterlyPrice(new BigDecimal(
										finalPriceList.getUnitPrice()
												.floatValue()).multiply(
										new BigDecimal(priceReportDetail
												.getProcessorCount()))
										.multiply(
												new BigDecimal(finalPriceList
														.getUnit())));
					}
					priceReport.addToTotalSplaPrice(priceReportDetail
							.getSplaQuarterlyPrice());
				} else if (finalPriceList.getLicenseAgreementType()
						.getLicenseAgreementTypeName().equals(Constants.ESPLA)) {
					if (finalPriceList.getLicenseType().getLicenseTypeName()
							.equals(Constants.USER_LICENSE_TYPE)) {
						priceReportDetail.setEsplaYearlyPrice(new BigDecimal(
								finalPriceList.getUnitPrice().floatValue())
								.multiply(new BigDecimal(priceReportDetail
										.getUserCount())));
					} else {
						priceReportDetail.setEsplaYearlyPrice(new BigDecimal(
								finalPriceList.getUnitPrice().floatValue())
								.multiply(new BigDecimal(priceReportDetail
										.getProcessorCount())));
					}

					priceReport.addToTotalEsplaPrice(priceReportDetail
							.getEsplaYearlyPrice());
				}

				priceReportDetail.setSku(finalPriceList.getSku());
				priceReportDetail.setLicenseType(finalPriceList
						.getLicenseType().getLicenseTypeName());
				priceReportDetail.setProductDescription(finalPriceList
						.getMicrosoftProduct().getProductDescription());
				priceReportDetail.setLicenseAgreementType(finalPriceList
						.getLicenseAgreementType()
						.getLicenseAgreementTypeName());

				priceReport.addToDetails(priceReportDetail);

				if (summaryHashMap.get(priceReportDetail.getSku()) == null) {
					priceReportSummary = new PriceReportSummary();
				} else {
					priceReportSummary = (PriceReportSummary) summaryHashMap
							.get(priceReportDetail.getSku());
				}

				priceReportSummary.setSku(priceReportDetail.getSku());
				priceReportSummary.setSoftwareName(priceReportDetail
						.getProductDescription());
				priceReportSummary.addToProcessorCount(priceReportDetail
						.getProcessorCount());
				priceReportSummary.addToUserCount(priceReportDetail
						.getUserCount());
				priceReportSummary.addToServerCount(1);

				if (priceReportDetail.getLicenseType().equals(
						Constants.USER_LICENSE_TYPE)) {
					priceReportSummary.addToLicenseTotal(priceReportDetail
							.getUserCount());
				} else {
					priceReportSummary.addToLicenseTotal(priceReportDetail
							.getProcessorCount());
				}

				if (priceReportDetail.getLicenseAgreementType().equals("SPLA")) {
					priceReportSummary.addToTotalSplaPrice(priceReportDetail
							.getSplaQuarterlyPrice());
				} else {
					priceReportSummary.addToTotalEsplaPrice(priceReportDetail
							.getEsplaYearlyPrice());
				}

				summaryHashMap.put(priceReportDetail.getSku(),
						priceReportSummary);
			} else {
				priceReportDetail = generateErrorReportRow(priceReportDetail);

				priceReport.addToDetails(priceReportDetail);

				if (summaryHashMap.get("ERROR") == null) {
					priceReportSummary = new PriceReportSummary();
				} else {
					priceReportSummary = (PriceReportSummary) summaryHashMap
							.get("ERROR");
				}

				priceReportSummary.setSku("ERROR");
				priceReportSummary.setSoftwareName("ERROR");
				priceReportSummary.addToProcessorCount(priceReportDetail
						.getProcessorCount());
				priceReportSummary.addToUserCount(priceReportDetail
						.getUserCount());
				priceReportSummary.addToServerCount(1);

				summaryHashMap.put(priceReportDetail.getSku(),
						priceReportSummary);

			}

		}

		priceReport.setSummary(summaryHashMap);
		List customerNumbers = LpidReadDelegate.getCustomerLpids(customer);
		ArrayList lpids = new ArrayList();

		Iterator j = customerNumbers.iterator();

		while (j.hasNext()) {
			Lpid lpid = (Lpid) j.next();

			lpids.add(new LabelValueBean(lpid.getLpidName() + " - "
					+ lpid.getMajor().getMajorName(), "" + lpid.getLpidId()));

		}

		priceReport.setLpids(lpids);

		return priceReport;
	}

	/**
	 * @param user_license_type
	 * @param priceList
	 * @param agreementName
	 * @param authenticated
	 * @param priceLevel
	 * @param qualifiedDiscount
	 * @return
	 */
	private static MicrosoftPriceList getLicense(String licenseType,
			List priceList, String agreementName, String authenticated,
			String priceLevel, String qualifiedDiscount) {

		Iterator j = priceList.iterator();

		while (j.hasNext()) {
			MicrosoftPriceList mpl = (MicrosoftPriceList) j.next();

			if (mpl.getLicenseAgreementType().getLicenseAgreementTypeName()
					.equals(agreementName)
					&& mpl.getLicenseType().getLicenseTypeName().equals(
							licenseType)) {
				if (Util.isBlankString(authenticated)) {
					if (mpl.getQualifiedDiscount().getQualifiedDiscount()
							.equals(qualifiedDiscount)
							&& mpl.getPriceLevel().getPriceLevel().equals(
									priceLevel)) {
						return mpl;
					}
				} else if (mpl.getAuthenticated() != null) {
					if (mpl.getAuthenticated().equals(authenticated)) {
						if (mpl.getQualifiedDiscount().getQualifiedDiscount()
								.equals(qualifiedDiscount)
								&& mpl.getPriceLevel().getPriceLevel().equals(
										priceLevel)) {
							return mpl;
						}
					}
				}
			}
		}

		return null;
	}

	/**
	 * @param reportRow
	 * @param software
	 * @param softwareOwner
	 * @param processorCount
	 * @param userCount
	 * @param userCount
	 * @param authenticated
	 * @param authenticated
	 * @return
	 */
	private static PriceReportDetail generateErrorReportRow(
			PriceReportDetail priceReportDetail) {

		priceReportDetail.setSku("ERROR");
		priceReportDetail.setLicenseType("ERROR");
		priceReportDetail.setProductDescription("ERROR");
		priceReportDetail.setLicenseAgreementType("ERROR");
		priceReportDetail.setSplaQuarterlyPrice(new BigDecimal(0));
		priceReportDetail.setEsplaYearlyPrice(new BigDecimal(0));

		return priceReportDetail;
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getSPLAAccountReport(String remoteUser)
			throws HibernateException, NamingException {

		List priceReports = null;

		Session session = getHibernateSession();

		priceReports = session.getNamedQuery("getActiveSPLA").list();

		session.close();

		return priceReports;
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getEmailSPLAAccountReport(String remoteUser)
			throws HibernateException, NamingException {

		List priceReports = null;
		PriceReportArchive priceReportArchive = new PriceReportArchive();

		Session session = getHibernateSession();

		priceReports = session.getNamedQuery("getActiveSPLA").list();

		session.close();

		ListIterator priceReportIterator = priceReports.listIterator();
		Vector reportVector = new Vector();

		while (priceReportIterator.hasNext()) {
			priceReportArchive = (PriceReportArchive) priceReportIterator
					.next();

			Vector rowVector = new Vector();

			rowVector.add(priceReportArchive.getPod());
			rowVector.add(priceReportArchive.getAccountNumber().toString());
			rowVector.add(priceReportArchive.getCustomerName());
			rowVector.add(priceReportArchive.getCustomerType());
			rowVector.add(priceReportArchive.getNodeName());
			rowVector.add(priceReportArchive.getProductDescription());

			reportVector.add(rowVector);

		}

		return reportVector;
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getEmailPriceReportApprovalStatus(String remoteUser)
			throws HibernateException, NamingException {

		List customers = null;
		Customer customer = new Customer();
		MisldAccountSettings misldAccountSettings = new MisldAccountSettings();

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getApprovedPriceReports").list();

		session.close();

		ListIterator customerIterator = customers.listIterator();
		Vector reportVector = new Vector();

		while (customerIterator.hasNext()) {
			customer = (Customer) customerIterator.next();
			misldAccountSettings = customer.getMisldAccountSettings();

			Vector rowVector = new Vector();

			rowVector.add(customer.getPod().getPodName());
			rowVector.add(customer.getCustomerName());
			rowVector.add(customer.getAccountNumber().toString());
			rowVector.add(customer.getContactDPE().getFullName());
			rowVector.add(misldAccountSettings.getPriceReportTimestamp()
					.toString());
			rowVector.add(misldAccountSettings.getPriceReportStatusUser());

			reportVector.add(rowVector);

		}

		return reportVector;
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getEmailPriceReport(Customer customer, String remoteUser)
			throws HibernateException, NamingException {

		PriceReport priceReport = new PriceReport();
		if (customer.getMisldAccountSettings().getStatus().equals(
				Constants.LOCKED)) {
			PriceReportCycle priceReportCycle = getActivePriceReportCycle(customer);
			if (priceReportCycle != null) {
				priceReport = getLockedPriceReportArchive(priceReportCycle,
						customer);
			} else {
				priceReport = getPriceReport(customer);
			}
		} else {
			priceReport = getPriceReport(customer);
		}
		Vector priceReportApprovalStatusVector = new Vector();

		Vector headVector = new Vector();

		headVector.add("Asset Admin Dept.");
		headVector.add(customer.getPod().getPodName());
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Customer Type");
		headVector.add(customer.getCustomerType().getCustomerTypeName());
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Customer Name");
		headVector.add(customer.getCustomerName());
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Customer License Agreement");
		headVector.add(priceReport.getCustomerAgreementType());
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();
		if (priceReport.getCustomerAgreementType().equals(Constants.ESPLA)) {
			headVector.add("Price Level");
			headVector.add(priceReport.getPriceLevel());
			priceReportApprovalStatusVector.add(headVector);
		} else {
			headVector.add("Qualified Discount");
			headVector.add(priceReport.getQualifiedDiscount());
			priceReportApprovalStatusVector.add(headVector);
		}

		headVector = new Vector();
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Product Summary");
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Sku");
		headVector.add("Software name");
		headVector.add("Server count");
		headVector.add("Processor count");
		headVector.add("User count");
		headVector.add("Total licenses");
		headVector.add("SPLA quarterly cost");
		headVector.add("ESPLA yearly cost");
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		HashMap summaryMap = priceReport.getSummary();

		for (Iterator it = summaryMap.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			String key = (String) entry.getKey();
			PriceReportSummary value = (PriceReportSummary) entry.getValue();

			Vector temp = new Vector();

			temp.add(key);
			temp.add(value.getSoftwareName());
			temp.add(new String("" + value.getServerCount()));
			temp.add(new String("" + value.getProcessorCount()));
			temp.add(new String("" + value.getUserCount()));
			temp.add(new String("" + value.getLicenseTotal()));
			temp.add(new String("" + value.getTotalSplaPrice()));
			temp.add(new String("" + value.getTotalEsplaPrice()));

			priceReportApprovalStatusVector.add(temp);

		}

		headVector.add("");
		headVector.add("");
		headVector.add("");
		headVector.add("");
		headVector.add("");
		headVector.add("");
		headVector.add(new String("" + priceReport.getTotalSplaPrice()));
		headVector.add(new String("" + priceReport.getTotalEsplaPrice()));

		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Assumptions");
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		if (priceReport.isOverallOsAuthFlag()) {
			headVector.add(priceReport.getOsAuthAssumption());
			priceReportApprovalStatusVector.add(headVector);
			headVector = new Vector();
		}
		if (priceReport.isOverallIbmOwnFlag()) {
			headVector.add(priceReport.getIbmOwnAssumption());
			priceReportApprovalStatusVector.add(headVector);
			headVector = new Vector();
		}
		if (priceReport.isOverallSoftwareFlag()) {
			headVector.add(priceReport.getSoftwareNameAssumption());
			priceReportApprovalStatusVector.add(headVector);
			headVector = new Vector();
		}
		if (priceReport.isOverallProcessorFlag()) {
			headVector.add(priceReport.getProcessorAssumption());
			priceReportApprovalStatusVector.add(headVector);
			headVector = new Vector();
		}
		if (priceReport.isOverallOsAuthFlag()) {
			headVector.add(priceReport.getOsAuthAssumption());
			priceReportApprovalStatusVector.add(headVector);
			headVector = new Vector();
		}
		if (priceReport.isOverallUserFlag()) {
			headVector.add(priceReport.getUserAssumption());
			priceReportApprovalStatusVector.add(headVector);
			headVector = new Vector();
		}
		if (priceReport.isPriceLevelFlag()) {
			headVector.add(priceReport.getPriceLevelAssumption());
			priceReportApprovalStatusVector.add(headVector);
			headVector = new Vector();
		}

		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Detailed Report");
		priceReportApprovalStatusVector.add(headVector);

		headVector = new Vector();

		headVector.add("Country");
		headVector.add("Server Name");
		headVector.add("Serial Number");
		headVector.add("Machine Type");
		headVector.add("MachineModel");
		headVector.add("Scan Date");
		headVector.add("Node Owner");
		headVector.add("Software Owner");
		headVector.add("Processor Count");
		headVector.add("User Count");
		headVector.add("Authenticated");
		headVector.add("SKU");
		headVector.add("License Type");
		headVector.add("Microsoft Product");
		headVector.add("License Agreement");
		headVector.add("SPLA Quarterly Price");
		headVector.add("ESPLA Yearly Price");

		priceReportApprovalStatusVector.add(headVector);

		Iterator i = priceReport.getDetails().iterator();
		while (i.hasNext()) {
			PriceReportDetail priceReportDetail = (PriceReportDetail) i.next();

			Vector temp = new Vector();

			temp.add(priceReportDetail.getCountry());
			temp.add(priceReportDetail.getNodeName());
			temp.add(priceReportDetail.getSerialNumber());
			temp.add(priceReportDetail.getMachineType());
			temp.add(priceReportDetail.getMachineModel());
			temp.add("" + priceReportDetail.getScanDate());
			temp.add(priceReportDetail.getNodeOwner());
			temp.add(priceReportDetail.getSoftwareOwnerFlag()
					+ priceReportDetail.getSoftwareOwner());
			temp.add(priceReportDetail.getProcessorFlag()
					+ priceReportDetail.getProcessorCount());
			temp.add(priceReportDetail.getUserFlag()
					+ priceReportDetail.getUserCount());
			temp.add(priceReportDetail.getAuthenticatedFlag()
					+ priceReportDetail.getAuthenticated());
			temp.add(priceReportDetail.getSku());
			temp.add(priceReportDetail.getLicenseType());
			temp.add(priceReportDetail.getNoOsFlag()
					+ priceReportDetail.getProductDescription());
			temp.add(priceReportDetail.getLicenseAgreementTypeFlag()
					+ priceReportDetail.getLicenseAgreementType());
			temp.add("" + priceReportDetail.getSplaQuarterlyPrice());
			temp.add("" + priceReportDetail.getEsplaYearlyPrice());

			priceReportApprovalStatusVector.add(temp);
		}

		return priceReportApprovalStatusVector;
	}

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static PriceReportCycle getActivePriceReportCycle(Customer customer)
			throws HibernateException, NamingException {

		PriceReportCycle priceReportCycle = null;

		Session session = getHibernateSession();

		priceReportCycle = (PriceReportCycle) session.getNamedQuery(
				"getActivePriceReportCycle").setEntity("customer", customer)
				.uniqueResult();

		session.close();

		return priceReportCycle;
	}

	public static void lockAccount(PriceReport priceReport, String remoteUser,
			UserContainer user) throws HibernateException, NamingException,
			InvalidAccessException, Exception {

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		} else {
			Customer customer = CustomerReadDelegate
					.getCustomerByAccountNumber(priceReport.getAccountNumber()
							.longValue());

			MisldAccountSettings misldAccountSettings = customer
					.getMisldAccountSettings();

			Session session = getHibernateSession();
			Transaction tx = session.beginTransaction();

			misldAccountSettings.setStatus(Constants.LOCKED);

			session.update(misldAccountSettings);
			tx.commit();
			session.close();

			createPriceReportArchive(customer, priceReport, Constants.LOCKED,
					remoteUser);
		}
	}

	public static void updatePriceReportStatus(PriceReport priceReport,
			String priceReportStatus, String remoteUser)
			throws HibernateException, NamingException {

		Customer customer = CustomerReadDelegate
				.getCustomerByAccountNumber(priceReport.getAccountNumber()
						.longValue());

		MisldAccountSettings misldAccountSettings = customer
				.getMisldAccountSettings();

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		misldAccountSettings.setPriceReportStatus(priceReportStatus);
		misldAccountSettings.setPriceReportStatusUser(remoteUser);
		misldAccountSettings.setPriceReportTimestamp(new Date());

		// If the Price Report is rejected, set the notification status to
		// Inactive
		// so that the account is not escalated
		if (priceReportStatus == Constants.REJECTED) {
			Notification notification = NotificationDelegate.getNotification(
					customer, Constants.PRICE_REPORT);
			if (notification != null) {
				notification.setStatus(Constants.INACTIVE);
				session.update(notification);
			}
		}

		session.update(misldAccountSettings);

		tx.commit();
		session.close();
	}

	public static void updatePriceReportStatus(Customer customer,
			String priceReportStatus, String remoteUser)
			throws HibernateException, NamingException {

		MisldAccountSettings misldAccountSettings = customer
				.getMisldAccountSettings();

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		misldAccountSettings.setPriceReportStatus(priceReportStatus);
		misldAccountSettings.setPriceReportStatusUser(remoteUser);
		misldAccountSettings.setPriceReportTimestamp(new Date());

		// If the Price Report is rejected, set the notification status to
		// Inactive
		// so that the account is not escalated
		if (priceReportStatus == Constants.REJECTED) {
			Notification notification = NotificationDelegate.getNotification(
					customer, Constants.PRICE_REPORT);
			if (notification != null) {
				notification.setStatus(Constants.INACTIVE);
				session.update(notification);
			}
		}

		session.update(misldAccountSettings);

		tx.commit();
		session.close();
	}

	/**
	 * @param priceReport
	 * @param customerIdStr
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void createPriceReportArchive(Customer customer,
			PriceReport priceReport, String status, String remoteUser)
			throws HibernateException, NamingException, Exception {

		String esplaNumber = null;
		String splaNumber = "5585168";
		HashMap lpidHash = new HashMap();

		// Customer customer = CustomerReadDelegate
		// .getCustomerByAccountNumber(priceReport.getAccountNumber()
		// .longValue());
		// MisldAccountSettings misldAccountSettings = customer
		// .getMisldAccountSettings();
		List customerNumbers = LpidReadDelegate.getCustomerLpids(customer);

		Iterator j = customerNumbers.iterator();
		Lpid lpidDefault = new Lpid();
		while (j.hasNext()) {
			Lpid lpid = (Lpid) j.next();
			lpidHash.put("" + lpid.getLpidId(), lpid);
			lpidDefault = lpid;
		}

		ConsentType enrollmentFormType = ConsentTypeReadDelegate
				.getConsentTypeByName(Constants.ESPLA_ENROLLMENT_FORM);

		ConsentLetter enrollmentForm = ConsentLetterReadDelegate
				.getConsentLetter(enrollmentFormType, customer);
		if (enrollmentForm != null) {
			if (enrollmentForm.getEsplaEnrollmentNumber() != null) {
				esplaNumber = enrollmentForm.getEsplaEnrollmentNumber();
			}
		}
		if (Util.isBlankString(esplaNumber)) {
			esplaNumber = "";
		}
		PriceReportCycle priceReportCycle = getActivePriceReportCycle(customer);
		if (priceReportCycle == null) {
			priceReportCycle = new PriceReportCycle();
		}
		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		priceReportCycle.setApprovalTime(new Date());
		priceReportCycle.setApprover(remoteUser);
		priceReportCycle.setCustomer(customer);
		priceReportCycle.setCycleStatus(status);
		priceReportCycle.setRecordTime(new Date());
		priceReportCycle.setRemoteUser(remoteUser);
		priceReportCycle.setStatus(Constants.ACTIVE);
		priceReportCycle.setPriceReportStatus(status);
		priceReportCycle.setPriceReportStatusUser(remoteUser);
		priceReportCycle.setPriceReportStatusTimestamp(new Date());

		session.saveOrUpdate(priceReportCycle);

		// Get the price report for this customer
		Iterator i = priceReport.getDetails().iterator();

		while (i.hasNext()) {
			PriceReportDetail priceReportDetail = (PriceReportDetail) i.next();

			PriceReportArchive priceReportArchive = new PriceReportArchive();

			if (!Util.isBlankString(priceReportDetail.getLpid())) {
				Lpid lpid = (Lpid) lpidHash.get(priceReportDetail.getLpid());
				priceReportArchive.setLpid(lpid.getLpidName());
				priceReportArchive.setMajor(lpid.getMajor().getMajorName());
			} else {
				Lpid lpid = (Lpid) lpidHash.get(priceReport.getLpid());
				if (lpid == null) {
					lpid = lpidDefault;
				}
				if (lpid != null) {
					priceReportArchive.setLpid(lpid.getLpidName());
					priceReportArchive.setMajor(lpid.getMajor().getMajorName());
				}
			}
			// Create a new price report archive

			priceReportArchive.setAccountNumber(priceReport.getAccountNumber());
			priceReportArchive.setCustomerLicenseAgreementType(priceReport
					.getCustomerAgreementType());
			priceReportArchive.setCustomerName(priceReport.getCustomerName());
			priceReportArchive.setCustomerType(priceReport.getCustomerType());
			priceReportArchive.setEsplaNumber(esplaNumber);
			priceReportArchive.setIndustry(priceReport.getIndustry());
			priceReportArchive.setPod(priceReport.getPod());
			priceReportArchive.setPoNumber(priceReport.getPoNumber());
			priceReportArchive.setPoDate(new Date(0));
			priceReportArchive.setUsageDate(new Date(0));
			if (priceReport.getPriceLevel() == null) {
				priceReportArchive.setPriceLevel("");
			} else {
				priceReportArchive.setPriceLevel(priceReport.getPriceLevel());
			}
			priceReportArchive.setPriceReportCycle(priceReportCycle);
			priceReportArchive.setQualifiedDiscount(priceReport
					.getQualifiedDiscount());
			// priceReportArchive.setPriceLevel(priceReport.getPriceLevel());

			priceReportArchive.setRecordTime(new Date());
			priceReportArchive.setRemoteUser(remoteUser);
			priceReportArchive.setSector(priceReport.getSector());

			if (priceReportDetail.getLicenseAgreementType() != null
					&& priceReportDetail.getLicenseAgreementType().equals(
							Constants.SPLA)) {
				priceReportArchive.setSplaNumber(splaNumber);
			} else {
				priceReportArchive.setSplaNumber("");
			}
			priceReportArchive.setStatus(Constants.ACTIVE);
			priceReportArchive.setOfferingType("STD");
			priceReportArchive.setOrderType("NE");

			if (priceReportDetail.getCountry() == null) {
				priceReportArchive.setCountry("");
			} else {
				priceReportArchive.setCountry(priceReportDetail.getCountry());
			}

			if (priceReportDetail.getNodeName() == null) {
				priceReportArchive.setNodeName("UNKNOWN");
			} else {
				priceReportArchive.setNodeName(priceReportDetail.getNodeName());
			}

			if (priceReportDetail.getSerialNumber() == null) {
				priceReportArchive.setSerialNumber("UNKNOWN");
			} else {
				priceReportArchive.setSerialNumber(priceReportDetail
						.getSerialNumber());
			}

			if (priceReportDetail.getMachineType() == null) {
				priceReportArchive.setMachineType("");
			} else {
				priceReportArchive.setMachineType(priceReportDetail
						.getMachineType());
			}

			if (priceReportDetail.getMachineModel() == null) {
				priceReportArchive.setMachineModel("UNKNOWN");
			} else {
				priceReportArchive.setMachineModel(priceReportDetail
						.getMachineModel());
			}

			if (priceReportDetail.getScanDate() == null) {
				Date date = Util
						.parseBaselineDate("1970-01-01-01.01.01.000000");
				priceReportArchive.setScanDate(date);
			} else {
				priceReportArchive.setScanDate(priceReportDetail.getScanDate());
			}

			if (priceReportDetail.getNodeOwner() == null) {
				priceReportArchive.setNodeOwner("");
			} else {
				priceReportArchive.setNodeOwner(priceReportDetail
						.getNodeOwner());
			}

			if (priceReportDetail.getSoftwareOwner() != null) {
				priceReportArchive.setSoftwareOwner(priceReportDetail
						.getSoftwareOwner());
			} else {
				priceReportArchive.setSoftwareOwner("");
			}

			priceReportArchive.setProcessorCount(priceReportDetail
					.getProcessorCount());
			priceReportArchive.setUserCount(priceReportDetail.getUserCount());

			if (priceReportDetail.getAuthenticated() == null) {
				priceReportArchive.setAuthenticated("");
			} else {
				priceReportArchive.setAuthenticated(priceReportDetail
						.getAuthenticated());
			}

			if (priceReportDetail.getSku() != null) {
				priceReportArchive.setSku(priceReportDetail.getSku());
			} else {
				priceReportArchive.setSku("");
			}
			if (priceReportDetail.getLicenseType() != null) {
				priceReportArchive.setLicenseType(priceReportDetail
						.getLicenseType());
			} else {
				priceReportArchive.setLicenseType("");
			}
			if (priceReportDetail.getProductDescription() != null) {
				priceReportArchive.setProductDescription(priceReportDetail
						.getProductDescription());
			} else {
				priceReportArchive.setProductDescription("");
			}
			if (priceReportDetail.getLicenseAgreementType() != null) {
				priceReportArchive.setLicenseAgreementType(priceReportDetail
						.getLicenseAgreementType());
			} else {
				priceReportArchive.setLicenseAgreementType("");
			}
			if (priceReportDetail.getSplaQuarterlyPrice() != null) {
				priceReportArchive.setSplaQuarterlyPrice(priceReportDetail
						.getSplaQuarterlyPrice());
			} else {
				priceReportArchive.setSplaQuarterlyPrice(new BigDecimal(0));
			}
			if (priceReportDetail.getEsplaYearlyPrice() != null) {
				priceReportArchive.setEsplaYearlyPrice(priceReportDetail
						.getEsplaYearlyPrice());
			} else {
				priceReportArchive.setEsplaYearlyPrice(new BigDecimal(0));
			}

			if (!Util.isBlankString(priceReportDetail.getPoNumber())) {
				priceReportArchive.setPoNumber(priceReportDetail.getPoNumber());
			} else {
				priceReportArchive.setPoNumber("");
			}

			session.save(priceReportArchive);

		}
		tx.commit();
		session.close();
	}

	/**
	 * @param priceReport
	 * @param customerIdStr
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void approvePriceReport(PriceReport priceReport,
			String remoteUser) throws HibernateException, NamingException,
			Exception {

		Customer customer = CustomerReadDelegate
				.getCustomerByAccountNumber(priceReport.getAccountNumber()
						.longValue());

		MisldAccountSettings misldAccountSettings = customer
				.getMisldAccountSettings();

		PriceReportCycle priceReportCycle = getActivePriceReportCycle(customer);
		if (priceReportCycle == null) {
			priceReportCycle = new PriceReportCycle();
			createPriceReportArchive(customer, priceReport, Constants.APPROVED,
					remoteUser);
		} else {
			priceReportCycle.setApprovalTime(new Date());
			priceReportCycle.setApprover(remoteUser);
			priceReportCycle.setCycleStatus(Constants.APPROVED);
			priceReportCycle.setPriceReportStatus(Constants.APPROVED);
			priceReportCycle.setPriceReportStatusUser(remoteUser);
			priceReportCycle.setPriceReportStatusTimestamp(new Date());
		}
		// createPriceReportArchive(customer, priceReport, Constants.APPROVED,
		// remoteUser);

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();
		//

		session.saveOrUpdate(priceReportCycle);

		Notification notification = NotificationDelegate.getNotificationByCustomerTypeStatus(
				customer, Constants.PRICE_REPORT, Constants.ACTIVE);

		boolean sameNotifier = false;

		if ((notification != null)) {
			String notifier = notification.getRemoteUser();
			if (notifier.equals(remoteUser))
				sameNotifier = true;

			// If the Price Report is approved, set the notification status to
			// Inactive
			// so that the account is not escalated
			notification.setStatus(Constants.INACTIVE);

			session.update(notification);

			// If the person who sent the Price Report notification to the DPE
			// is the person
			// who approved the report, send an email to the management chain
			if (sameNotifier && (customer != null)) {
				Customer[] c = new Customer[1];
				c[0] = customer;

				Contact dpe = new Contact();
				String dpe_serial = null;
				String dpe_email = null;
				Contact manager = new Contact();
				String manager_serial = null;
				String manager_email = null;
				Contact director = new Contact();
				String director_serial = null;
				String director_email = null;
				Contact vp = new Contact();
				String vp_serial = null;
				String vp_email = null;

				dpe = customer.getContactDPE();
				dpe_serial = dpe.getSerial();
				dpe = BluegroupsDelegate.getContactByLongSerial(dpe_serial);
				dpe_email = dpe.getRemoteUser();
				manager_serial = dpe.getManagerSerial();
				if (manager_serial != null) {
					manager = BluegroupsDelegate
							.getContactByLongSerial(manager_serial);
					manager_email = manager.getRemoteUser();
					director_serial = manager.getManagerSerial();

					if (director_serial != null) {
						director = BluegroupsDelegate
								.getContactByLongSerial(director_serial);
						director_email = director.getRemoteUser();
						vp_serial = director.getManagerSerial();

						if (vp_serial != null) {
							vp = BluegroupsDelegate
									.getContactByLongSerial(vp_serial);
							vp_email = vp.getRemoteUser();
						}
					}
				}

				String[] toUsers = new String[2];
				String[] ccUsers = new String[3];

				toUsers[0] = director_email;
				toUsers[1] = vp_email;

				ccUsers[0] = dpe_email;
				ccUsers[1] = manager_email;
				ccUsers[2] = "srednick@us.ibm.com";

				sendNotifications(c, remoteUser, notifier, toUsers, ccUsers,
						Constants.SW_ANALYST_APPROVAL);

			}
		}

		// Set the Account Settings so that the account is locked
		if (misldAccountSettings != null) {
			misldAccountSettings.setStatus(Constants.LOCKED);
			misldAccountSettings.setPriceReportStatus(Constants.APPROVED);
			misldAccountSettings.setPriceReportStatusUser(remoteUser);
			misldAccountSettings.setPriceReportTimestamp(new Date());
		}

		session.update(misldAccountSettings);

		tx.commit();
		session.close();
	}

	public static HashMap createSplaMoetReport(String usageDate)
			throws HibernateException, NamingException {

		Date usageDateAsDate = Util.parseDayString(usageDate);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(usageDateAsDate);

		HashMap poHash = new HashMap();

		Session session = getHibernateSession();
		List moetList = session.getNamedQuery("moetQuery").setDate("usageDate",
				usageDateAsDate).list();
		session.close();

		if (moetList != null) {
			Iterator j = moetList.iterator();

			while (j.hasNext()) {
				Vector tempVector = new Vector();

				int countInt = 0;

				Object[] pair = (Object[]) j.next();
				String poNumber = (String) pair[0];
				String sku = (String) pair[1];
				String licenseType = (String) pair[2];
				String country = (String) pair[3];
				Long procCount = (Long) pair[4];
				Integer processorCount = (Integer) procCount.intValue();
				Long usrCount = (Long) pair[5];
				Integer userCount = (Integer) usrCount.intValue();
				Integer count;

				if (licenseType.equals(Constants.PROCESSOR_BASED_LICENSE)) {
					count = processorCount;
				} else {
					count = userCount;
				}

				countInt = count.intValue() * 3;

				count = new Integer(countInt);

				tempVector.add("");
				tempVector.add(sku);
				tempVector.add("" + count);
				tempVector.add("");
				tempVector.add("STD");
				tempVector.add(country);
				tempVector.add("");

				if (poHash.get(poNumber) == null) {
					Moet moet = new Moet();
					moet.setAgreementNumber("5585168");
					moet.setPoNumber(poNumber);
					moet.setPoType("NE");
					String month = "";
					if ((calendar.get(Calendar.MONTH) + 1) < 10) {
						month = "0" + (calendar.get(Calendar.MONTH) + 1);
					} else {
						month = "" + (calendar.get(Calendar.MONTH) + 1);
					}
					moet.setUsageDate("" + calendar.get(Calendar.YEAR) + month
							+ calendar.get(Calendar.DAY_OF_MONTH));

					Vector productVector = moet.getProductVector();
					productVector.add(tempVector);
					moet.setProductVector(productVector);
					poHash.put(poNumber, moet);
				} else {
					Moet moet = (Moet) poHash.get(poNumber);
					Vector productVector = moet.getProductVector();
					productVector.add(tempVector);
					moet.setProductVector(productVector);
					poHash.put(poNumber, moet);
				}

			}
		}

		return poHash;
	}

	/**
	 * @return
	 * @throws HibernateException
	 * @throws NamingException
	 */
	public static List getDistinctUsageDates() throws HibernateException,
			NamingException {

		List usageDateList = null;

		Vector dateList = new Vector();

		Session session = getHibernateSession();

		usageDateList = session.getNamedQuery("getDistinctUsageDates").list();

		session.close();

		if (usageDateList != null) {
			Iterator j = usageDateList.iterator();

			while (j.hasNext()) {
				Date usageDate = (Date) j.next();

				dateList.add(usageDate);
			}
		}

		return dateList;
	}

	/**
	 * @return
	 * @throws HibernateException
	 * @throws NamingException
	 */
	public static Vector getAcceptMoetDates() throws HibernateException,
			NamingException {

		List usageDateList = null;

		Vector dateList = new Vector();

		Session session = getHibernateSession();

		usageDateList = session.getNamedQuery("getAcceptMoetDates").list();

		session.close();

		if (usageDateList != null) {
			Iterator j = usageDateList.iterator();

			while (j.hasNext()) {
				Date usageDate = (Date) j.next();

				dateList.add(usageDate);
			}
		}

		return dateList;
	}

	/**
	 * @param priceReport
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void updatePriceReportArchivePO(PriceReport priceReport,
			String remoteUser) throws HibernateException, NamingException {

		Customer customer = CustomerReadDelegate
				.getCustomerByAccountNumber(priceReport.getAccountNumber()
						.longValue());

		// Get the price report cycle
		PriceReportCycle priceReportCycle = PriceReportDelegate
				.getActivePriceReportCycle(customer);

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// update the price report cycle
		priceReportCycle.setCycleStatus("PO ENTERED");
		priceReportCycle.setPoEntryTime(new Date());
		priceReportCycle.setPoUser(remoteUser);
		priceReportCycle.setRecordTime(new Date());
		priceReportCycle.setRemoteUser(remoteUser);

		session.update(priceReportCycle);

		Iterator i = priceReport.getDetails().iterator();

		while (i.hasNext()) {
			PriceReportArchive priceReportArchive = (PriceReportArchive) i
					.next();

			if (Util.isBlankString(priceReportArchive.getPoNumber())) {
				priceReportArchive.setPoNumber(priceReport.getPoNumber());
			}

			priceReportArchive.setPoDate(Util.parseDayString(priceReport
					.getPoDate()));
			priceReportArchive.setUsageDate(Util.parseDayString(priceReport
					.getUsageDate()));

			session.update(priceReportArchive);
		}

		tx.commit();
		session.close();

	}

	public static PriceReportDetail copyArchiveToDetail(
			PriceReportArchive priceReportArchive) throws HibernateException,
			NamingException {

		PriceReportDetail priceReportDetail = new PriceReportDetail();

		priceReportDetail.setAuthenticated(priceReportArchive
				.getAuthenticated());
		priceReportDetail.setCountry(priceReportArchive.getCountry());
		priceReportDetail.setEsplaYearlyPrice(priceReportArchive
				.getEsplaYearlyPrice());
		priceReportDetail.setSplaQuarterlyPrice(priceReportArchive
				.getSplaQuarterlyPrice());
		priceReportDetail.setLicenseAgreementType(priceReportArchive
				.getLicenseAgreementType());
		priceReportDetail.setLpid(priceReportArchive.getLpid());
		priceReportDetail.setMachineModel(priceReportArchive.getMachineModel());
		priceReportDetail.setMachineType(priceReportArchive.getMachineType());
		priceReportDetail.setNodeName(priceReportArchive.getNodeName());
		priceReportDetail.setNodeOwner(priceReportArchive.getNodeOwner());
		priceReportDetail.setPoNumber(priceReportArchive.getPoNumber());
		priceReportDetail.setProcessorCount(priceReportArchive
				.getProcessorCount());
		priceReportDetail.setProductDescription(priceReportArchive
				.getProductDescription());
		priceReportDetail.setScanDate(priceReportArchive.getScanDate());
		priceReportDetail.setSerialNumber(priceReportArchive.getSerialNumber());
		priceReportDetail.setSku(priceReportArchive.getSku());
		priceReportDetail.setSoftwareOwner(priceReportArchive
				.getSoftwareOwner());
		priceReportDetail.setUserCount(priceReportArchive.getUserCount());

		return priceReportDetail;
	}

	/**
	 * @param priceReportCycle
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static PriceReport getLockedPriceReportArchive(
			PriceReportCycle priceReportCycle, Customer customer)
			throws HibernateException, NamingException {

		// Initialize variables
		PriceReport priceReport = new PriceReport();
		PriceReportSummary priceReportSummary = null;

		HashMap summaryHashMap = new HashMap();
		HashMap lpidHashMap = new HashMap();

		// set up the customer attributes
		priceReport.setAccountNumber(customer.getAccountNumber());
		priceReport.setCustomerAgreementType(customer.getMisldAccountSettings()
				.getLicenseAgreementType().getLicenseAgreementTypeName());
		priceReport.setCustomerName(customer.getCustomerName());
		priceReport.setCustomerType(customer.getCustomerType()
				.getCustomerTypeName());
		priceReport.setIndustry(customer.getIndustry().getIndustryName());
		priceReport.setPod(customer.getPod().getPodName());
		priceReport.setSector(customer.getIndustry().getSector()
				.getSectorName());
		priceReport.setPodId("" + customer.getPod().getPodId());
		if (customer.getMisldAccountSettings().getDefaultLpid() != null) {
			priceReport.setLpid(customer.getMisldAccountSettings()
					.getDefaultLpid().getLpidId().toString());
		}

		// To date all spla prices are corporate so we will set it here
		priceReport.setQualifiedDiscount("CORPORATE");

		// Set up the price level if customer is espla
		if (priceReport.getCustomerAgreementType().equals(Constants.ESPLA)) {

			ConsentType consentType = ConsentTypeReadDelegate
					.getConsentTypeByName(Constants.ESPLA_ENROLLMENT_FORM);

			ConsentLetter consentLetter = ConsentLetterReadDelegate
					.getConsentLetter(consentType, customer);

			if (consentLetter.getPriceLevel() == null) {
				priceReport.setPriceLevel("A");
				priceReport.setPriceLevelFlag(true);
			} else {
				priceReport.setPriceLevel(consentLetter.getPriceLevel()
						.getPriceLevel());
			}
		}

		// Now we need to get the price report archives
		List priceReportArchiveList = getPriceReportArchiveList(priceReportCycle);

		Iterator i = priceReportArchiveList.iterator();

		while (i.hasNext()) {
			PriceReportArchive priceReportArchive = (PriceReportArchive) i
					.next();

			// Setup initial price report detail
			PriceReportDetail priceReportDetail = copyArchiveToDetail(priceReportArchive);

			priceReport.addToDetails(priceReportDetail);

			if (priceReportArchive.getSplaQuarterlyPrice().intValue() != 0) {
				priceReport.addToTotalSplaPrice(priceReportArchive
						.getSplaQuarterlyPrice());
				lpidHashMap.put(priceReportArchive.getLpid(), priceReport
						.addToLpidPrice(lpidHashMap, priceReportArchive
								.getLpid(), priceReportArchive
								.getSplaQuarterlyPrice()));
			} else {
				priceReport.addToTotalEsplaPrice(priceReportArchive
						.getEsplaYearlyPrice());
				lpidHashMap.put(priceReportArchive.getLpid(), priceReport
						.addToLpidPrice(lpidHashMap, priceReportArchive
								.getLpid(), priceReportArchive
								.getEsplaYearlyPrice()));
			}

			if (summaryHashMap.get(priceReportArchive.getSku()) == null) {
				priceReportSummary = new PriceReportSummary();
			} else {
				priceReportSummary = (PriceReportSummary) summaryHashMap
						.get(priceReportArchive.getSku());
			}

			priceReportSummary.setSku(priceReportArchive.getSku());
			priceReportSummary.setSoftwareName(priceReportArchive
					.getProductDescription());
			priceReportSummary.addToProcessorCount(priceReportArchive
					.getProcessorCount());
			priceReportSummary
					.addToUserCount(priceReportArchive.getUserCount());
			priceReportSummary.addToServerCount(1);

			if (priceReportArchive.getLicenseType().equals(
					Constants.USER_LICENSE_TYPE)) {
				priceReportSummary.addToLicenseTotal(priceReportArchive
						.getUserCount());
			} else {
				priceReportSummary.addToLicenseTotal(priceReportArchive
						.getProcessorCount());
			}

			if (priceReportArchive.getLicenseAgreementType().equals("SPLA")) {
				priceReportSummary.addToTotalSplaPrice(priceReportArchive
						.getSplaQuarterlyPrice());
			} else {
				priceReportSummary.addToTotalEsplaPrice(priceReportArchive
						.getEsplaYearlyPrice());
			}

			summaryHashMap.put(priceReportArchive.getSku(), priceReportSummary);

		}
		priceReport.setLpidTotals(lpidHashMap);
		priceReport.setSummary(summaryHashMap);

		List customerNumbers = LpidReadDelegate.getCustomerLpids(customer);
		ArrayList lpids = new ArrayList();

		Iterator j = customerNumbers.iterator();

		while (j.hasNext()) {
			Lpid lpid = (Lpid) j.next();

			lpids.add(new LabelValueBean(lpid.getLpidName() + " - "
					+ lpid.getMajor().getMajorName(), "" + lpid.getLpidId()));

		}

		priceReport.setLpids(lpids);

		return priceReport;
	}

	/**
	 * @param priceReportCycle
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static PriceReport getPriceReportArchive(
			PriceReportCycle priceReportCycle, Customer customer)
			throws HibernateException, NamingException {

		// Initialize variables
		PriceReport priceReport = new PriceReport();
		PriceReportSummary priceReportSummary = null;

		HashMap summaryHashMap = new HashMap();
		HashMap lpidHashMap = new HashMap();

		// set up the customer attributes
		priceReport.setAccountNumber(customer.getAccountNumber());
		priceReport.setCustomerAgreementType(customer.getMisldAccountSettings()
				.getLicenseAgreementType().getLicenseAgreementTypeName());
		priceReport.setCustomerName(customer.getCustomerName());
		priceReport.setCustomerType(customer.getCustomerType()
				.getCustomerTypeName());
		priceReport.setIndustry(customer.getIndustry().getIndustryName());
		priceReport.setPod(customer.getPod().getPodName());
		priceReport.setSector(customer.getIndustry().getSector()
				.getSectorName());
		priceReport.setPodId("" + customer.getPod().getPodId());
		if (customer.getMisldAccountSettings().getDefaultLpid() != null) {
			priceReport.setLpid(customer.getMisldAccountSettings()
					.getDefaultLpid().getLpidId().toString());
		}

		// To date all spla prices are corporate so we will set it here
		priceReport.setQualifiedDiscount("CORPORATE");

		// Set up the price level if customer is espla
		if (priceReport.getCustomerAgreementType().equals(Constants.ESPLA)) {

			ConsentType consentType = ConsentTypeReadDelegate
					.getConsentTypeByName(Constants.ESPLA_ENROLLMENT_FORM);

			ConsentLetter consentLetter = ConsentLetterReadDelegate
					.getConsentLetter(consentType, customer);

			if (consentLetter.getPriceLevel() == null) {
				priceReport.setPriceLevel("A");
				priceReport.setPriceLevelFlag(true);
			} else {
				priceReport.setPriceLevel(consentLetter.getPriceLevel()
						.getPriceLevel());
			}
		}

		// Now we need to get the price report archives
		List priceReportArchiveList = getPriceReportArchiveList(priceReportCycle);

		Iterator i = priceReportArchiveList.iterator();

		while (i.hasNext()) {
			PriceReportArchive priceReportArchive = (PriceReportArchive) i
					.next();

			// Setup initial price report detail
			priceReport.addToDetails(priceReportArchive);

			// add the correct values for price
			if (priceReportArchive.getSplaQuarterlyPrice().intValue() != 0) {
				priceReport.addToTotalSplaPrice(priceReportArchive
						.getSplaQuarterlyPrice());
				lpidHashMap.put(priceReportArchive.getLpid(), priceReport
						.addToLpidPrice(lpidHashMap, priceReportArchive
								.getLpid(), priceReportArchive
								.getSplaQuarterlyPrice()));
			} else {
				priceReport.addToTotalEsplaPrice(priceReportArchive
						.getEsplaYearlyPrice());
				lpidHashMap.put(priceReportArchive.getLpid(), priceReport
						.addToLpidPrice(lpidHashMap, priceReportArchive
								.getLpid(), priceReportArchive
								.getEsplaYearlyPrice()));
			}

			if (summaryHashMap.get(priceReportArchive.getSku()) == null) {
				priceReportSummary = new PriceReportSummary();
			} else {
				priceReportSummary = (PriceReportSummary) summaryHashMap
						.get(priceReportArchive.getSku());
			}

			priceReportSummary.setSku(priceReportArchive.getSku());
			priceReportSummary.setSoftwareName(priceReportArchive
					.getProductDescription());
			priceReportSummary.addToProcessorCount(priceReportArchive
					.getProcessorCount());
			priceReportSummary
					.addToUserCount(priceReportArchive.getUserCount());
			priceReportSummary.addToServerCount(1);

			if (priceReportArchive.getLicenseType().equals(
					Constants.USER_LICENSE_TYPE)) {
				priceReportSummary.addToLicenseTotal(priceReportArchive
						.getUserCount());
			} else {
				priceReportSummary.addToLicenseTotal(priceReportArchive
						.getProcessorCount());
			}

			if (priceReportArchive.getLicenseAgreementType().equals("SPLA")) {
				priceReportSummary.addToTotalSplaPrice(priceReportArchive
						.getSplaQuarterlyPrice());
			} else {
				priceReportSummary.addToTotalEsplaPrice(priceReportArchive
						.getEsplaYearlyPrice());
			}

			summaryHashMap.put(priceReportArchive.getSku(), priceReportSummary);

		}
		priceReport.setLpidTotals(lpidHashMap);
		priceReport.setSummary(summaryHashMap);

		List customerNumbers = LpidReadDelegate.getCustomerLpids(customer);
		ArrayList lpids = new ArrayList();

		Iterator j = customerNumbers.iterator();

		while (j.hasNext()) {
			Lpid lpid = (Lpid) j.next();

			lpids.add(new LabelValueBean(lpid.getLpidName() + " - "
					+ lpid.getMajor().getMajorName(), "" + lpid.getLpidId()));

		}

		priceReport.setLpids(lpids);

		return priceReport;
	}

	/**
	 * @param priceReportCycle
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	private static List getPriceReportArchiveList(
			PriceReportCycle priceReportCycle) throws HibernateException,
			NamingException {

		List priceReportArchiveList = null;

		Session session = getHibernateSession();

		priceReportArchiveList = session.getNamedQuery("getPriceReportArchive")
				.setEntity("priceReportCycle", priceReportCycle).list();

		session.close();

		return priceReportArchiveList;
	}

	/**
	 * @param unlockCustomers
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void InactivatePriceReportCycle(ArrayList unlockCustomers)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.getNamedQuery("inactivatePriceReportCycle").setParameterList(
				"customers", unlockCustomers).executeUpdate();

		tx.commit();
		session.close();
	}

	/**
	 * @param s
	 * @param string
	 * @throws Exception
	 */
	public static String sendNotifications(Customer[] s, String remoteUser,
			String notifier, String[] toUsers, String[] ccUsers,
			String notificationType) throws Exception {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		String pod = null;
		if (notifier == null) {
			notifier = "srednick@us.ibm.com";
		}

		for (int i = 0; i < s.length; i++) {
			Customer formCustomer = (Customer) s[i];

			if (((notificationType.equals(Constants.PRICE_REPORT)) && (formCustomer
					.getStatus().equals("on")))
					|| (!notificationType.equals(Constants.PRICE_REPORT))) {

				Customer customer = CustomerReadDelegate
						.getCustomerByLong(formCustomer.getCustomerId()
								.longValue());

				pod = customer.getPod().getPodId().toString();

				Notification notification = NotificationDelegate
						.getNotification(customer, notificationType);

				if (notification == null) {
					notification = new Notification();
					notification.setCustomer(customer);
					notification.setNotificationType(notificationType);
				}

				notification.setRemoteUser(remoteUser);
				notification.setStatus(Constants.ACTIVE);
				notification.setRecordTime(new Date());

				session.saveOrUpdate(notification);

				StringBuffer content = new StringBuffer();
				ArrayList topeeps = new ArrayList();
				String toUser = null;
				if (toUsers != null) {
					for (int u = 0; u < toUsers.length; u++) {
						toUser = (String) toUsers[u];
						topeeps.add(toUser);
					}
				}

				ArrayList ccpeeps = new ArrayList();
				String ccUser = null;
				if (ccUsers != null) {
					for (int c = 0; c < ccUsers.length; c++) {
						ccUser = (String) ccUsers[c];
						ccpeeps.add(ccUser);
					}
				}
				// Add notifier email to each notification
				if (!remoteUser.equals("mswiz@tap.raleigh.ibm.com")) {
					ccpeeps.add(remoteUser);
				}

				String subject = "";
				// MisldDate currentQtrRecord =
				// MisldDateReadDelegate.getCurrentQtr();
				String currentQtr = "4Q";
				// String currentQtr = currentQtrRecord.getDateValue();

				if (notificationType == Constants.PRICE_REPORT) {

					topeeps.add(customer.getContactDPE().getRemoteUser());

					subject = "URGENT: Action Required within 5 business days: Microsoft Price Report Notification";

					content.append("DPE,\n\n");

					content
							.append("You are required to take action within 5 business days of this notification.\n");

					content
							.append("Summary of Action Items that Need to Be Completed within 5 business days:\n\n");

					content
							.append("1.  Log into the Microsoft Wizard to review "
									+ customer.getCustomerName()
									+ " account's Microsoft pricing report.\n");
					content
							.append("2.  If any changes are needed, please click the REJECT button and notify your SW asset management analyst of the changes, who is also copied on this note.  "
									+ "The SW analyst will make any updates needed and then resubmit the pricing report for your review.\n");
					content
							.append("3.  Once you agree with the pricing report, please click the APPROVE button.\n");
					content
							.append("4.  If you fail to respond within 5 business days, your manager will be notified.  You will then have an additional "
									+ "3 days to review the report.  If you do not do so, your Director and VP will be notified and a PO will be cut "
									+ "against the "
									+ customer.getCustomerName()
									+ " account's "
									+ currentQtr
									+ " Microsoft SPLA payment.\n\n");
					content.append("Detailed Instructions:\n\n");
					content
							.append("Asset Management has collected the Microsoft data found in the Microsoft Wizard for your account.  "
									+ "Please click on the following link to be taken to your account's pricing report in the Microsoft Wizard:  "
									+ "https://bravo.boulder.ibm.com/BRAVO/MsWizard/PriceReport.do?customer="
									+ customer.getCustomerId() + "\n\n");
					content
							.append("If the following link does not work, please follow these instructions to be taken to your account's price report:\n");
					content
							.append("1.  Access https://bravo.boulder.ibm.com/BRAVO/mswiz.do. Login with your intranet ID and password.\n");
					content
							.append("2.  Click on the Reports link on the left.\n");
					content.append("3.  Click on the following department: "
							+ customer.getPod().getPodName() + "\n");
					content
							.append("4.  To view your account's price report, click on view located to the right of your account's name.\n\n");
					content
							.append("If there is missing Microsoft SW information from this spreadsheet, please contact your SW asset management analyst, "
									+ "who is also copied on this note, so that they can add missing information.\n\n");
					content
							.append("Please pay special attention to the Non-Operating System software (ex Office and SQL).  "
									+ "If any SW marked as IBM owned is really customer owned, please let your SW analyst know.  "
									+ "Also, if known, please provide the user count on each server.  Unless we are provided the user count, "
									+ "we assume 1000 users so that processor licenses are purchased.  If you can provide the user count, "
									+ "it's quite possible that you can save money as we may be able to pay for user licenses.  "
									+ "Also, please pay special attention to SQL Server and Office.  The script used to collect the "
									+ "SW inventory has caused false positives for this product in the past.  Please ensure that any instances of "
									+ "these products in your pricing report are correct.\n\n");
					content
							.append("Due to recent ASCA certification reviews of the MS Wizard, we are now required to show positive confirmation from the DPE or "
									+ "escalation if there is no response from the DPE prior to sending price report with purchase orders to SHI.  Because of the timeline "
									+ "we are on with Microsoft it is imperative that you respond asap.  If you fail to respond within the specified time, asset management "
									+ "will lock down the report and notification will be sent to your Director and VP informing them that you have not responded to "
									+ "these communications.\n\n");
					content
							.append("Please direct your questions or responses to your SW asset management analyst, who is copied on this note, or the Microsoft SPLA Focal, "
									+ "Stacy Shanahan.  Please do not respond to the mswiz@tap.raleigh.ibm.com address.\n\n");

				}

				if (notificationType == Constants.ESCALATION) {

					subject = "Second Notice: URGENT: Action Required within 3 Business Days: Microsoft Price Report Notification";

					content.append("Manager,\n\n");
					content
							.append("The DPE on copy has been notified that their action is required to review and approve the "
									+ currentQtr
									+ " Microsoft SPLA price report for the "
									+ customer.getCustomerName()
									+ " account.  Our records indicate that the report has not been reviewed/approved.  Please ensure that your employee does "
									+ "so within the next 3 business days otherwise the report will be approved by the SW Asset Analyst and notification will be sent to their "
									+ "Director and VP.\n\n");
					content
							.append("Please do not respond to the mswiz@tap.raleigh.ibm.com address.  If you have any questions please contact "
									+ notifier
									+ " at "
									+ ccUsers[1]
									+ " .\n\n\n");

					content
							.append("Here is the notice originally sent to the DPE asking that they respond within 5 business days: \n");

					content
							.append("==============================================================================================\n\n");

					content.append("DPE,\n\n");

					content
							.append("You are required to take action within 5 business days of this notification.\n");

					content
							.append("Summary of Action Items that Need to Be Completed within 5 business days:\n\n");

					content
							.append("1.  Log into the Microsoft Wizard to review "
									+ customer.getCustomerName()
									+ " account's Microsoft pricing report.\n");
					content
							.append("2.  If any changes are needed, please click the REJECT button and notify your SW asset management analyst of the changes, who is also copied on this note.  "
									+ "The SW analyst will make any updates needed and then resubmit the pricing report for your review.\n");
					content
							.append("3.  Once you agree with the pricing report, please click the APPROVE button.\n");
					content
							.append("4.  If you fail to respond within 5 business days, your manager will be notified.  You will then have an additional "
									+ "3 days to review the report.  If you do not do so, your Director and VP will be notified and a PO will be cut "
									+ "against the "
									+ customer.getCustomerName()
									+ " account's "
									+ currentQtr
									+ " Microsoft SPLA payment.\n\n");
					content.append("Detailed Instructions:\n\n");
					content
							.append("Asset Management has collected the Microsoft data found in the Microsoft Wizard for your account.  "
									+ "Please click on the following link to be taken to your account's pricing report in the Microsoft Wizard:  "
									+ "https://bravo.boulder.ibm.com/BRAVO/MsWizard/PriceReport.do?customer="
									+ customer.getCustomerId() + "\n\n");
					content
							.append("If the following link does not work, please follow these instructions to be taken to your account's price report:\n");
					content
							.append("1.  Access https://bravo.boulder.ibm.com/BRAVO/mswiz.do. Login with your intranet ID and password.\n");
					content
							.append("2.  Click on the Reports link on the left.\n");
					content.append("3.  Click on the following department: "
							+ customer.getPod().getPodName() + "\n");
					content
							.append("4.  To view your account's price report, click on view located to the right of your account's name.\n\n");
					content
							.append("If there is missing Microsoft SW information from this spreadsheet, please contact your SW asset management analyst, "
									+ "who is also copied on this note, so that they can add missing information.\n\n");
					content
							.append("Please pay special attention to the Non-Operating System software (ex Office and SQL).  "
									+ "If any SW marked as IBM owned is really customer owned, please let your SW analyst know.  "
									+ "Also, if known, please provide the user count on each server.  Unless we are provided the user count, "
									+ "we assume 1000 users so that processor licenses are purchased.  If you can provide the user count, "
									+ "it's quite possible that you can save money as we may be able to pay for user licenses.  "
									+ "Also, please pay special attention to SQL Server and Office.  The script used to collect the "
									+ "SW inventory has caused false positives for this product in the past.  Please ensure that any instances of "
									+ "these products in your pricing report are correct.\n\n");
					content
							.append("Due to recent ASCA certification reviews of the MS Wizard, we are now required to show positive confirmation from the DPE or "
									+ "escalation if there is no response from the DPE prior to sending price report with purchase orders to SHI.  Because of the timeline "
									+ "we are on with Microsoft it is imperative that you respond asap.  If you fail to respond within the specified time, asset management "
									+ "will lock down the report and notification will be sent to your Director and VP informing them that you have not responded to "
									+ "these communications.\n\n");
					content
							.append("Please direct your questions or responses to your SW asset management analyst, who is copied on this note, or the Microsoft SPLA Focal, "
									+ "Stacy Shanahan.  Please do not respond to the mswiz@tap.raleigh.ibm.com address.\n\n");

				}

				if (notificationType == Constants.SW_ANALYST_APPROVAL) {

					subject = "URGENT: Microsoft SPLA Charges for the "
							+ customer.getCustomerName() + " Account";

					content.append("Director and VP,\n\n");
					content
							.append("The DPE on copy has been notified that their action is required to review and approve the "
									+ currentQtr
									+ " Microsoft SPLA price report for the "
									+ customer.getCustomerName()
									+ " account.  Our records indicate that the report has not been reviewed/approved.  This has already been escalated to their "
									+ "Manager without success.  The account has now been approved and the charges processed. \n\n");
					content
							.append("To view the charges for this account, please click on the following link to be taken to the account's pricing report in the Microsoft Wizard:  "
									+ "https://bravo.boulder.ibm.com/BRAVO/MsWizard/PriceReport.do?customer="
									+ customer.getCustomerId() + "\n\n");
					content
							.append("Please do not respond to the mswiz@tap.raleigh.ibm.com address.\n\n");
				}

				try {
					// *************** FOR TESTING
					// *******************************
					// content.append("To: ");
					// for (int t = 0; t < topeeps.size(); t++) {
					// System.out.println("topeeps " + t + " = " +
					// topeeps.get(t));
					// content.append(topeeps.get(t) + ", ");
					// }
					// content.append("\n\n");

					// content.append("Cc: ");
					// for (int c = 0; c < ccpeeps.size(); c++) {
					// System.out.println("ccpeeps " + c + " = " +
					// ccpeeps.get(c));
					// if (ccpeeps.get(c) != null) {
					// content.append(ccpeeps.get(c) + ", ");
					// }
					// }
					// content.append("\n\n");

					// ArrayList to = new ArrayList();
					// to.add("srednick@us.ibm.com");
					// ArrayList cc = new ArrayList();
					// cc.add("kneikirk@us.ibm.com");
					// cc.add("cpereira@us.ibm.com");
					// EmailDelegate.sendMessage(subject, to, cc, content);
					// System.out.println("== test emailing enabled ==");

					// ***********************************************************

					EmailDelegate.sendMessage(subject, topeeps, ccpeeps,
							content);

				} catch (Exception e) {
					e.printStackTrace();
					throw e;
				}

			}

		}

		tx.commit();
		session.close();

		return pod;

	}

	/**
	 * @param poForm
	 * @throws NamingException
	 * @throws HibernateException
	 * @throws SQLException
	 */
	public static void acceptSplaMoet(String usageDate) throws NamingException,
			HibernateException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.getNamedQuery("acceptSplaMoet").setString("usageDate",
				usageDate).executeUpdate();

		tx.commit();

		session.close();

	}

	/**
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void createMassReportArchive(String remoteUser)
			throws HibernateException, NamingException, Exception {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		Vector customers = CustomerReadDelegate.getInScopeCustomers();

		Iterator i = customers.iterator();
		while (i.hasNext()) {
			Customer customer = (Customer) i.next();

			createPriceReportArchive(customer, getPriceReport(customer),
					Constants.LOCKED, remoteUser);

			MisldAccountSettings misldAccountSettings = customer
					.getMisldAccountSettings();

			misldAccountSettings.setStatus(Constants.LOCKED);

			session.update(misldAccountSettings);

			tx.commit();
		}

		session.close();

	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static DefaultCategoryDataset getPriceReportNotificationStatus()
			throws HibernateException, NamingException {

		DefaultCategoryDataset dataset = new DefaultCategoryDataset();

		List notificationStatusList = getPriceReportNotificationReport();

		Iterator i = notificationStatusList.iterator();
		while (i.hasNext()) {
			PriceReportNotificationReport registrationStatus = (PriceReportNotificationReport) i
					.next();
			dataset.addValue(registrationStatus.getCount(), registrationStatus
					.getStatus(), registrationStatus.getPodName());
		}

		return dataset;

	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	private static List getPriceReportNotificationReport()
			throws HibernateException, NamingException {
		List notificationList = null;
		Vector returnList = new Vector();

		Session session = getHibernateSession();

		notificationList = session.getNamedQuery(
				"getPriceReportNotificationReport").list();

		session.close();

		Iterator i = notificationList.iterator();

		while (i.hasNext()) {
			Object[] pair = (Object[]) i.next();
			String podName = (String) pair[0];
			String status = (String) pair[1];
			Integer count = (Integer) pair[2];

			PriceReportNotificationReport prnr = new PriceReportNotificationReport(
					podName, status, count.longValue());
			returnList.add(prnr);
		}

		return returnList;
	}

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getPriceReportCycles(Customer customer)
			throws HibernateException, NamingException {

		List priceReportCycles = null;

		Session session = getHibernateSession();
		priceReportCycles = session.getNamedQuery("getPriceReportCycles")
				.setEntity("customer", customer).list();
		session.close();

		Iterator i = priceReportCycles.iterator();
		Vector returnVector = new Vector();
		while (i.hasNext()) {
			Object[] pair = (Object[]) i.next();
			Long priceReportCycleId = (Long) pair[0];
			Date recordTime = (Date) pair[1];

			PriceReportCycle priceReportCycle = new PriceReportCycle();
			priceReportCycle.setPriceReportCycleId(priceReportCycleId);
			priceReportCycle.setCustomer(customer);
			priceReportCycle.setRecordTime(recordTime);
			returnVector.add(priceReportCycle);
		}

		return returnVector;
	}

	/**
	 * @param priceReportCycleId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static PriceReportCycle getPriceReportCycle(Long priceReportCycleId)
			throws HibernateException, NamingException {

		PriceReportCycle priceReportCycle = null;

		Session session = getHibernateSession();
		priceReportCycle = (PriceReportCycle) session.getNamedQuery(
				"getPriceReportCycle").setLong("priceReportCycleId",
				priceReportCycleId.longValue()).uniqueResult();
		session.close();

		return priceReportCycle;
	}

	public int GetBusinessDays(Date From, Date To) throws ParseException,
			Exception {

		int Result = 0;

		Calendar FromCal = Calendar.getInstance();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-dd-MM");
		Date FromDt = null;
		int FromDayOfWeek = 1;

		while (From.compareTo(To) <= 0) {

			try {
				FromDt = sdf.parse(From.toString());
			} catch (ParseException pe) {
				pe.printStackTrace();
			}

			FromCal.setTime(FromDt);
			FromDayOfWeek = FromCal.get(Calendar.DAY_OF_WEEK);

			// Exclude Sunday (1) and Saturday (7) and holidays
			if ((FromDayOfWeek != 1) && (FromDayOfWeek != 7)
					&& (!HolidayReadDelegate.isHoliday(From)))
				;
			{

				Result++;
			}
			// Increment the From date
			FromCal.add(Calendar.DATE, 1);
			From = FromCal.getTime();
		}

		return Result;

	}

}