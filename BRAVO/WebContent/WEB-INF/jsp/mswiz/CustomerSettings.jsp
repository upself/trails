<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Customer Account Settings Form</h1>
<h2><span class="orange-dark"><bean:write name="user.container"
	property="customer.customerName" /></span></h2>
<br>
<p>Use this form to register account settings for a customer. When you
are finished, click the submit button. Press the Cancel button to
discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled in
to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
<html:form action="/SaveInitialCustomerSettings">

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="releaseInformation">*Can IBM release
			customer information to Microsoft according to the contract between
			IBM and the customer?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:radio property="releaseInformation" value="true">Yes</html:radio>
			<html:radio property="releaseInformation" value="false">No</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="contractEnd">*Will the contract with this
			account end before <bean:write name="user.container"
				property="quarterQuestion" />?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:radio property="contractEnd" value="true">Yes</html:radio> <html:radio
				property="contractEnd" value="false">No</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="microsoftSoftwareOwner">*Who owns the
			Microsoft software used to support the account (this includes
			Operating System Software)?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="microsoftSoftwareOwner">
				<html:option value=""></html:option>
				<html:option value="IBM">IBM</html:option>
				<html:option value="CUSTOMER">Customer</html:option>
				<html:option value="BOTH">Both</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="qualifiedDiscount">*What is the qualified
			discount level of this customer?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="qualifiedDiscountLong">
				<html:options collection="qualifiedDiscount.list"
					labelProperty="qualifiedDiscount" property="qualifiedDiscountId" />
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="usMachines">*Are all machines for this
			customer located in the United States?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:radio property="usMachines" value="true">Yes</html:radio> <html:radio
				property="usMachines" value="false">No</html:radio></td>
		</tr>
		<tr>
			<td class="t1"><label for="defaultLpidLong">*What is the LPID used to
			purchase software for this customer?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="defaultLpidLong">
				<html:option value=""></html:option>
				<html:options collection="lpids" property="value"
					labelProperty="label" />
			</html:select></td>
		</tr>

	</table>
	<p/>
	<div class="hrule-dots"></div>

	<div class="clear"></div>
	<div class="button-bar">

	<div class="buttons"><span class="button-blue"><html:submit
		property="command(next)">Next</html:submit></span> <span
		class="button-blue"><html:submit property="command(draft)">Save as draft</html:submit></span>
	<span class="button-blue"><html:submit property="command(cancel)">Cancel</html:submit></span></div>
	</div>
</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
