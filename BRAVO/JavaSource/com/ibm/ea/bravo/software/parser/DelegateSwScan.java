package com.ibm.ea.bravo.software.parser;

/**
 * @author dbryson@us.ibm.com
 */
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.discrepancy.DelegateDiscrepancy;
import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.InstalledBase;
import com.ibm.ea.bravo.software.InstalledDoranaProduct;
import com.ibm.ea.bravo.software.InstalledSaProduct;
import com.ibm.ea.bravo.software.InstalledSoftware;
import com.ibm.ea.bravo.software.InstalledVmProduct;
import com.ibm.ea.bravo.software.ScanProduct;
import com.ibm.ea.bravo.software.SoftwareDiscrepancyH;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.sigbank.BankAccount;
import com.ibm.ea.sigbank.DoranaProduct;
import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.SaProduct;
import com.ibm.ea.sigbank.Software;
import com.ibm.ea.sigbank.VmProduct;

public abstract class DelegateSwScan extends HibernateDelegate {

	private static final Logger logger = Logger.getLogger(DelegateSwScan.class);

	/*
	 * Given the SoftwareLparID, return a list of all InstalledSoftware records --
	 * both active and inactive Calls HQL parserInstalledSoftware
	 */
	@SuppressWarnings("unchecked")
    public static List<InstalledSoftware> getInstalledSoftware(int softwareLparId)
			throws Exception {
		List<InstalledSoftware> list = null;
		Session session = getSession();

		list = session.getNamedQuery("parserInstalledSoftware").setInteger(
				"lparId", softwareLparId).list();

		closeSession(session);
		return list;
	}

	/*
	 * Given a SoftwareLparId and SoftwareId, return an InstalledSoftware record
	 * SoftwareId points to the sigbank software table Calls HQL
	 * parserIndividualInstalledSoftware
	 */
	public static InstalledSoftware getIndividualInstalledSoftware(
			int softwareLparId, int softwareId) throws Exception {
		Session session = getSession();

		InstalledSoftware installedSoftware = (InstalledSoftware) session
				.getNamedQuery("parserIndividualInstalledSoftware").setInteger(
						"softwareLparId", softwareLparId).setInteger(
						"softwareId", softwareId).uniqueResult();

		closeSession(session);
		return installedSoftware;
	}

	/*
	 * Given a HardwareLparId, return the HardwareLpar Calls HQL
	 * parserHardwareLpar
	 */
	public static HardwareLpar getHardwareLpar(int hardwareLparId)
			throws Exception {

		Session session = getSession();

		logger.debug("Looking for Id " + hardwareLparId);

		HardwareLpar hardware = (HardwareLpar) session.getNamedQuery(
				"parserHardwareLpar").setInteger("hardwareLparId",
				hardwareLparId).uniqueResult();

		closeSession(session);
		logger.debug("Found " + hardware.getName());
		return hardware;
	}

	/*
	 * Given a customerId, return the Customer Calls HQL parserCustomer
	 */
	public static Customer getCustomer(int customerId) throws Exception {

		Session session = getSession();

		Customer customer = (Customer) session.getNamedQuery("parserCustomer")
				.setInteger("customerId", customerId).uniqueResult();

		closeSession(session);
		return customer;
	}

