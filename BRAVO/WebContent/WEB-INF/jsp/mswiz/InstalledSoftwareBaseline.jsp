<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<div id="fourth-level">
<h1>Microsoft software for <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>
<!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/CustomerProfile.do">Overview</html:link> |</li>
	<li><html:link page="/HardwareBaseline.do">Hardware</html:link>
	|</li>
	<li><html:link page="/InstalledSoftwareBaseline.do" styleClass="active">Installed Software</html:link>
	|</li>
	<li><html:link page="/ConsentLetter.do">Consent Letters</html:link> |</li>
</ul>
</div>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<logic:notEmpty name="user.container"
	property="customer.misldAccountSettings">
	<logic:notEqual name="user.container"
		property="customer.misldAccountSettings.status" value="LOCKED">
		<html:form action="/InstalledSoftwareBaselineSave"
			enctype="multipart/form-data">

			<table cellspacing="0" cellpadding="0" class="sign-in-table">

				<tr>
					<td class="t1"><label for="file">*File name:</label></td>
					<td>
					<div class="input-note">select an installed software baseline file
					to upload</div>
					<html:file property="file" /><html:submit>Submit</html:submit></td>
				</tr>

			</table>
		</html:form>
	</logic:notEqual>
</logic:notEmpty>

<%
        boolean alternate = true;
        %>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="14" style="white-space:nowrap; background-color:#bd6;">Installed
		software</th>
	</tr>
	<tr style="background-color:#dfb;" style="font-size:8pt">
		<th nowrap="nowrap">Hostname</th>
		<th nowrap="nowrap">Serial number</th>
		<th nowrap="nowrap">Proc count</th>
		<th nowrap="nowrap">User count</th>
		<th nowrap="nowrap">Auth</th>
		<th nowrap="nowrap">Scan date</th>
		<th nowrap="nowrap">Hardware Status</th>
		<th nowrap="nowrap">Software Status</th>
		<th nowrap="nowrap">Software</th>
		<th nowrap="nowrap">Owner</th>
		<th nowrap="nowrap">Edit Hardware</th>
		<th nowrap="nowrap">Edit Software</th>
	</tr>

	<logic:iterate id="software" name="software.list">
		<%alternate = alternate ? false : true;

        if (alternate) {
            out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
        }
        else {
            out.println("<tr style=\"font-size:8pt\">");
        }
    %>

		<td><bean:write name="software" property="softwareLpar.name" /></td>
		<td><bean:write name="software"
			property="softwareLpar.biosSerialNumber" /></td>
		<td><bean:write name="software"
			property="softwareLpar.processorCount" /></td>
		
		<c:choose>
				<c:when test="${software.installedSoftwareEff == null}">
					<td>1000</td>				
				</c:when>
				<c:otherwise>
					<td><bean:write name="software" property="installedSoftwareEff.userCount" /></td>
				</c:otherwise>
		</c:choose>
		<c:choose>
				<c:when test="${software.installedSoftwareEff == null}">
					<c:choose>
						<c:when test="${software.authenticated eq '0'}">
							<td>N</td>
						</c:when>
						<c:when test="${software.authenticated eq '1'}">
							<td>Y</td>
						</c:when>
						<c:otherwise>
							<td></td>
						</c:otherwise>
					</c:choose>			
				</c:when>
				<c:otherwise>
					<td><bean:write name="software" property="installedSoftwareEff.authenticated" /></td>
				</c:otherwise>
		</c:choose>
		<td><bean:write name="software" property="softwareLpar.scantime" /></td>
		<td><bean:write name="software" property="softwareLpar.status" /></td>
		<td><bean:write name="software" property="status" /></td>
		<td><logic:empty name="software"
			property="software.microsoftProductMap">
			<img src="https://w3.ibm.com/ui/v8/images/icon-urgent.gif" width="3"
				height="10">
		</logic:empty><bean:write name="software"
			property="software.softwareName" /></td>
		<c:choose>
				<c:when test="${software.installedSoftwareEff == null}">
					<td></td>				
				</c:when>
				<c:otherwise>
					<td><bean:write name="software" property="installedSoftwareEff.owner" /></td>
				</c:otherwise>
		</c:choose>
		<td><html:link action="/EditHardware" paramId="hardware"
					paramName="software"
					paramProperty="softwareLpar.id">Edit</html:link>
		</td>
		<td><html:link action="/ShowSoftware" paramId="hardware"
			paramName="software"
			paramProperty="softwareLpar.id">Edit</html:link>
		</td>
		</tr>
	</logic:iterate>
</table>
<logic:empty name="software.list">
There are no results to display
</logic:empty>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
