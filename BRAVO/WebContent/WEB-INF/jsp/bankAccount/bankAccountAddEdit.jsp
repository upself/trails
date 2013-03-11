<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="logic" uri="http://struts.apache.org/tags-logic"%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>

<html lang="en">
<head>
<title>Bank accounts - <logic:equal scope="request"
	name="bankAccountForm" property="connectionType" value="CONNECTED">Connected</logic:equal><logic:equal
	scope="request" name="bankAccountForm" property="connectionType"
	value="DISCONNECTED">Disconnected</logic:equal> - Add/Edit</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>

<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<script type="text/javascript">
<!--
function setChange() {
	var lbankAccountForm = document.bankAccountForm;
	var bankAccountType = lbankAccountForm.type.value;
	if ( bankAccountType && bankAccountType=='TADZ') {

		alert("You can not change the TAD4Z bank account to disconnected!");
       return false;
	} else {
		self.location="/BRAVO/bankAccount/updateConnectionType.do?id="+lbankAccountForm.id.value ;
		return true;
	}
		
}
-->
</script>

<!-- BEGIN CONTENT -->
<div id="content">
<h1 class="access">Start of main content</h1>

<!-- BEGIN CONTENT HEAD -->
<div id="content-head">
<p id="date-stamp">New as of 17 February 2009</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/">BRAVO</html:link> &gt; <html:link
	page="/bankAccount/home.do">Bank accounts</html:link> &gt; <logic:equal
	scope="request" name="bankAccountForm" property="connectionType"
	value="CONNECTED">
	<html:link page="/bankAccount/connected.do">Connected</html:link>
</logic:equal> <logic:equal scope="request" name="bankAccountForm"
	property="connectionType" value="DISCONNECTED">
	<html:link page="/bankAccount/disconnected.do">Disconnected</html:link>
</logic:equal></p>
</div>

<!-- BEGIN MAIN CONTENT -->
<div id="content-main"><!-- BEGIN PARTIAL-SIDEBAR -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="action">
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="Contextual field help icon" />
</html:link></h2>
</div>
<br />

</div>
<!-- END PARTIAL-SIDEBAR -->

<h1>Add/Edit <logic:equal scope="request" name="bankAccountForm"
	property="connectionType" value="CONNECTED">connected</logic:equal><logic:equal
	scope="request" name="bankAccountForm" property="connectionType"
	value="DISCONNECTED">disconnected</logic:equal> bank account</h1>
<p>Use this form to <logic:empty scope="request"
	name="bankAccountForm" property="id">request a new</logic:empty> <logic:notEmpty
	scope="request" name="bankAccountForm" property="id">update a</logic:notEmpty>
<logic:equal scope="request" name="bankAccountForm"
	property="connectionType" value="CONNECTED">connected</logic:equal> <logic:equal
	scope="request" name="bankAccountForm" property="connectionType"
	value="DISCONNECTED">disconnected</logic:equal> bank account. When you
are finished, press the Submit button. Press the Cancel button to
discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.</p>
<p class="hrule-dots" />

