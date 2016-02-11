<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<script src="/BRAVO/javascript/misld.js"></script>

<h1>Customers for asset admin department, <bean:write
	name="user.container" property="pod.podName" /></h1>
<p>The list below contains customers by asset admin department that are
registered SPLA or ESPLA.</p>

<div id="fourth-level"><!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/AdminPod.do" styleClass="active">Unlock customers</html:link>
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

<html:form action="/UnlockAccount">
	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top:2em;">

		<tr class="tablefont">
			<th colspan="11" style="white-space:nowrap; background-color:#bd6;">Customers
			by asset admin department</th>
		</tr>
		<tr style="background-color:#dfb;" class="tablefont">
			<th nowrap="nowrap" width="0"></th>
			<th nowrap="nowrap" width="0"></th>
			<th nowrap="nowrap">Account Name</th>
			<th nowrap="nowrap">Type</th>
			<th nowrap="nowrap">DPE</th>
			<th nowrap="nowrap">Pod</th>
			<th nowrap="nowrap">Industry</th>
			<th nowrap="nowrap">Sector</th>
			<th nowrap="nowrap">Account Id</th>
			<th nowrap="nowrap">Unlock</th>
		</tr>
		<logic:iterate id="customer" name="customer">
			<bean:define id="misldAccountSettings" name="customer"
				property="misldAccountSettings" />
			<html:hidden name="customer" property="customerId" indexed="true" />
			<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>
			<td><logic:notEmpty name="customer" property="misldRegistration">
				<logic:equal name="customer" property="misldRegistration.status"
					value="LOCKED">
					<img src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
						width="11" height="12">
				</logic:equal>
				<logic:notEqual name="customer" property="misldRegistration.status"
					value="LOCKED">
					<logic:equal name="customer" property="misldRegistration.inScope"
						value="false">
						<img
							src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
							width="12" height="10">
					</logic:equal>
					<logic:equal name="customer" property="misldRegistration.inScope"
						value="true">
						<img
							src="https://w3.ibm.com/ui/v8/images/icon-system-status-ok.gif"
							width="12" height="10">
					</logic:equal>
				</logic:notEqual>
			</logic:notEmpty> <logic:empty name="customer"
				property="misldRegistration">
				<img src="https://w3.ibm.com/ui/v8/images/icon-urgent.gif" width="3"
					height="10" alt="urgent icon">
			</logic:empty></td>
			<td><logic:notEmpty name="misldAccountSettings">
				<logic:equal name="misldAccountSettings" property="status"
					value="DRAFT">
					<html:img page="/images/mnemo.gif" border="0" />
				</logic:equal>
				<logic:equal name="misldAccountSettings" property="status"
					value="COMPLETE">
					<img src="https://w3.ibm.com/ui/v8/images/icon-sametime-active.gif"
						width="8" height="8">
				</logic:equal>
				<logic:equal name="misldAccountSettings" property="status"
					value="LOCKED">
					<img src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
						width="11" height="12">
				</logic:equal>
			</logic:notEmpty> <logic:empty name="misldAccountSettings">
				<img src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
					width="12" height="10">
			</logic:empty></td>
			<td><bean:write name="customer" property="customerName" /></td>
			<td><bean:write name="customer"
				property="customerType.customerTypeName" /></td>
			<td><bean:write name="customer" property="contactDPE.fullName" /></td>
			<td><bean:write name="customer" property="pod.podName" /></td>
			<td><bean:write name="customer" property="industry.industryName" /></td>
			<td><bean:write name="customer" property="sector.sectorName" /></td>
			<td><bean:write name="customer" property="accountNumber" /></td>
			<td><logic:equal name="customer"
				property="misldAccountSettings.status" value="LOCKED">
				<html:checkbox name="customer"
					property="misldAccountSettings.status" value="COMPLETE"
					indexed="true" />
			</logic:equal><logic:notEqual name="customer"
				property="misldAccountSettings.status" value="LOCKED">
				<html:checkbox name="customer"
					property="misldAccountSettings.status" value="Off" indexed="true"
					disabled="true" />
			</logic:notEqual></td>
			</tr>
		</logic:iterate>
	</table>
	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	</div>
	<p/>
	<div class="hrule-dots"></div>
</html:form>
<logic:empty name="customer">
There are no results to display
</logic:empty>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
