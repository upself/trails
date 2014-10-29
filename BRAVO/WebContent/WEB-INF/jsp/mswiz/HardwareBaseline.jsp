<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<div id="fourth-level">
<h1>Microsoft hardware for <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>
<!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/CustomerProfile.do">Overview</html:link> |</li>
	<li><html:link page="/HardwareBaseline.do" styleClass="active">Hardware</html:link>
	|</li>
	<li><html:link page="/InstalledSoftwareBaseline.do">Installed Software</html:link>
	|</li>
	<li><html:link page="/ConsentLetter.do">Consent Letters</html:link> |</li>
</ul>
</div>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<%
        boolean alternate = true;
        %>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="12" style="white-space:nowrap; background-color:#bd6;">Baseline</th>
	</tr>
	<tr style="background-color:#dfb;" style="font-size:8pt">
		<th nowrap="nowrap">Hostname</th>
		<th nowrap="nowrap">Status</th>
		<th nowrap="nowrap">Proc count</th>
		<th nowrap="nowrap">Eff Proc count</th>
		<th nowrap="nowrap">User count</th>
		<th nowrap="nowrap">Operating system</th>
		<th nowrap="nowrap">Scan date</th>
		<th nowrap="nowrap">Editor</th>
		<logic:notEmpty name="user.container"
			property="customer.misldAccountSettings">
			<logic:notEqual name="user.container"
				property="customer.misldAccountSettings.status" value="LOCKED">
				<th nowrap="nowrap">Edit Hardware</th>
			</logic:notEqual>
		</logic:notEmpty>
		<th nowrap="nowrap">Edit Software</th>
	</tr>

	<logic:iterate id="hardware" name="hardware.list">
		<%alternate = alternate ? false : true;

        if (alternate) {
            out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
        }
        else {
            out.println("<tr style=\"font-size:8pt\">");
        }
    %>

		<td><bean:write name="hardware" property="softwareLpar.name" /></td>
		<td><bean:write name="hardware" property="softwareLpar.status" /></td>
		<td><bean:write name="hardware" property="softwareLpar.processorCount" /></td>		
		<c:choose>
				<c:when test="${hardware.softwareLpar.softwareLparEff == null || hardware.softwareLpar.softwareLparEff.status=='INACTIVE'}">
					<td></td>				
				</c:when>
				<c:otherwise>
					<td><bean:write name="hardware" property="softwareLpar.softwareLparEff.processorCount" /></td>
				</c:otherwise>
		</c:choose>		
		<td><bean:write name="hardware" property="users" /></td>
		<td><bean:write name="hardware" property="software.softwareName" /></td>
		<td><bean:write name="hardware" property="softwareLpar.scantime" /></td>
		<td><bean:write name="hardware"
			property="softwareLpar.remoteUser" /></td>
		<logic:notEmpty name="user.container"
			property="customer.misldAccountSettings">
			<logic:notEqual name="user.container"
				property="customer.misldAccountSettings.status" value="LOCKED">
				<td><html:link action="/EditHardware" paramId="hardware"
					paramName="hardware"
					paramProperty="softwareLpar.id">Edit</html:link></td>
			</logic:notEqual>
		</logic:notEmpty>
		<td><html:link action="/ShowSoftware" paramId="hardware"
			paramName="hardware"
			paramProperty="softwareLpar.id">Edit</html:link></td>
		</tr>
	</logic:iterate>
</table>
<logic:empty name="hardware.list">
There are no results to display
</logic:empty>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
