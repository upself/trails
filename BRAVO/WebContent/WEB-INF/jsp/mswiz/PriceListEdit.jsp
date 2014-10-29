<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Price List Form</h1>
<br>
<p>Use this form to change attributes of an object in the price
list. When you are finished, click the submit button. Press the Cancel
button to discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent> <html:form action="/SaveMicrosoftPriceList">
	<html:hidden property="microsoftPriceListId" />

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="text_sku">*Sku: </label></td>
			<td class="t1">
			<html:text property="sku" size="32" styleId="text_sku" />
		</tr>
		<tr>
			<td class="t1"><label for="select_microsoftProduct">*Microsoft
			Product: </label></td>
			<td class="t1">
			<html:select property="microsoftProductId"
				styleId="select_microsoftProduct">
				<html:options collection="product.list"
					labelProperty="productDescription" property="microsoftProductId" />
			</html:select>
		</tr>
		<tr>
			<td class="t1"><label for="select_licenseAgreementType">*License
			Agreement Type: </label></td>
			<td class="t1">
			<html:select property="licenseAgreementTypeId"
				styleId="select_licenseAgreementType">
				<html:options collection="licenseAgreement.list"
					labelProperty="licenseAgreementTypeName"
					property="licenseAgreementTypeId" />
			</html:select>
		</tr>
		<tr>
			<td class="t1"><label for="select_licenseType">*License
			Type: </label></td>
			<td class="t1">
			<html:select property="licenseTypeId" styleId="select_licenseType">
				<html:options collection="licenseType.list"
					labelProperty="licenseTypeName" property="licenseTypeId" />
			</html:select>
		</tr>
		<tr>
			<td class="t1"><label for="select_priceLevel">Price
			Level: </label></td>
			<td class="t1">
			<html:select property="priceLevelId" styleId="select_priceLevel">
				<html:options collection="priceLevel.list"
					labelProperty="priceLevel" property="priceLevelId" />
			</html:select>
		</tr>
		<tr>
			<td class="t1"><label for="select_qualifiedDiscount">Qualified
			Discount: </label></td>
			<td class="t1">
			<html:select property="qualifiedDiscountId"
				styleId="select_qualifiedDiscount">
				<html:options collection="qualifiedDiscount.list"
					labelProperty="qualifiedDiscount" property="qualifiedDiscountId" />
			</html:select>
		</tr>
		<tr>
			<td class="t1"><label for="select_authenticated">Authenticated:
			</label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select property="authenticated" styleId="select_authenticated">
				<html:option value=""></html:option>
				<html:option value="Y">Yes</html:option>
				<html:option value="N">No</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="text_unit">*Unit: </label></td>
			<td>
			<div class="input-note">maximum 16 characters</div>
			<html:text property="unit" size="16" styleId="text_unit" />
		</tr>
		<tr>
			<td class="t1"><label for="text_unit_price">*Unit Price: </label></td>
			<td>
			<div class="input-note">maximum 16 characters</div>
			<html:text property="unitPrice" size="16" styleId="text_unit_price"/>
		</tr>
	</table>
	<p />
	<div class="hrule-dots"></div>

	<div class="clear"></div>
	<div class="button-bar">

	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>
</html:form> <br>
<html:form action="/DeleteMicrosoftPriceList">
	<html:hidden property="microsoftPriceListId" />
	<div class="clear"></div>
	<div class="button-bar">

	<div class="buttons"><span class="button-blue"><html:submit>Delete</html:submit></span></div>
	</div>
</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->