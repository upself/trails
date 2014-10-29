<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<script src="/BRAVO/javascript/misld.js"></script>

<logic:empty name="customer">
	<h1>No asset admin department defined</h1>
	<br>
	<html:form action="/AdminPod">
		<p><label for="select_pod">Please select an asset admin
		department below.</label></p>
		<html:select property="podId" styleId="select_pod">
			<html:options collection="pod.list" labelProperty="podName"
				property="podId" />
		</html:select>
		<html:submit>Submit</html:submit>
	</html:form>
</logic:empty>

<logic:notEmpty name="customer">
	<h1>Customers for asset admin department, <bean:write
		name="user.container" property="pod.podName" /></h1>
	<p>The list below contains customers by asset admin department that
	are registered SPLA or ESPLA.</p>

	<div id="fourth-level"><!-- forth level navigation -->
	<ul class="text-tabs">
		<li><html:link page="/AdminUnlockView.do">Unlock customers</html:link>
		|</li>
		<li><html:link page="/ScanNotification.do">DPE scan notification</html:link>
		|</li>
		<li><html:link page="/LockRegistration.do">Lock/Unlock agreements</html:link>
		|</li>
	</ul>
	</div>
	<br>
	<br>

	<%
		boolean alternate = true;
	%>

	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top: 2em;">

		<tr class="tablefont">
			<th colspan="11" style="white-space: nowrap; background-color: #bd6;">
			<html:form action="/AdminPod">
				<html:select property="podId">
					<html:options collection="pod.list" labelProperty="podName"
						property="podId" />
				</html:select>
				<html:submit>Submit</html:submit>
			</html:form></th>
		</tr>
		<tr style="background-color: #dfb;" class="tablefont">
			<th nowrap="nowrap" width="0"></th>
			<th nowrap="nowrap" width="0"></th>
			<th nowrap="nowrap">Account Name</th>
			<th nowrap="nowrap">Type</th>
			<th nowrap="nowrap">DPE</th>
			<th nowrap="nowrap">Pod</th>
			<th nowrap="nowrap">Industry</th>
			<th nowrap="nowrap">Sector</th>
			<th nowrap="nowrap">Account Id</th>
		</tr>
		<logic:iterate id="customer" name="customer">
			<bean:define id="misldAccountSettings" name="customer"
				property="misldAccountSettings" />
			<html:hidden name="customer" property="customerId" indexed="true" />
			<%
				alternate = alternate ? false : true;

						if (alternate) {
							out
									.println("<tr class=\"gray\" style=\"font-size:8pt\">");
						} else {
							out.println("<tr style=\"font-size:8pt\">");
						}
			%>
			<td><logic:notEmpty name="customer" property="misldRegistration">
				<logic:equal name="customer" property="misldRegistration.status"
					value="LOCKED">
					<img alt="Agreement Locked" src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
						width="11" height="12">
				</logic:equal>
				<logic:notEqual name="customer" property="misldRegistration.status"
					value="LOCKED">
					<logic:equal name="customer" property="misldRegistration.inScope"
						value="false">
						<img alt="Out-Of-Scope"
							src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
							width="12" height="10">
					</logic:equal>
					<logic:equal name="customer" property="misldRegistration.inScope"
						value="true">
						<img alt="Registered"
							src="https://w3.ibm.com/ui/v8/images/icon-system-status-ok.gif"
							width="12" height="10">
					</logic:equal>
				</logic:notEqual>
			</logic:notEmpty> <logic:empty name="customer" property="misldRegistration">
				<img alt="Un-Registered" src="https://w3.ibm.com/ui/v8/images/icon-urgent.gif" width="3"
					height="10">
			</logic:empty></td>
			<td><logic:notEmpty name="misldAccountSettings">
				<logic:equal name="misldAccountSettings" property="status"
					value="DRAFT">
					<html:img alt="Account Settings in Draft" page="/images/mnemo.gif" border="0" />
				</logic:equal>
				<logic:equal name="misldAccountSettings" property="status"
					value="COMPLETE">
					<img alt="Account Settings Complete" src="https://w3.ibm.com/ui/v8/images/icon-sametime-active.gif"
						width="8" height="8">
				</logic:equal>
				<logic:equal name="misldAccountSettings" property="status"
					value="LOCKED">
					<img alt="Account Locked" src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
						width="11" height="12">
				</logic:equal>
			</logic:notEmpty> <logic:empty name="misldAccountSettings">
				<img alt="No Account Settings" src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
					width="12" height="10">
			</logic:empty></td>
			<td><bean:write name="customer" property="customerName" /></td>
			<td><bean:write name="customer"
				property="customerType.customerTypeName" /></td>
			<td><bean:write name="customer" property="contactDPE.fullName" /></td>
			<td><bean:write name="customer" property="pod.podName" /></td>
			<td><bean:write name="customer" property="industry.industryName" /></td>
			<td><bean:write name="customer"
				property="industry.sector.sectorName" /></td>
			<td><bean:write name="customer" property="accountNumber" /></td>
			</tr>
		</logic:iterate>
	</table>

</logic:notEmpty>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
