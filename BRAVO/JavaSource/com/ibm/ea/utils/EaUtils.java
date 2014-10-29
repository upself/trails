/*
 * Created on Jun 11, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EaUtils {
	
	private static SimpleDateFormat monthDayYear = new SimpleDateFormat("MM/dd/yyyy");
	private static SimpleDateFormat yearMonthDay = new SimpleDateFormat("yyyyMMdd");
	private static SimpleDateFormat hourMinuteSecond = new SimpleDateFormat("hhmmss");
	private static SimpleDateFormat timeStamp = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss.SSSSSS");

	public static boolean isBlank(String string) {
		return string == null || string.equals("") ? true : false;
	}

	public static boolean isEmpty(String string) {
		return string == null || string.trim().equals("") ? true : false;
	}

	public static String join(Object[] array, String delimiter) {
		StringBuffer sb = join(array, delimiter, new StringBuffer());
		return sb.toString();
	}

	public static StringBuffer join(Object[] array, String delimiter, StringBuffer sb) {
        for (int i = 0; i < array.length; i++) {
            String s;

            if (array[i] == null) {
                s = "";
            } else {
                s = array[i].toString().trim();
                if(s.contains("\r\n"))
                	s=s.replaceAll("\r\n", " ");
            }

            if (i != 0)
                sb.append(delimiter);
            
            sb.append(s);
        }

        return sb;
	}

	public static String yearMonthDay(Date date) {
		return date == null ? "" : yearMonthDay.format(date);
	}

	public static String monthDayYear(Date date) {
		return date == null ? "" : monthDayYear.format(date);
	}

	public static String hourMinuteSecond(Date date) {
		return date == null ? "" : hourMinuteSecond.format(date);
	}
	public static String timeStamp(Date date) {
		return date == null ? "" : timeStamp.format(date);
	}	
    public static boolean isPositiveInteger(String str) {
        try {
            int i = Integer.parseInt(str);
            if(i > 0) {
            	return true;
            }
            return false;
        }
        catch (Exception e) {
            return false;
        }
    }
	
}