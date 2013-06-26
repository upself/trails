/*
 * Created on Mar 29, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.software;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessage;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.asset.trails.domain.ReconSoftware;
import com.ibm.tap.sigbank.filter.SoftwareFilterDelegate;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Delegate;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.framework.navigate.SearchForm;
import com.ibm.tap.sigbank.signature.SoftwareSignatureDelegate;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategory;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryDelegate;

public abstract class ProductDelegate extends Delegate {

	private static final String OPERATIING_SYSTEMS = "Operating Systems";
	static Logger logger = Logger.getLogger(ProductDelegate.class);

	public static ActionErrors validateSoftwareSearch(SearchForm ssf) {
		ActionErrors errors = new ActionErrors();

		if (Util.isBlankString(ssf.getSoftwareName())
				&& Util.isBlankString(ssf.getManufacturerId())
				&& Util.isBlankString(ssf.getSoftwareCategoryId())) {
			errors.add("softwareName", new ActionMessage("search.required"));
		}

		return errors;
	}

	public static List getProductSearchResults(SearchForm ssf)
			throws HibernateException, NamingException {

		List results = null;

		Session session = getHibernateSession();

		if (Util.isBlankString(ssf.getManufacturerId())
				&& Util.isBlankString(ssf.getSoftwareCategoryId())) {
			results = searchProductByName(ssf.getSoftwareName().toUpperCase(),
					results, session);
		} else if (Util.isBlankString(ssf.getManufacturerId())) {
			results = searchProductByNameAndCategory(ssf.getSoftwareName()
					.toUpperCase(), ssf.getSoftwareCategoryId(), results,
					session);
		} else if (Util.isBlankString(ssf.getSoftwareCategoryId())) {
			results = searchProductByNameAndManufacturer(ssf.getSoftwareName()
					.toUpperCase(), ssf.getManufacturerId(), results, session);
		} else {
			results = searchProductByNameManfCat(ssf.getSoftwareName()
					.toUpperCase(), ssf.getSoftwareCategoryId(), ssf
					.getManufacturerId(), results, session);
		}

		session.close();

		return results;
	}

	private static List searchProductByNameManfCat(String search,
			String softwareCategoryId, String manufacturerId, List results,
			Session session) {

		search = "%" + search + "%";

		results = session.getNamedQuery(
				"searchProductByNameManufacturerCategory").setString("search",
				search).setLong("manufacturerId",
				new Long(manufacturerId).longValue()).setLong(
				"softwareCategoryId", new Long(softwareCategoryId).longValue())
				.list();

		return results;
	}

	private static List searchProductByNameAndManufacturer(String search,
			String manufacturerId, List results, Session session) {

		search = "%" + search + "%";

		results = session.getNamedQuery("searchProductByNameAndManufacturer")
				.setString("search", search).setLong("manufacturerId",
						new Long(manufacturerId).longValue()).list();

		return results;
	}

	private static List searchProductByNameAndCategory(String search,
			String softwareCategoryId, List results, Session session) {

		search = "%" + search + "%";

		results = session.getNamedQuery("searchProductByNameAndCategory")
				.setString("search", search).setLong("softwareCategoryId",
						new Long(softwareCategoryId).longValue()).list();

		return results;
	}

	public static List searchProductByName(String search)
			throws HibernateException, NamingException {

		List products = null;

		Session session = getHibernateSession();

		products = searchProductByName(search, products, session);

		session.close();

		return products;
	}

	public static List searchProductByName(String search, List results,
			Session session) {

		search = "%" + search + "%";

		results = session.getNamedQuery("searchProductByName").setString(
				"search", search).list();

		return results;
	}

	private static Integer getPriority(SoftwareCategory softwareCategory,
			Integer priority, Session session) {
		priority = (Integer) session.getNamedQuery("getMaxCategoryPriority")
				.setEntity("softwareCategory", softwareCategory).uniqueResult();

		if (priority == null) {
			priority = new Integer("1");
		}

		return priority;
	}

	public static Product getProductByName(String productName)
			throws HibernateException, NamingException {

		Product software = null;

		Session session = getHibernateSession();

		software = getProductByName(productName, software, session);

		session.close();

		return software;
	}

	public static Product getProductByName(String productName, Product result,
			Session session) {

		productName = productName.toUpperCase();
		result = (Product) session.getNamedQuery("productByNameFirstSearch")
				.setString("productName", productName).uniqueResult();
		if (result == null)
			result = (Product) session.getNamedQuery(
					"productByNameSecondSearch").setString("productName",
					productName).uniqueResult();
		return result;
	}
	
	public static Product getNonTadzProductByName(String productName, Product result,
			Session session) {

		productName = productName.toUpperCase();
		result = (Product) session.getNamedQuery("nonTadzProductByNameFirstSearch")
				.setString("productName", productName).uniqueResult();
		if (result == null)
			result = (Product) session.getNamedQuery(
					"nonTadzProductByNameSecondSearch").setString("productName",
					productName).uniqueResult();
		return result;
	}

	public static SoftwareForm setUpdateForm(String softwareId)
			throws IllegalAccessException, InvocationTargetException,
			HibernateException, NamingException {

		Product product = getProduct(softwareId);

		SoftwareForm softwareForm = new SoftwareForm();
		softwareForm.setSoftwareId(softwareId);
		softwareForm.setSoftwareName(product.getName());
		softwareForm.setManufacturer(product.getManufacturer()
				.getManufacturerName());
		if (product.getVendorManaged() != null
				&& product.getVendorManaged().equalsIgnoreCase("TRUE"))
			softwareForm.setVendorManaged("TRUE");
		else
			softwareForm.setVendorManaged("FALSE");
		if (product.getDeleted())
			softwareForm.setStatus("INACTIVE");
		else
			softwareForm.setStatus("ACTIVE");

		if (product.getProductInfo() != null) {
			softwareForm
					.setSoftwareCategory(product.getProductInfo()
							.getSoftwareCategory().getSoftwareCategoryName()
							.toString());
			if (product.getProductInfo().isLicensable())
				softwareForm.setLevel("LICENSABLE");
			else
				softwareForm.setLevel("UN-LICENSABLE");
			softwareForm.setPriority(product.getProductInfo().getPriority()
					.toString());
		}
		softwareForm.setChangeJustification(null);
		softwareForm.setComments(null);

		return softwareForm;
	}

	private static List getProducts(List selected, List results, Session session) {
		results = session.getNamedQuery("productByIdList").setParameterList(
				"ids", selected).list();
		return results;
	}

	public static void updateProductSoftwareCategory(SoftwareCategory from,
			SoftwareCategory to, String remoteUser, Session session)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		List products = null;
		products = getProducts(from, products, session);
		changeSoftwareSoftwareCategory(products, to, from
				.getChangeJustification(), "SOFTWARE CATEGORY CHANGE",
				remoteUser, session);

	}

	public static void changeSoftwareSoftwareCategory(List products,
			SoftwareCategory to, String changeJustification, String comments,
			String remoteUser, Session session) throws HibernateException,
			NamingException, IllegalAccessException, InvocationTargetException {

		// If we are moving software to an inactive software category, we need
		// to
		// activate the software category
		if (to.getStatus().equals(Constants.INACTIVE)) {
			to.setStatus(Constants.ACTIVE);
			to.setChangeJustification(changeJustification);
			to.setComments(comments);
			SoftwareCategoryDelegate.save(to, remoteUser, session);
		}

		Integer priority = null;
		priority = getPriority(to, priority, session);

		Iterator i = products.iterator();
		while (i.hasNext()) {
			Product product = (Product) i.next();
			if (product.getProductInfo().getSoftwareCategory()
					.getSoftwareCategoryName().equals(
							to.getSoftwareCategoryName())) {
				continue;
			}
			SoftwareCategory from = product.getProductInfo()
					.getSoftwareCategory();
			if (!product.getDeleted()
					&& (OPERATIING_SYSTEMS.equals(from
							.getSoftwareCategoryName()) || OPERATIING_SYSTEMS
							.equals(to.getSoftwareCategoryName()))) {
				addToReconSoftware(product, "OS", session);
			} else
				addToReconSoftware(product, "UPDATE", session);
			addToProductInfoH(product.getProductInfo(), session);
			product.getProductInfo().setSoftwareCategory(to);
			product.getProductInfo()
					.setChangeJustification(changeJustification);
			product.getProductInfo().setComments(comments);
			if (product.getDeleted())
				product.getProductInfo().setPriority(0);
			else {
				product.getProductInfo().setPriority(priority);
				priority = new Integer(priority.intValue() + 1);
			}
			saveProduct(product, remoteUser, session);

		}
	}

	private static void addToProductInfoH(ProductInfo productInfo,
			Session session) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {
		ProductInfoH productInfoH = new ProductInfoH();
		BeanUtils.copyProperties(productInfoH, productInfo);
		productInfoH.setSoftwareCategory(productInfo.getSoftwareCategory()
				.getSoftwareCategoryName());
		productInfoH.setProductInfo(productInfo);
		session.save(productInfoH);
	}

	private static void addToReconSoftware(Product product, String action,
			Session session) throws HibernateException, NamingException {
		ReconSoftware reconSoftware = new ReconSoftware();
		reconSoftware.setAction(action);
		reconSoftware.setProduct(product);
		reconSoftware.setRecordTime(new Date());
		reconSoftware.setRemoteUser("SIGBANK");
		session.save(reconSoftware);
	}

	public static List getProducts(SoftwareCategory softwareCategory)
			throws HibernateException, Exception {

		List products = null;

		Session session = getHibernateSession();

		products = getProducts(softwareCategory, products, session);

		session.close();

		return products;
	}

	public static List getProducts(SoftwareCategory softwareCategory,
			List results, Session session) {

		results = session.getNamedQuery("productBySoftwareCategory").setEntity(
				"softwareCategory", softwareCategory).list();

		return results;
	}

	public static ActionErrors updateProductSoftwareCategory(
			SoftwareForm softwareForm, String remoteUser)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		ActionErrors errors = new ActionErrors();
		List<Long> selected = new Vector<Long>();

		for (int i = 0; i < softwareForm.getSelectedItems().length; i++) {
			if (Util.isInt(softwareForm.getSelectedItems()[i])) {
				selected.add(new Long(softwareForm.getSelectedItems()[i]));
			}
		}

		SoftwareCategory to = null;
		to = SoftwareCategoryDelegate.getSoftwareCategory(softwareForm
				.getSoftwareCategory(), to, session);

		List products = null;
		products = getProducts(selected, products, session);

		changeSoftwareSoftwareCategory(products, to, softwareForm
				.getChangeJustification(), softwareForm.getComments(),
				remoteUser, session);

		tx.commit();
		session.close();

		// Return the errors
		return errors;
	}

	public static void changeSoftwarePriority(SoftwareForm sf, String remoteUser)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		Session session = getHibernateSession();

		int newPriority = new Integer(sf.getPriority()).intValue();

		Product product = null;
		product = getProduct(sf.getSoftwareId(), product, session);

		if ((product.getDeleted() && product.getProductInfo().getPriority()
				.intValue() != 0)
				|| (!product.getDeleted() && product.getProductInfo()
						.getPriority().intValue() != newPriority)) {

			Transaction tx = session.beginTransaction();

			addToProductInfoH(product.getProductInfo(), session);
			if (product.getDeleted())
				product.getProductInfo().setPriority(0);
			else
				product.getProductInfo().setPriority(new Integer(newPriority));
			product.getProductInfo().setChangeJustification(
					sf.getChangeJustification());
			product.getProductInfo().setComments(sf.getComments());
			saveProduct(product, remoteUser, session);
			addToReconSoftware(product, "UPDATE", session);
			tx.commit();

			tx = session.beginTransaction();

			List priorities = null;
			priorities = getProductPriorityOrder(product.getProductInfo()
					.getSoftwareCategory(), priorities, session);

			Iterator i = priorities.iterator();
			int currentPriority = 1;

			while (i.hasNext()) {
				Product prod = (Product) i.next();
				if (prod.getDeleted()) {
					if (prod.getProductInfo().getPriority().intValue() == 0) {
						continue;
					} else {
						prod.getProductInfo().setPriority(0);
						prod.getProductInfo().setChangeJustification(
								sf.getChangeJustification());
						prod.getProductInfo().setComments(sf.getComments());
						saveProduct(prod, remoteUser, session);
					}
				} else if (prod.getProductInfo().getPriority().intValue() != currentPriority) {
					if (prod.getId() != product.getId()) {
						addToReconSoftware(prod, "UPDATE", session);
						addToProductInfoH(prod.getProductInfo(), session);
					}
					prod.getProductInfo().setPriority(
							new Integer(currentPriority));
					prod.getProductInfo().setChangeJustification(
							sf.getChangeJustification());
					prod.getProductInfo().setComments(sf.getComments());
					saveProduct(prod, remoteUser, session);
				}
				if (!prod.getDeleted()) {
					currentPriority++;
				}
			}

			tx.commit();
		}
		session.close();
	}

	private static List getProductPriorityOrder(
			SoftwareCategory softwareCategory, List priorities, Session session) {

		priorities = session.getNamedQuery("productPriorityOrder").setEntity(
				"softwareCategory", softwareCategory).list();
		return priorities;
	}

	public static List getProducts() throws HibernateException, Exception {

		List products = null;

		Session session = getHibernateSession();

		products = getProducts(products, session);

		session.close();

		return products;
	}

	public static List getProducts(List results, Session session) {

		results = session.getNamedQuery("products").list();

		return results;
	}

	public static Product getProduct(String id) throws HibernateException,
			NamingException {

		Product product = null;

		Session session = getHibernateSession();

		product = getProduct(id, product, session);

		session.close();

		return product;
	}

	public static Product getProduct(String id, Product product, Session session) {

		product = (Product) session.getNamedQuery("productById").setLong(
				"productId", new Long(id).longValue()).uniqueResult();

		return product;
	}

	public static void saveProduct(Product product, String remoteUser,
			Session session) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		product.getProductInfo().setRecordTime(new Date());
		product.getProductInfo().setRemoteUser(remoteUser);

		session.update(product);
	}

}