<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Customer Registration Form</h1>
<h2><span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h2>
<br>
<p>Use this form to register a customer. When you are finished, click
the submit button. Press the Cancel button to discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled in
to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
<html:form action="/SaveCustomerRegistration">

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="inScope">*Is this account in scope for
			reporting license information to Microsoft?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:radio property="inScope" value="true">Yes</html:radio> <html:radio
				property="inScope" value="false">No</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="notInScopeJustification">Out of scope
			justification: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="notInScopeJustification">
				<html:option value=""></html:option>
				<html:option value="TERMINATED">Terminated</html:option>
				<html:option value="IBM INTERNAL ONLY">IBM Internal only</html:option>
				<html:option value="ALL RISC OR MAINFRAME">All RISC or mainframe</html:option>
				<html:option value="OTHER">Other</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="notInScopeJustificationOther">Out of scope
			justification(If other): </label></td>
			<td>
			<div class="input-note">maximum 64 characters</div>
			<input size="64" id="justificationOther"
				name="justificationOther" property="justificationOther" /></td>
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
