/*
 * Created on May 28, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.sigbank.framework.common;

import java.math.BigDecimal;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

/**
 * @author newtont
 * 
 * This object is used as an abstract class for common utilities.
 */
public abstract class Util {

	static Logger logger = Logger.getLogger(Util.class);

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
		} catch (Exception e) {
			return false;
		}
	}

	public static boolean isFloat(String str) {
		try {
			Float.parseFloat(str);
			logger.debug(Float.parseFloat(str) + "");
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	public static boolean isDouble(String str) {
		try {
			Double.parseDouble(str);
			logger.debug(Double.parseDouble(str) + "");
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	protected static boolean isDecimal(String str) {
		try {
			new BigDecimal(str);
			return true;
		} catch (Exception e) {
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
		} catch (Exception e) {
		}

		return false;

	}

	public static String findValue(String value, String defaultValue,
			String[] range) {

		if (Util.isBlankString(value)) {
			return defaultValue;
		}

		boolean pass = false;

		for (int i = 0; i < range.length; i++) {
			if (value.equals(range[i])) {
				pass = true;
			}
		}

		if (pass) {
			return value;
		} else {
			return defaultValue;
		}

	}

	public static Date parseDateString(String str) {

		Format formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		try {
			return (Date) formatter.parseObject(str);
		} catch (ParseException e) {
			logger.error(e, e);
		}
		return null;
	}

	public static Date parseDayString(String str) {

		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");

		try {
			String dates[] = str.split("/");

			if (!valideDate(dates[2], dates[0], dates[1])) {
				return null;
			}

			Date returnDate = (Date) format.parse(str);
			Calendar cal = Calendar.getInstance();
			cal.setTime(returnDate);
			int year = cal.get(Calendar.YEAR);

			if (year < 100) {
				cal.set(Calendar.YEAR, year + 2000);
				returnDate = cal.getTime();
			}
			System.out.println("Date is: " + returnDate.toString());

			return returnDate;
		} catch (Exception e) {

		}

		format = new SimpleDateFormat("yyyy-MM-dd");

		try {
			String dates[] = str.split("-");

			if (!valideDate(dates[0], dates[1], dates[2])) {
				return null;
			}
			Date returnDate = format.parse(str);
			Calendar cal = Calendar.getInstance();
			cal.setTime(returnDate);
			int year = cal.get(Calendar.YEAR);

			if (year < 100) {
				cal.set(Calendar.YEAR, year + 2000);
				returnDate = cal.getTime();
			}

			return returnDate;
		} catch (Exception e) {

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
				} else {
					if (intDay > 28) {

						return false;
					}
				}
			}

			return true;

		} catch (Exception e) {
			return false;
		}

	}

	public static boolean isLeapYear(int intYear) {
		if (intYear % 100 == 0) {
			if (intYear % 400 == 0) {
				return true;
			}
		} else {
			if ((intYear % 4) == 0) {
				return true;
			}
		}

		return false;
	}

}