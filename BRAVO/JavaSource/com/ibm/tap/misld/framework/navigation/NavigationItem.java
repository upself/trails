/*
 * Created on Mar 23, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.framework.navigation;

import java.util.Vector;

import org.apache.struts.tiles.beans.MenuItem;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class NavigationItem implements MenuItem {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String  value;

    private String  link;

    private String  icon;

    private String  tooltip;

    private Vector  Children = new Vector();

    private boolean open;

    private boolean active;

    /**
     * @return Returns the icon.
     */
    public String getIcon() {
        return icon;
    }

    /**
     * @param icon
     *            The icon to set.
     */
    public void setIcon(String icon) {
        this.icon = icon;
    }

    /**
     * @return Returns the link.
     */
    public String getLink() {
        return link;
    }

    /**
     * @param link
     *            The link to set.
     */
    public void setLink(String link) {
        this.link = link;
    }

    /**
     * @return Returns the tooltip.
     */
    public String getTooltip() {
        return tooltip;
    }

    /**
     * @param tooltip
     *            The tooltip to set.
     */
    public void setTooltip(String tooltip) {
        this.tooltip = tooltip;
    }

    /**
     * @return Returns the value.
     */
    public String getValue() {
        return value;
    }

    /**
     * @param value
     *            The value to set.
     */
    public void setValue(String value) {
        this.value = value;
    }

    /**
     * @return Returns the active.
     */
    public boolean isActive() {
        return active;
    }

    /**
     * @param active
     *            The active to set.
     */
    public void setActive(boolean active) {
        this.active = active;
    }

    /**
     * @return Returns the open.
     */
    public boolean isOpen() {
        return open;
    }

    /**
     * @param open
     *            The open to set.
     */
    public void setOpen(boolean open) {
        this.open = open;
    }

    /**
     * @return Returns the children.
     */
    public Vector getChildren() {
        return Children;
    }

    /**
     * @param children
     *            The children to set.
     */
    public void setChildren(Vector children) {
        Children = children;
    }
}