<p><logic:notEmpty scope="request" name="bankAccountForm"
	property="id">
					To change this bank account to a
					<logic:equal scope="request" name="bankAccountForm"
		property="connectionType" value="CONNECTED">disconnected</logic:equal>
	<logic:equal scope="request" name="bankAccountForm"
		property="connectionType" value="DISCONNECTED">connected</logic:equal>
					bank account click
					<html:submit onclick="setChange()">here</html:submit>.
				</logic:notEmpty></p>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent> <html:form action="/bankAccount/bankAccountSave">
	<html:hidden styleId="id" property="id" />
	<html:hidden styleId="connectionType" property="connectionType" />
	<html:hidden styleId="connectionStatus" property="connectionStatus" />
	<logic:empty scope="request" name="bankAccountForm" property="id">
		<html:hidden styleId="status" property="status" />
	</logic:empty>
	<table cellpadding="2" cellspacing="1" border="0">
		<tbody>
			<logic:notEmpty scope="request" name="bankAccountForm" property="id">
				<tr>
					<td></td>
					<td>Bank account ID:</td>
					<td><bean:write name="bankAccountForm" property="id" /></td>
				</tr>
			</logic:notEmpty>
			<tr>
				<td>*</td>
				<td><label for="name">Bank account name:</label></td>
				<td>
				<div class="input-note">maximum 32 characters</div>
				<html:text styleId="name" property="name" styleClass="input"
					size="40" maxlength="32" /></td>
			</tr>
			<tr>
				<td>*</td>
				<td><label for="description">Bank account description:</label>
				</td>
				<td>
				<div class="input-note">maximum 128 characters</div>
				<html:text styleId="description" property="description"
					styleClass="input" size="40" maxlength="128" /></td>
			</tr>
			<tr>
				<td>*</td>
				<td><label for="type">Bank account type:</label></td>
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
					<html:option value="TAD4Z">TADZ</html:option>
					<logic:equal scope="request" name="bankAccountForm"
						property="connectionType" value="DISCONNECTED">
						<html:option value="FACTS">FACTS</html:option>
						<html:option value="TAD4D">TAD4D</html:option>
					</logic:equal>
					<logic:equal scope="request" name="bankAccountForm"
						property="connectionType" value="CONNECTED">
						<html:option value="ATP">ATP</html:option>
						<html:option value="SWCM">SWCM</html:option>
					</logic:equal>
				</html:select></td>
			</tr>
			<tr>
				<td>*</td>
				<td><label for="version">Bank account version:</label></td>
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
				<td>*</td>
				<td><label for="dataType">Data type:</label></td>
				<td>
				<div class="input-note">Select one</div>
				<html:select styleId="dataType" property="dataType"
					styleClass="input">
					<html:option value="">-SELECT-</html:option>
					<html:option value="ATP">ATP</html:option>
					<html:option value="BASELINE">BASELINE</html:option>
					<html:option value="INVENTORY">INVENTORY</html:option>
				</html:select></td>
			</tr>
			<logic:equal scope="request" name="bankAccountForm"
				property="connectionType" value="CONNECTED">
				<tr>
					<td>*</td>
					<td><label for="databaseType">Database type:</label></td>
					<td>
					<div class="input-note">Select one</div>
					<html:select styleId="databaseType" property="databaseType"
						styleClass="input">
						<html:option value="">-SELECT-</html:option>
						<html:option value="DB2">DB2</html:option>
					</html:select></td>
				</tr>
				<tr>
					<td>*</td>
					<td><label for="databaseVersion">Database version:</label></td>
					<td>
					<div class="input-note">Select one</div>
					<html:select styleId="databaseVersion" property="databaseVersion"
						styleClass="input">
						<html:option value="">-SELECT-</html:option>
						<html:option value="8.1">8.1</html:option>
						<html:option value="8.2">8.2</html:option>
					</html:select></td>
				</tr>
				<tr>
					<td>*</td>
					<td><label for="databaseName">Database name:</label></td>
					<td>
					<div class="input-note">maximum 8 characters</div>
					<html:text styleId="databaseName" property="databaseName"
						styleClass="input" size="40" maxlength="8" /></td>
				</tr>
				<tr>
					<td></td>
					<td><label for="databaseSchema">Database schema:</label></td>
					<td>
					<div class="input-note">maximum 16 characters</div>
					<html:text styleId="databaseSchema" property="databaseSchema"
						styleClass="input" size="40" maxlength="16" /></td>
				</tr>
				<tr>
					<td>*</td>
					<td><label for="databaseIp">Database IP:</label></td>
					<td>
					<div class="input-note">maximum 15 characters(x.x.x.x)</div>
					<html:text styleId="databaseIp" property="databaseIp"
						styleClass="input" size="40" maxlength="15" /></td>
				</tr>
				<tr>
					<td>*</td>
					<td><label for="databasePort">Database port:</label></td>
					<td>
					<div class="input-note">maximum 16 characters</div>
					<html:text styleId="databasePort" property="databasePort"
						styleClass="input" size="40" maxlength="16" /></td>
				</tr>
				<tr>
					<td>*</td>
					<td><label for="databaseUser">Database user name:</label></td>
					<td>
					<div class="input-note">maximum 16 characters</div>
					<html:text styleId="databaseUser" property="databaseUser"
						styleClass="input" size="40" maxlength="16" /></td>
				</tr>
				<tr>
					<td>*</td>
					<td><label for="databasePassword">Database password:</label></td>
					<td>
					<div class="input-note">maximum 16 characters</div>
					<html:password styleId="databasePassword"
						property="databasePassword" styleClass="input" size="40"
						maxlength="16" /></td>
				</tr>
				<tr>
					<td>*</td>
					<td>Socks connection required:</td>
					<td>
					<div class="input-note">Select one:</div>
					<label for="radio_socks_y"></label> <html:radio
						styleId="radio_socks_y" property="socks" value="Y">YES</html:radio>
					<label for="radio_socks_n"></label> <html:radio
						styleId="radio_socks_n" property="socks" value="N">NO</html:radio>
					</td>
				</tr>
				<tr>
					<td>*</td>
					<td>SSH tunnel connection required:</td>
					<td>
					<div class="input-note">Select one:</div>
					<label for="radio_tunnel_y"></label> <html:radio
						styleId="radio_tunnel_y" property="tunnel" value="Y">YES</html:radio>
					<label for="radio_tunnel_n"></label> <html:radio
						styleId="radio_tunnel_n" property="tunnel" value="N">NO</html:radio>
					</td>
				</tr>
				<tr>
					<td></td>
					<td><label for="text_tunnelPort">Tunnel port:</label></td>
					<td>
					<div class="input-note">integer</div>
					<html:text styleId="text_tunnelPort" property="tunnelPort"
						styleClass="input" size="40" maxlength="16" /></td>
				</tr>
			</logic:equal>
			<tr>
				<td>*</td>
				<td>Authenticated data:</td>
				<td>
				<div class="input-note">Select one:</div>
				<label for="radio_authenticationData_yes"></label> <html:radio
					styleId="radio_authenticationData_yes" property="authenticatedData"
					value="Y">YES</html:radio> <label for="radio_authenticationData_no"></label>
				<html:radio styleId="radio_authenticationData_no"
					property="authenticatedData" value="N">NO</html:radio></td>
			</tr>
			<logic:equal scope="request" name="bankAccountForm"
				property="connectionType" value="CONNECTED">
				<tr>
					<td>*</td>
					<td>Synchronize signatures:</td>
					<td>
					<div class="input-note">Select one:</div>
					<label for="radio_syncSig_y"></label> <html:radio
						styleId="radio_syncSig_y" property="syncSig" value="Y">YES</html:radio>
					<label for="radio_syncSig_n"></label> <html:radio
						styleId="radio_syncSig_n" property="syncSig" value="N">NO</html:radio>
					</td>
				</tr>
			</logic:equal>
			<logic:notEmpty scope="request" name="bankAccountForm" property="id">
				<tr>
					<td>*</td>
					<td><label for="select_status">Status:</label></td>
					<td>
					<div class="input-note">Select one:</div>
					<html:select styleId="select_status" property="status"
						styleClass="input">
						<html:option value="ACTIVE">ACTIVE</html:option>
						<html:option value="INACTIVE">INACTIVE</html:option>
					</html:select></td>
				</tr>
			</logic:notEmpty>
		</tbody>
	</table>
	<p />
	<div class="hrule-dots"></div>
	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"> <html:submit>Submit</html:submit>
	<html:cancel onkeypress="return(this.onclick());">Cancel</html:cancel>
	</span></div>
	</div>
</html:form> <br />
<br />

</div>
<!-- END MAIN CONTENT --></div>
<!-- END CONTENT -->
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>
