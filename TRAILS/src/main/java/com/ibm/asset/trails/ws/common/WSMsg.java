package com.ibm.asset.trails.ws.common;

import java.util.List;

public class WSMsg {
	private String status;
	private String msg;
	private Object data;
	private List<?> dataList;
	
	public static final String SUCCESS = "200";
	public static final String FAIL = "400";
	public static final String NOT_FOUND = "404";
	
	private WSMsg(){
		
	}
	
	private WSMsg(String status, String msg){
		this.status = status;
		this.msg = msg;
	}
	
	private WSMsg(String status, String msg, Object data, List<?> dataList){
		this.status = status;
		this.msg = msg;
		this.data = data;
		this.dataList = dataList;
	}
	
	public static WSMsg failMessage(String message){
		return new WSMsg(FAIL,message);
	}
	
	public static WSMsg failMessage(String status, String message){
		return new WSMsg(status,message);
	}
	
	public static WSMsg successMessage(String message){
		return new WSMsg(SUCCESS,message);
	}
	
	public static WSMsg successMessage(String message, Object data){
		return new WSMsg(SUCCESS,message, data, null);
	} 
	
	public static WSMsg successMessage(String message, List<?> dataList){
		return new WSMsg(SUCCESS,message, null, dataList);
	} 
	
	public static WSMsg successMessage(String message, Object data, List<?> dataList){
		return new WSMsg(SUCCESS, message, data, dataList);
	}
	
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public List<?> getDataList() {
		return dataList;
	}

	public void setDataList(List<?> dataList) {
		this.dataList = dataList;
	} 
	
}
