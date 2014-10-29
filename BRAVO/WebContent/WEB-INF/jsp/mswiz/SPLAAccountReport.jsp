<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>SPLA Accounts</h1>
<br>
<p>The list below contains details on SPLA accounts.
<p class="hrule-dots"></p>
<br>
<html:form action="/ReportPod">
<img src="https://w3.ibm.com/ui/v8/images/icon-link-email.gif" width="20" height="11" alt="email icon" />
<html:link action="/EmailSPLAAccountReport">Email this page</html:link>
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
			<th nowrap="nowrap">Account Id</th>
			<th nowrap="nowrap">Customer Name</th>
			<th nowrap="nowrap">Customer Type</th>
			<th nowrap="nowrap">Hostname</th>
			<th nowrap="nowrap">Software Name</th>
		</tr>

		<logic:iterate id="priceReportArchive" name="priceReports.list">
			<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>

			<td><bean:write name="priceReportArchive" property="pod" /></td>
			<td><bean:write name="priceReportArchive" property="accountNumber" /></td>
			<td><bean:write name="priceReportArchive" property="customerName" /></td>
			<td><bean:write name="priceReportArchive" property="customerType" /></td>
			<td><bean:write name="priceReportArchive" property="nodeName" /></td>
			<td><bean:write name="priceReportArchive" property="productDescription" /></td>

		</tr>
		</logic:iterate>
	</table>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
