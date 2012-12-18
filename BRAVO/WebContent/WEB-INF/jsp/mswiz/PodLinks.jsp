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
			width="12" height="10" alt="Registered"/></td>
		<td>Registered</td>
	</tr>
	<tr align="center">
		<td><img src="https://w3.ibm.com/ui/v8/images/icon-urgent.gif"
			width="3" height="10" alt="Un-Registered"/></td>
		<td>Un-Registered</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
			width="12" height="10" alt="Out-Of-Scope"/></td>
		<td>Out-Of-Scope</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
			width="11" height="12" alt="Agreement Locked"/></td>
		<td>Agreement Locked</td>
	</tr>
</table>

<br>
<br>
<br>
Second Column:
<hr>
<table border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td><html:img page="/images/mnemo.gif" width="12" height="10" alt="Account Settings in Draft" /></td>
		<td>Account Settings in Draft</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-sametime-active.gif"
			width="8" height="8" alt="Account Settings Complete"/></td>
		<td>Account Settings Complete</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-document-locked.gif"
			width="11" height="12" alt="Account Locked" /></td>
		<td>Account Locked</td>
	</tr>
	<tr>
		<td><img
			src="https://w3.ibm.com/ui/v8/images/icon-system-status-na.gif"
			width="12" height="10" alt="No Account Settings"/></td>
		<td>No Account Settings</td>
	</tr>
</table>
