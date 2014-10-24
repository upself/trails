<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>

<h1>Update Disconnected Bank Account</h1>
<br>
<p>Use this form to request a new disconnected bank account. When
you are finished, click the submit button. Press the Cancel button to
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
<html:form action="/UpdateDisconnectedBankAccountSave">
	<p>To change this bank account to a connected bank account click <html:link
		page="/UpdateConnectedBankAccount.do" paramId="id"
		paramName="bankAccountForm" paramProperty="id">here</html:link>
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<html:hidden property="id" />
		<tr>
			<td class="t1"><label for="name">*Bank Account Name:</label></td>
			<td>
			<div class="input-note">maximum 8 characters</div>
			<html:text property="name" styleClass="input" size="32" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="description">*Bank Account
			Description:</label></td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:text property="description" styleClass="input" size="128" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="type">*Bank Account Type:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="type" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="TCM">TCM</html:option>
				<html:option value="TLM">TLM</html:option>
				<html:option value="SMS">SMS</html:option>
				<html:option value="SNAPSHOT">SNAPSHOT</html:option>
				<html:option value="EESM">EESM</html:option>
				<html:option value="BLAZANT">BLAZANT</html:option>
				<html:option value="ALTIRIS">ALTIRIS</html:option>
				<html:option value="IDD">IDD</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="version">*Bank Account
			Version:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="version" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="4.2">4.2</html:option>
				<html:option value="4.2.3.2">4.2.3 FixPack 2</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="dataType">*Data Type:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="dataType" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="ATP">ATP</html:option>
				<html:option value="BASELINE">BASELINE</html:option>
				<html:option value="INVENTORY">INVENTORY</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="authenticatedData">*Authenticated
			Data:</label></td>
			<td>
			<div class="input-note">Select one:</div>
			<html:radio property="authenticatedData" value="Y">YES</html:radio> <html:radio
				property="authenticatedData" value="N">NO</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="status">*Status:</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="status" styleClass="input">
				<html:option value="DB2">ACTIVE</html:option>
				<html:option value="DB2">INACTIVE</html:option>
			</html:select></td>
		</tr>
	</table>
	<p>&nbsp;</p>
	<div class="hrule-dots">&nbsp;</div>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>

</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
