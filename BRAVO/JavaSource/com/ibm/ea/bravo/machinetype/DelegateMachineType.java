package com.ibm.ea.bravo.machinetype;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

public abstract class DelegateMachineType extends HibernateDelegate {

	private static final Logger logger = Logger
			.getLogger(DelegateMachineType.class);

	public static void initForm(String id, FormMachineType form) {
		// go get the hardware lpar and hardware from id
		// id = hardware lpar id
		// query also does join fetch on hardware
		// HardwareLpar hardwareLpar = DelegateHardware.getHardwareLpar(id);

		// if (hardwareLpar != null)
		// form = new FormHardwareDiscrepancy();
		// populate form with data
	}

	@SuppressWarnings("unchecked")
    public static List<MachineType> search(String type, String search) throws Exception {
		List<MachineType> list = null;

		logger.debug("DelgateMachineType.machineTypeList type = " + type);
		logger.debug("DelgateMachineType.machineTypeList search = " + search);

		Session session = getSession();

		if (type.equalsIgnoreCase(Constants.NAME_SEARCH)) {
			list = session.getNamedQuery("searchMachineTypeName").setString(
					"name", "%" + search.toUpperCase() + "%").list();
		}

		if (type.equalsIgnoreCase(Constants.TYPE_SEARCH)) {
			list = session.getNamedQuery("searchMachineTypeType").setString(
					"type", "%" + search.toUpperCase() + "%").list();
		}

		if (type.equalsIgnoreCase(Constants.DEFINITION_SEARCH)) {
			list = session.getNamedQuery("searchMachineTypeDefinition")
					.setString("definition", "%" + search.toUpperCase() + "%")
					.list();
		}

		if (type.equalsIgnoreCase(Constants.MACHINETYPE_LISTALL)) {
			list = session.getNamedQuery("listMachineTypes").list();
		}

		if (type.equalsIgnoreCase(Constants.RECENTADD_SEARCH)) {
			list = session.getNamedQuery("listRecentAddMachineTypes").list();
		}

		logger.debug("DelgateMachineType.machineTypeList results generated "+list);

		closeSession(session);

		return list;
	}

	@SuppressWarnings("unchecked")
    public static List<Type> getTypeList() throws Exception {
		List<String> list = null;
		List<Type> types = new ArrayList<Type>();

		logger.debug("DelgateMachineType.getTypeList");

		Session session = getSession();

		list = session.getNamedQuery("listTypes").list();

		// build list of type objects
		if (list != null) {
			Iterator<String> i = list.iterator();
			while (i.hasNext()) {
				types.add(new Type((String) i.next()));
			}
		}

		logger
				.debug("DelgateMachineType.getTypeList results generated count = "
						+ list.size());

		closeSession(session);

		return types;
	}

	public static MachineType getMachineType(String id) throws Exception {
		logger.debug("DelgateMachineType.getMachineType");

		Session session = getSession();

		int machinetypeId = Integer.parseInt(id);

		MachineType machinetype = (MachineType) session.getNamedQuery(
				"getMachineType").setInteger("id", machinetypeId)
				.uniqueResult();

		closeSession(session);

		logger.debug("DelgateMachineType.getMachineType " + machinetype);

		return machinetype;
	}

	public static MachineType getMachineTypeByName(String name) {
		logger.debug("DelgateMachineType.getMachineTypeByName - " + name);
		MachineType machineType = null;

		try {
			Session session = getSession();

			machineType = (MachineType) session.getNamedQuery(
					"getMachineTypeByName").setString("name", name)
					.uniqueResult();

			closeSession(session);
		} catch (Exception e) {
			logger.debug(e, e);
		}

		logger.debug("DelgateMachineType.getMachineTypeByName " + machineType);

		return machineType;
	}

	public static FormMachineType save(FormMachineType mtForm) throws Exception {
		logger.debug("DelegateMachineType.save");
		// FormMachineType dbMachine = null;

		MachineType machineType = new MachineType();

		if (mtForm.getId() == null) {
			BeanUtils.copyProperties(machineType, mtForm);
			machineType.setId(null);
		} else {
			BeanUtils.copyProperties(machineType, mtForm);
		}

		logger.debug("machineType.Id = " + machineType.getId());
		logger.debug("machineType.Name = " + machineType.getName());
		logger.debug("machineType.Type = " + machineType.getType());

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.saveOrUpdate(machineType);
			logger.debug("DelegateMachineType.save - new ID = "
					+ machineType.getId());
			mtForm.setId(String.valueOf(machineType.getId()));

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return mtForm;
	}

	// public static FormMachineType delete(FormMachineType mtForm) throws
	// Exception{
	// logger.debug("DelegateMachineType.delete");
	// //FormMachineType dbMachine = null;
	//
	// MachineType machineType = new MachineType();
	//		
	// if (mtForm.getId() == null){
	// BeanUtils.copyProperties(machineType, mtForm);
	// machineType.setId(null);
	// }else{
	// BeanUtils.copyProperties(machineType, mtForm);
	// }
	//        
	//		
	// try {
	// Session session = getSession();
	// Transaction tx = session.beginTransaction();
	//			
	// // save or update the machineType
	// logger.debug("DelegateMachineType.delete - about to delete the record");
	// session.delete(machineType);
	//			
	// tx.commit();
	// closeSession(session);
	//			
	// } catch (Exception e) {
	// logger.error(e, e);
	// }
	//		
	// return mtForm;
	// }

	@SuppressWarnings("unchecked")
    public static List<Status> getStatusList() throws Exception {
		List<String> list = null;
		List<Status> status = new ArrayList<Status>();

		logger.debug("DelgateMachineType.getStatusList");

		Session session = getSession();

		list = session.getNamedQuery("listStatus").list();

		if (list != null) {
			Iterator<String> i = list.iterator();
			while (i.hasNext()) {
				status.add(new Status((String) i.next()));

			}
		}
		logger
				.debug("DelgateMachineType.getStatusList results generated count = "
						+ list.size());

		closeSession(session);

		return status;
	}

}