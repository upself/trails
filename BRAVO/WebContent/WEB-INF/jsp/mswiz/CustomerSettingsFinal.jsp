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
<html:form action="/SaveFinalCustomerSettings">

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="microsoftSoftwareBuyer">*Who will buy
			customer owned licenses off of the customers Microsoft agreement?: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="microsoftSoftwareBuyer">
				<html:option value=""></html:option>
				<html:option value="IBM">IBM</html:option>
				<html:option value="CUSTOMER">Customer</html:option>
				<html:option value="BOTH">Both</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="customerLicenseAgreementStrings">*Which
			agreement does the customer have with Microsoft for the customer
			owned SW?: </label></td>
			<td>
			<div class="input-note">Select all that apply</div>
			<logic:iterate id="customerAgreementType" name="agreementType.list">
				<html:multibox property="customerAgreementLongs">
					<bean:write name="customerAgreementType"
						property="customerAgreementTypeId" />
				</html:multibox>
				<bean:write name="customerAgreementType"
					property="customerAgreementType" />
				<br>
			</logic:iterate></td>
		</tr>
	</table>
	<p/>
	<div class="hrule-dots"></div>

	<div class="clear"></div>
	<div class="button-bar">

	<div class="buttons"><span class="button-blue"><html:submit
		property="command(saveFinal)">Submit</html:submit></span> <span
		class="button-blue"><html:submit property="command(cancel)">Cancel</html:submit></span></div>
	</div>
</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
