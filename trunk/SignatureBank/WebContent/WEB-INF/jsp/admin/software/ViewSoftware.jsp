<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Software Details Page</h1>
<br>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
<html:form action="/SoftwareRefineSearch">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td><label for="softwareName">Software Name:</label></td>
			<td><html:text name="softwareForm" property="softwareName"
				styleClass="input" readonly="true" /></td>
		</tr>
		<tr>
			<td><label for="manufacturer">Software Manufacturer: </label></td>
			<td><html:text name="softwareForm" property="manufacturer"
				styleClass="input" readonly="true" /></td>
		</tr>
		<tr>
			<td><label for="softwareCategory">Software Category: </label></td>
			<td><html:text name="softwareForm" property="softwareCategory"
				styleClass="input" readonly="true" /></td>
		</tr>
		<tr>
			<td><label for="level">Software License Level: </label></td>
			<td><html:text name="softwareForm" property="level"
				styleClass="input" readonly="true" /></td>
		</tr>
		<tr>
			<td><label for="level">Vendor Managed: </label></td>
			<td><html:text name="softwareForm" property="vendorManaged"
				styleClass="input" readonly="true" /></td>
		</tr>
		<tr>
			<td><label for="status">Status: </label></td>
			<td><html:text name="softwareForm" property="status"
				styleClass="input" readonly="true" /></td>
		</tr>
	</table>
	<p>&nbsp;</p>
	<div class="hrule-dots">&nbsp;</div>

	<div class="clear">&nbsp;</div>
</html:form>
