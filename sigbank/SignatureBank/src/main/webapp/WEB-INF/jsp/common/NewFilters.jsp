<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>

<!-- start related links -->
<!-- ** If there's related links, html goes here.  Otherwise, remove this line ** -->
	<br>
	<br>
	<br>
	<logic:greaterThan name="user.container"  property="newFilters" value="0">
	<b>New Filter Alert:</b><br>
	<div class="hrule-dots">&nbsp;</div><br>
	<img alt="Alert" src="https://w3.ibm.com/ui/v8/images/icon-system-status-alert.gif"/>
	<html:link page="/SoftwareFilterNew.do">
	(<bean:write name="user.container" property="newFilters" />) New Filters </html:link>
	</logic:greaterThan>
	<br>
<!-- stop related links -->


