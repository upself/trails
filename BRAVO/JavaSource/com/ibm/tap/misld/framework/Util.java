/*
 * Created on May 28, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.framework;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.ListIterator;
import java.util.Properties;
import java.util.Vector;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import org.apache.log4j.Category;
import org.hibernate.HibernateException;

import com.ibm.tap.misld.delegate.holiday.HolidayReadDelegate;
import com.ibm.tap.misld.om.holiday.Holiday;

/**
 * @author newtont
 * 
 * This object is used as an abstract class for common utilities.
 */
public abstract class Util {

    static Category logger = Category.getInstance(Util.class.getName());

    public static boolean isSingleAlphaNumericWord(String str) {
        Pattern pattern = Pattern.compile("\\w");
        String words[] = pattern.split(str);

        if (words.length > 1) {
            return false;
        }

        return true;
    }

    public static boolean isWithUnderscore(String str) {
        Pattern pattern = Pattern.compile("(_)");
        String words[] = pattern.split(str);

        if (words.length > 1) {
            return false;
        }

        return true;
    }

    public static boolean isBlankString(String str) {
        if (str == null) {
            return true;
        }

        return (str.length() == 0);
    }

    public static boolean isInt(String str) {
        try {
            Integer.parseInt(str);
            return true;
        }
        catch (Exception e) {
            return false;
        }
    }

    public static boolean isFloat(String str) {
        try {
            Float.parseFloat(str);
            logger.debug(Float.parseFloat(str) + "");
            return true;
        }
        catch (Exception e) {
            return false;
        }
    }

    public static boolean isDouble(String str) {
        try {
            Double.parseDouble(str);
            logger.debug(Double.parseDouble(str) + "");
            return true;
        }
        catch (Exception e) {
            return false;
        }
    }

    public static boolean isDecimal(String str) {
        try {
            new BigDecimal(str);
            return true;
        }
        catch (Exception e) {
            return false;
        }
    }

    protected static boolean isZeroStr(String str) {

        float zeroFloat;

        try {
            zeroFloat = Float.parseFloat(str);

            if (zeroFloat == 0) {
                return true;
            }
        }
        catch (Exception e) {
        }

        return false;

    }

    public static boolean isCharLength(String str, int length) {
        if (str == null) {
            return false;
        }

        if (str.length() == length) {
            return true;
        }

        return false;
    }

    public static String parseDateString(Date date) {

        String monthStr = "";
        String dayStr = "";
        String yearStr = "";

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int month = cal.get(Calendar.MONTH);
        month = month + 1;
        if (month < 10) {
            monthStr = "0" + month;
        }
        else {
            monthStr = "" + month;
        }
        int day = cal.get(Calendar.DATE);
        if (day < 10) {
            dayStr = "0" + day;
        }
        else {
            dayStr = "" + day;
        }
        int year = cal.get(Calendar.YEAR);
        if (year < 100) {
            yearStr = "" + year + 2000;
        }
        else {
            yearStr = "" + year;
        }
        return monthStr + "/" + dayStr + "/" + yearStr;
    }

    public static Date parseDayString(String str) {
        SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");

        try {
            String dates[] = str.split("/");

            if (!valideDate(dates[2], dates[0], dates[1])) {

            }

            Date returnDate = (Date) format.parse(str);
            Calendar cal = Calendar.getInstance();
            cal.setTime(returnDate);
            int year = cal.get(Calendar.YEAR);

            if (year < 100) {
                cal.set(Calendar.YEAR, year + 2000);
                returnDate = cal.getTime();
            }

            return returnDate;
        }
        catch (Exception e) {
            
        }

        format = new SimpleDateFormat("yyyy-MM-dd");

        try {
            String dates[] = str.split("-");

            if (!valideDate(dates[0], dates[1], dates[2])) {
                return null;
            }
            Date returnDate = (Date)format.parse(str);
            Calendar cal = Calendar.getInstance();
            cal.setTime(returnDate);
            int year = cal.get(Calendar.YEAR);

            if (year < 100) {
                cal.set(Calendar.YEAR, year + 2000);
                returnDate = cal.getTime();
            }
            return returnDate;
        }
        catch (Exception f) {
            f.printStackTrace();
        }

        return null;
    }

