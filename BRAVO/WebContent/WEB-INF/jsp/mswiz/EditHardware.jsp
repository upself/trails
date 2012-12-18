<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<jsp:useBean id="countryCodeDefault" class="java.lang.String" scope="request"/>

<h1>Hardware Settings Form - <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>
<br>
<p>Use this form to change hardware settings for a particular piece of hardware. When you
are finished, click the submit button. Press the Cancel button to
discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled in
to complete the form.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/SaveHardware">
	<html:hidden property="id" />
	<html:hidden name="softwareLpar" property="name" />

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="name">Hostname:&nbsp;</label></td>
			<td>
			<div class="input-note">&nbsp;</div>
			<bean:write name="softwareLpar" property="name" />
			</td>
		</tr>			
		<tr>
			<td class="t1"><label for="countryCodeId" >*Country: </label></td>
			<td><div class="input-note">&nbsp;</div>
				<html:select property="countryCodeId" value='<%= countryCodeDefault %>'>
					<html:options collection="countryCodes" name="CountryCode" property="value"
					labelProperty="label" />
				</html:select>
			</td>
		</tr>
		<tr>
			<td class="t1"><label for="comment">Comment: </label></td>
			<td>
			<div class="input-note">maximum 255 characters</div>
			<html:textarea property="comment" rows="4" cols="64"></html:textarea>
			</td>
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

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
