<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<br>
<br>
<br>
First Column:
<hr>
<table border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-system-status-ok.gif"
			alt="system status ok icon" width="12" height="10" /></td>
		<td>Registered</td>
	</tr>
	<tr>
		<td style="color: green"><strong>A</strong> -</td>
		<td>Approved</td>
	</tr>
	<tr>
		<td style="color: red"><strong>R</strong> -</td>
		<td>Rejected</td>
	</tr>
	<tr>
		<td style="color: #FDD017"><strong>E</strong> -</td>
		<td>Escalated</td>
	</tr>
	<tr>
		<td style="color: blue"><strong>P</strong> -</td>
		<td>Past Due</td>
	</tr>

</table>

<br>
<br>
<br>
Second Column:
<hr>
<table border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td><html:img page="/images/mnemo.gif" alt="memo icon" width="12"
			height="10" /></td>
		<td>Account Settings in Draft</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-sametime-active.gif"
			alt="sametime active icon" width="8" height="8" /></td>
		<td>Account Settings Complete</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
			alt="document locked icon" width="11" height="12" /></td>
		<td>Account Locked</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
			alt="system status na icon" width="12" height="10" /></td>
		<td>No Account Settings</td>
	</tr>
</table>