	/*
	 * Given InstalledSoftwareId, SaProductId, and BankAccountId, return
	 * InstalledSaProduct Calls parserInstalledSaProduct
	 */
	public static InstalledSaProduct getInstalledSaProduct(
			int installedSoftwareId, int saProductId, int bankAccountId)
			throws Exception {
		InstalledSaProduct installedSaProduct = null;

		try {
			Session session = getSession();

			installedSaProduct = (InstalledSaProduct) session.getNamedQuery(
					"parserInstalledSaProduct").setInteger(
					"installedSoftwareId", installedSoftwareId).setInteger(
					"saProductId", saProductId).uniqueResult();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return installedSaProduct;
	}

	/*
	 * Given InstalledSoftwareId, SaProductId, and BankAccountId, return
	 * InstalledSaProduct Calls parserInstalledSaProduct
	 */
	public static InstalledDoranaProduct getInstalledDoranaProduct(
			int installedSoftwareId, int doranaProductId, int bankAccountId)
			throws Exception {
		InstalledDoranaProduct installedDoranaProduct = null;

		try {
			Session session = getSession();

			installedDoranaProduct = (InstalledDoranaProduct) session
					.getNamedQuery("parserInstalledDoranaProduct").setInteger(
							"installedSoftwareId", installedSoftwareId)
					.setInteger("doranaProductId", doranaProductId)
					.uniqueResult();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return installedDoranaProduct;
	}

	/*
	 * Given InstalledSoftwareId, VmProductId, and BankAccountId, return
	 * InstalledVmProduct Calls parserInstalledVmProduct
	 */
	public static InstalledVmProduct getInstalledVmProduct(
			int installedSoftwareId, int vmProductId, int bankAccountId)
			throws Exception {
		Session session = getSession();

		logger.debug("Looking for Installed SW Id " + installedSoftwareId);
		logger.debug("Looking for VM Prod Id " + vmProductId);
		logger.debug("Looking for Bank Id " + bankAccountId);

		InstalledVmProduct installedVmProduct = (InstalledVmProduct) session
				.getNamedQuery("parserInstalledVmProduct").setInteger(
						"installedSoftwareId", installedSoftwareId).setInteger(
						"vmProductId", vmProductId).setInteger("bankAccountId",
						bankAccountId).uniqueResult();

		closeSession(session);
		return installedVmProduct;
	}

	/*
	 * Given BankAccountId, return BankAccount Calls HQL parserBankAccount
	 */
	public static BankAccount getBankAccount(String bankName) throws Exception {
		Session session = getSession();

		BankAccount bankaccount = (BankAccount) session.getNamedQuery(
				"parserBankAccount").setString("bankName", bankName)
				.uniqueResult();

		closeSession(session);
		logger.debug("Found " + bankaccount.getName());

		// don't fail JUST because it couldn't find the bank account
		if (bankaccount == null) {
			logger.warn("Could not find sigbank type " + bankName
					+ " setting to type id 61");
			bankaccount = new BankAccount();
			bankaccount.setId(new Long(61));
		}
		return bankaccount;
	}

	/*
	 * Given softwareName, return Software Calls HQL parserSoftwareByName
	 */
	public static Software getSoftwareByName(String softwareName)
			throws Exception {
		Session session = getSession();

		Software software = (Software) session.getNamedQuery(
				"parserSoftwareByName").setString("softwareName", softwareName)
				.uniqueResult();

		closeSession(session);
		return software;

	}

	/*
	 * Next two functions are very closely related but NOT interchangable --
	 * getSaSoftware returns Software and getSaproduct returns getSaProduct.
	 * Both use parserSoftwareSa HQL and both take the product identifier as a
	 * string.
	 */

	/*
	 * Given productId , returns Software Calls parserSoftwareSa
	 */
	public static Product getSaSoftware(String productId) throws Exception {
		Session session = getSession();

		SaProduct saProduct = (SaProduct) session.getNamedQuery(
				"parserSoftwareSa").setString("productId", productId)
				.uniqueResult();

		closeSession(session);
		if (saProduct == null) {
			return null;
		}
		else {
			return saProduct.getSoftware();
		}
	}

	/*
	 * Given productId, returns SaProduct Calls parserSoftwareSa
	 */
	public static SaProduct getSaProduct(String productId) throws Exception {
		Session session = getSession();

		SaProduct saProduct = (SaProduct) session.getNamedQuery(
				"parserSoftwareSa").setString("productId", productId)
				.uniqueResult();

		closeSession(session);
		return saProduct;
	}

	public static DoranaProduct getDoranaProduct(String productId)
			throws Exception {

		Session session = getSession();

		DoranaProduct doranaProduct = (DoranaProduct) session.getNamedQuery(
				"parserSoftwareDorana").setString("productId", productId)
				.uniqueResult();

		closeSession(session);
		return doranaProduct;

	}

	/*
	 * Next two functions are very closely related but NOT interchangable --
	 * getVmSoftware returns Software and getVmProduct returns VmProduct. Both
	 * use parserSoftware HQL and both take the product identifier as a string.
	 */

	/*
	 * Given productId, return VmProduct Calls HQL parserSoftwareVm
	 */
	public static VmProduct getVmProduct(String productId) throws Exception {

		Session session = getSession();

		VmProduct vmProduct = (VmProduct) session.getNamedQuery(
				"parserSoftwareVm").setString("productId", productId)
				.uniqueResult();

		closeSession(session);
		return vmProduct;

	}

	/*
	 * Given productId , returns Software Calls parserSoftwareVm
	 */
	public static Product getVmSoftware(String productId) throws Exception {
		Session session = getSession();

		VmProduct vmProduct = (VmProduct) session.getNamedQuery(
				"parserSoftwareVm").setString("productId", productId)
				.uniqueResult();

		closeSession(session);
		if (vmProduct == null) {
			return null;
		}
		else {
			return vmProduct.getSoftware();
		}
	}

	/*
	 * Given hostname and customerId, return SoftwareLpar Calls HQL
	 * parserSoftwareLpar
	 */
	public static SoftwareLpar getSoftwareLpar(String hostname, int customerId)
			throws Exception {
		Session session = getSession();

		SoftwareLpar softwareLpar = (SoftwareLpar) session.getNamedQuery(
				"parserSoftwareLpar").setString("hostname", hostname)
				.setInteger("customerId", customerId).uniqueResult();
		closeSession(session);
		return softwareLpar;
	}

	public static void write(SwScan swScan) throws Exception {
		// The SwScan object contains everything we know about the scan
		// including a vector with the
		// the software
		Date now = new Date();
		String user = swScan.getUser().getRemoteUser();
		logger.debug("Attempting to write to database for file: "
				+ swScan.getFileName());
		SoftwareLpar swLpar;
		Map<Long, InstalledSoftware> oldSoftwareMap;

		// Before we write to the database, make this is a good file
		if (swScan.getGoodFile().booleanValue() == false) {
			swScan
					.getNotifyMessage()
					.add(
							swScan.getFileName()
									+ " was not a good file and will not be written to the database.");
			logger.warn(swScan.getNotifyMessage().lastElement());
			return;
		}

		// By-pass the SoftwareLpar and Composite routines if this is a manual
		// scan
		// Because those will be dealt with on a record by record basis instead
		// of
		// once for the entire scan
		if (!swScan.getScanType().equals("manual")) {
			swLpar = DelegateSwScan
					.getSoftwareLpar(swScan.getHardware().getName(), swScan
							.getCustomer().getCustomerId().intValue());
			if (swLpar == null) {
				String lparName = swScan.getHardware().getName();
				swLpar = new SoftwareLpar();
				swLpar.setName(swScan.getHardware().getName());
				swLpar.setCustomer(swScan.getCustomer());
				swLpar.setRecordTime(now);
				swLpar.setRemoteUser(user);
				swLpar.setStatus(Constants.ACTIVE);
				swLpar.setId(null);

				Session session = getSession();
				Transaction tx = session.beginTransaction();
				swScan.getNotifyMessage().add(
						"Added Software LPAR Name " + lparName);
				session.saveOrUpdate(swLpar);
				tx.commit();
				closeSession(session);

			}
			else {
				swLpar.setRecordTime(now);
				swLpar.setRemoteUser(user);
				swLpar.setStatus(Constants.ACTIVE);

				swScan.getNotifyMessage().add(
						"Updated Software LPAR Name "
								+ swScan.getHardware().getName());

				Session session = getSession();
				session.saveOrUpdate(swLpar);
				closeSession(session);

			}

			// logger.debug("Saved Software Lpar Object submitted by " + user);
			if (swLpar.getHardwareLpar() == null) {
				swScan.getNotifyMessage().add(
						"Did not find HW SW Composite -- created a new one");
				swLpar.setHardwareLpar(swScan.getHardware());
				// composite.setRecordTime(now);
				// composite.setRemoteUser(user);
				// composite.setStatus("ACTIVE");

				Session session = getSession();
				Transaction tx = session.beginTransaction();
				session.saveOrUpdate(swLpar);
				tx.commit();
				closeSession(session);

			}
			else {
				swScan.getNotifyMessage().add(
						"Found HW SW Composite -- updating existing one");
				// composite.setRecordTime(now);
				// composite.setRemoteUser(user);
				// composite.setStatus("ACTIVE");

				//Session session = getSession();
				//Transaction tx = session.beginTransaction();
				//session.saveOrUpdate(composite);
				//tx.commit();
				//closeSession(session);

			}
		}
		else {
			swLpar = null;
		}

		int numberProducts = swScan.getInstalledSoftware().size();
		swScan.getNotifyMessage().add(
				"Software rows in file: " + swScan.getFileName() + " = "
						+ numberProducts);
		logger.debug(swScan.getNotifyMessage().lastElement());
		if (!swScan.getScanType().equals("manual")) {
			List<InstalledSoftware> installedSoftware = DelegateSwScan.getInstalledSoftware(swLpar
					.getId().intValue());
			int numberOldProducts = installedSoftware.size();
			oldSoftwareMap = new HashMap<Long, InstalledSoftware>();
			Iterator<InstalledSoftware> i = installedSoftware.iterator();
			while (i.hasNext()) {
				InstalledSoftware o = (InstalledSoftware) i.next();
				oldSoftwareMap.put(o.getSoftware().getSoftwareId(), o);
			}
			swScan.getNotifyMessage().add(
					"DB2 already had " + numberOldProducts
							+ " installed products for this LPAR.");
			logger.debug(swScan.getNotifyMessage().lastElement());
		}
		else {
			oldSoftwareMap = null;
		}

		int c = 0;
		while (c < numberProducts) {
			// Get my software object
			InstalledSoftware s = new InstalledSoftware();
			ParserInstalledSoftware sParsed = (ParserInstalledSoftware) swScan
					.getInstalledSoftware().elementAt(c++);
			ScanProduct saProduct;
			if (swScan.getScanType().equals("softaudit")) {
				saProduct = (SaProduct) DelegateSwScan.getSaProduct(sParsed
						.getSoftwareId());
				if (saProduct == null) {
					swScan.getNotifyMessage().add(
							"FYI SKIP LINE: Did not find software ID "
									+ sParsed.getSoftwareId() + " "
									+ sParsed.getProductName()
									+ " in the current Sig-bank.");
					logger.debug(swScan.getNotifyMessage().lastElement());
				}
			}
			else if (swScan.getScanType().equals("dorana")) {
				saProduct = (DoranaProduct) DelegateSwScan
						.getDoranaProduct(sParsed.getSoftwareId());
				if (saProduct == null) {
					swScan.getNotifyMessage().add(
							"FYI SKIP LINE: Did not find software ID "
									+ sParsed.getSoftwareId() + " "
									+ sParsed.getProductName()
									+ " in the current Sig-bank.");
					logger.debug(swScan.getNotifyMessage().lastElement());
				}
			}
			else if (swScan.getScanType().equals("vm")) {
				saProduct = (VmProduct) DelegateSwScan.getVmProduct(sParsed
						.getSoftwareId());
				if (saProduct == null) {
					swScan.getNotifyMessage().add(
							"FYI SKIP LINE: Did not find software ID "
									+ sParsed.getSoftwareId() + " "
									+ sParsed.getProductName()
									+ " in the current Sig-bank.");
					logger.debug(swScan.getNotifyMessage().lastElement());
				}
			}
			else {
				saProduct = null;
			}

			/* Only deal with this as softaudit or vm IF Product is not NULL */
			if (saProduct != null) {
				Product software = saProduct.getSoftware();
				s = DelegateSoftware.getInstalledSoftware(software
						.getSoftwareId().toString(), swLpar.getId().toString());
				if (s == null) {
					s = new InstalledSoftware();
					// set to no discrepancy if new Installed Software else this
					// will keep the old discrepancy
					DiscrepancyType d = new DiscrepancyType();
					d.setId(new Long(1));
					d.setName("None");
					s.setDiscrepancyType(d);
				}
				s.setSoftware(software);
				s.setSoftwareLpar(swLpar);
				s.setRecordTime(now);
				s.setRemoteUser(user);
				s.setStatus(Constants.ACTIVE);

				s.setUsers(new Integer(0));
				s.setAuthenticated(new Integer(2));
				s.setProcessorCount(new Integer(0));
				s.setResearchFlag(new Boolean(false));

				/*
				 * Delete the entry in the existing map, if it exists and save
				 * or update accordingly
				 */
				if (oldSoftwareMap.containsKey(software.getSoftwareId())) {
					/*
					 * Instead of saving what we are building, pull up the
					 * existing and and update it
					 */
					InstalledSoftware tmp = (InstalledSoftware) oldSoftwareMap
							.get(saProduct.getSoftware().getSoftwareId());
					if (tmp != null) {
						s.setId(tmp.getId()); // cause record with ID
												// tmp.getId() to be updated
												// instead of create

						// false software hit or invalid discrepancy
						// ---- when the software is updated to inactive,
						// update history table saying it was closed,
						// then when activated switch to NONE discrepancy
						// bravo - missing - comes through staging, close
						// discrepancy to valid

						// if existing product is missing
						if (tmp.getDiscrepancyType().getName()
								.equalsIgnoreCase(Constants.MISSING)) {

							// set the discrepancy type to VALID
							DiscrepancyType discrepancyType = DelegateDiscrepancy
									.getDiscrepancyType(DelegateDiscrepancy.VALID);
							s.setDiscrepancyType(discrepancyType);

							// if the current record is active, create a
							// software discrepancy history record
							if (s.getStatus()
									.equalsIgnoreCase(Constants.ACTIVE)) {
								SoftwareDiscrepancyH history = new SoftwareDiscrepancyH();
								history.setInstalledSoftware(tmp);
								history.setComment("SA Loader autoclose");
								history.setRemoteUser(user);
								history.setAction("CLOSED "
										+ s.getDiscrepancyType().getName());

								// save or update the history
								Session session = getSession();
								Transaction tx = session.beginTransaction();
								session.saveOrUpdate(history);
								tx.commit();
								closeSession(session);
								swScan.getNotifyMessage().add(
										"Updated History -- "
												+ history.getAction()
												+ " for Installed Software ID "
												+ s.getId());

							}

							// save the installed software record
							Session session = getSession();
							Transaction tx = session.beginTransaction();
							session.saveOrUpdate(s);
							tx.commit();
							closeSession(session);
							swScan.getNotifyMessage().add(
									"Wrote " + s.getId()
											+ " Installed Software");

							// otherwise, if the existing record is inactive,
							// update it
						}
						else if (tmp.getStatus().equalsIgnoreCase(
								Constants.INACTIVE)) {

							// set the discrepancy type to NONE
							DiscrepancyType discrepancyType = DelegateDiscrepancy
									.getDiscrepancyType(DelegateDiscrepancy.NONE);
							tmp.setDiscrepancyType(discrepancyType);

							Session session = getSession();
							Transaction tx = session.beginTransaction();
							session.saveOrUpdate(s);
							tx.commit();
							closeSession(session);
							swScan.getNotifyMessage().add(
									"Wrote " + s.getId()
											+ " Installed Software");
						}

						oldSoftwareMap.remove(software.getSoftwareId());
					}
					else {
						logger.debug("Null old software");
					}
				}
				else {

					InstalledSoftware installedSoftware = DelegateSoftware
							.getInstalledSoftware(s.getSoftware()
									.getSoftwareId().toString(), s
									.getSoftwareLpar().getId().toString());

					if (installedSoftware == null) {
						Session session = getSession();
						Transaction tx = session.beginTransaction();
						session.saveOrUpdate(s);
						tx.commit();
						closeSession(session);
						swScan.getNotifyMessage().add(
								"Created Installed Software ID " + s.getId());
					}
					else {
						// This occurs due to grouping that was placed in the
						// SoftAudit / VM ID to sigbank ID
						swScan.getNotifyMessage().add(
								"Ignoring duplicate software records record -- SW LPAR ID "
										+ s.getSoftwareLpar().getId()
												.toString()
										+ " Software ID "
										+ s.getSoftware().getSoftwareId()
												.toString()
										+ " Installed Software ID "
										+ installedSoftware.getId());
						logger.warn(swScan.getNotifyMessage().lastElement());
					}
				}

				InstalledBase tmpInstalledProduct; // = new InstalledBase();
				InstalledBase orgInstalledProduct; // InstalledXXProduct from
													// last scan
				// InstalledSaProduct saTmpInstalledProduct = new
				// InstalledSaProduct();
				// InstalledVmProduct vmTmpInstalledProduct = new
				// InstalledVmProduct();
				if (swScan.getScanType().equals("softaudit")) {
					tmpInstalledProduct = new InstalledSaProduct();
					tmpInstalledProduct.setSaProduct((SaProduct) saProduct);
				}
				else if (swScan.getScanType().equals("vm")) {
					tmpInstalledProduct = new InstalledVmProduct();
					tmpInstalledProduct.setVmProduct((VmProduct) saProduct);
				}
				else if (swScan.getScanType().equals("dorana")) {
					tmpInstalledProduct = new InstalledDoranaProduct();
					tmpInstalledProduct
							.setDoranaProduct((DoranaProduct) saProduct);
				}
				else {
					tmpInstalledProduct = null;
					swScan.getNotifyMessage().add(
							"Trying to write an invalid scan type of "
									+ swScan.getScanType() + " for file "
									+ swScan.getFileName());
					logger.warn(swScan.getNotifyMessage().lastElement());
				}
				tmpInstalledProduct.setInstalledSoftware(s);
				tmpInstalledProduct.setRecordTime(now);
				tmpInstalledProduct.setStatus(Constants.ACTIVE);
				tmpInstalledProduct.setRemoteUser(user);
				String bankName;
				// Get bank account depending on which scanType
				// This most likely needs changed to include dorana
				if (swScan.getScanType().equals("softaudit")) {
					bankName = "SOFTADT";
				}
				else if (swScan.getScanType().equals("vm")) {
					bankName = "VMMF";
				}
				else if (swScan.getScanType().equals("dorana")) {
					bankName = "DORANA";
				}
				else {
					bankName = null;
				}
				BankAccount bankAccount = DelegateSwScan
						.getBankAccount(bankName);
				tmpInstalledProduct.setBankAccount(bankAccount);
				/* Only save if saProduct is not null */
				if ((saProduct != null) && (bankAccount != null)) {
					int productNumber;
					if (tmpInstalledProduct instanceof InstalledSaProduct) {
						productNumber = tmpInstalledProduct.getSaProduct()
								.getId().intValue();
						orgInstalledProduct = DelegateSwScan
								.getInstalledSaProduct(tmpInstalledProduct
										.getInstalledSoftware().getId()
										.intValue(), productNumber,
										tmpInstalledProduct.getBankAccount()
												.getId().intValue());
					}
					else if (tmpInstalledProduct instanceof InstalledVmProduct) {
						productNumber = tmpInstalledProduct.getVmProduct()
								.getId().intValue();
						orgInstalledProduct = DelegateSwScan
								.getInstalledVmProduct(tmpInstalledProduct
										.getInstalledSoftware().getId()
										.intValue(), productNumber,
										tmpInstalledProduct.getBankAccount()
												.getId().intValue());
					}
					else if (tmpInstalledProduct instanceof InstalledDoranaProduct) {
						productNumber = tmpInstalledProduct.getDoranaProduct()
								.getId().intValue();
						orgInstalledProduct = DelegateSwScan
								.getInstalledDoranaProduct(tmpInstalledProduct
										.getInstalledSoftware().getId()
										.intValue(), productNumber,
										tmpInstalledProduct.getBankAccount()
												.getId().intValue());
					}
					else {
						productNumber = 0;
						orgInstalledProduct = null;
					}

					if (orgInstalledProduct == null) {
						String notifyUpdateProduct;
						if (tmpInstalledProduct instanceof InstalledSaProduct) {
							notifyUpdateProduct = "Created New record SoftAudit InstalledSaProduct for Software ID "
									+ tmpInstalledProduct.getSaProduct()
											.getId();
							Session session = getSession();
							Transaction tx = session.beginTransaction();
							session
									.saveOrUpdate((InstalledSaProduct) tmpInstalledProduct);
							tx.commit();
							closeSession(session);

						}
						else if (tmpInstalledProduct instanceof InstalledVmProduct) {
							notifyUpdateProduct = "Created New record VM InstalledVmProduct for Software ID "
									+ tmpInstalledProduct.getVmProduct()
											.getId();
							Session session = getSession();
							Transaction tx = session.beginTransaction();
							session
									.saveOrUpdate((InstalledVmProduct) tmpInstalledProduct);
							tx.commit();
							closeSession(session);
						}
						else if (tmpInstalledProduct instanceof InstalledDoranaProduct) {
							notifyUpdateProduct = "Created New record Dorana for Software ID "
									+ tmpInstalledProduct.getDoranaProduct()
											.getId();
							Session session = getSession();
							Transaction tx = session.beginTransaction();
							session
									.saveOrUpdate((InstalledDoranaProduct) tmpInstalledProduct);
							tx.commit();
							closeSession(session);

						}
						else {
							notifyUpdateProduct = "Odd class for tmpInstalledProduct -- record NOT SAVED.";
						}
						swScan.getNotifyMessage().add(notifyUpdateProduct);
						logger.debug(swScan.getNotifyMessage().lastElement());
					}
					else {
						orgInstalledProduct.setStatus(Constants.ACTIVE);
						Session session = getSession();
						Transaction tx = session.beginTransaction();
						session.saveOrUpdate(orgInstalledProduct);
						tx.commit();
						closeSession(session);
						swScan.getNotifyMessage().add(
								"Updated existing InstalledProduct ID "
										+ orgInstalledProduct.getId());
						logger.debug(swScan.getNotifyMessage().lastElement());
					}
				}
				else {
					swScan
							.getNotifyMessage()
							.add(
									"Either Bank ID was null or the saProduct was null");
					logger.warn(swScan.getNotifyMessage().lastElement());
				}
			}
			else {
				// Either product is not valid OR this is a manual sheet
				if (!swScan.getScanType().equals("manual")) {
					// logger.debug("SWLPAR " + swLpar.getId() + " -- " +
					// sParsed.getProductName() + " -- In SCAN but not found in
					// available software");
				}
				else {
					// logger.debug("manual add " + sParsed.getProductName() + "
					// " + sParsed.getCpuSysName());
					// This block of code should not be executed at this time
					// Note that the attempt was made and exit
					swScan
							.getNotifyMessage()
							.add(
									"Attempted to write to the database for a manual file -- exited without writing to the database.");
					logger.error(swScan.getNotifyMessage().lastElement());
					return;
					// SoftwareLpar swIndividualLpar =
					// DelegateSwScan.getSoftwareLpar(sParsed.getCpuSysName(),
					// sParsed.getAccountId().intValue());
					// if ( swIndividualLpar == null ) {
					// logger.debug("Did not find SoftwareLpar -- attempted to
					// create new one based on account ID");
					// String lparName = sParsed.getCpuSysName();
					// swIndividualLpar = new SoftwareLpar();
					// swIndividualLpar.setName(lparName);
					// Customer customer = null;
					// customer =
					// DelegateSwScan.getCustomer(sParsed.getAccountId().intValue());
					// if ( customer != null ) {
					// swIndividualLpar.setCustomer(customer);
					// swIndividualLpar.setRecordTime(now);
					// swIndividualLpar.setRemoteUser(user);
					// swIndividualLpar.setStatus(Constants.ACTIVE);
					// swIndividualLpar.setId(null);
					//
					// Session session = getSession();
					// Transaction tx = session.beginTransaction();
					// session.saveOrUpdate(swIndividualLpar);
					// tx.commit();
					// closeSession(session);
					//							
					// } else {
					// logger.warn("Unable to create a new SoftwareLpar for
					// account " + sParsed.getAccountId());
					// }
					// } else {
					// logger.debug("Found SoftwareLpar -- updating existing
					// one");
					// swIndividualLpar.setRecordTime(now);
					// swIndividualLpar.setRemoteUser(user);
					// swIndividualLpar.setStatus(Constants.ACTIVE);
					//
					// Session session = getSession();
					// Transaction tx = session.beginTransaction();
					// session.saveOrUpdate(swIndividualLpar);
					// tx.commit();
					// closeSession(session);
					//						
					// }
					// Software software =
					// DelegateSwScan.getSoftwareByName(sParsed.getProductName());
					// // Only save if we have a valid Software and valid
					// SoftwareLpar
					// if ( ( software != null) && (swIndividualLpar != null) )
					// {
					// s.setSoftware(software);
					// s.setSoftwareLpar(swIndividualLpar);
					// InstalledSoftware tmpInstalledSoftware =
					// DelegateSwScan.getIndividualInstalledSoftware(
					// swIndividualLpar.getId().intValue(),
					// software.getSoftwareId().intValue());
					// if ( tmpInstalledSoftware == null ) {
					// s.setRecordTime(now);
					// s.setRemoteUser(user);
					// s.setStatus(Constants.ACTIVE);
					// DiscrepancyType d = new DiscrepancyType();
					// d.setId(new Long(1));
					// d.setName("None");
					// s.setDiscrepancyType(d);
					// s.setUsers(sParsed.getUsers());
					// s.setAuthenticated(new Boolean(false));
					// s.setProcessorCount(sParsed.getProcessorCount());
					// s.setResearchFlag(new Boolean(false));
					//
					// Session session = getSession();
					// Transaction tx = session.beginTransaction();
					// session.saveOrUpdate(s);
					// tx.commit();
					// closeSession(session);
					//							
					// } else {
					// s.setUsers(sParsed.getUsers());
					// s.setProcessorCount(sParsed.getProcessorCount());
					// tmpInstalledSoftware.setRecordTime(now);
					// tmpInstalledSoftware.setRemoteUser(user);
					// tmpInstalledSoftware.setStatus(Constants.ACTIVE);
					//
					// Session session = getSession();
					// Transaction tx = session.beginTransaction();
					// session.saveOrUpdate(tmpInstalledSoftware);
					// tx.commit();
					// closeSession(session);
					//							
					// }
					// }
				}
			}
		}
		swScan.getNotifyMessage().add(
				"Current SCAN has resulted in the need to inactivate "
						+ oldSoftwareMap.size() + " products.");
		logger.debug(swScan.getNotifyMessage().lastElement());
		/* set all of the ones not in the scan to inactive */
		if (!swScan.getScanType().equals("manual")) {
			for (Iterator<InstalledSoftware> oldProducts = oldSoftwareMap.values().iterator(); oldProducts
					.hasNext();) {
				InstalledSoftware tmp = (InstalledSoftware) oldProducts.next();

				// false software hit or invalid discrepancy
				// ---- when the software is updated to inactive,
				// update history table saying it was closed,
				// then when activated switch to NONE discrepancy
				// bravo - missing - comes through staging, close discrepancy to
				// valid

				swScan.getNotifyMessage().add(
						"No longer finding " + tmp.getId()
								+ " in the currecnt SCAN.");
				logger.debug(swScan.getNotifyMessage().lastElement());

				if (tmp.getStatus().equals(Constants.ACTIVE)) {

					if (tmp.getDiscrepancyType().getName().equalsIgnoreCase(
							Constants.FALSE_HIT_DISCREPANCY)
							|| tmp.getDiscrepancyType().getName()
									.equalsIgnoreCase(
											Constants.INVALID_DISCREPANCY)) {

						SoftwareDiscrepancyH history = new SoftwareDiscrepancyH();
						history.setInstalledSoftware(tmp);
						history.setComment("SA Loader autoclose");
						history.setRemoteUser(user);
						history.setAction("CLOSED "
								+ tmp.getDiscrepancyType().getName());

						// save or update the history
						Session session = getSession();
						Transaction tx = session.beginTransaction();
						session.saveOrUpdate(history);
						tx.commit();
						closeSession(session);
						swScan.getNotifyMessage().add(
								history.getAction()
										+ " for Installed Software ID "
										+ tmp.getId());
						logger.debug(swScan.getNotifyMessage().lastElement());
					}

					// only inactivate non-MISSING discrepancies
					if (!tmp.getDiscrepancyType().getName().equalsIgnoreCase(
							Constants.MISSING)) {
						tmp.setRecordTime(now);
						tmp.setRemoteUser(user);
						tmp.setStatus(Constants.INACTIVE);

						Session session = getSession();
						Transaction tx = session.beginTransaction();
						session.saveOrUpdate(tmp);
						tx.commit();
						closeSession(session);
						swScan.getNotifyMessage().add(
								"Setting Installed Software ID " + tmp.getId()
										+ " INACTIVE.");
						logger.debug(swScan.getNotifyMessage().lastElement());

					}
				}
			}
		}
	}

	/*
	 * Given a HardwareLparId, return the HardwareLpar Calls HQL
	 * parserHardwareLpar
	 */
	@SuppressWarnings("unchecked")
    public static List<HardwareLpar> getHardwareLpars(Long accountNumber)
			throws Exception {
		
		logger.debug("DelegateSwScan.getHardwareLpars account number = " 
				+ accountNumber);
	
		Session session = getSession();
	
		List<HardwareLpar> hardware = (List) session.getNamedQuery("parserHardwareLpars").setLong(
						"accountNumber", accountNumber.longValue()).list();
	
		closeSession(session);
		logger.debug("Found " + hardware.size() + " elements.");
		return hardware;
	}

}