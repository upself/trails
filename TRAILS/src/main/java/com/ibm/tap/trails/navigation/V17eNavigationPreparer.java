/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.trails.navigation;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import org.apache.struts2.dispatcher.StrutsRequestWrapper;
import org.apache.tiles.Attribute;
import org.apache.tiles.AttributeContext;
import org.apache.tiles.beans.SimpleMenuItem;
import org.apache.tiles.context.TilesRequestContext;
import org.apache.tiles.preparer.PreparerException;
import org.apache.tiles.preparer.ViewPreparer;

import com.ibm.tap.trails.framework.UserSession;

/**
 * @author alexmois
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class V17eNavigationPreparer implements ViewPreparer {

	public void execute(TilesRequestContext tContext, AttributeContext aContext)
			throws PreparerException {

		LinkedHashMap<SimpleMenuItem, LinkedHashMap<SimpleMenuItem, Vector<SimpleMenuItem>>> levelOneMap = new LinkedHashMap<SimpleMenuItem, LinkedHashMap<SimpleMenuItem, Vector<SimpleMenuItem>>>();

		StrutsRequestWrapper s = (StrutsRequestWrapper) tContext.getRequest();
		HttpSession session = s.getSession();
		UserSession user = (UserSession) session
				.getAttribute(UserSession.USER_SESSION);

		String testRequestUrl = (String) s
				.getAttribute("javax.servlet.forward.servlet_path") == null ? s
				.getRequestURI().replaceFirst(s.getContextPath(), "")
				: (String) s.getAttribute("javax.servlet.forward.servlet_path");
		testRequestUrl = testRequestUrl.equals("/admin/scheduleF/save.htm") ? "/admin/scheduleF/manage.htm"
				: (testRequestUrl.equals("/admin/alertCause/add.htm")
						|| testRequestUrl.equals("/admin/alertCause/save.htm")
						|| testRequestUrl
								.equals("/admin/alertCause/update.htm") ? "/admin/alertCause/list.htm"
						: (testRequestUrl
								.equals("/admin/alertTypeCauseMapping/map.htm") ? "/admin/alertTypeCauseMapping/listAlertType.htm"
								: testRequestUrl));
		testRequestUrl = testRequestUrl
				.equals("/admin/nonInstancebasedSW/upload.htm") ? "/admin/nonInstancebasedSW/list.htm"
				: (testRequestUrl
						.equals("/admin/nonInstancebasedSW/manage.htm") ? "/admin/nonInstancebasedSW/list.htm"
						: testRequestUrl);

		// We want to start with the levelOne attribute
		Attribute levelOne = aContext.getAttribute("levelOne");
		List levelOneList = (List) levelOne.getValue();
		Iterator i = levelOneList.iterator();

		while (i.hasNext()) {
			SimpleMenuItem sm = (SimpleMenuItem) i.next();
			LinkedHashMap<SimpleMenuItem, Vector<SimpleMenuItem>> levelTwoMap = new LinkedHashMap<SimpleMenuItem, Vector<SimpleMenuItem>>();

			if (sm.getLink().equals(testRequestUrl)) {
				sm.setTooltip("active");
			} else {
				sm.setTooltip("");
			}

			Attribute levelTwo = aContext.getAttribute(sm.getLink());

			if (levelTwo != null) {
				List levelTwoList = (List) levelTwo.getValue();
				Iterator j = levelTwoList.iterator();
				while (j.hasNext()) {
					SimpleMenuItem smTwo = (SimpleMenuItem) j.next();

					Vector<SimpleMenuItem> levelThreeVector = new Vector<SimpleMenuItem>();

					if (smTwo.getLink().equals(testRequestUrl)) {
						smTwo.setTooltip("active");
						sm.setTooltip("open");
					} else {
						smTwo.setTooltip("");
					}

					Attribute levelThree = aContext.getAttribute(smTwo
							.getLink());

					if (levelThree != null) {
						List levelThreeList = (List) levelThree.getValue();
						Iterator k = levelThreeList.iterator();

						while (k.hasNext()) {
							SimpleMenuItem smThree = (SimpleMenuItem) k.next();

							if (smThree.getLink().equals(testRequestUrl)) {
								smThree.setTooltip("active");
								smTwo.setTooltip("open");
								sm.setTooltip("open");
							} else {
								smThree.setTooltip("");
							}

							levelThreeVector.add(smThree);

						}
					}

					levelTwoMap.put(smTwo, levelThreeVector);

				}
			}

			levelOneMap.put(sm, levelTwoMap);

		}

		Attribute menuAttribute = new Attribute();
		menuAttribute.setValue(levelOneMap);
		aContext.putAttribute("menu", menuAttribute);
	}
}
