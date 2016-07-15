package com.ibm.ea.bravo.software.delegatesoftware.test;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.InvalidCategory;

public class getInvalidCategoryListTest {

	@Test
	public void getInvalidCategoryListTadzTest() {
		List<InvalidCategory> list = new ArrayList<InvalidCategory>();
		
		List<InvalidCategory> listExpected = new ArrayList<InvalidCategory>();
		listExpected.add(new InvalidCategory(""));
		listExpected.add(new InvalidCategory("Blocked in IFAPRD"));
		listExpected.add(new InvalidCategory("Complex discovery"));
		listExpected.add(new InvalidCategory("IBM SW GSD Build"));
		
		list = DelegateSoftware.getInvalidCategoryList("TADZ");
		
		assertTrue("TADZ invalid category list", equalsInvalidCategoryList(list,listExpected));
		
	}
	
	@Test
	public void getInvalidCategoryListSwkbtTest() {
		List<InvalidCategory> list = new ArrayList<InvalidCategory>();
		
		List<InvalidCategory> listExpected = new ArrayList<InvalidCategory>();
		listExpected.add(new InvalidCategory(""));
		listExpected.add(new InvalidCategory("Blocked in IFAPRD"));
		listExpected.add(new InvalidCategory("Complex discovery"));
		
		list = DelegateSoftware.getInvalidCategoryList("SWKBT");
		
		assertTrue("TADZ invalid category list", equalsInvalidCategoryList(list, listExpected));
		
	}
	
	public boolean equalsInvalidCategoryList(List<InvalidCategory> fisrtList, List<InvalidCategory> secondList) {
		int i = 0;
		int j = 0;
		if (fisrtList.size() == secondList.size() ) {
			for(InvalidCategory firstCategory: fisrtList){
				j = 0;
				for (InvalidCategory secondCategory: secondList) {
				  if (i == j ){	
					  if (! secondCategory.getValue().equals(firstCategory.getValue())) {
						  return false;
					  }
					  else {
						  break;
					  }
				  }
				 j++;
				}
				i++;
			}
		} else {
			return false;
		}
		
		return true;
	}
	

}
