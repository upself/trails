/*
 * Created on Jan 19, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.delegate.acl;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;
import java.util.TreeSet;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import org.apache.log4j.Logger;

import com.ibm.ea.cndb.Contact;
import com.ibm.ea.cndb.Pod;
import com.ibm.swat.password.ReturnCode;
import com.ibm.swat.password.cwa2;
import com.ibm.tap.misld.framework.Constants;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class BluegroupsDelegate {
    /**
     * Logger for this class
     */
    private static final int    SUCCESS           = 0;

    private static final int    NO_RECORD_FOUND   = 2;

    private static final Logger logger = Logger
    .getLogger(BluegroupsDelegate.class);

    /*
     * isMember
     * 
     * Checks group membersip
     * 
     * Parameters: memberName - Internet email address to check groupName - The
     * group to check Returns: boolean true - member of the group false - not a
     * member of the group
     */
    public static boolean isMember(String memberName, String groupName) {
        return isMember(memberName, groupName, Constants.BLUEGROUP_SUBDEPTH);
    }

    /*
     * isMember
     * 
     * Checks group membersip
     * 
     * Parameters: memberName - Internet email address to check groupName - The
     * group to check subgroupDepth - how many levels below to check Returns:
     * boolean true - member of the group false - not a member of the group
     */
    public static boolean isMember(String memberName, String groupName,
            int subgroupDepth) {

        // create query object
        cwa2 CWA2 = new cwa2(Constants.BLUEPAGES, Constants.BLUEGROUPS);

        // check if the user is a member of the group
        ReturnCode rc = CWA2.inAGroup(memberName, groupName, subgroupDepth);

        // 0 == success
        if (rc.getCode() == 0)
            return true;

        // by default, return false
        return false;
    }

    /*
     * addMember
     * 
     * Adds a member to a group.
     * 
     * Parameters: id - User name password - Password groupName - Group to be
     * added to. memberName - person to add such as jondoe@us.ibm.com Returns:
     * void - throws Exception on error
     */
    public static void addMember(String id, String password, String groupName,
            String memberName) throws Exception {

        // create query object
        cwa2 CWA2 = new cwa2(Constants.BLUEPAGES, Constants.BLUEGROUPS);

        // test the group
        if (!CWA2.groupExist(groupName)) {
            throw new Exception("group DNE: " + groupName);
        }

        // authenticate the id
        try {
            CWA2.authenticate_throw(id, password);
        }
        catch (Exception e) {
            throw new Exception("failed login: " + id);
        }

        // add the member
        ReturnCode rc = CWA2.addMember(id, password, groupName, memberName);

        // process the ReturnCode
        switch (rc.getCode()) {
        case (SUCCESS):
            break;
        case (NO_RECORD_FOUND):
            throw new Exception(rc.getMessage() + ": " + memberName);
        default:
            throw new Exception(rc.getMessage());
        }
    }

    /*
     * removeMember
     * 
     * Removes a member from a group.
     * 
     * Parameters: id - User name password - Password groupName - Group to be
     * added to. memberName - person to add such as jondoe@us.ibm.com Returns:
     * void - throws Exception on error
     */
    public static void removeMember(String id, String password,
            String groupName, String memberName) throws Exception {

        // create query object
        cwa2 CWA2 = new cwa2(Constants.BLUEPAGES, Constants.BLUEGROUPS);

        // test the group
        if (!CWA2.groupExist(groupName)) {
            throw new Exception("group DNE: " + groupName);
        }

        // authenticate the id
        try {
            CWA2.authenticate_throw(id, password);
        }
        catch (Exception e) {
            throw new Exception("failed login: " + id);
        }

        // remove the member
        ReturnCode rc = CWA2.removeMember(id, password, groupName, memberName);

        // process the ReturnCode
        switch (rc.getCode()) {
        case (SUCCESS):
            break;
        case (NO_RECORD_FOUND):
            throw new Exception(rc.getMessage() + ": " + memberName);
        default:
            throw new Exception(rc.getMessage());
        }
    }

    /*
     * addAdmin
     * 
     * Adds an Administrator to a group.
     * 
     * Parameters: id - User name password - Password groupName - Group to be
     * added to. memberName - person to add such as jondoe@us.ibm.com Returns:
     * void - throws Exception on error
     */
    public static void addAdmin(String id, String password, String groupName,
            String memberName) throws Exception {

        // create query object
        cwa2 CWA2 = new cwa2(Constants.BLUEPAGES, Constants.BLUEGROUPS);

        // test the group
        if (!CWA2.groupExist(groupName)) {
            throw new Exception("group DNE: " + groupName);
        }

        // authenticate the id
        try {
            CWA2.authenticate_throw(id, password);
        }
        catch (Exception e) {
            throw new Exception("failed login: " + id);
        }

        // add the admin
        ReturnCode rc = CWA2.addAdmin(id, password, groupName, memberName);

        // process the ReturnCode
        switch (rc.getCode()) {
        case (SUCCESS):
            break;
        case (NO_RECORD_FOUND):
            throw new Exception(rc.getMessage() + ": " + memberName);
        default:
            throw new Exception(rc.getMessage());
        }
    }

    /*
     * removeAdmin
     * 
     * Removes an Administrator from a group.
     * 
     * Parameters: id - User name password - Password groupName - Group to be
     * added to. memberName - person to add such as jondoe@us.ibm.com Returns:
     * void - throws Exception on error
     */
    public static void removeAdmin(String id, String password,
            String groupName, String memberName) throws Exception {

        // create query object
        cwa2 CWA2 = new cwa2(Constants.BLUEPAGES, Constants.BLUEGROUPS);

        // test the group
        if (!CWA2.groupExist(groupName)) {
            throw new Exception("group DNE: " + groupName);
        }

        // authenticate the id
        try {
            CWA2.authenticate_throw(id, password);
        }
        catch (Exception e) {
            throw new Exception("failed login: " + id);
        }

        // remove the admin
        ReturnCode rc = CWA2.removeAdmin(id, password, groupName, memberName);

        // process the ReturnCode
        switch (rc.getCode()) {
        case (SUCCESS):
            break;
        case (NO_RECORD_FOUND):
            throw new Exception(rc.getMessage() + ": " + memberName);
        default:
            throw new Exception(rc.getMessage());
        }
    }

    /*
     * listMemberEmails
     * 
     * Lists the member emails of the bluegroup
     * 
     * Parameters: groupName - Group to list from Returns: List - list of member
     * emails
     */
    public static List<String> listMemberEmails(String groupName) throws Exception {
        Vector<String> vector = new Vector<String>();

        // create query object
        cwa2 CWA2 = new cwa2(Constants.BLUEPAGES, Constants.BLUEGROUPS);

        // test the group
        if (!CWA2.groupExist(groupName)) {
            throw new Exception("group DNE: " + groupName);
        }

        // list the members
        ReturnCode rc = CWA2.listMembers(groupName,
                Constants.BLUEGROUP_SUBDEPTH, vector, "mail");

        // process the ReturnCode
        switch (rc.getCode()) {
        case (SUCCESS):
            break;
        default:
            throw new Exception(rc.getMessage());
        }

        // The Vector can have dupes, so lets get rid of those.
        // TreeSet will produce a sorted set
        List<String> list = new ArrayList<String>(new TreeSet<String>(vector));

        return list;
    }
    
	public static Contact getContactByEmail(String email) {
		// protect the email
		if (email != null) {
			email.replaceAll("\\*", "");
		}

		String filter = "(mail=" + email + ")";
		return getContact(filter);
	}

	public static Contact getContactByShortSerial(String shortSerial) {

		// protect the serial
		if (shortSerial != null) {
			shortSerial.replaceAll("\\*", "");
		}

		String filter = "(ibmserialnumber=" + shortSerial + ")";

		return getContact(filter);
	}

	public static Contact getContactByLongSerial(String longSerial) {

		// protect the uid
		if (longSerial != null) {
			longSerial.replaceAll("\\*", "");
		}

		String filter = "(uid=" + longSerial + ")";

		return getContact(filter);
	}

	public static Contact initContactMgmtInfo(Contact contact) {
		String filter = "(email=" + contact.getRemoteUser() + ")";
		String searchBase = "ou=bluepages,o=ibm.com";

		String server = "ldap://bluepages.ibm.com:389";

		Properties env1 = new Properties();
		env1.put(Context.INITIAL_CONTEXT_FACTORY,
				"com.sun.jndi.ldap.LdapCtxFactory");
		env1.put(Context.PROVIDER_URL, server);
		env1.put("java.naming.ldap.derefAliases", "never");
		env1.put("java.naming.ldap.version", "2");
		Vector<Hashtable<String, String>> v = new Vector<Hashtable<String, String>>();
		Hashtable<String, String> h = new Hashtable<String, String>();

		try {
			String attrlist[] = { "isManager", "managerSerialNumber",
					"managerCountryCode" };
			SearchControls constraints = new SearchControls();
			constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
			constraints.setReturningAttributes(attrlist);
			constraints.setCountLimit(1);
			constraints.setTimeLimit(30 * 1000);
			DirContext ctx = new InitialDirContext(env1);
			NamingEnumeration<SearchResult> results = ctx.search(searchBase, filter,
					constraints);
			ctx.close(); // close the connection

			SearchResult sr;
			Attributes attrs;
			Attribute attr;
			NamingEnumeration<?> vals;
			Object q;
			if (results != null && results.hasMore()) {
				sr = (SearchResult) results.next();
				attrs = sr.getAttributes();
				h = new Hashtable<String, String>();
				for (NamingEnumeration<? extends Attribute> ae = attrs.getAll(); ae.hasMore();) {
					attr = (Attribute) ae.next();
					vals = attr.getAll();
					q = vals.nextElement();
					try {
						h.put(attr.getID(), (String) q);
					} // put the String in the hash
					catch (ClassCastException cce) // it's not a String, so
					// "decode" it (int'l chars)
					{
						try {
							byte b[] = (byte[]) q;
							String s = new String(b, "ISO-8859-1");
							h.put(attr.getID(), s); // put the string in the
							// hash
						} catch (UnsupportedEncodingException ue) {
						}
					}

				}
				if (h.size() > 0)
					v.addElement(h); // no reason to add the hash if it is
				// empty
			}

		} catch (NamingException ne) {
			ne.printStackTrace();
			logger.error(ne, ne);
			return null;
		}

		if (v.size() == 0) {
			return null;
		}

		// contact.setFullName((String) h.get("callupName"));
		// contact.setSerial((String) h.get("uid"));
		// contact.setRemoteUser((String) h.get("mail"));
		// contact.setNotesMail((String) h.get("notesId"));
		contact.setManager(false);
		/*
		 * Iterator k = h.keySet().iterator(); while( k.hasNext()) { String key =
		 * (String)k.next(); logger.info( "'" + key + "' = '" + h.get( key ) +
		 * "'" ); }
		 */
		if (((String) h.get("isManager")).equalsIgnoreCase("Y")) {
			contact.setManager(true);
		}
		contact.setManagerSerial((String) h.get("managerSerialNumber")
				+ (String) h.get("managerCountryCode"));

		return contact;
	}

	private static Contact getContact(String filter) {
		Contact contact = new Contact();
		String searchBase = "ou=bluepages,o=ibm.com";

		String server = "ldap://bluepages.ibm.com:389";

		Properties env1 = new Properties();
		env1.put(Context.INITIAL_CONTEXT_FACTORY,
				"com.sun.jndi.ldap.LdapCtxFactory");
		env1.put(Context.PROVIDER_URL, server);
		env1.put("java.naming.ldap.derefAliases", "never");
		env1.put("java.naming.ldap.version", "2");
		Vector<Hashtable<String, String>> v = new Vector<Hashtable<String, String>>();
		Hashtable<String, String> h = new Hashtable<String, String>();

		try {
			String attrlist[] = { "uid", "mail", "notesId", "callupName", "managerSerialNumber", "managerCountryCode" };
			SearchControls constraints = new SearchControls();
			constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
			constraints.setReturningAttributes(attrlist);
			constraints.setCountLimit(1);
			constraints.setTimeLimit(30 * 1000);
			DirContext ctx = new InitialDirContext(env1);
			NamingEnumeration<?> results = ctx.search(searchBase, filter,
					constraints);
			ctx.close(); // close the connection

			SearchResult sr;
			Attributes attrs;
			Attribute attr;
			Enumeration<?> vals;
			Object q;
			if (results != null && results.hasMore()) {
				sr = (SearchResult) results.next();
				attrs = sr.getAttributes();
				h = new Hashtable<String, String>();
				for (NamingEnumeration<? extends Attribute> ae = attrs.getAll(); ae.hasMore();) {
					attr = (Attribute) ae.next();
					vals = attr.getAll();
					q = vals.nextElement();
					try {
						h.put(attr.getID(), (String) q);
					} // put the String in the hash
					catch (ClassCastException cce) // it's not a String, so
					// "decode" it (int'l chars)
					{
						try {
							byte b[] = (byte[]) q;
							String s = new String(b, "ISO-8859-1");
							h.put(attr.getID(), s); // put the string in the
							// hash
						} catch (UnsupportedEncodingException ue) {
						}
					}

				}
				if (h.size() > 0)
					v.addElement(h); // no reason to add the hash if it is
				// empty
			}

		} catch (NamingException ne) {
			ne.printStackTrace();
			logger.error(ne, ne);
			return null;
		}

		if (v.size() == 0) {
			return null;
		}

		contact.setFullName((String) h.get("callupName"));
		contact.setSerial((String) h.get("uid"));
		contact.setRemoteUser((String) h.get("mail"));
		contact.setNotesMail((String) h.get("notesId"));

		// TLN set the email to lower case
		contact.setRemoteUser(contact.getRemoteUser().toLowerCase());
		
		contact.setManagerSerial((String) h.get("managerSerialNumber")
				+ (String) h.get("managerCountryCode"));
		//contact.setManagerSerial((String) h.get( "managerUid" ));

		return contact;

	}
	private static Pod getDepartment(String filter) {
		Pod aaDept = new Pod();
		String searchBase = "ou=bluepages,o=ibm.com";

		String server = "ldap://bluepages.ibm.com:389";

		Properties env1 = new Properties();
		env1.put(Context.INITIAL_CONTEXT_FACTORY,
				"com.sun.jndi.ldap.LdapCtxFactory");
		env1.put(Context.PROVIDER_URL, server);
		env1.put("java.naming.ldap.derefAliases", "never");
		env1.put("java.naming.ldap.version", "2");
		Vector<Hashtable<String, String>> v = new Vector<Hashtable<String, String>>();
		Hashtable<String, String> h = new Hashtable<String, String>();

		try {
			String attrlist[] = { "dept", "managerSerialNumber", "nativeTitle", "title" };
			SearchControls constraints = new SearchControls();
			constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
			constraints.setReturningAttributes(attrlist);
			constraints.setCountLimit(1);
			constraints.setTimeLimit(30 * 1000);
			DirContext ctx = new InitialDirContext(env1);
			NamingEnumeration<?> results = ctx.search(searchBase, filter,
					constraints);
			ctx.close(); // close the connection

			SearchResult sr;
			Attributes attrs;
			Attribute attr;
			Enumeration<?> vals;
			Object q;
			if (results != null && results.hasMore()) {
				sr = (SearchResult) results.next();
				attrs = sr.getAttributes();
				h = new Hashtable<String, String>();
				for (NamingEnumeration<?> ae = attrs.getAll(); ae.hasMore();) {
					attr = (Attribute) ae.next();
					vals = attr.getAll();
					q = vals.nextElement();
					try {
						h.put(attr.getID(), (String) q);
					} // put the String in the hash
					catch (ClassCastException cce) // it's not a String, so
					// "decode" it (int'l chars)
					{
						try {
							byte b[] = (byte[]) q;
							String s = new String(b, "ISO-8859-1");
							h.put(attr.getID(), s); // put the string in the
							// hash
						} catch (UnsupportedEncodingException ue) {
						}
					}

				}
				if (h.size() > 0)
					v.addElement(h); // no reason to add the hash if it is
				// empty
			}

		} catch (NamingException ne) {
			ne.printStackTrace();
			logger.error(ne, ne);
			return null;
		}

		if (v.size() == 0) {
			return null;
		}

		aaDept.setPodName((String) h.get("dept"));
		if( aaDept.getPodName() != null )
		{
			aaDept.setPodName(aaDept.getPodName().toUpperCase());
		}
//		aaDept.setPodDesc((String) h.get("nativeTitle"));

		// contact.setManager( false );
		/*
		 * Iterator k = h.keySet().iterator(); while( k.hasNext()) { String key =
		 * (String)k.next(); logger.info( "'" + key + "' = '" + h.get( key ) +
		 * "'" ); }
		 */
		/*
		 * if(((String) h.get( "isManager")).equalsIgnoreCase( "Y" )) {
		 * contact.setManager( true ); } contact.setManagerSerial((String)
		 * h.get( "managerSerialNumber" ) + (String) h.get( "managerCountryCode"
		 * ));
		 */

		return( aaDept );
	}
	public static Pod getDepartmentByCode(String deptCode) {
		// protect the email
		if (deptCode != null) {
			deptCode.replaceAll("\\*", "");
		}

		String filter = "(dept=" + deptCode + ")";
		return( getDepartment(filter));
	}
	public static Contact getDeptMgrByDeptCode( String deptCode )
	{
		Contact deptMgr;
		String searchBase = "ou=bluepages,o=ibm.com";

		String server = "ldap://bluepages.ibm.com:389";

		Properties env1 = new Properties();
		env1.put(Context.INITIAL_CONTEXT_FACTORY,
				"com.sun.jndi.ldap.LdapCtxFactory");
		env1.put(Context.PROVIDER_URL, server);
		env1.put("java.naming.ldap.derefAliases", "never");
		env1.put("java.naming.ldap.version", "2");
		Vector<Hashtable<String, String>> v = new Vector<Hashtable<String, String>>();
		Hashtable<String, String> h = new Hashtable<String, String>();

		try {
			String attrlist[] = { "dept", "managerSerialNumber", "nativeTitle", "title" };
			SearchControls constraints = new SearchControls();
			constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
			constraints.setReturningAttributes(attrlist);
			constraints.setCountLimit(1);
			constraints.setTimeLimit(30 * 1000);
			DirContext ctx = new InitialDirContext(env1);
			NamingEnumeration<?> results = ctx.search(searchBase, deptCode,
					constraints);
			ctx.close(); // close the connection

			SearchResult sr;
			Attributes attrs;
			Attribute attr;
			Enumeration<?> vals;
			Object q;
			if (results != null && results.hasMore()) {
				sr = (SearchResult) results.next();
				attrs = sr.getAttributes();
				h = new Hashtable<String, String>();
				for (NamingEnumeration<?> ae = attrs.getAll(); ae.hasMore();) {
					attr = (Attribute) ae.next();
					vals = attr.getAll();
					q = vals.nextElement();
					try {
						h.put(attr.getID(), (String) q);
					} // put the String in the hash
					catch (ClassCastException cce) // it's not a String, so
					// "decode" it (int'l chars)
					{
						try {
							byte b[] = (byte[]) q;
							String s = new String(b, "ISO-8859-1");
							h.put(attr.getID(), s); // put the string in the
							// hash
						} catch (UnsupportedEncodingException ue) {
						}
					}

				}
				if (h.size() > 0)
				{
					v.addElement(h); // no reason to add the hash if it is
				}
				// empty
			}

		} catch (NamingException ne) {
			ne.printStackTrace();
			logger.error(ne, ne);
			return null;
		}

		if (v.size() == 0) {
			return null;
		}

		String deptMgrSerial = (String) h.get("managerSerialNumber");
		deptMgr = BluegroupsDelegate.getContactByLongSerial( deptMgrSerial );
		return( deptMgr );
	}

}