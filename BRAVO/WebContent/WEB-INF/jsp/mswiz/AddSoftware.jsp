<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>


<div id="fourth-level">
<h1>Add software for <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>
<!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/CustomerProfile.do">Overview</html:link> |</li>
	<li><html:link page="/HardwareBaseline.do">Hardware Baseline</html:link>
	|</li>
	<li><html:link page="/InstalledSoftwareBaseline.do">Installed Software Baseline</html:link>
	|</li>
	<li><html:link page="/ConsentLetter.do">Consent Letters</html:link> |</li>
	<li><html:link page="/AddSoftware.do" styleClass="active">Add Software</html:link>
	|</li>
</ul>
</div>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/SaveNewSoftware">
	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top:2em;">

		<html:hidden property="msHardwareBaselineId" />

		<tr class="tablefont">
			<th colspan="3" style="white-space:nowrap; background-color:#bd6;">Add
			software</th>
		</tr>
		<tr>
			<td>Software name:</td>
			<td><html:select property="softwareLong">
				<html:options collection="software.list"
					labelProperty="softwareName" property="softwareId" />
			</html:select></td>
		</tr>
		<tr>
			<td>Owner:</td>
			<td><html:select property="softwareOwner">
				<html:option value=""></html:option>
				<html:option value="IBM">IBM</html:option>
				<html:option value="CUSTOMER">Customer</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td>Buyer:</td>
			<td><html:select property="softwareBuyer">
				<html:option value=""></html:option>
				<html:option value="IBM">IBM</html:option>
				<html:option value="CUSTOMER">Customer</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td>User count:</td>
			<td><html:text property="userCount" size="5" /></td>
		</tr>
		<tr>
			<td>Status:</td>
			<td><html:select property="status">
				<html:option value="ACTIVE">ACTIVE</html:option>
				<html:option value="INACTIVE">INACTIVE</html:option>
				<html:option value="ERROR/MISTAKE">ERROR/MISTAKE</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td>Comment:</td>
			<td><html:textarea property="comment" rows="4" cols="64" /></td>
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

<logic:empty name="software.list">
There are no results to display
</logic:empty>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