    public static Date parseBaselineDate(String str) {

        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        try {
            Date returnDate = format.parse(str);
            Calendar cal = Calendar.getInstance();
            cal.setTime(returnDate);
            int year = cal.get(Calendar.YEAR);

            if (year < 100) {
                cal.set(Calendar.YEAR, year + 2000);
                returnDate = cal.getTime();
            }

            return returnDate;
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public static boolean valideDate(String year, String month, String day) {
        int intYear = 0;
        int intMonth = 0;
        int intDay = 0;

        try {
            intYear = Integer.parseInt(year);
            intMonth = Integer.parseInt(month);
            intDay = Integer.parseInt(day);

            if (intYear < 999) {
                return false;
            }

            if (intMonth > 12 || intMonth < 1) {
                return false;
            }

            if ((intMonth == 1 || intMonth == 3 || intMonth == 5
                    || intMonth == 7 || intMonth == 8 || intMonth == 10 || intMonth == 12)
                    && (intDay > 31 || intDay < 1)) {
                return false;
            }
            if ((intMonth == 4 || intMonth == 6 || intMonth == 9 || intMonth == 11)
                    && (intDay > 30 || intDay < 1)) {

                return false;
            }
            if (intMonth == 2) {
                if (intDay < 1) {

                    return false;
                }
                if (isLeapYear(intYear)) {
                    if (intDay > 29) {
                        return false;
                    }
                }
                else {
                    if (intDay > 28) {

                        return false;
                    }
                }
            }

            return true;

        }
        catch (Exception e) {
            return false;
        }

    }

    public static boolean isLeapYear(int intYear) {
        if (intYear % 100 == 0) {
            if (intYear % 400 == 0) {
                return true;
            }
        }
        else {
            if ((intYear % 4) == 0) {
                return true;
            }
        }

        return false;
    }

    public static int calculateBusinessDays(Calendar startDate, Calendar endDate) throws HibernateException,
		NamingException {
    	
    	int businessDays = 0;  
    	
		List holidays = HolidayReadDelegate.getHolidays(); 
		boolean dateIsAHoliday = false;

    	Calendar calDt = (Calendar) startDate.clone();
		calDt.add(Calendar.DAY_OF_MONTH, 1); 
    	while (calDt.before(endDate)) {   
    		
			dateIsAHoliday = isHoliday(holidays, calDt);
    		
    		// If the Date is not a business holiday and is a week day, then increment the business days counter
    		if (!dateIsAHoliday && (calDt.get(Calendar.DAY_OF_WEEK) > 1  && calDt.get(Calendar.DAY_OF_WEEK) < 7)) {
    			businessDays++;  
    		}

    		calDt.add(Calendar.DAY_OF_MONTH, 1);
    	}  

    	return businessDays; 
    }
    
    public static boolean isHoliday(List holidays, Calendar nextDate) {
    	
    	boolean dateIsAHoliday = false;
		Holiday holiday = new Holiday();
		Date holidayDt = new Date();

		ListIterator holidayIterator = holidays.listIterator(); 
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	String nextDt = sdf.format(nextDate.getTime());
		
		while(holidayIterator.hasNext()) {
			holiday = (Holiday)holidayIterator.next();
			holidayDt = holiday.getHoliday();
			if (holidayDt.toString().equals(nextDt)) {
				dateIsAHoliday = true;
			}
		}
    	return dateIsAHoliday;
    }
    
    public static boolean isIBMEmail(String email) {
        if (isBlankString(email)) {
            return false;
        }

        String searchBase = "ou=bluepages,o=ibm.com";

        String server = "ldap://bluepages.ibm.com:389";

        Properties env1 = new Properties();
        env1.put(Context.INITIAL_CONTEXT_FACTORY,
                "com.sun.jndi.ldap.LdapCtxFactory");
        env1.put(Context.PROVIDER_URL, server);
        env1.put("java.naming.ldap.derefAliases", "never");
        env1.put("java.naming.ldap.version", "2");
        Vector v = new Vector();
        Hashtable h = new Hashtable();

        try {
            String attrlist[] = { "uid" };
            String filter = "(mail=" + email + ")";
            SearchControls constraints = new SearchControls();
            constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
            constraints.setReturningAttributes(attrlist);
            DirContext ctx = new InitialDirContext(env1);
            NamingEnumeration results = ctx.search(searchBase, filter,
                    constraints);
            ctx.close(); //close the connection

            SearchResult sr;
            Attributes attrs;
            Attribute attr;
            Enumeration vals;
            Object q;
            while (results.hasMore()) {
                sr = (SearchResult) results.next();
                attrs = sr.getAttributes();
                //snag the DN

                h = new Hashtable();
                for (NamingEnumeration ae = attrs.getAll(); ae.hasMore();) {
                    attr = (Attribute) ae.next();
                    vals = attr.getAll();
                    q = vals.nextElement();
                    try {
                        h.put(attr.getID(), (String) q);
                    } //put the String in the hash
                    catch (ClassCastException cce) //it's not a String, so
                    // "decode" it (int'l chars)
                    {
                        try {
                            byte b[] = (byte[]) q;
                            String s = new String(b, "ISO-8859-1");
                            h.put(attr.getID(), s); //put the string in the
                            // hash
                        }
                        catch (UnsupportedEncodingException ue) {
                        }
                    }
                }
                if (h.size() > 0)
                    v.addElement(h); //no reason to add the hash if it is empty
            }

        }
        catch (NamingException ne) {
            ne.printStackTrace();
            logger.error(ne, ne);
            return false;
        }

        if (v.size() == 0) {
            logger.debug("LDAP query size was 0 ");
            return false;
        }

        return true;

    }
}