<%@ taglib prefix="req" uri="http://jakarta.apache.org/taglibs/request-1.0"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="logic" uri="http://struts.apache.org/tags-logic"%>

<div id="navigation">
<h2 class="access">Start of left navigation</h2>
<div id="left-nav">
<div class="top-level">
	<a href="http://tap.raleigh.ibm.com/">Asset home</a>
	<a href="/BRAVO/home.do">BRAVO</a>
	<a href="/BRAVO/mswiz.do">MS Wizard</a>
	<a href="/BRAVO/help/help.do">Help</a>
	<a href="/BRAVO/report/home.do">Reports</a>
	<a href="/BRAVO/systemStatus/home.do">System status</a>
<% boolean lbValidRole = false;
   boolean lbAdminRole = false; %>
	<req:isUserInRole role="com.ibm.tap.admin">
<% lbValidRole = true;
   lbAdminRole = true; %>
	</req:isUserInRole>
	<req:isUserInRole role="com.ibm.tap.sigbank.admin">
<% lbValidRole = true;
   lbAdminRole = true; %>
	</req:isUserInRole>
	<req:isUserInRole role="com.ibm.tap.sigbank.user">
<% lbValidRole = true; %>
	</req:isUserInRole>
<% if (lbValidRole) { %>
	<a href="/BRAVO/bankAccount/home.do">Bank accounts</a>
<% } %>
	<logic:present scope="request" name="bankAccountSection">
	<div class="second-level">
		<a href="/BRAVO/bankAccount/connected.do">Connected</a>
		<logic:equal scope="request" name="bankAccountSection" value="CONNECTED">
		<% if (lbAdminRole) { %>
		<div class="third-level">
			<a href="/BRAVO/bankAccount/connectedAddEdit.do">Add</a>
		</div>
		<% } %>
		</logic:equal>
		<a href="/BRAVO/bankAccount/disconnected.do">Disconnected</a>
		<logic:equal scope="request" name="bankAccountSection" value="DISCONNECTED">
		<% if (lbAdminRole) { %>
		<div class="third-level">
			<a href="/BRAVO/bankAccount/disconnectedAddEdit.do">Add</a>
		</div>
		<% } %>
		</logic:equal>
	</div>
	</logic:present>
<%
 boolean validRole = false;
 %> <req:isUserInRole role="com.ibm.ea.bravo.admin">
	<%
	validRole = true;
	%>
</req:isUserInRole> <req:isUserInRole role="com.ibm.ea.asset.admin">
	<%
	validRole = true;
	%>
</req:isUserInRole> <req:isUserInRole role="com.ibm.ea.admin">
	<%
	validRole = true;
	%>
</req:isUserInRole> <req:isUserInRole role="com.ibm.tap.admin">
	<%
	validRole = true;
	%>
</req:isUserInRole> <%
 if (validRole) {
 %> <a href="/BRAVO/admin/home.do">Administration</a>
<%
}
%>
</div>
</div>
<br />

<div class="indent" />Legend:
<hr />
<table border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td><img alt="Active"
			src="https://w3.ibm.com/ui/v8/images/icon-system-status-ok.gif"
			width="12" height="10" /></td>
		<td>Active</td>
	</tr>
	<tr>
		<td><img alt="Inactive"
			src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
			width="12" height="10" /></td>
		<td>Inactive</td>
	</tr>
	<tr>
		<td><img alt="Alert"
			src="https://w3.ibm.com/ui/v8/images/icon-system-status-alert.gif"
			width="12" height="10" /></td>
		<td>Alert</td>
	</tr>
</table>
</div>



</div>
