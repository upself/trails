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
import org.apache.poi.ss.usermodel.Row;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.ProductInfo;
import com.ibm.asset.trails.domain.ReconCustomerSoftware;
import com.ibm.asset.trails.domain.ReconInstalledSoftware;
import com.ibm.asset.trails.domain.ReconcileH;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFH;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.domain.ScheduleFLevelEnumeration;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.ScheduleFService;
import com.ibm.tap.trails.framework.DisplayTagList;

@Service
public class ScheduleFServiceImpl implements ScheduleFService {

	private EntityManager em;

	@Autowired
	private AccountService accountService;

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ScheduleF findScheduleF(Long plScheduleFId, Account pAccount,
			ProductInfo pProductInfo) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFByAccountAndSwNotId")
				.setParameter("account", pAccount)
				.setParameter("productInfo", pProductInfo)
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
	public ScheduleF findScheduleF(Account pAccount, ProductInfo pProductInfo) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFByAccountAndSw")
				.setParameter("account", pAccount)
				.setParameter("productInfo", pProductInfo).getResultList();
		ScheduleF result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}

		return result;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<ScheduleF> findScheduleF(Account pAccount, ProductInfo pProductInfo, String level) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createNamedQuery("findScheduleFByAccountAndSwAndLevel")
				.setParameter("account", pAccount)
				.setParameter("productInfo", pProductInfo)
				.setParameter("level", level).getResultList();

		if (results == null || results.isEmpty()) {
			results = null;
		} else {
			return results;
		}
		return results;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ArrayList<ProductInfo> findProductInfoBySoftwareName(
			String psSoftwareName) {
		@SuppressWarnings("unchecked")
		ArrayList<ProductInfo> lalProductInfo = (ArrayList<ProductInfo>) getEntityManager()
				.createNamedQuery("productInfoBySoftwareName")
				.setParameter("name", psSoftwareName.toUpperCase())
				.getResultList();

		if (lalProductInfo.size() > 0) {
			return lalProductInfo;
		} else {
			List resultList = getEntityManager()
					.createNamedQuery("productInfoByAliasName")
					.setParameter("name", psSoftwareName.toUpperCase())
					.getResultList();

			ArrayList<ProductInfo> productInforList = new ArrayList<ProductInfo>();
          if(!resultList.isEmpty()){
			// loop the result list to get the product information aggregation.
			for (Object resultElement : resultList) {
				if (!(resultElement instanceof Object[])) {
					continue;
				}

				for (Object object : (Object[]) resultElement) {
					if (object instanceof ProductInfo) {
						productInforList.add((ProductInfo) object);
					}
				}
			}
          }
			if (productInforList.isEmpty()){
				@SuppressWarnings("unchecked")
				ArrayList<ProductInfo> linalProductInfo = (ArrayList<ProductInfo>) getEntityManager()
						.createNamedQuery("inactiveProductInfoBySoftwareName")
						.setParameter("name", psSoftwareName.toUpperCase())
						.getResultList();
				if (linalProductInfo.size() > 0) {
						for (ProductInfo object :  linalProductInfo) {						
								productInforList.add((ProductInfo) object);						
						}
					
				} else {
					List inacPiResultList = getEntityManager()
							.createNamedQuery("inactiveProductInfoByAliasName")
							.setParameter("name", psSoftwareName.toUpperCase())
							.getResultList();
					if(!inacPiResultList.isEmpty()){
					for (Object resultElement : inacPiResultList) {
						if (!(resultElement instanceof Object[])) {
							continue;
						}

						for (Object object : (Object[]) resultElement) {
							if (object instanceof ProductInfo) {
								productInforList.add((ProductInfo) object);
							}
						}
					}
				}
				}
			}
			return productInforList;
		}
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<MachineType> findMachineTypebyName(String name) {
		@SuppressWarnings("unchecked")
		List<MachineType> results = getEntityManager()
				.createNamedQuery("machineTypeDetailsByName")
				.setParameter(
						"name",
						name).getResultList();

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
		return (ArrayList<String>) getEntityManager().createNativeQuery("select level from eaadmin.schedule_f group by level").getResultList();
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
			lbHeaderRow = false;

			for (int i = 0; i <= 13; i++) {
				cell = row.getCell(i);
				if (cell == null) {
					cell = row.createCell(i);
					if ( i == 0 || i > 4 ){
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
					} catch (Exception e) {					
							cell.setCellStyle(lcsError);
//							e.printStackTrace();
							lsbErrorMessage.append(error ? "\n" : "").append(
									e.getMessage());
							error = true;
					}
				}
			}

			if (!lbHeaderRow) {
				if (error) {
					cell = row.createCell(15);
					cell.setCellStyle(lcsError);
					cell.setCellValue(new HSSFRichTextString(lsbErrorMessage
							.toString()));
				} else {
					saveScheduleF(sf, psRemoteUser);
					cell = row.createCell(15);
					cell.setCellStyle(lcsMessage);
					cell.setCellValue( new StringBuffer("YOUR TEMPLATE UPLOAD SUCCESSFULLY").toString());
				}
			}
		}

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);

		return bos;
	}
    
	@SuppressWarnings("null")
	@Transactional(readOnly = true, propagation = Propagation.REQUIRED)
	public void insertInswRecon(List<InstalledSoftware> installedswlist, String psRemoteUser){
		
		if (installedswlist != null && !installedswlist.isEmpty()) {
			for (InstalledSoftware inswtemp : installedswlist){
				@SuppressWarnings("unchecked")
				List<ReconInstalledSoftware> results = getEntityManager()
						.createNamedQuery("reconInstalledSWbyInswIdANDCsId")
						.setParameter("account", inswtemp.getSoftwareLpar().getAccount())
						.setParameter("installedSoftware", inswtemp)
						.getResultList();
		if (results == null || results.isEmpty()){
            ReconInstalledSoftware rcInswSave = new ReconInstalledSoftware();
            rcInswSave.setAccount(inswtemp.getSoftwareLpar().getAccount());
            rcInswSave.setInstalledSoftware(inswtemp);
            rcInswSave.setAction("UPDATE");
            rcInswSave.setRecordTime(new Date());
            rcInswSave.setRemoteUser(psRemoteUser);
			getEntityManager().persist(rcInswSave);
			}
		  }
		}
	}
	@Transactional(readOnly = true, propagation = Propagation.REQUIRED)
	public void saveScheduleF(ScheduleF psfSave, String psRemoteUser) {
		boolean lbSaveReconRow = false;
		boolean lbSaveExistReconRow = false;
		if (psfSave.getAccount() != null && psfSave.getProductInfo() != null && psfSave.getLevel() != null ) {
			List<ScheduleF> lsfExists = findScheduleF(psfSave.getAccount(),
					psfSave.getProductInfo(),psfSave.getLevel());
            if (lsfExists != null){
				for (ScheduleF existsSF : lsfExists) {
					if (existsSF instanceof ScheduleF) {
						if (psfSave.getLevel().toString().equals(ScheduleFLevelEnumeration.PRODUCT.toString()) ){
							psfSave.setId(existsSF.getId());
						} else if((psfSave.getLevel().toString().equals(ScheduleFLevelEnumeration.HWOWNER.toString()) && psfSave.getHwOwner().equals(existsSF.getHwOwner()) )
								|| (psfSave.getLevel().toString().equals(ScheduleFLevelEnumeration.HOSTNAME.toString()) && psfSave.getHostname().equals(existsSF.getHostname()) )
								|| (psfSave.getLevel().toString().equals(ScheduleFLevelEnumeration.HWBOX.toString()) && psfSave.getMachineType().equals(existsSF.getMachineType()) && psfSave.getSerial().equals(existsSF.getSerial()) )) {
							psfSave.setId(existsSF.getId());
						}
					}
				}
            }
		}
		if (psfSave.getId() != null) {
			ScheduleF lsfExists = findScheduleF(psfSave.getId());
			ScheduleFH lsfhSave = new ScheduleFH();
			// Determine if we should insert a row into the Recon_Customer_Sw
			// table
			// for the new data and the old data
			
			if (!psfSave.getScope().equals(lsfExists.getScope()) || !psfSave.getStatus().equals(lsfExists.getStatus())){
					lbSaveReconRow = true;
					lbSaveExistReconRow = true;
			}

			

			// Insert a ScheduleFH record
			lsfhSave.setScheduleF(lsfExists);
			lsfhSave.setAccount(lsfExists.getAccount());
			lsfhSave.setProductInfo(lsfExists.getProductInfo());
			lsfhSave.setSoftwareTitle(lsfExists.getSoftwareTitle());
			lsfhSave.setSoftwareName(lsfExists.getSoftwareName());
			lsfhSave.setManufacturer(lsfExists.getManufacturer());
			lsfhSave.setLevel(lsfExists.getLevel());
			lsfhSave.setHwOwner(lsfExists.getHwOwner());
			lsfhSave.setMachineType(lsfExists.getMachineType());
			lsfhSave.setSerial(lsfExists.getSerial());
			lsfhSave.setHostname(lsfExists.getHostname());
			lsfhSave.setScope(lsfExists.getScope());
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
			lsfExists.setProductInfo(psfSave.getProductInfo());
			lsfExists.setSoftwareTitle(psfSave.getSoftwareTitle());
			lsfExists.setSoftwareName(psfSave.getSoftwareName());
			lsfExists.setManufacturer(psfSave.getManufacturer());
			lsfExists.setScope(psfSave.getScope());
			lsfExists.setSource(psfSave.getSource());
			lsfExists.setSourceLocation(psfSave.getSourceLocation());
			lsfExists.setStatus(psfSave.getStatus());
			lsfExists.setBusinessJustification(psfSave
					.getBusinessJustification());
			lsfExists.setRemoteUser(psRemoteUser);
			lsfExists.setRecordTime(new Date());

			getEntityManager().merge(lsfExists);
			getEntityManager().flush();
			
			if (lbSaveExistReconRow){
				if (lsfhSave.getLevel().equals(ScheduleFLevelEnumeration.PRODUCT.toString()) ){
					ArrayList<ProductInfo> llProductInfo = null;
					llProductInfo = findProductInfoBySoftwareName(lsfhSave.getSoftwareName());
					if (llProductInfo != null && !llProductInfo.isEmpty()) {
						for (ProductInfo productInfotemp : llProductInfo){
					@SuppressWarnings("unchecked")
					List<ReconCustomerSoftware> results = getEntityManager()
							.createNamedQuery("reconCustomerSwExists")
							.setParameter("productInfo", productInfotemp)
							.setParameter("account", lsfhSave.getAccount())
							.getResultList();
					
					if (results == null || results.isEmpty()) {
						ReconCustomerSoftware lrcsSave = new ReconCustomerSoftware();

						lrcsSave.setAccount(lsfhSave.getAccount());
						lrcsSave.setProductInfo(productInfotemp);
						lrcsSave.setAction("UPDATE");
						lrcsSave.setRecordTime(new Date());
						lrcsSave.setRemoteUser(psRemoteUser);
						getEntityManager().persist(lrcsSave);
					}
						}
					}
				}
				
				if (lsfhSave.getLevel().equals(ScheduleFLevelEnumeration.HWOWNER.toString()) ){
					@SuppressWarnings("unchecked")
					List<InstalledSoftware> installedswlist = getEntityManager()
							.createQuery(
									"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH a.softwareLpar.hardwareLpar c JOIN FETCH a.softwareLpar.hardwareLpar.hardware d WHERE a.status='ACTIVE'  AND c.status='ACTIVE' AND  a.productInfo.name = :productName AND b.account = :account AND d.owner = :owner")
							.setParameter("productName",lsfhSave.getProductInfo().getName())
							.setParameter("account",lsfhSave.getAccount())
							.setParameter("owner", lsfhSave.getHwOwner()).getResultList();
					insertInswRecon(installedswlist,psRemoteUser);
				}
				
				if (lsfhSave.getLevel().equals(ScheduleFLevelEnumeration.HWBOX.toString()) ){
					@SuppressWarnings("unchecked")
					List<InstalledSoftware> installedswlist = getEntityManager()
							.createQuery(
									"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH b.hardwareLpar c JOIN FETCH c.hardware d JOIN FETCH d.machineType e  Where a.status='ACTIVE'  and d.status='ACTIVE' and a.productInfo.name = :productName and b.account = :account and d.serial = :serail and e.name = :name")
							.setParameter("productName",lsfhSave.getProductInfo().getName())
							.setParameter("account",lsfhSave.getAccount())
							.setParameter("serail", lsfhSave.getSerial())
							.setParameter("name", lsfhSave.getMachineType()).getResultList();
					insertInswRecon(installedswlist,psRemoteUser);
				}
				
				if (lsfhSave.getLevel().equals(ScheduleFLevelEnumeration.HOSTNAME.toString())){
					@SuppressWarnings("unchecked")
					List<InstalledSoftware> installedswlist = getEntityManager()
							.createQuery(
									"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b Where a.status='ACTIVE' and a.productInfo.name = :productName and b.account = :account and b.name = :hostname")
							.setParameter("productName",lsfhSave.getProductInfo().getName())
							.setParameter("account",lsfhSave.getAccount())
							.setParameter("hostname", lsfhSave.getHostname()).getResultList();
					insertInswRecon(installedswlist,psRemoteUser);
				}
			}
		} else {
			// Insert a ScheduleF record
			psfSave.setRemoteUser(psRemoteUser);
			psfSave.setRecordTime(new Date());
			getEntityManager().persist(psfSave);

			// Always insert a row into the Recon_Customer_Sw table for the new
			// data
			lbSaveReconRow = true;
		}

		if (lbSaveReconRow){
			if (psfSave.getLevel().equals(ScheduleFLevelEnumeration.PRODUCT.toString()) ){
				@SuppressWarnings("unchecked")
				List<ReconCustomerSoftware> results = getEntityManager()
						.createNamedQuery("reconCustomerSwExists")
						.setParameter("productInfo", psfSave.getProductInfo())
						.setParameter("account", psfSave.getAccount())
						.getResultList();
				
				if (results == null || results.isEmpty()) {
					ReconCustomerSoftware lrcsSave = new ReconCustomerSoftware();

					lrcsSave.setAccount(psfSave.getAccount());
					lrcsSave.setProductInfo(psfSave.getProductInfo());
					lrcsSave.setAction("UPDATE");
					lrcsSave.setRecordTime(new Date());
					lrcsSave.setRemoteUser(psRemoteUser);
					getEntityManager().persist(lrcsSave);
				}
			}
			
			if (psfSave.getLevel().equals(ScheduleFLevelEnumeration.HWOWNER.toString()) ){
				@SuppressWarnings("unchecked")
				List<InstalledSoftware> installedswlist = getEntityManager()
						.createQuery(
								"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH a.softwareLpar.hardwareLpar c JOIN FETCH a.softwareLpar.hardwareLpar.hardware d WHERE a.status='ACTIVE'  AND c.status='ACTIVE' AND  a.productInfo = :productInfo AND b.account = :account AND d.owner = :owner")
						.setParameter("productInfo",psfSave.getProductInfo())
						.setParameter("account",psfSave.getAccount())
						.setParameter("owner", psfSave.getHwOwner()).getResultList();
				insertInswRecon(installedswlist,psRemoteUser);
			}
			
			if (psfSave.getLevel().equals(ScheduleFLevelEnumeration.HWBOX.toString()) ){
				@SuppressWarnings("unchecked")
				List<InstalledSoftware> installedswlist = getEntityManager()
						.createQuery(
								"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b JOIN FETCH b.hardwareLpar c JOIN FETCH c.hardware d JOIN FETCH d.machineType e  Where a.status='ACTIVE'  and d.status='ACTIVE' and a.productInfo = :productInfo and b.account = :account and d.serial = :serail and e.name = :name")
						.setParameter("productInfo",psfSave.getProductInfo())
						.setParameter("account",psfSave.getAccount())
						.setParameter("serail", psfSave.getSerial())
						.setParameter("name", psfSave.getMachineType()).getResultList();
				insertInswRecon(installedswlist,psRemoteUser);
			}
			
			if (psfSave.getLevel().equals(ScheduleFLevelEnumeration.HOSTNAME.toString())){
				@SuppressWarnings("unchecked")
				List<InstalledSoftware> installedswlist = getEntityManager()
						.createQuery(
								"FROM InstalledSoftware a JOIN FETCH a.softwareLpar b Where a.status='ACTIVE' and a.productInfo = :productInfo and b.account = :account and b.name = :hostname")
						.setParameter("productInfo",psfSave.getProductInfo())
						.setParameter("account",psfSave.getAccount())
						.setParameter("hostname", psfSave.getHostname()).getResultList();
				insertInswRecon(installedswlist,psRemoteUser);
			}		
		}

	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public void paginatedList(DisplayTagList pdtlData, Account pAccount,
			int piStartIndex, int piObjectsPerPage, String psSort, String psDir) {
		Session lSession = (Session) getEntityManager().getDelegate();
		ScrollableResults lsrList = lSession
				.createQuery(
						lSession.getNamedQuery("scheduleFList")
								.getQueryString()
								+ " ORDER BY "
								+ psSort
								+ " "
								+ psDir).setParameter("account", pAccount)
				.scroll();
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
	private ScheduleF findScheduleF(Long plId) {
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
		
		switch (cell.getColumnIndex()) {
		case 0: { // Level
			if(cell.getRow().getCell(4)!=null){cell.getRow().getCell(4).setCellType(Cell.CELL_TYPE_STRING);}
			if(cell.getRow().getCell(2)!=null){cell.getRow().getCell(2).setCellType(Cell.CELL_TYPE_STRING);}
			if(cell.getRow().getCell(3)!=null){cell.getRow().getCell(3).setCellType(Cell.CELL_TYPE_STRING);}
			if (StringUtils.isEmpty(cell.getRichStringCellValue().getString())) {
				throw new Exception("Level is required.");
			} else if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Level is not a string.");
			} else if (cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.HWOWNER.toString())
					&& (cell.getRow().getCell(1)==null || StringUtils.isEmpty(cell.getRow().getCell(1)
							.getRichStringCellValue().getString()))) {
				throw new Exception("HW owner is required.");
			} else if (cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.HWBOX.toString())
					&& ((cell.getRow().getCell(3)==null || StringUtils.isEmpty(cell.getRow().getCell(3)
							.getRichStringCellValue().getString())) || (cell.getRow().getCell(4)==null || StringUtils
							.isEmpty(cell.getRow().getCell(4)
									.getRichStringCellValue().getString())))) {
				throw new Exception(
						"Serial number and Machine type are required.");
			} else if (cell.getRichStringCellValue().getString()
					.equals(ScheduleFLevelEnumeration.HOSTNAME.toString())
					&& (cell.getRow().getCell(2)==null || StringUtils.isEmpty(cell.getRow().getCell(2)
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
						.getString().equals(ScheduleFLevelEnumeration.HWOWNER.toString())) {
					throw new Exception("Level is not specified with HWOWNER.");
				} else {
					sf.setHwOwner(cell.getRichStringCellValue().getString());
				}
			}
			break;
		}
		case 2: { // Hostname
			if(cell!=null){cell.setCellType(Cell.CELL_TYPE_STRING);}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
					.getString())) {
				if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
					throw new Exception("Hostname is not a string.");
				} else if (!cell.getRow().getCell(0).getRichStringCellValue()
						.getString().equals(ScheduleFLevelEnumeration.HOSTNAME.toString())) {
					throw new Exception("Level is not specified with HOSTNAME.");
				} else {
					sf.setHostname(cell.getRichStringCellValue().getString());
				}
			}
			break;
		}
		case 3: { // Serial number
			if(cell!=null){cell.setCellType(Cell.CELL_TYPE_STRING);}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
					.getString())) {
				if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
					throw new Exception("Serial number is not a string.");
				} else if (!cell.getRow().getCell(0).getRichStringCellValue()
						.getString().equals(ScheduleFLevelEnumeration.HWBOX.toString())) {
					throw new Exception("Level is not specified with HWBOX.");
				} else {
					sf.setSerial(cell.getRichStringCellValue().getString());
				}
			}
			break;
		}
		case 4: { // Machine type
			if(cell!=null){cell.setCellType(Cell.CELL_TYPE_STRING);}
			if (StringUtils.isNotEmpty(cell.getRichStringCellValue()
					.getString())) {
				if (!cell.getRow().getCell(0).getRichStringCellValue()
						.getString().equals(ScheduleFLevelEnumeration.HWBOX.toString())) {
					throw new Exception("Level is not specified with HWBOX.");
				} else {
					 List<MachineType> mtlist =  findMachineTypebyName(cell.getRichStringCellValue().getString()
									.toUpperCase());
					if (mtlist == null || mtlist.isEmpty()) {
						throw new Exception("Machine Type is invalid.");
					} else {
					sf.setMachineType(mtlist.get(0).getName());
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
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Software title is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Software title is required.");
			} else {
				sf.setSoftwareTitle(cell.getRichStringCellValue().getString());
			}

			break;
		}

		case 7: { // Software name
			ArrayList<ProductInfo> lalProductInfo = null;

			if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
				sf.setSoftwareName(cell.getRichStringCellValue().getString());
			} else {
				throw new Exception("Software name is not a string.");
			}

			lalProductInfo = findProductInfoBySoftwareName(sf.getSoftwareName());
			if (lalProductInfo.size() > 0) {
				sf.setProductInfo(lalProductInfo.get(0));
				if (lalProductInfo.get(0).getDeleted().equals(1)){
					@SuppressWarnings("unchecked")
					List<Status> results = getEntityManager()
							.createNamedQuery("statusDetails")
							.setParameter(
									"description",
									"INACTIVE").getResultList();
					sf.setStatus(results.get(0));
				}

			} else {
				throw new Exception("Software does not exist in catalog");
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
				sf.setManufacturer(cell.getRichStringCellValue().getString());
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
				} else if (cell.getRow().getCell(0).getRichStringCellValue().getString()
						.equals(ScheduleFLevelEnumeration.HWOWNER.toString())){
					String[] scDesParts = results.get(0).getDescription().split(",");
					if (scDesParts[0].contains("IBM owned") && cell.getRow().getCell(1).getRichStringCellValue()
							.getString().equals("IBM")) {
						sf.setScope(results.get(0));
					} else if (scDesParts[0].contains("Customer owned") && cell.getRow().getCell(1).getRichStringCellValue()
							.getString().equals("CUSTO")) {
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

		case 10: { // Source
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

		case 11: { // Source location
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Source location is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Source location is required.");
			} else {
				sf.setSourceLocation(cell.getRichStringCellValue().getString());
			}

			break;
		}

		case 12: { // Status
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
				} else if(!(sf.getStatus() instanceof Status && sf.getStatus().getId() > 0 )) {
					sf.setStatus(results.get(0));
				}
			} else {
				throw new Exception("Status is not a string.");
			}

			break;
		}

		case 13: { // Business justification
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
			lsErrorMessage = "Software title is required.";

			break;
		}

		case 7: { // Software name
			lsErrorMessage = "Software name is required.";

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

		case 10: { // Source
			lsErrorMessage = "Source is required.";

			break;
		}

		case 11: { // Source location
			lsErrorMessage = "Source location is required.";

			break;
		}

		case 12: { // Status
			lsErrorMessage = "Status is required.";

			break;
		}

		case 13: { // Business justification
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
