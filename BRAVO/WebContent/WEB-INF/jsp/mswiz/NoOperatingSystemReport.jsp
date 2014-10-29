<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<script src="/BRAVO/javascript/misld.js"></script>

<h1>No Operating System Report</h1>
<p>The list below contains hardware baseline entries that have no
operating system defined</p>

<div id="fourth-level"><!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/Administration.do" styleClass="active">Reports</html:link>
	|</li>
	<li><html:link page="/AdminFunction.do">Functions</html:link> |</li>
	<li><html:link page="/PriceList.do">Price List</html:link> |</li>
</ul>
</div>
<br>
<br>

<%
		boolean alternate = true;
		%>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="11" style="white-space:nowrap; background-color:#bd6;">No
		operating system report</th>
	</tr>
	<tr style="background-color:#dfb;" class="tablefont">
		<th nowrap="nowrap">Admin Dept.</th>
		<th nowrap="nowrap">Account Name</th>
		<th nowrap="nowrap">Account Type</th>
		<th nowrap="nowrap">Node Name</th>
	</tr>
	<logic:iterate id="server" name="server.list">

		<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>

		<td><bean:write name="server"
			property="msHardwareBaseline.customer.pod.podName" /></td>
		<td><bean:write name="server"
			property="msHardwareBaseline.customer.customerName" /></td>
		<td><bean:write name="server"
			property="msHardwareBaseline.customer.customerType.customerTypeName" /></td>
		<td><bean:write name="server" property="msHardwareBaseline.nodeName" /></td>
		</tr>
	</logic:iterate>
</table>
<logic:empty name="server.list">
There are no results to display
</logic:empty></div>
<!-- stop main content -->
</div>
<!-- stop content -->
