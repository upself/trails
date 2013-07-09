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
import org.hibernate.ScrollableResults;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ProductInfo;
import com.ibm.asset.trails.domain.ReconCustomerSoftware;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.ScheduleFH;
import com.ibm.asset.trails.domain.Scope;
import com.ibm.asset.trails.domain.Source;
import com.ibm.asset.trails.domain.Status;
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
            return productInforList;
        }
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
        HSSFCell cell = null;
        boolean lbHeaderRow = false;

        lcsError.setFillForegroundColor(HSSFColor.RED.index);
        lcsError.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        lcsNormal.setFillForegroundColor(HSSFColor.WHITE.index);
        lcsNormal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        for (liRow = sheet.rowIterator(); liRow.hasNext();) {
            row = (HSSFRow) liRow.next();
            sf = new ScheduleF();
            error = false;
            lsbErrorMessage = new StringBuffer();
            lbHeaderRow = false;

            for (int i = 0; i <= 8; i++) {
                cell = row.getCell(i);
                if (cell == null) {
                    cell = row.createCell(i);
                    cell.setCellStyle(lcsError);
                    lsbErrorMessage.append(error ? "\n" : "").append(
                            getErrorMessage(i));
                    error = true;
                } else {
                    cell.setCellStyle(lcsNormal);

                    try {
                        parseCell(cell, sf);
                    } catch (Exception e) {
                        if (row.getRowNum() == 0 && cell.getColumnIndex() == 0) {
                            lbHeaderRow = true;
                            break;
                        } else {
                            cell.setCellStyle(lcsError);
                            lsbErrorMessage.append(error ? "\n" : "").append(
                                    e.getMessage());
                            error = true;
                        }
                    }
                }
            }

            if (!lbHeaderRow) {
                if (error) {
                    cell = row.createCell(9);
                    cell.setCellStyle(lcsError);
                    cell.setCellValue(new HSSFRichTextString(lsbErrorMessage
                            .toString()));
                } else {
                    saveScheduleF(sf, psRemoteUser);
                }
            }
        }

        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        wb.write(bos);

        return bos;
    }

    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public void saveScheduleF(ScheduleF psfSave, String psRemoteUser) {
        boolean lbSaveReconRow = false;

        if (psfSave.getId() != null) {
            ScheduleF lsfExists = findScheduleF(psfSave.getId());
            ScheduleFH lsfhSave = new ScheduleFH();

            // Determine if we should insert a row into the Recon_Customer_Sw
            // table
            // for the new data and the old data
            if (psfSave.getAccount().getId().intValue() != lsfExists
                    .getAccount().getId().intValue()
                    || psfSave.getProductInfo().getId().longValue() != lsfExists
                            .getProductInfo().getId().longValue()
                    || psfSave.getScope().getId().intValue() != lsfExists
                            .getScope().getId().intValue()
                    || psfSave.getStatus().getId().intValue() != lsfExists
                            .getStatus().getId().intValue()) {
                // Insert into the Recon_Customer_Sw table a record for the old
                // data if
                // one doesn't already exist
                @SuppressWarnings("unchecked")
                List<ReconCustomerSoftware> results = getEntityManager()
                        .createNamedQuery("reconCustomerSwExists")
                        .setParameter("productInfo", lsfExists.getProductInfo())
                        .setParameter("account", lsfExists.getAccount())
                        .getResultList();
                ScheduleF result;
                if (results == null || results.isEmpty()) {
                    ReconCustomerSoftware lrcsSave = new ReconCustomerSoftware();

                    lrcsSave.setAccount(lsfExists.getAccount());
                    lrcsSave.setProductInfo(lsfExists.getProductInfo());
                    lrcsSave.setAction("UPDATE");
                    lrcsSave.setRecordTime(new Date());
                    lrcsSave.setRemoteUser(psRemoteUser);
                    getEntityManager().persist(lrcsSave);
                }

                // Set a flag to insert a row for the new data
                lbSaveReconRow = true;
            }

            // Insert a ScheduleFH record
            lsfhSave.setScheduleF(lsfExists);
            lsfhSave.setAccount(lsfExists.getAccount());
            lsfhSave.setProductInfo(lsfExists.getProductInfo());
            lsfhSave.setSoftwareTitle(lsfExists.getSoftwareTitle());
            lsfhSave.setSoftwareName(lsfExists.getSoftwareName());
            lsfhSave.setManufacturer(lsfExists.getManufacturer());
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
        } else {
            // Insert a ScheduleF record
            psfSave.setRemoteUser(psRemoteUser);
            psfSave.setRecordTime(new Date());
            getEntityManager().persist(psfSave);

            // Always insert a row into the Recon_Customer_Sw table for the new
            // data
            lbSaveReconRow = true;
        }

        // Insert into the Recon_Customer_Sw table a record for the new data if
        // one
        // doesn't already exist
        if (lbSaveReconRow) {
            ReconCustomerSoftware lrcsExists = null;

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

    private void parseCell(HSSFCell cell, ScheduleF sf) throws Exception {
        switch (cell.getColumnIndex()) {
        case 0: { // Account number
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

        case 1: { // Software title
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

        case 2: { // Software name
            ArrayList<ProductInfo> lalProductInfo = null;

            if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
                sf.setSoftwareName(cell.getRichStringCellValue().getString());
            } else {
                throw new Exception("Software name is not a string.");
            }

            lalProductInfo = findProductInfoBySoftwareName(sf.getSoftwareName());
            if (lalProductInfo.size() > 1) {
                sf.setProductInfo(lalProductInfo.get(0));
            } else if (lalProductInfo.size() == 1) {
                sf.setProductInfo(lalProductInfo.get(0));
            } else {
                throw new Exception("Software does not exist in catalog");
            }

            if (sf.getAccount() != null) {
                ScheduleF lsfExists = findScheduleF(sf.getAccount(),
                        lalProductInfo.get(0));

                if (lsfExists != null) {
                    // Fix the issue under TI00628-42792 'Can't massload update
                    // status
                    // of Schedule F'
                    //
                    // throw new Exception(
                    // "An entry with the given software name already exists.");
                    sf.setId(lsfExists.getId());
                }
            }
            break;
        }

        case 3: { // Manufacturer
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

        case 4: { // Scope
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
                } else {
                    sf.setScope(results.get(0));
                }
            } else {
                throw new Exception("Scope is not a string.");
            }

            break;
        }

        case 5: { // Source
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

        case 6: { // Source location
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

        case 7: { // Status
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
                } else {
                    sf.setStatus(results.get(0));
                }
            } else {
                throw new Exception("Status is not a string.");
            }

            break;
        }

        case 8: { // Business justification
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
        case 0: { // Account number
            lsErrorMessage = "Account number is required.";

            break;
        }

        case 1: { // Software title
            lsErrorMessage = "Software title is required.";

            break;
        }

        case 2: { // Software name
            lsErrorMessage = "Software name is required.";

            break;
        }

        case 3: { // Manufacturer
            lsErrorMessage = "Manufacturer is required.";

            break;
        }

        case 4: { // Scope
            lsErrorMessage = "Scope is required.";

            break;
        }

        case 5: { // Source
            lsErrorMessage = "Source is required.";

            break;
        }

        case 6: { // Source location
            lsErrorMessage = "Source location is required.";

            break;
        }

        case 7: { // Status
            lsErrorMessage = "Status is required.";

            break;
        }

        case 8: { // Business justification
            lsErrorMessage = "Business justification is required.";

            break;
        }
        }

        return lsErrorMessage;
    }

    private EntityManager getEntityManager() {
        return em;
    }

    @PersistenceContext
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
