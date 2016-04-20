package com.ibm.asset.trails.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.ReconCustomerSoftware;
import com.ibm.asset.trails.domain.ReconInstalledSoftware;
import com.ibm.asset.trails.domain.ReconPriorityISVSoftware;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFH;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ManufacturerService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.ea.common.InvalidException;
import com.ibm.tap.trails.framework.DisplayTagList;

@Service
public class ScheduleFServiceImpl implements ScheduleFService {

	private EntityManager em;

	@Autowired
	private AccountService accountService;
	
	@Autowired
	private ManufacturerService manufactuerService;

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ScheduleF findScheduleF(Long plScheduleFId, Account pAccount,
			Software pSoftware) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFByAccountAndSwNotId")
				.setParameter("account", pAccount)
				.setParameter("softwareName", pSoftware.getSoftwareName())
				.setParameter("id", plScheduleFId).getResultList();
		ScheduleF result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}

		return result;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ScheduleF findScheduleF(Account pAccount, Software pSoftware) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFByAccountAndSw")
				.setParameter("account", pAccount)
				.setParameter("softwareName", pSoftware.getSoftwareName())
				.getResultList();
		ScheduleF result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}

		return result;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<ScheduleF> findScheduleF(Account pAccount, String softwareName, String level) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFByAccountAndSwAndLevel")
				.setParameter("account", pAccount)
				.setParameter("softwareName", softwareName)
				.setParameter("level", level).getResultList();

		if (results == null || results.isEmpty()) {
			results = null;
		} else {
			return results;
		}
		return results;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<ScheduleF> findScheduleFbyManufacturer(Account pAccount, String manufacturerName,	String level) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFByAccountAndManAndLevel")
				.setParameter("account", pAccount)
				.setParameter("manufacturerName", manufacturerName)
				.setParameter("level", level).getResultList();

		if (results == null || results.isEmpty()) {
			results = null;
		} else {
			return results;
		}
		return results;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ArrayList<Software> findSoftwareByManufacturer(String manufacturerName) {
		@SuppressWarnings("unchecked")
		ArrayList<Software> softwareforList =  (ArrayList<Software>) getEntityManager()
				.createNamedQuery("softwareByManufacturerName")
				.setParameter("manufacturerName", manufacturerName)
				.getResultList();
		
		if (softwareforList == null || softwareforList.isEmpty()) {
			softwareforList = null;
		} else {
			return softwareforList;
		}

		return softwareforList;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ArrayList<Software> findSoftwareBySoftwareName(String psSoftwareName) {
		@SuppressWarnings("unchecked")
		ArrayList<Software> lalSoftware = (ArrayList<Software>) getEntityManager()
				.createNamedQuery("softwareBySoftwareName")
				.setParameter("name", psSoftwareName.toUpperCase())
				.getResultList();

		if (lalSoftware.size() > 0) {
			return lalSoftware;
		} else {
			List resultList = getEntityManager()
					.createNamedQuery("softwareByAliasName")
					.setParameter("name", psSoftwareName.toUpperCase())
					.getResultList();

			ArrayList<Software> softwareforList = new ArrayList<Software>();
			if (!resultList.isEmpty()) {
				// loop the result list to get the product information
				// aggregation.
				for (Object resultElement : resultList) {
					if (!(resultElement instanceof Object[])) {
						continue;
					}

					for (Object object : (Object[]) resultElement) {
						if (object instanceof Software) {
							softwareforList.add((Software) object);
						}
					}
				}
			}
			if (softwareforList.isEmpty()) {
				@SuppressWarnings("unchecked")
				ArrayList<Software> linalSoftware = (ArrayList<Software>) getEntityManager()
						.createNamedQuery("inactiveSoftwareBySoftwareName")
						.setParameter("name", psSoftwareName.toUpperCase())
						.getResultList();
				if (linalSoftware.size() > 0) {
					for (Software object : linalSoftware) {
						softwareforList.add((Software) object);
					}

				} else {
					List inacSWResultList = getEntityManager()
							.createNamedQuery("inactiveSoftwareByAliasName")
							.setParameter("name", psSoftwareName.toUpperCase())
							.getResultList();
					if (!inacSWResultList.isEmpty()) {
						for (Object resultElement : inacSWResultList) {
							if (!(resultElement instanceof Object[])) {
								continue;
							}

							for (Object object : (Object[]) resultElement) {
								if (object instanceof Software) {
									softwareforList.add((Software) object);
								}
							}
						}
					}
				}
			}
			return softwareforList;
		}
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<MachineType> findMachineTypebyName(String name) {
		@SuppressWarnings("unchecked")
		List<MachineType> results = getEntityManager()
				.createNamedQuery("machineTypeDetailsByName")
				.setParameter("name", name).getResultList();

		if (results == null || results.isEmpty()) {
			results = null;
		} else {
			return results;
		}
		return results;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ScheduleF getScheduleFDetails(Long plScheduleFId) {
		return (ScheduleF) getEntityManager()
				.createNamedQuery("scheduleFDetails")
				.setParameter("id", plScheduleFId).getSingleResult();
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ArrayList<Scope> getScopeList() {
		return (ArrayList<Scope>) getEntityManager().createNamedQuery(
				"scopeList").getResultList();
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ArrayList<Source> getSourceList() {
		return (ArrayList<Source>) getEntityManager().createNamedQuery(
				"sourceList").getResultList();
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ArrayList<Status> getStatusList() {
		return (ArrayList<Status>) getEntityManager().createNamedQuery(
				"statusList").getResultList();
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ArrayList<String> getLevelList() {
		return (ArrayList<String>) getEntityManager().createNativeQuery(
				"select level from eaadmin.schedule_f group by level")
				.getResultList();
	}

	// TODO Not sure if this is best way to do validation, perhaps we can reuse
	// the validation for the gui
	// I don't particularly like the way I setup the methods, may look at
	// later..it works
	// Probably would be better if I had requirements on error handling
	// We are just stopping at the first error per row here
	@Transactional(readOnly = true, propagation = Propagation.REQUIRES_NEW)
	public ByteArrayOutputStream loadSpreadsheet(File file, String psRemoteUser)
			throws IOException {
		FileInputStream fin = new FileInputStream(file);
		HSSFWorkbook wb = new HSSFWorkbook(fin);
		HSSFSheet sheet = wb.getSheetAt(0);
		Iterator liRow = null;
		HSSFRow row = null;
		ScheduleF sf = null;
		boolean error = false;
		StringBuffer lsbErrorMessage = null;
		StringBuffer successMessage = null;
		HSSFCellStyle lcsError = wb.createCellStyle();
		HSSFCellStyle lcsNormal = wb.createCellStyle();
		HSSFCellStyle lcsMessage = wb.createCellStyle();
		HSSFCell cell = null;
		boolean lbHeaderRow = false;

		lcsError.setFillForegroundColor(HSSFColor.RED.index);
		lcsError.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		lcsNormal.setFillForegroundColor(HSSFColor.WHITE.index);
		lcsNormal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		lcsMessage.setFillForegroundColor(HSSFColor.YELLOW.index);
		lcsMessage.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

		for (liRow = sheet.rowIterator(); liRow.hasNext();) {
			row = (HSSFRow) liRow.next();
			sf = new ScheduleF();
			error = false;
			lsbErrorMessage = new StringBuffer();
			successMessage  = new StringBuffer();
			lbHeaderRow = false;

			for (int i = 0; i <= 14; i++) {
				cell = row.getCell(i);
				if (cell == null) {
					cell = row.createCell(i);
					if (i == 0 || i == 5 || i > 7) {
						cell.setCellStyle(lcsError);
						lsbErrorMessage.append(error ? "\n" : "").append(
								getErrorMessage(i));
						error = true;
					}
				} else {
					cell.setCellStyle(lcsNormal);

					try {
						if (row.getRowNum() == 0 && cell.getColumnIndex() == 0) {
							lbHeaderRow = true;
							break;
						} else {
							parseCell(cell, sf);
						}
					} catch (InvalidException nv) {
						cell.setCellStyle(lcsMessage);
						successMessage.append(nv.getMessage())
								.append(" BUT ");
					} catch (Exception e) {
						cell.setCellStyle(lcsError);
						// e.printStackTrace();
						lsbErrorMessage.append(error ? "\n" : "").append(
								e.getMessage());
						error = true;
					}
				}
			}

			if (!lbHeaderRow) {
				if (error) {
					cell = row.createCell(16);
					cell.setCellStyle(lcsError);
					cell.setCellValue(new HSSFRichTextString(lsbErrorMessage
							.toString()));
				} else if (sf.getAccount() != null
						&& (sf.getSoftware() != null || sf.getManufacturer() != null)
						&& sf.getLevel() != null) {
					List<ScheduleF> lsfExists = null;
					if (sf.getLevel()
							.toString()
							.equals(ScheduleFLevelEnumeration.MANUFACTURER
									.toString())) {
						lsfExists = findScheduleFbyManufacturer(
								sf.getAccount(), sf.getManufacturer(),
								sf.getLevel());
					} else {
						lsfExists = findScheduleF(sf.getAccount(),
								sf.getSoftwareName(), sf.getLevel());
					}
					if (lsfExists != null) {
						for (ScheduleF existsSF : lsfExists) {
							if (existsSF instanceof ScheduleF) {
								if (sf.getLevel()
										.toString()
										.equals(ScheduleFLevelEnumeration.PRODUCT
												.toString())) {
									sf.setId(existsSF.getId());
								} else if ((sf
										.getLevel()
										.toString()
										.equals(ScheduleFLevelEnumeration.MANUFACTURER
												.toString()) && sf
										.getManufacturer().equals(
												existsSF.getManufacturer()))
										|| (sf.getLevel()
												.toString()
												.equals(ScheduleFLevelEnumeration.HWOWNER
														.toString()) && sf
												.getHwOwner().equals(
														existsSF.getHwOwner()))
										|| (sf.getLevel()
												.toString()
												.equals(ScheduleFLevelEnumeration.HOSTNAME
														.toString()) && sf
												.getHostname().equals(
														existsSF.getHostname()))
										|| (sf.getLevel()
												.toString()
												.equals(ScheduleFLevelEnumeration.HWBOX
														.toString())
												&& sf.getMachineType()
														.equals(existsSF
																.getMachineType()) && sf
												.getSerial().equals(
														existsSF.getSerial()))) {
									sf.setId(existsSF.getId());
								}
							}
						}
					}
					saveScheduleF(sf, psRemoteUser);
					cell = row.createCell(16);
					cell.setCellStyle(lcsMessage);
					cell.setCellValue(new HSSFRichTextString(successMessage.append("YOUR TEMPLATE UPLOAD SUCCESSFULLY").toString()));
				}
			}
		}

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);

		return bos;
	}

	@SuppressWarnings("null")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public void insertInswRecon(List<InstalledSoftware> installedswlist,
			String psRemoteUser) {

		if (installedswlist != null && !installedswlist.isEmpty()) {
			for (InstalledSoftware inswtemp : installedswlist) {
				@SuppressWarnings("unchecked")
				List<ReconInstalledSoftware> results = getEntityManager()
						.createNamedQuery("reconInstalledSWbyInswIdANDCsId")
						.setParameter("account",
								inswtemp.getSoftwareLpar().getAccount())
						.setParameter("installedSoftware", inswtemp)
						.getResultList();
				if (results == null || results.isEmpty()) {
					ReconInstalledSoftware rcInswSave = new ReconInstalledSoftware();
					rcInswSave.setAccount(inswtemp.getSoftwareLpar()
							.getAccount());
					rcInswSave.setInstalledSoftware(inswtemp);
					rcInswSave.setAction("UPDATE");
					rcInswSave.setRecordTime(new Date());
					rcInswSave.setRemoteUser(psRemoteUser);
					getEntityManager().persist(rcInswSave);
				}
			}
		}
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public void saveScheduleF(ScheduleF psfSave, String psRemoteUser) {
		boolean lbSaveReconRow = false;
		boolean lbSaveExistReconRow = false;
		if (psfSave.getId() != null && ((!psfSave.getLevel().equals(
				ScheduleFLevelEnumeration.MANUFACTURER.toString()) && psfSave.getSoftware() != null) || (psfSave.getLevel().equals(
						ScheduleFLevelEnumeration.MANUFACTURER.toString())))) {
			ScheduleF lsfExists = findScheduleF(psfSave.getId());
			ScheduleFH lsfhSave = new ScheduleFH();
			// Determine if we should insert a row into the Recon_Customer_Sw
			// table
			// for the new data and the old data

			if (!psfSave.getScope().equals(lsfExists.getScope())
					|| !psfSave.getStatus().equals(lsfExists.getStatus())) {
				lbSaveExistReconRow = true;
			}
			
			if (!psfSave.getLevel().equals(lsfExists.getLevel())){
				lbSaveReconRow = true;
				lbSaveExistReconRow = true;
			}
			
            if (psfSave.getSoftwareName() != null && lsfExists.getSoftwareName() != null){
			if (!psfSave.getSoftwareName().equals(lsfExists.getSoftwareName())) {
				lbSaveReconRow = true;
				lbSaveExistReconRow = true;
			}
            } else if ((psfSave.getSoftwareName() != null && lsfExists.getSoftwareName() == null) || (psfSave.getSoftwareName() == null && lsfExists.getSoftwareName() != null)){
            	lbSaveReconRow = true;
				lbSaveExistReconRow = true;
            }
			
			if (!psfSave.getManufacturer().equals(lsfExists.getManufacturer()) && (psfSave.getLevel().equals(ScheduleFLevelEnumeration.MANUFACTURER.toString()) || lsfExists.getLevel().equals(ScheduleFLevelEnumeration.MANUFACTURER.toString()))){
					lbSaveReconRow = true;
					lbSaveExistReconRow = true;
			} 

			if (psfSave.getHostname() != null
					&& lsfExists.getHostname() != null) {
				if (!psfSave.getHostname().equals(lsfExists.getHostname())) {
					lbSaveReconRow = true;
					lbSaveExistReconRow = true;
				}
			} else if ((psfSave.getHostname() != null && lsfExists
					.getHostname() == null)
					|| (psfSave.getHostname() == null && lsfExists
							.getHostname() != null)) {
				lbSaveReconRow = true;
				lbSaveExistReconRow = true;
			}

			if (psfSave.getHwOwner() != null && lsfExists.getHwOwner() != null) {
				if (!psfSave.getHwOwner().equals(lsfExists.getHwOwner())) {
					lbSaveReconRow = true;
					lbSaveExistReconRow = true;
				}
			} else if ((psfSave.getHwOwner() != null && lsfExists.getHwOwner() == null)
					|| (psfSave.getHwOwner() == null && lsfExists.getHwOwner() != null)) {
				lbSaveReconRow = true;
				lbSaveExistReconRow = true;
			}

			if (psfSave.getMachineType() != null
					&& lsfExists.getMachineType() != null) {
				if (!psfSave.getMachineType()
						.equals(lsfExists.getMachineType())) {
					lbSaveReconRow = true;
					lbSaveExistReconRow = true;
				}
			} else if ((psfSave.getMachineType() != null && lsfExists
					.getMachineType() == null)
					|| (psfSave.getMachineType() == null && lsfExists
							.getMachineType() != null)) {
				lbSaveReconRow = true;
				lbSaveExistReconRow = true;
			}

			if (psfSave.getSerial() != null && lsfExists.getSerial() != null) {
				if (!psfSave.getSerial().equals(lsfExists.getSerial())) {
					lbSaveReconRow = true;
					lbSaveExistReconRow = true;
				}
			} else if ((psfSave.getSerial() != null && lsfExists.getSerial() == null)
					|| (psfSave.getSerial() == null && lsfExists.getSerial() != null)) {
				lbSaveReconRow = true;
				lbSaveExistReconRow = true;
			}

			// Insert a ScheduleFH record
			lsfhSave.setScheduleF(lsfExists);
			lsfhSave.setAccount(lsfExists.getAccount());
			lsfhSave.setSoftware(lsfExists.getSoftware());
			lsfhSave.setSoftwareTitle(lsfExists.getSoftwareTitle());
			lsfhSave.setSoftwareName(lsfExists.getSoftwareName());
			lsfhSave.setManufacturer(lsfExists.getManufacturer());
			lsfhSave.setLevel(lsfExists.getLevel());
			lsfhSave.setHwOwner(lsfExists.getHwOwner());
			lsfhSave.setMachineType(lsfExists.getMachineType());
			lsfhSave.setSerial(lsfExists.getSerial());
			lsfhSave.setHostname(lsfExists.getHostname());
			lsfhSave.setScope(lsfExists.getScope());

			// AB added
			lsfhSave.setSWFinanceResp(lsfExists.getSWFinanceResp());

			lsfhSave.setSource(lsfExists.getSource());
			lsfhSave.setSourceLocation(lsfExists.getSourceLocation());
			lsfhSave.setStatus(lsfExists.getStatus());
			lsfhSave.setBusinessJustification(lsfExists
					.getBusinessJustification());
			lsfhSave.setRemoteUser(lsfExists.getRemoteUser());
			lsfhSave.setRecordTime(lsfExists.getRecordTime());
			getEntityManager().persist(lsfhSave);

			// Update the ScheduleF record
			lsfExists.setLevel(psfSave.getLevel());
			lsfExists.setHwOwner(psfSave.getHwOwner());
			lsfExists.setMachineType(psfSave.getMachineType());
			lsfExists.setSerial(psfSave.getSerial());
			lsfExists.setHostname(psfSave.getHostname());
			lsfExists.setAccount(psfSave.getAccount());
			lsfExists.setSoftware(psfSave.getSoftware());
			lsfExists.setSoftwareTitle(psfSave.getSoftwareTitle());
			lsfExists.setSoftwareName(psfSave.getSoftwareName());
			lsfExists.setManufacturer(psfSave.getManufacturer());
			lsfExists.setManufacturerName(psfSave.getManufacturerName());
			lsfExists.setScope(psfSave.getScope());
			lsfExists.setSource(psfSave.getSource());
			lsfExists.setSourceLocation(psfSave.getSourceLocation());
			lsfExists.setStatus(psfSave.getStatus());
			lsfExists.setBusinessJustification(psfSave
					.getBusinessJustification());
			lsfExists.setRemoteUser(psRemoteUser);
			lsfExists.setRecordTime(new Date());

			// AB added
			lsfExists.setSWFinanceResp(psfSave.getSWFinanceResp());

			getEntityManager().merge(lsfExists);
			getEntityManager().flush();

			if (lbSaveExistReconRow) {
				if (lsfhSave.getLevel().equals(
						ScheduleFLevelEnumeration.PRODUCT.toString())) {
					ArrayList<Software> llProductInfo = null;
					llProductInfo = findSoftwareBySoftwareName(lsfhSave
							.getSoftwareName());
					if (llProductInfo != null && !llProductInfo.isEmpty()) {
						for (Software productInfotemp : llProductInfo) {
							@SuppressWarnings("unchecked")
							List<ReconCustomerSoftware> results = getEntityManager()
									.createNamedQuery("reconCustomerSwExists")
									.setParameter("software", productInfotemp)
									.setParameter("account",
											lsfhSave.getAccount())
									.getResultList();

							if (results == null || results.isEmpty()) {
								ReconCustomerSoftware lrcsSave = new ReconCustomerSoftware();

								lrcsSave.setAccount(lsfhSave.getAccount());
								lrcsSave.setSoftware(productInfotemp);
								lrcsSave.setAction("UPDATE");
								lrcsSave.setRecordTime(new Date());
								lrcsSave.setRemoteUser(psRemoteUser);
								getEntityManager().persist(lrcsSave);
							}
						}
					}
				}
				
				if (lsfhSave.getLevel().equals(
						ScheduleFLevelEnumeration.MANUFACTURER.toString())) {
					List<Manufacturer> manufacturerList = new ArrayList<Manufacturer>();
				    manufacturerList = manufactuerService.findManufacturerListByName(lsfhSave.getManufacturer());
					if (manufacturerList != null && !manufacturerList.isEmpty()) {
							for (Manufacturer manufacturer :  manufacturerList) {
									@SuppressWarnings("unchecked")
									List<ReconPriorityISVSoftware> results = getEntityManager()
											.createNamedQuery("findReconPriorityISVSoftwareByUniqueKeys2")
											.setParameter("customerId", lsfhSave.getAccount().getId())
											.setParameter("manufacturerId",manufacturer.getId())
											.getResultList();

									if (results == null || results.isEmpty()) {
										ReconPriorityISVSoftware rcPISVSWSave = new ReconPriorityISVSoftware();
										rcPISVSWSave.setAccount(lsfhSave.getAccount());
										rcPISVSWSave.setManufacturer(manufacturer);
										rcPISVSWSave.setAction("UPDATE");
										rcPISVSWSave.setRecordTime(new Date());
										rcPISVSWSave.setRemoteUser(psRemoteUser);
										getEntityManager().persist(rcPISVSWSave);
									}
							}
						
					}
				}

				if (lsfhSave.getLevel().equals(
						ScheduleFLevelEnumeration.HWOWNER.toString())) {
					@SuppressWarnings("unchecked")
					List<InstalledSoftware> installedswlist = getEntityManager()
							.createQuery(
									"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH a.softwareLpar.hardwareLpar c JOIN FETCH a.softwareLpar.hardwareLpar.hardware d WHERE a.status='ACTIVE'  AND c.status='ACTIVE' AND  a.software.softwareName = :softwareName AND b.account = :account AND d.owner = :owner")
							.setParameter("softwareName",
									lsfhSave.getSoftware().getSoftwareName())
							.setParameter("account", lsfhSave.getAccount())
							.setParameter("owner", lsfhSave.getHwOwner())
							.getResultList();
					insertInswRecon(installedswlist, psRemoteUser);
				}

				if (lsfhSave.getLevel().equals(
						ScheduleFLevelEnumeration.HWBOX.toString())) {
					@SuppressWarnings("unchecked")
					List<InstalledSoftware> installedswlist = getEntityManager()
							.createQuery(
									"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH b.hardwareLpar c JOIN FETCH c.hardware d JOIN FETCH d.machineType e  Where a.status='ACTIVE'  and d.status='ACTIVE' and a.software.softwareName = :softwareName and b.account = :account and d.serial = :serail and e.name = :name")
							.setParameter("softwareName",
									lsfhSave.getSoftware().getSoftwareName())
							.setParameter("account", lsfhSave.getAccount())
							.setParameter("serail", lsfhSave.getSerial())
							.setParameter("name", lsfhSave.getMachineType())
							.getResultList();
					insertInswRecon(installedswlist, psRemoteUser);
				}

				if (lsfhSave.getLevel().equals(
						ScheduleFLevelEnumeration.HOSTNAME.toString())) {
					@SuppressWarnings("unchecked")
					List<InstalledSoftware> installedswlist = getEntityManager()
							.createQuery(
									"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b Where a.status='ACTIVE' and a.software.softwareName = :softwareName and b.account = :account and b.name = :hostname")
							.setParameter("softwareName",
									lsfhSave.getSoftware().getSoftwareName())
							.setParameter("account", lsfhSave.getAccount())
							.setParameter("hostname", lsfhSave.getHostname())
							.getResultList();
					insertInswRecon(installedswlist, psRemoteUser);
				}
			}
		} else {
			// Insert a ScheduleF record
			psfSave.setRemoteUser(psRemoteUser);
			psfSave.setRecordTime(new Date());
			getEntityManager().persist(psfSave);

			// Always insert a row into the Recon_Customer_Sw table for the new
			// data
			if ((!psfSave.getLevel().equals(
					ScheduleFLevelEnumeration.MANUFACTURER.toString()) && psfSave.getSoftware() != null) || (psfSave.getLevel().equals(
							ScheduleFLevelEnumeration.MANUFACTURER.toString()))){
			lbSaveReconRow = true;
			}
		}

		if (lbSaveReconRow) {
			if (psfSave.getLevel().equals(
					ScheduleFLevelEnumeration.PRODUCT.toString())) {
				@SuppressWarnings("unchecked")
				List<ReconCustomerSoftware> results = getEntityManager()
						.createNamedQuery("reconCustomerSwExists")
						.setParameter("software", psfSave.getSoftware())
						.setParameter("account", psfSave.getAccount())
						.getResultList();

				if (results == null || results.isEmpty()) {
					ReconCustomerSoftware lrcsSave = new ReconCustomerSoftware();

					lrcsSave.setAccount(psfSave.getAccount());
					lrcsSave.setSoftware(psfSave.getSoftware());
					lrcsSave.setAction("UPDATE");
					lrcsSave.setRecordTime(new Date());
					lrcsSave.setRemoteUser(psRemoteUser);
					getEntityManager().persist(lrcsSave);
				}
			}
			
			if (psfSave.getLevel().equals(
					ScheduleFLevelEnumeration.MANUFACTURER.toString())) {
				List<Manufacturer> manufacturerList = new ArrayList<Manufacturer>();
			    manufacturerList = manufactuerService.findManufacturerListByName(psfSave.getManufacturer());
				if (manufacturerList != null && !manufacturerList.isEmpty()) {
					for (Manufacturer manufacturer :  manufacturerList) {
						@SuppressWarnings("unchecked")
						List<ReconPriorityISVSoftware> results = getEntityManager()
								.createNamedQuery("findReconPriorityISVSoftwareByUniqueKeys2")
								.setParameter("customerId", psfSave.getAccount().getId())
								.setParameter("manufacturerId",manufacturer.getId())
								.getResultList();

						if (results == null || results.isEmpty()) {
							ReconPriorityISVSoftware rcPISVSWSave = new ReconPriorityISVSoftware();
							rcPISVSWSave.setAccount(psfSave.getAccount());
							rcPISVSWSave.setManufacturer(manufacturer);
							rcPISVSWSave.setAction("UPDATE");
							rcPISVSWSave.setRecordTime(new Date());
							rcPISVSWSave.setRemoteUser(psRemoteUser);
							getEntityManager().persist(rcPISVSWSave);
						}
				}
			
		}
			}

			if (psfSave.getLevel().equals(
					ScheduleFLevelEnumeration.HWOWNER.toString())) {
				@SuppressWarnings("unchecked")
				List<InstalledSoftware> installedswlist = getEntityManager()
						.createQuery(
								"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH a.softwareLpar.hardwareLpar c JOIN FETCH a.softwareLpar.hardwareLpar.hardware d WHERE a.status='ACTIVE'  AND c.status='ACTIVE' AND  a.software = :software AND b.account = :account AND d.owner = :owner")
						.setParameter("software", psfSave.getSoftware())
						.setParameter("account", psfSave.getAccount())
						.setParameter("owner", psfSave.getHwOwner())
						.getResultList();
				insertInswRecon(installedswlist, psRemoteUser);
			}

			if (psfSave.getLevel().equals(
					ScheduleFLevelEnumeration.HWBOX.toString())) {
				@SuppressWarnings("unchecked")
				List<InstalledSoftware> installedswlist = getEntityManager()
						.createQuery(
								"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH b.hardwareLpar c JOIN FETCH c.hardware d JOIN FETCH d.machineType e  Where a.status='ACTIVE'  and d.status='ACTIVE' and a.software = :software and b.account = :account and d.serial = :serail and e.name = :name")
						.setParameter("software", psfSave.getSoftware())
						.setParameter("account", psfSave.getAccount())
						.setParameter("serail", psfSave.getSerial())
						.setParameter("name", psfSave.getMachineType())
						.getResultList();
				insertInswRecon(installedswlist, psRemoteUser);
			}

			if (psfSave.getLevel().equals(
					ScheduleFLevelEnumeration.HOSTNAME.toString())) {
				@SuppressWarnings("unchecked")
				List<InstalledSoftware> installedswlist = getEntityManager()
						.createQuery(
								"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b Where a.status='ACTIVE' and a.software = :software and b.account = :account and b.name = :hostname")
						.setParameter("software", psfSave.getSoftware())
						.setParameter("account", psfSave.getAccount())
						.setParameter("hostname", psfSave.getHostname())
						.getResultList();
				insertInswRecon(installedswlist, psRemoteUser);
			}
		}

	}

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public void paginatedList(DisplayTagList pdtlData, Account pAccount,
			int piStartIndex, int piObjectsPerPage, String psSort, String psDir) {
		Session lSession = (Session) getEntityManager().getDelegate();
		ScrollableResults lsrList = lSession.createQuery(lSession.getNamedQuery("scheduleFList").getQueryString() + " ORDER BY " + psSort + " " + psDir).setParameter("account", pAccount).scroll();
		ArrayList<ScheduleF> lalScheduleF = new ArrayList<ScheduleF>();

		lsrList.beforeFirst();
		if (lsrList.next()) {
			int liCounter = 0;

			lsrList.scroll(piStartIndex);

			while (piObjectsPerPage > liCounter++) {
				lalScheduleF.add((ScheduleF) lsrList.get(0));
				if (!lsrList.next())
					break;
			}

			pdtlData.setList(lalScheduleF);
			lsrList.last();
			pdtlData.setFullListSize(lsrList.getRowNumber() + 1);
			lsrList.close();
		} else {
			pdtlData.setList(null);
			pdtlData.setFullListSize(0);
			lsrList.close();
		}
		
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<ScheduleF> paginatedList(Account pAccount,int piStartIndex, int piObjectsPerPage, String psSort, String psDir){
		
		Session lSession = (Session) getEntityManager().getDelegate();
		ScrollableResults lsrList = lSession.createQuery(lSession.getNamedQuery("scheduleFList").getQueryString() + " ORDER BY SF." + psSort + " " + psDir).setParameter("account", pAccount).scroll();
        ArrayList<ScheduleF> schfList = new ArrayList<ScheduleF>();
		lsrList.beforeFirst();
		if (lsrList.next()) {
			int liCounter = 0;

			lsrList.scroll(piStartIndex);

			while (piObjectsPerPage > liCounter++) {
				schfList.add((ScheduleF) lsrList.get(0));
				if (!lsrList.next())
					break;
			}
			lsrList.close();
			return schfList;
		} else {
			lsrList.close();
			return null;
		}
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<ScheduleFH> paginatedList(Long scheduleFId,int piStartIndex, int piObjectsPerPage, String psSort, String psDir){
		
		Session lSession = (Session) getEntityManager().getDelegate();
		ScrollableResults lsrList = lSession.createQuery(lSession.getNamedQuery("scheduleFHList").getQueryString() + " ORDER BY SH." + psSort + " " + psDir).setParameter("scheduleFId", scheduleFId).scroll();
        ArrayList<ScheduleFH> schhfList = new ArrayList<ScheduleFH>();
		lsrList.beforeFirst();
		if (lsrList.next()) {
			int liCounter = 0;

			lsrList.scroll(piStartIndex);

			while (piObjectsPerPage > liCounter++) {
				schhfList.add((ScheduleFH) lsrList.get(0));
				if (!lsrList.next())
					break;
			}
			lsrList.close();
			return schhfList;
		} else {
			lsrList.close();
			return null;
		}
	}
	
	public Long getAllScheduleFSize(Account pAccount){
		Long total = (Long)getEntityManager().createNamedQuery("findScheduleFTotal").setParameter("account", pAccount).getSingleResult();
		return total;
	}
	
	public Long getScheduleFHSize(ScheduleF scheduleF){
		Long total = (Long)getEntityManager().createNamedQuery("findscheduleFHIdTotal").setParameter("scheduleF", scheduleF).getSingleResult();
		return total;
	}
    
	public ScheduleF findScheduleF(Long plId) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFById").setParameter("id", plId)
				.getResultList();
		ScheduleF result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}

		return result;
	}

	@SuppressWarnings("null")
	private void parseCell(HSSFCell cell, ScheduleF sf) throws Exception {
		@SuppressWarnings("unchecked")
		List<Status> statusresults = getEntityManager()
				.createNamedQuery("statusDetails")
				.setParameter("description", "INACTIVE").getResultList();
		switch (cell.getColumnIndex()) {
		case 0: { // Level
			if (cell.getRow().getCell(4) != null) {
				cell.getRow().getCell(4).setCellType(Cell.CELL_TYPE_STRING);
			}
			if (cell.getRow().getCell(2) != null) {
				cell.getRow().getCell(2).setCellType(Cell.CELL_TYPE_STRING);
			}
			if (cell.getRow().getCell(3) != null) {
				cell.getRow().getCell(3).setCellType(Cell.CELL_TYPE_STRING);
			}
			if (cell.getRow().getCell(6) != null) {
				cell.getRow().getCell(6).setCellType(Cell.CELL_TYPE_STRING);
			}
			if (cell.getRow().getCell(7) != null) {
				cell.getRow().getCell(7).setCellType(Cell.CELL_TYPE_STRING);
			}
			if (cell.getRow().getCell(8) != null) {
				cell.getRow().getCell(8).setCellType(Cell.CELL_TYPE_STRING);
			}
			if (!cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.MANUFACTURER.toString())
					&& (cell.getRow().getCell(7) == null || StringUtils
							.isEmpty(cell.getRow().getCell(7)
									.getRichStringCellValue().getString()))) {
				throw new Exception("Software name is required.");
			}
			if (StringUtils.isEmpty(cell.getRichStringCellValue().getString())) {
				throw new Exception("Level is required.");
			} else if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Level is not a string.");
			} else if (cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.MANUFACTURER.toString())
					&& (cell.getRow().getCell(8) == null || StringUtils
							.isEmpty(cell.getRow().getCell(8)
									.getRichStringCellValue().getString()))) {
				throw new Exception("Manufacturer is required.");
			} else if (cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.HWOWNER.toString())
					&& (cell.getRow().getCell(1) == null || StringUtils
							.isEmpty(cell.getRow().getCell(1)
									.getRichStringCellValue().getString()))) {
				throw new Exception("HW owner is required.");
			} else if (cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.HWBOX.toString())
					&& ((cell.getRow().getCell(3) == null || StringUtils
							.isEmpty(cell.getRow().getCell(3)
									.getRichStringCellValue().getString())) || (cell
							.getRow().getCell(4) == null || StringUtils
							.isEmpty(cell.getRow().getCell(4)
									.getRichStringCellValue().getString())))) {
				throw new Exception(
						"Serial number and Machine type are required.");
			} else if (cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.HOSTNAME.toString())
					&& (cell.getRow().getCell(2) == null || StringUtils
							.isEmpty(cell.getRow().getCell(2)
									.getRichStringCellValue().getString()))) {
				throw new Exception("Hostname is required.");
			} else if (ScheduleFLevelEnumeration.contains(cell
					.getRichStringCellValue().getString())) {
				sf.setLevel(cell.getRichStringCellValue().getString());
			} else {
				throw new Exception("ScheduleF Level is not recognized.");
			}

			break;
		}
		case 1: { // HW owner
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
					.getString())) {
				if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
					throw new Exception("HW owner is not a string.");
				} else if (!cell.getRow().getCell(0).getRichStringCellValue()
						.getString()
						.equals(ScheduleFLevelEnumeration.HWOWNER.toString())) {
					throw new Exception("Level is not specified with HWOWNER.");
				} else {
					sf.setHwOwner(cell.getRichStringCellValue().getString()
							.trim());
				}
			}
			break;
		}
		case 2: { // Hostname
			if (cell != null) {
				cell.setCellType(Cell.CELL_TYPE_STRING);
			}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
					.getString())) {
				if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
					throw new Exception("Hostname is not a string.");
				} else if (!cell.getRow().getCell(0).getRichStringCellValue()
						.getString()
						.equals(ScheduleFLevelEnumeration.HOSTNAME.toString())) {
					throw new Exception("Level is not specified with HOSTNAME.");
				} else {
					sf.setHostname(cell.getRichStringCellValue().getString()
							.trim());
				}
			}
			break;
		}
		case 3: { // Serial number
			if (cell != null) {
				cell.setCellType(Cell.CELL_TYPE_STRING);
			}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
					.getString())) {
				if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
					throw new Exception("Serial number is not a string.");
				} else if (!cell.getRow().getCell(0).getRichStringCellValue()
						.getString()
						.equals(ScheduleFLevelEnumeration.HWBOX.toString())) {
					throw new Exception("Level is not specified with HWBOX.");
				} else {
					sf.setSerial(cell.getRichStringCellValue().getString()
							.trim());
				}
			}
			break;
		}
		case 4: { // Machine type
			if (cell != null) {
				cell.setCellType(Cell.CELL_TYPE_STRING);
			}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
					.getString())) {
				if (!cell.getRow().getCell(0).getRichStringCellValue()
						.getString()
						.equals(ScheduleFLevelEnumeration.HWBOX.toString())) {
					throw new Exception("Level is not specified with HWBOX.");
				} else {
					List<MachineType> mtlist = findMachineTypebyName(cell
							.getRichStringCellValue().getString().toUpperCase());
					if (mtlist == null || mtlist.isEmpty()) {
						throw new Exception("Machine Type is invalid.");
					} else {
						sf.setMachineType(mtlist.get(0).getName().trim());
					}
				}
			}
			break;
		}
		case 5: { // Account number
			Long accountNumber = null;
			Account account = null;

			try {
				if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
					accountNumber = new Long(cell.getRichStringCellValue()
							.getString());
				} else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
					accountNumber = new Double(cell.getNumericCellValue())
							.longValue();
				} else {
					throw new Exception();
				}
			} catch (Exception e) {
				throw new Exception("Invalid account number");
			}

			account = getAccountService().getAccountByAccountNumber(
					accountNumber);
			if (account == null) {
				throw new Exception("Invalid account number");
			} else {
				sf.setAccount(account);
			}

			break;
		}

		case 6: { // Software title
			if (cell != null) {
				cell.setCellType(Cell.CELL_TYPE_STRING);
			}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
							.getString())) {
				if (cell.getRow()
						.getCell(0)
						.getRichStringCellValue()
						.getString()
						.equals(ScheduleFLevelEnumeration.MANUFACTURER
								.toString())) {
					throw new Exception(
							"Level is not specified with any equal or lower PRODUCT level.");
				} else {
					sf.setSoftwareTitle(cell.getRichStringCellValue()
							.getString().trim());
				}
			}

			break;
		}

		case 7: { // Software name
			if (cell != null) {
				cell.setCellType(Cell.CELL_TYPE_STRING);
			}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
							.getString())) {
				if (cell.getRow()
						.getCell(0)
						.getRichStringCellValue()
						.getString()
						.equals(ScheduleFLevelEnumeration.MANUFACTURER
								.toString())) {
					throw new Exception(
							"Level is not specified with any equal or lower PRODUCT level.");
				} else {

					ArrayList<Software> lalProductInfo = null;
					sf.setSoftwareName(cell.getRichStringCellValue()
							.getString().trim());
					lalProductInfo = findSoftwareBySoftwareName(sf
							.getSoftwareName());
					if (lalProductInfo.size() > 0) {
						sf.setSoftware(lalProductInfo.get(0));
						if (lalProductInfo.get(0).getStatus()
								.equalsIgnoreCase("INACTIVE")) {
							sf.setStatus(statusresults.get(0));
						}

					} else if (cell.getRow().getCell(13)
							.getRichStringCellValue().getString()
							.equals("ACTIVE")) {
						throw new Exception(
								"Software does not exist in catalog");
					} else {
						sf.setStatus(statusresults.get(0));
						throw new InvalidException("Software is invalid");
					}

				}
			}

			break;
		}

		case 8: { // Manufacturer
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Manufacturer is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Manufacturer is required.");
			} else {
				Manufacturer manufacturer = manufactuerService
						.findManufacturerByName(cell.getRichStringCellValue()
								.getString().trim());
				if (null != manufacturer) {
					sf.setManufacturer(manufacturer.getManufacturerName());
					sf.setManufacturerName(manufacturer.getManufacturerName());
				} else if (cell.getRow().getCell(13).getRichStringCellValue()
						.getString().equals("INACTIVE")) {
					sf.setManufacturer(cell.getRichStringCellValue()
							.getString().trim());
					sf.setManufacturerName(cell.getRichStringCellValue()
							.getString().trim());
					sf.setStatus(statusresults.get(0));
					throw new InvalidException("Manufacturer is invalid");
				} else {
					throw new Exception(
							"Manufacturer does not exist in catalog");
				}
			}

			break;
		}

		case 9: { // Scope
			if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
				@SuppressWarnings("unchecked")
				List<Scope> results = getEntityManager()
						.createNamedQuery("scopeDetails")
						.setParameter(
								"description",
								cell.getRichStringCellValue().getString()
										.toUpperCase()).getResultList();
				if (results == null || results.isEmpty()) {
					throw new Exception("Scope is invalid.");
				} else if (cell.getRow().getCell(0).getRichStringCellValue()
						.getString()
						.equals(ScheduleFLevelEnumeration.HWOWNER.toString())) {
					String[] scDesParts = results.get(0).getDescription()
							.split(",");
					if (scDesParts[0].contains("IBM owned")
							&& cell.getRow().getCell(1)
									.getRichStringCellValue().getString()
									.equals("IBM")) {
						sf.setScope(results.get(0));
					} else if (scDesParts[0].contains("Customer owned")
							&& cell.getRow().getCell(1)
									.getRichStringCellValue().getString()
									.equals("CUSTO")) {
						sf.setScope(results.get(0));
					} else {
						throw new Exception("Invalid Scope combination.");
					}
				} else {
					sf.setScope(results.get(0));
				}
			} else {
				throw new Exception("Scope is not a string.");
			}

			break;
		}

		case 10: { // SW Financial Resp
			if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
				String[] scDesParts = cell.getRow().getCell(9)
						.getRichStringCellValue().getString().split(",");
				String swFinancialResp = cell.getRichStringCellValue()
						.getString().trim();
				if (!swFinancialResp.equals("CUSTO")
						&& !swFinancialResp.equals("IBM")
						&& !swFinancialResp.equals("N/A")) {
					throw new Exception(
							"The value of SW Financial Resp should only be IBM or CUSTO or N/A.");
				} else if (swFinancialResp.equals("CUSTO")
						&& scDesParts[0].contains("IBM owned")) {
					throw new Exception(
							"The value of SW Financial Resp should only be IBM when this scheduleF scope is IBM owned.");
				} else if (swFinancialResp.equals("N/A")
						&& !(scDesParts[0].contains("Customer owned") && scDesParts[1]
								.contains("Customer managed"))) {
					throw new Exception(
							"The value of SW Financial Resp could be N/A only when the scheduleF scope is Customer owned, Customer managed.");
				} else {
					sf.setSWFinanceResp(swFinancialResp);
				}
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("SW Financial Resp is required.");
			} else {
				throw new Exception("SW Financial Resp is not a string.");
			}
			break;
		}

		case 11: { // Source
			if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
				@SuppressWarnings("unchecked")
				List<Source> results = getEntityManager()
						.createNamedQuery("sourceDetails")
						.setParameter(
								"description",
								cell.getRichStringCellValue().getString()
										.toUpperCase()).getResultList();
				if (results == null || results.isEmpty()) {
					throw new Exception("Source is invalid.");
				} else {
					sf.setSource(results.get(0));
				}
			} else {
				throw new Exception("Source is not a string.");
			}

			break;
		}

		case 12: { // Source location
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Source location is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Source location is required.");
			} else {
				sf.setSourceLocation(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}

		case 13: { // Status
			if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
				@SuppressWarnings("unchecked")
				List<Status> results = getEntityManager()
						.createNamedQuery("statusDetails")
						.setParameter(
								"description",
								cell.getRichStringCellValue().getString()
										.toUpperCase()).getResultList();
				if (results == null || results.isEmpty()) {
					throw new Exception("Status is invalid.");
				} else if (!(sf.getStatus() instanceof Status && sf.getStatus()
						.getId() > 0)) {
					if (null == sf.getStatus()) {
						sf.setStatus(results.get(0));
					}
				}
			} else {
				throw new Exception("Status is not a string.");
			}

			break;
		}

		case 14: { // Business justification
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Business justification is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Business justification is required.");
			} else {
				sf.setBusinessJustification(cell.getRichStringCellValue()
						.getString());
			}
			break;
		}
		}

	}

	private String getErrorMessage(int piCellIndex) {
		String lsErrorMessage = null;

		switch (piCellIndex) {
		case 0: { // Level
			lsErrorMessage = "Level is required.";

			break;
		}

		case 1: { // HWOWNER

			break;
		}

		case 2: { // HOSTNAME

			break;
		}

		case 3: { // Serial number

			break;
		}

		case 4: { // Machine Type

			break;
		}

		case 5: { // Account number
			lsErrorMessage = "Account number is required.";

			break;
		}

		case 6: { // Software title

			break;
		}

		case 7: { // Software name

			break;
		}

		case 8: { // Manufacturer
			lsErrorMessage = "Manufacturer is required.";

			break;
		}

		case 9: { // Scope
			lsErrorMessage = "Scope is required.";

			break;
		}

		case 10: { // SW Financial Resp
			lsErrorMessage = "SW Financial Resp is required.";

			break;
		}

		case 11: { // Source
			lsErrorMessage = "Source is required.";

			break;
		}

		case 12: { // Source location
			lsErrorMessage = "Source location is required.";

			break;
		}

		case 13: { // Status
			lsErrorMessage = "Status is required.";

			break;
		}

		case 14: { // Business justification
			lsErrorMessage = "Business justification is required.";

			break;
		}
		}

		return lsErrorMessage;
	}

	private EntityManager getEntityManager() {
		return em;
	}

	@PersistenceContext(unitName = "trailspd")
	public void setEntityManager(EntityManager em) {
		this.em = em;
	}

	public AccountService getAccountService() {
		return accountService;
	}

	public void setAccountService(AccountService accountService) {
		this.accountService = accountService;
	}
}
