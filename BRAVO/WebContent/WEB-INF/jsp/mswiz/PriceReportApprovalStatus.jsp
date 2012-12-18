<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Customers with an approved Price Report</h1>
<br>
<p>The list below contains customers that have an approved Price Report.
<p class="hrule-dots"></p>
<br>
<html:form action="/ReportPod">
<img src="https://w3.ibm.com/ui/v8/images/icon-link-email.gif" width="20" height="11" alt="email icon" />
<html:link action="/EmailPriceReportApprovalStatus">Email this page</html:link>
</html:form>
<!-- <html:errors/> -->
<% 
	boolean alternate = true;
		%>


	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top:2em;">

		<tr class="tablefont">
			<th colspan="12" style="white-space:nowrap; background-color:#bd6;"></th>
		</tr>
		<tr style="background-color:#dfb;" class="tablefont">
			<th nowrap="nowrap">Pod</th>
			<th nowrap="nowrap">Account Name</th>
			<th nowrap="nowrap">Account Id</th>
			<th nowrap="nowrap">DPE</th>
			<th nowrap="nowrap">Date Approved</th>
			<th nowrap="nowrap">Approver</th>
		</tr>

		<logic:iterate id="customer" name="customer.list">
			<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>

			<td><bean:write name="customer" property="pod.podName" /></td>
			<td><bean:write name="customer" property="customerName" /></td>
			<td><bean:write name="customer" property="accountNumber" /></td>
			<td><bean:write name="customer" property="contactDPE.fullName" /></td>
			<td><bean:write name="customer" property="misldAccountSettings.priceReportTimestamp" /></td>
			<td><bean:write name="customer" property="misldAccountSettings.priceReportStatusUser" /></td>

		</tr>
		</logic:iterate>
	</table>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
