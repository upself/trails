<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>

<h1>Add Connected Bank Account</h1>
<br>
<p>Use this form to request a new connected bank account. When you
are finished, click the submit button. Press the Cancel button to
discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.
<p class="hrule-dots"></p>
<br>
<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
<html:form action="/AddConnectedBankAccountSave">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="name">*Bank Account Name:</label></td>
			<td>
			<div class="input-note">maximum 32 characters</div>
			<html:text styleId="name" property="name" styleClass="input" size="32" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="description">*Bank Account
			Description:</label></td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:text styleId="description" property="description" styleClass="input" size="128" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="type">*Bank Account Type:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select styleId="type" property="type" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="TCM">TCM</html:option>
				<html:option value="TLM">TLM</html:option>
				<html:option value="SMS">SMS</html:option>
				<html:option value="SNAPSHOT">SNAPSHOT</html:option>
				<html:option value="EESM">EESM</html:option>
				<html:option value="BLAZANT">BLAZANT</html:option>
				<html:option value="ALTIRIS">ALTIRIS</html:option>
				<html:option value="IDD">IDD</html:option>
				<html:option value="ATP">ATP</html:option>
				<html:option value="SWCM">SWCM</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="version">*Bank Account
			Version:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select styleId="version" property="version" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="1.0">1.0</html:option>
				<html:option value="4.2">4.2</html:option>
				<html:option value="4.2.3.2">4.2.3 FixPack 2</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="id_dataType">*Data Type:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select styleId="id_dataType" property="dataType" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="ATP">ATP</html:option>
				<html:option value="BASELINE">BASELINE</html:option>
				<html:option value="INVENTORY">INVENTORY</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="databaseType">*Database Type:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select styleId="databaseType" property="databaseType" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="DB2">DB2</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="databaseVersion">*Database
			Version:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select styleId="databaseVersion" property="databaseVersion" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="8.1">8.1</html:option>
				<html:option value="8.2">8.2</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="databaseName">*Database Name:</label></td>
			<td>
			<div class="input-note">maximum 8 characters</div>
			<html:text styleId="databaseName" property="databaseName" styleClass="input" size="8" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="databaseSchema">Database
			Schema:</label></td>
			<td>
			<div class="input-note">maximum 16 characters</div>
			<html:text styleId="databaseSchema" property="databaseSchema" styleClass="input" size="16" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="databaseIp">*Database IP:</label></td>
			<td>
			<div class="input-note">maximum 15 characters(x.x.x.x)</div>
			<html:text styleId="databaseIp" property="databaseIp" styleClass="input" size="15" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="databasePort">*Database Port:</label></td>
			<td>
			<div class="input-note">maximum 16 characters</div>
			<html:text styleId="databasePort" property="databasePort" styleClass="input" size="16" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="databaseUser">*Database User
			Name:</label></td>
			<td>
			<div class="input-note">maximum 16 characters</div>
			<html:text styleId="databaseUser" property="databaseUser" styleClass="input" size="16" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="databasePassword">*Database
			Password:</label></td>
			<td>
			<div class="input-note">maximum 16 characters</div>
			<html:password styleId="databasePassword" property="databasePassword" styleClass="input"
				size="16" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="socks">*Socks connection
			required:</label></td>
			<td>
			<div class="input-note">Select one:</div>
			<html:radio styleId="socks" property="socks" value="Y">YES</html:radio> <html:radio
				styleId="socks" property="socks" value="N">NO</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="tunnel">*SSH Tunnel
			connection required:</label></td>
			<td>
			<div class="input-note">Select one:</div>
			<html:radio styleId="tunnel" property="tunnel" value="Y">YES</html:radio> <html:radio
				styleId="tunnel" property="tunnel" value="N">NO</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="tunnelPort">Tunnel Port:</label></td>
			<td>
			<div class="input-note">integer</div>
			<html:text styleId="tunnelPort" property="tunnelPort" styleClass="input" size="16" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="authenticatedData">*Authenticated
			Data:</label></td>
			<td>
			<div class="input-note">Select one:</div>
			<html:radio styleId="authenticationData" property="authenticatedData" value="Y">YES</html:radio> <html:radio
				styleId="authenticationData" property="authenticatedData" value="N">NO</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="syncSig">*Synchronize
			Signatures:</label></td>
			<td>
			<div class="input-note">Select one:</div>
			<html:radio styleId="syncSig" property="syncSig" value="Y">YES</html:radio> <html:radio
				styleId="syncSig" property="syncSig" value="N">NO</html:radio></td>
		</tr>
	</table>
	<p>&nbsp;</p>
	<div class="hrule-dots">&nbsp;</div>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel onkeypress="return(this.onclick());">Cancel</html:cancel></span></div>
	</div>

</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
