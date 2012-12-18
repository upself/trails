<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<div id="fourth-level">
<h1>Installed software <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>
<!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/CustomerProfile.do">Overview</html:link> |</li>
	<li><html:link page="/HardwareBaseline.do">Hardware</html:link>
	|</li>
	<li><html:link page="/InstalledSoftwareBaseline.do">Installed Software</html:link>
	|</li>
	<li><html:link page="/ConsentLetter.do">Consent Letters</html:link> |</li>
</ul>
</div>

<%
        boolean alternate = true;
        %>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="13" style="white-space:nowrap; background-color:#bd6;">Software</th>
	</tr>
	<tr style="background-color:#dfb;" style="font-size:8pt">
		<th nowrap="nowrap">Software name</th>
		<th nowrap="nowrap">Category</th>
		<th nowrap="nowrap">Owner</th>
		<th nowrap="nowrap">User count</th>
		<th nowrap="nowrap">Eff User count</th>
		<th nowrap="nowrap">Auth</th>
		<th nowrap="nowrap">Eff Auth</th>
		<th nowrap="nowrap">Scan date</th>
		<th nowrap="nowrap">Edit date</th>
		<th nowrap="nowrap">Editor</th>
		<th nowrap="nowrap">Modify</th>
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

		<td><bean:write name="software" property="software.softwareName" /></td>
		<td><bean:write name="software"
			property="software.softwareCategory.softwareCategoryName" /></td>
		<c:choose>
				<c:when test="${software.installedSoftwareEff == null}">
					<td></td>				
				</c:when>
				<c:otherwise>
					<td><bean:write name="software" property="installedSoftwareEff.owner" /></td>
				</c:otherwise>
		</c:choose>
		<td><bean:write name="software" property="users" /></td>
		<c:choose>
				<c:when test="${software.installedSoftwareEff == null}">
					<td></td>				
				</c:when>
				<c:otherwise>
					<td><bean:write name="software" property="installedSoftwareEff.userCount" /></td>
				</c:otherwise>
		</c:choose>
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
		<c:choose>
				<c:when test="${software.installedSoftwareEff.authenticated eq '0'}">
					<td>N</td>
				</c:when>
				<c:when test="${software.installedSoftwareEff.authenticated eq '1'}">
					<td>Y</td>
				</c:when>
				<c:otherwise>
					<td></td>
				</c:otherwise>
		</c:choose>
		<td><bean:write name="software" property="softwareLpar.scantime" /></td>
		<c:choose>
				<c:when test="${software.installedSoftwareEff == null}">
					<td><bean:write name="software" property="recordTime" /></td>				
				</c:when>
				<c:otherwise>
					<td><bean:write name="software" property="installedSoftwareEff.recordTime" /></td>
				</c:otherwise>
		</c:choose>
		<td><bean:write name="software" property="remoteUser" /></td>
		<td><html:link action="/EditSoftware" paramId="software"
					paramName="software" paramProperty="id">Edit</html:link>
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
