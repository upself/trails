package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;

import com.ibm.ea.sigbank.ProductInfo;

public class ProductInfoTestHelper {

	public static ProductInfo createRecord() {
		
		ProductInfo productInfo = new ProductInfo();
		productInfo.setRecordTime(new Date());
		productInfo.setRemoteUser("SWKBT");
		productInfo.setChangeJustification("changeJustification");
		productInfo.setLicensable(true);
		productInfo.setPriority(1);
		productInfo.setSoftwareCategoryId(1000L);
//		productInfo.setI
		return productInfo;
	}

	public static void deleteRecord(Long productInfoId) {
		// TODO Auto-generated method stub
		
	}

	
	
}
