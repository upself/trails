<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>System Status</h1>
<br>
<%
		boolean alternate = true;
		%>
<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">
	<tr class="tablefont">
		<th colspan="6" style="white-space:nowrap; background-color:#bd6;">
		Queue</th>
	</tr>
	</tr>
	<tr style="background-color:#dfb;" class="tablefont">
		<th nowrap="nowrap">ID</th>
		<th nowrap="nowrap">User Name</th>
		<th nowrap="nowrap">Batch Type</th>
		<th nowrap="nowrap">Customer</th>
		<th nowrap="nowrap">add Time</th>
	</tr>


	<logic:iterate id="batch" name="status">
		<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>
		<td><bean:write name="batch" property="batchId" /></td>
		<td><bean:write name="batch" property="remoteUser" /></td>

		<td><bean:write name="batch" property="name" /></td>

		<logic:notEmpty name="batch" property="customer">
			<td><bean:write name="batch" property="customer.customerName" /></td>
		</logic:notEmpty>
		<logic:empty name="batch" property="customer">
			<td></td>
		</logic:empty>
		<td><bean:write name="batch" property="startTime" /></td>

		</tr>
	</logic:iterate>
</table>



</div>
<!-- stop main content -->

</div>
<!-- stop content -->
r
