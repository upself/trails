<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>


<div id="fourth-level">
<h1>Customer Profile for <span class="orange-dark"><bean:write
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

<%
        boolean alternate = true;
        %>
<%alternate = alternate ? false : true;

        if (alternate) {
            out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
        }
        else {
            out.println("<tr style=\"font-size:8pt\">");
        }
    %>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<logic:equal name="installedSoftwareEff"
	property="softwareCategoryName" value="Operating Systems">

	<html:form action="/SaveOsSoftware">
		<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
			width="100%" style="margin-top:2em;">
			
			<html:hidden name="installedSoftwareEff" property="id"/>
			<html:hidden name="installedSoftwareEff" property="installedSoftwareId"/>
			<html:hidden name="installedSoftwareEff" property="softwareLparId"/>

			<tr class="tablefont">
				<th colspan="3" style="white-space:nowrap; background-color:#bd6;">Category:
				<bean:write name="installedSoftwareEff"
					property="softwareCategoryName" /></th>
			</tr>
			<tr>
				<td>Software name:</td>
				<td><bean:write name="installedSoftwareEff" property="softwareName" /></td>
			</tr>
			<tr>
				<td>Owner:</td>
				<td><html:select name="installedSoftwareEff" property="owner">
					<html:option value=""></html:option>
					<html:option value="IBM">IBM</html:option>
					<html:option value="CUSTOMER">Customer</html:option>
					<html:option value="INTERNAL USE">Internal Use</html:option>
				</html:select></td>
			</tr>
			<tr>
				<td>User count:</td>
				<td><html:text name="installedSoftwareEff" property="userCount" size="5" /></td>
			</tr>
			<tr>
				<td>Authenticated:</td>
				<td><html:select name="installedSoftwareEff" property="authenticated">
					<html:option value=""></html:option>
					<html:option value="1">Yes</html:option>
					<html:option value="0">No</html:option>
				</html:select></td>
			</tr>
			<tr>
				<td>Comment:</td>
				<td><html:textarea name="installedSoftwareEff" property="comment" rows="4" cols="64" /></td>
			</tr>

		</table>
		<div class="clear"></div>
		<div class="button-bar">

		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
		<p/>
		<div class="hrule-dots"></div>
	</html:form>
</logic:equal>

<logic:notEqual name="installedSoftwareEff"
	property="softwareCategoryName" value="Operating Systems">

	<html:form action="/SaveSoftware">
		<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
			width="100%" style="margin-top:2em;">
			
			<html:hidden name="installedSoftwareEff" property="id"/>
			<html:hidden name="installedSoftwareEff" property="installedSoftwareId"/>
			<html:hidden name="installedSoftwareEff" property="softwareLparId"/>

			<tr class="tablefont">
				<th colspan="3" style="white-space:nowrap; background-color:#bd6;">Category:
				<bean:write name="installedSoftwareEff"
					property="softwareCategoryName" /></th>
			</tr>
			<tr>
				<td>Software name:</td>
				<td>
					<bean:write name="installedSoftwareEff" property="softwareName" />
				</td>
			</tr>
			<tr>
				<td>Owner:</td>
				<td><html:select name="installedSoftwareEff" property="owner">
					<html:option value=""></html:option>
					<html:option value="IBM">IBM</html:option>
					<html:option value="CUSTOMER">Customer</html:option>
					<html:option value="INTERNAL USE">Internal Use</html:option>
				</html:select></td>
			</tr>
			<tr>
				<td>User count:</td>
				<td><html:text name="installedSoftwareEff" property="userCount" size="5" /></td>
			</tr>
			<tr>
				<td>Comment:</td>
				<td><html:textarea name="installedSoftwareEff" property="comment" rows="4" cols="64" /></td>
			</tr>

		</table>
		<div class="clear"></div>
		<div class="button-bar">

		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
		<p/>
		<div class="hrule-dots"></div>
	</html:form>
</logic:notEqual>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
