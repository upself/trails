<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>


<logic:empty name="customer.list">
	<h1>No asset admin department defined</h1>
	<br>
	<html:form action="/ReportPod">
		<p><label for="select_pod">Please select an asset admin
		department below.</label></p>
		<html:select property="podId" styleId="select_pod">
			<html:options collection="pod.list" labelProperty="podName"
				property="podId" />
		</html:select>
		<html:submit>Submit</html:submit>
	</html:form>
</logic:empty>
<logic:notEmpty name="customer.list">
	<h1>Customers for asset admin department, <bean:write
		name="user.container" property="pod.podName" /></h1>
	<br>
	<p>The list below contains customers by asset admin department.
	Click on an account name to view/edit an account.
	<p class="hrule-dots"></p>
	<br>

	<%
		boolean alternate = true;
	%>
	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top: 2em;">

		<tr class="tablefont">
			<th colspan="12" style="white-space: nowrap; background-color: #bd6;">
			<html:form action="/ReportPod">
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
			<th nowrap="nowrap">Price Report</th>
			<th nowrap="nowrap">Default LPID</th>
			<th nowrap="nowrap">Last DPE Notification</th>

		</tr>
		<logic:iterate id="customer" name="customer.list">
			<%
				alternate = alternate ? false : true;

						if (alternate) {
							out
									.println("<tr class=\"gray\" style=\"font-size:8pt\">");
						} else {
							out.println("<tr style=\"font-size:8pt\">");
						}
			%>
			<td><logic:notEmpty name="customer"
				property="misldAccountSettings">
				<logic:equal name="customer"
					property="misldAccountSettings.priceReportStatus"
					value="REGISTERED">
					<img alt="Registered"
						src="https://w3.ibm.com/ui/v8/images/icon-system-status-ok.gif"
						width="12" height="10">
				</logic:equal>
				<logic:equal name="customer"
					property="misldAccountSettings.priceReportStatus" value="APPROVED">
					<font color="green"><b>A</b></font>
				</logic:equal>
				<logic:equal name="customer"
					property="misldAccountSettings.priceReportStatus" value="REJECTED">
					<font color="red"><b>R</b></font>
				</logic:equal>
				<logic:equal name="customer"
					property="misldAccountSettings.priceReportStatus" value="ESCALATED">
					<font color="#FDD017"><b>E</b></font>
				</logic:equal>
				<logic:equal name="customer"
					property="misldAccountSettings.priceReportStatus" value="PAST DUE">
					<font color="blue"><b>P</b></font>
				</logic:equal>
			</logic:notEmpty> <logic:empty name="customer" property="misldRegistration">
				<img alt="Un-Registered"
					src="https://w3.ibm.com/ui/v8/images/icon-urgent.gif" width="3"
					height="10">
			</logic:empty></td>
			<td><logic:notEmpty name="customer"
				property="misldAccountSettings">
				<logic:equal name="customer" property="misldAccountSettings.status"
					value="DRAFT">
					<html:img alt="Account Settings in Draft" page="/images/mnemo.gif"
						border="0" />
				</logic:equal>
				<logic:equal name="customer" property="misldAccountSettings.status"
					value="COMPLETE">
					<img alt="Account Settings Complete"
						src="https://w3.ibm.com/ui/v8/images/icon-sametime-active.gif"
						width="8" height="8">
				</logic:equal>
				<logic:equal name="customer" property="misldAccountSettings.status"
					value="LOCKED">
					<img alt="Account Locked"
						src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
						width="11" height="12">
				</logic:equal>
			</logic:notEmpty> <logic:empty name="customer" property="misldAccountSettings">
				<img alt="No Account Settings"
					src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
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
			<td><html:link action="/PriceReport" paramId="customer"
				paramName="customer" paramProperty="customerId">View</html:link> - <html:link
				action="/EmailPriceReport" paramId="customer" paramName="customer"
				paramProperty="customerId">Email</html:link></td>
			<td><logic:notEmpty name="customer"
				property="misldAccountSettings.defaultLpid">
				<bean:write name="customer"
					property="misldAccountSettings.defaultLpid.lpidName" />
			</logic:notEmpty></td>
			<logic:equal name="user.container" property="asset" value="true">
				<td><logic:notEmpty name="customer"
					property="priceReportNotification">
					<bean:write name="customer"
						property="priceReportNotification.remoteUser" />
					<br>
					<bean:write name="customer"
						property="priceReportNotification.recordTime" />
				</logic:notEmpty></td>
			</logic:equal>

			</tr>
		</logic:iterate>

	</table>
</logic:notEmpty>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
