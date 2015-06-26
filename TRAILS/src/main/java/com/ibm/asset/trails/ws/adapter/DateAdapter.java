package com.ibm.asset.trails.ws.adapter;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class DateAdapter extends XmlAdapter<String, Date>{

	private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	@Override
	public Date unmarshal(String v) throws Exception {
		// TODO Auto-generated method stub
		return dateFormat.parse(v); 
	}

	@Override
	public String marshal(Date v) throws Exception {
		// TODO Auto-generated method stub
		return dateFormat.format(v);
	}

}
