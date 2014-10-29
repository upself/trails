<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<script src="/BRAVO/javascript/misld.js"></script>

<h1>Microsoft Price List</h1>
<p>The list below contains details of the Microsoft Price List. Click on
the sku to edit.</p>

<br>
<br>
<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
	alt="add icon - dark" width="13" height="13" />
<html:link page="/AddMicrosoftProduct.do">Add Microsoft Product</html:link>
<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
	alt="add icon - dark" width="13" height="13" />
<html:link page="/AddMicrosoftPriceList.do">Add Microsoft Price List Object</html:link>

<%
		boolean alternate = true;
		%>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="11" style="white-space:nowrap; background-color:#bd6;">Price
		List</th>
	</tr>
	<tr style="background-color:#dfb;" class="tablefont">
		<th nowrap="nowrap">SKU</th>
		<th nowrap="nowrap">Microsoft Product Name</th>
		<th nowrap="nowrap">License Agreement Type</th>
		<th nowrap="nowrap">License Type</th>
		<th nowrap="nowrap">Price Level</th>
		<th nowrap="nowrap">Qualified Discount</th>
		<th nowrap="nowrap">Authenticated</th>
		<th nowrap="nowrap">Unit</th>
		<th nowrap="nowrap">Unit Price</th>
		<th nowrap="nowrap">Editor</th>
	</tr>

	<logic:iterate id="priceList" name="priceList">

		<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>
		<td><html:link action="/EditPriceList.do" paramId="priceList"
			paramName="priceList" paramProperty="microsoftPriceListId">
			<bean:write name="priceList" property="sku" />
		</html:link></td>
		<td><html:link action="/EditProductMap.do" paramId="product"
			paramName="priceList"
			paramProperty="microsoftProduct.microsoftProductId">
			<bean:write name="priceList"
				property="microsoftProduct.productDescription" />
		</html:link></td>
		<td><bean:write name="priceList"
			property="licenseAgreementType.licenseAgreementTypeName" /></td>
		<td><bean:write name="priceList"
			property="licenseType.licenseTypeName" /></td>
		<td><bean:write name="priceList" property="priceLevel.priceLevel" /></td>
		<td><bean:write name="priceList"
			property="qualifiedDiscount.qualifiedDiscount" /></td>
		<td><bean:write name="priceList" property="authenticated" /></td>
		<td><bean:write name="priceList" property="unit" /></td>
		<td><bean:write name="priceList" property="unitPrice" /></td>
		<td><bean:write name="priceList" property="remoteUser" /></td>
		</tr>
	</logic:iterate>
</table>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
