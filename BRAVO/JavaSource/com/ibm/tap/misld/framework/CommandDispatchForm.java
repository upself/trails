package com.ibm.tap.misld.framework;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.ValidatorActionForm;

/**
 * If you want to call the add() method of your Action, these tags will set the
 * method value to "add".
 * <ul>
 * <li>&#060;input type="submit" name="command(add)" value="Add This"/&#062;
 * <li>&#060;input type="submit" name="command(add-8)" value="Add Row 8"/&#062;
 * <li>&#060;html:submit property="command(add)" value="Add This Other
 * One"/&#062;
 * <li>&#060;html:submit property="command(add-other)" value="Add This Other
 * One"/&#062;
 * </ul>
 */
public class CommandDispatchForm
        extends ValidatorActionForm {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * The method String is the method to be called in your Action.
     */
    private String            method   = null;

    /**
     * The item String is optional extra data to be accessed by your Action's
     * method.
     */
    private String            item     = null;

    /**
     * The hyphen (-) character. If present in the button's submission, it will
     * separate the method from the item ;
     */
    private static final char SPLITTER = '-';

    public Object getCommand(String key) {
        return null;
    }

    /**
     * Used by form buttons. The "map-backed" setCommand(). This allows button
     * submissions to not rely on the text of the button.
     * 
     * @param key
     *            the String containing the method (and optional item)
     * @param value
     *            Object representation of the text of the button submitted,
     *            which is ignored.
     */
    public void setCommand(String key, Object value) {
        // Object value is ignored (it's the button's display text)
        int splitIndex = key.indexOf(SPLITTER);

        if (splitIndex == -1) {
            method = key;
        }
        else {
            method = key.substring(0, splitIndex);
            if (++splitIndex < key.length()) {
                item = key.substring(splitIndex, key.length());
            }
        }
    }

    public String getMethod() {
        return method;
    }

    public String getItem() {
        return item;
    }

    /**
     * Used by hyperlinks. Simple setter for the <code>method</code> value.
     * 
     * @param m
     */
    public void setMethod(String m) {
        this.method = m;
    }

    /**
     * Used by hyperlinks. Simple setter for the <code>item</code> value.
     * 
     * @param d
     */
    public void setItem(String d) {
        this.item = d;
    }

    /**
     * Resets the command and extraCommandData values. Subclasses should call
     * super.reset() method when overriding.
     * 
     * @see org.apache.struts.action.ActionForm#reset(org.apache.struts.action.ActionMapping,
     *      javax.servlet.http.HttpServletRequest)
     */
    public void reset(ActionMapping mapping, HttpServletRequest request) {
        method = null;
        item = null;
        super.reset(mapping, request);
    }
}

