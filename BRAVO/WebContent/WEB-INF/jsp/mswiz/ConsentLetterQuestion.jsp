<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<script src="/BRAVO/javascript/date-picker.js"></script>

<h1><bean:write name="consentLetter"
	property="consentType.consentTypeName" /> - <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>

<br>
<p>Use this form to change the status of a consent letter. When you are
finished, click the submit button. Press the Cancel button to discard
your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled in
to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<logic:equal name="consentLetter" property="consentType.consentTypeName"
	value="ESPLA ENROLLMENT FORM">
	<html:form action="/SaveEsplaEnrollmentQuestions">
		<html:hidden name="consentLetter" property="consentLetterId" />
		<table cellspacing="0" cellpadding="0" class="sign-in-table">
			<tr>
				<td class="t1"><label for="microsoftStatus">*Has the form been
				Submitted to Microsoft?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="microsoftStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="esplaEnrollmentNumber">What is the ESPLA
				enrollment number?: </label></td>
				<td>
				<div class="input-note">maximum 16 characters</div>
				<html:text property="esplaEnrollmentNumber" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="priceLevelValue">What is the price level of
				the account?: </label></td>
				<td> 
				<div class="input-note">Select one</div>
				<html:select property="priceLevelValue">
					<html:option value=""></html:option>
					<html:option value="A">A</html:option>
					<html:option value="B">B</html:option>
					<html:option value="C">C</html:option>
					<html:option value="D">D</html:option>
				</html:select></td>
			</tr>
		</table>

		<p/>
		<div class="hrule-dots"></div>

		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
	</html:form>
</logic:equal>

<logic:equal name="consentLetter" property="consentType.consentTypeName"
	value="SELECT HOSTING VERIFICATION FORM">
	<html:form action="/SaveSelectHostingQuestions">
		<html:hidden property="consentLetterId" />
		<table cellspacing="0" cellpadding="0" class="sign-in-table">
			<tr>
				<td class="t1"><label for="accountStatus">*Has the form been
				submitted to account team?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="accountStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="assetStatus">Has the signed form been
				received by asset management?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="assetStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="respondDateStr">Input the date which the
				account team has to respond back to Asset Management with the
				complete form: </label></td>
				<td>
				<div class="input-note">Click on icon for calendar</div>
				<a href="javascript:show_calendar('consentLetter.respondDateStr');"
					onmouseover="window.status='Date Picker';return true;"
					onmouseout="window.status='';return true;"><html:img
					src="images/calendar.gif" border="0"></html:img></a> <html:text
					property="respondDateStr" /></td>
			</tr>
		</table>

		<p/>
		<div class="hrule-dots"></div>

		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
	</html:form>
</logic:equal>

<logic:equal name="consentLetter" property="consentType.consentTypeName"
	value="ENTERPRISE HOSTING VERIFICATION FORM">
	<html:form action="/SaveEnterpriseHostingQuestions">
		<html:hidden property="consentLetterId" />
		<table cellspacing="0" cellpadding="0" class="sign-in-table">
			<tr>
				<td class="t1"><label for="accountStatus">*Has the form been
				Submitted to account team?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="accountStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="assetStatus">Has the signed form been
				received by asset management?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="assetStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="respondDateStr">Input the date which the
				account team has to respond back to Asset Management with the
				complete form: </label></td>
				<td>
				<div class="input-note">Click on icon for calendar</div>
				<a href="javascript:show_calendar('consentLetter.respondDateStr');"
					onmouseover="window.status='Date Picker';return true;"
					onmouseout="window.status='';return true;"><html:img
					src="images/calendar.gif" border="0"></html:img></a> <html:text
					property="respondDateStr" /></td>
			</tr>
		</table>

		<p/>
		<div class="hrule-dots"></div>

		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
	</html:form>
</logic:equal>

<logic:equal name="consentLetter" property="consentType.consentTypeName"
	value="PRO FORMA CONSENT">
	<html:form action="/SaveProFormaQuestions">
		<html:hidden property="consentLetterId" />
		<table cellspacing="0" cellpadding="0" class="sign-in-table">
			<tr>
				<td class="t1"><label for="accountStatus">*Has the form been
				Submitted to account team?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="accountStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="assetStatus">Has the signed form been
				received by asset management?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="assetStatus" value="true" /></td>
			</tr>
		</table>

		<p/>
		<div class="hrule-dots"></div>

		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
	</html:form>
</logic:equal>

<logic:equal name="consentLetter" property="consentType.consentTypeName"
	value="ENTERPRISE OUTSOURCER ENROLLMENT AGREEMENT">
	<html:form action="/SaveEnterpriseOutsourcerQuestions">
		<html:hidden property="consentLetterId" />
		<table cellspacing="0" cellpadding="0" class="sign-in-table">
			<tr>
				<td class="t1"><label for="accountStatus">*Has the form been
				Submitted to account team?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="accountStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="assetStatus">Has the signed form been
				received by asset management?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="assetStatus" value="true" /></td>
			</tr>
		</table>

		<p/>
		<div class="hrule-dots"></div>

		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
	</html:form>
</logic:equal>

<logic:equal name="consentLetter" property="consentType.consentTypeName"
	value="SELECT OUTSOURCER ENROLLMENT AGREEMENT">
	<html:form action="/SaveSelectOutsourcerQuestions">
		<html:hidden property="consentLetterId" />
		<table cellspacing="0" cellpadding="0" class="sign-in-table">
			<tr>
				<td class="t1"><label for="accountStatus">*Has the form been
				Submitted to account team?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="accountStatus" value="true" /></td>
			</tr>
			<tr>
				<td class="t1"><label for="assetStatus">Has the signed form been
				received by asset management?: </label></td>
				<td>
				<div class="input-note">Check here</div>
				<html:checkbox property="assetStatus" value="true" /></td>
			</tr>
		</table>

		<p/>
		<div class="hrule-dots"></div>

		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
		<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
		</div>
	</html:form>
</logic:equal>

</table>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
