/*
 * Created on May 31, 2006
 */
package com.ibm.ea.bravo.hardware;

import com.ibm.ea.bravo.framework.common.OrmBase;

/**
 * @author denglers
 */
public class SCRTRecord extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -3892313570350390627L;

    private Long id;

	private Hardware hardware;

	private Integer year;

	private Integer month;

	private Integer cpc;
	
	private String lpar;

	private Integer msu;

	private String scrtReportFile;
	
	private String uploadDay;
	
	public Integer getCpc() {
		return this.cpc;
	}
	public void setCpc(Integer cpc) {
		this.cpc = cpc;
	}
	public Hardware getHardware() {
		return this.hardware;
	}
	public void setHardware(Hardware hardware) {
		this.hardware = hardware;
	}
	public Long getId() {
		return this.id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getLpar() {
		return this.lpar;
	}
	public void setLpar(String lpar) {
		this.lpar = lpar;
	}
	public Integer getMonth() {
		return this.month;
	}
	public void setMonth(Integer month) {
		this.month = month;
	}
	public Integer getMsu() {
		return this.msu;
	}
	public void setMsu(Integer msu) {
		this.msu = msu;
	}
	public String getScrtReportFile() {
		return this.scrtReportFile;
	}
	public void setScrtReportFile(String scrtReportFile) {
		this.scrtReportFile = scrtReportFile;
	}
	public Integer getYear() {
		return this.year;
	}
	public void setYear(Integer year) {
		this.year = year;
	}
	
	public String getUploadDay() {
		this.uploadDay = (this.recordTime.toString().split(" "))[0];
		return this.uploadDay;
	}
	public void setUploadDay(String uploadDay) {
		this.uploadDay = uploadDay;
	}
}