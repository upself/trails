/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;


/**
 * @author Thomas
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SoftwareSignature {
    private Long softwareSignatureId;
    private Product software;
    
    private String tcmId;
    private String fileName;
    private Integer fileSize;
    private String softwareVersion;
    private String signatureSource;
    private String checksumQuick;
    private String checksumCrc32;
    private String checksumMd5;
    private Date endOfSupport;
    private String endOfSupportDate;

    private String osType;
    
    private String remoteUser;
    private Date recordTime;
    private String status;
    
    /**
     * @return Returns the recordTimeString.
     */
    public String getRecordTimeString() {
        return recordTime.toString();
    }
    /**
     * @param recordTimeString The recordTimeString to set.
     */
    public void setRecordTimeString(String recordTimeString) {
    }
    
    /**
     * @return Returns the endOfSupportDate.
     */
    public String getEndOfSupportDate() {
        return endOfSupportDate;
    }
    /**
     * @param endOfSupportDate The endOfSupportDate to set.
     */
    public void setEndOfSupportDate(String endOfSupportDate) {
        this.endOfSupportDate = endOfSupportDate;
    }

    /**
     * @return Returns the checksumCrc32.
     */
    public String getChecksumCrc32() {
        return checksumCrc32;
    }
    /**
     * @param checksumCrc32 The checksumCrc32 to set.
     */
    public void setChecksumCrc32(String checksumCrc32) {
        this.checksumCrc32 = checksumCrc32;
    }
    /**
     * @return Returns the checksumMd5.
     */
    public String getChecksumMd5() {
        return checksumMd5;
    }
    /**
     * @param checksumMd5 The checksumMd5 to set.
     */
    public void setChecksumMd5(String checksumMd5) {
        this.checksumMd5 = checksumMd5;
    }
    /**
     * @return Returns the checksumQuick.
     */
    public String getChecksumQuick() {
        return checksumQuick;
    }
    /**
     * @param checksumQuick The checksumQuick to set.
     */
    public void setChecksumQuick(String checksumQuick) {
        this.checksumQuick = checksumQuick;
    }
    /**
     * @return Returns the endOfSupport.
     */
    public Date getEndOfSupport() {
        return endOfSupport;
    }
    /**
     * @param endOfSupport The endOfSupport to set.
     */
    public void setEndOfSupport(Date endOfSupport) {
        this.endOfSupport = endOfSupport;
    }
    /**
     * @return Returns the fileName.
     */
    public String getFileName() {
        return fileName;
    }
    /**
     * @param fileName The fileName to set.
     */
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    /**
     * @return Returns the fileSize.
     */
    public Integer getFileSize() {
        return fileSize;
    }
    /**
     * @param fileSize The fileSize to set.
     */
    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }
    /**
     * @return Returns the osType.
     */
    public String getOsType() {
        return osType;
    }
    /**
     * @param osType The osType to set.
     */
    public void setOsType(String osType) {
        this.osType = osType;
    }

    /**
     * @return Returns the recordTime.
     */
    public Date getRecordTime() {
        return recordTime;
    }
    /**
     * @param recordTime The recordTime to set.
     */
    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
    }
    /**
     * @return Returns the remoteUser.
     */
    public String getRemoteUser() {
        return remoteUser;
    }
    /**
     * @param remoteUser The remoteUser to set.
     */
    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }
    /**
     * @return Returns the signatureSource.
     */
    public String getSignatureSource() {
        return signatureSource;
    }
    /**
     * @param signatureSource The signatureSource to set.
     */
    public void setSignatureSource(String signatureSource) {
        this.signatureSource = signatureSource;
    }
    /**
     * @return Returns the software.
     */
    public Product getSoftware() {
        return software;
    }
    /**
     * @param software The software to set.
     */
    public void setSoftware(Product software) {
        this.software = software;
    }
    /**
     * @return Returns the softwareSignatureId.
     */
    public Long getSoftwareSignatureId() {
        return softwareSignatureId;
    }
    /**
     * @param softwareSignatureId The softwareSignatureId to set.
     */
    public void setSoftwareSignatureId(Long softwareSignatureId) {
        this.softwareSignatureId = softwareSignatureId;
    }
    /**
     * @return Returns the softwareVersion.
     */
    public String getSoftwareVersion() {
        return softwareVersion;
    }
    /**
     * @param softwareVersion The softwareVersion to set.
     */
    public void setSoftwareVersion(String softwareVersion) {
        this.softwareVersion = softwareVersion;
    }
    /**
     * @return Returns the status.
     */
    public String getStatus() {
        return status;
    }
    /**
     * @param status The status to set.
     */
    public void setStatus(String status) {
        this.status = status;
    }
    /**
     * @return Returns the tcmId.
     */
    public String getTcmId() {
        return tcmId;
    }
    /**
     * @param tcmId The tcmId to set.
     */
    public void setTcmId(String tcmId) {
        this.tcmId = tcmId;
    }
}
