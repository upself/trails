<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<%boolean alternate = true;%>

<html:form action="/SavePoInfo">

	<h1>Price Report: <span class="orange-dark"><bean:write
		name="priceReport" property="customerName" /> <bean:write
		name="priceReport" property="customerType" /></span></h1>
	<h2>Industry: <span class="orange-dark"><bean:write name="priceReport"
		property="industry" /></span></h2>
	<h2>Sector: <span class="orange-dark"><bean:write name="priceReport"
		property="sector" /></span></h2>
	<h2>Customer Agreement: <span class="orange-dark"><bean:write
		name="priceReport" property="customerAgreementType" /></span></h2>
	<logic:notEqual name="priceReport" property="priceLevel" value="">
		<h1><logic:equal name="priceReport" property="priceLevelFlag"
			value="true">*</logic:equal>Price Level: <span class="orange-dark"><bean:write
			name="priceReport" property="priceLevel" /></span></h1>
	</logic:notEqual>

	<br>

	<logic:notEmpty name="priceReport" property="summary">
		<bean:define id="summary" name="priceReport" property="summary" />

		<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
			width="100%" style="margin-top:2em;">
			<tr class="tablefont">
				<th colspan="8" style="white-space:nowrap; background-color:#bd6;">Produce
				Summary</th>
			</tr>
			<tr style="background-color:#dfb;" class="tablefont">
				<th nowrap="nowrap">SKU</th>
				<th nowrap="nowrap">Software Name</th>
				<th nowrap="nowrap">Server Count</th>
				<th nowrap="nowrap">Processor Count</th>
				<th nowrap="nowrap">User Count</th>
				<th nowrap="nowrap">Total Licenses</th>
				<th nowrap="nowrap">Total Spla Quarterly Cost</th>
				<th nowrap="nowrap">Total Espla Yearly Cost</th>
			</tr>
			<logic:iterate id="sumComponent" name="summary">
				<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
		%>
				<logic:notEmpty name="sumComponent" property="value">
					<bean:define id="something" name="sumComponent" property="value" />
					<td><bean:write name="something" property="sku" /></td>
					<td><bean:write name="something" property="softwareName" /></td>
					<td><bean:write name="something" property="serverCount" /></td>
					<td><bean:write name="something" property="processorCount" /></td>
					<td><bean:write name="something" property="userCount" /></td>
					<td><bean:write name="something" property="licenseTotal" /></td>
					<td><bean:write name="something" property="totalSplaPrice" /></td>
					<td><bean:write name="something" property="totalEsplaPrice" /></td>
				</logic:notEmpty>
				</tr>
			</logic:iterate>

			<tr style="font-size:8pt">
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<th style="white-space:nowrap; background-color:#bd6;">Totals</th>
				<th style="white-space:nowrap; background-color:#bd6;"><bean:write
					name="priceReport" property="totalSplaPrice" /></th>
				<th style="white-space:nowrap; background-color:#bd6;"><bean:write
					name="priceReport" property="totalEsplaPrice" /></th>
			</tr>
		</table>
	</logic:notEmpty>
	<br>
	<br>
	<br>

	<logic:notEmpty name="priceReport" property="lpidTotals">

		<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
			width="100%" style="margin-top:2em;">
			<tr class="tablefont">
				<th colspan="8" style="white-space:nowrap; background-color:#bd6;">LPID
				Summary</th>
			</tr>
			<tr style="background-color:#dfb;" class="tablefont">
				<th nowrap="nowrap">LPID</th>
				<th nowrap="nowrap">Total</th>
			</tr>
			<logic:iterate id="sumComponent" name="priceReport"
				property="lpidTotals">
				<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
		%>
				<td><bean:write name="sumComponent" property="key" /></td>
				<td><bean:write name="sumComponent" property="value" /></td>
				</tr>
			</logic:iterate>
		</table>
	</logic:notEmpty>
	<br>
	<br>
	<logic:equal name="priceReport" property="assumption" value="true">*Assumptions</logic:equal>
	<dl>
		<dt><logic:equal name="priceReport" property="overallOsAuthFlag"
			value="true">
			<bean:write name="priceReport" property="osAuthAssumption" />
		</logic:equal></dt>
		<dt><logic:equal name="priceReport" property="overallIbmOwnFlag"
			value="true">
			<bean:write name="priceReport" property="ibmOwnAssumption" />
		</logic:equal></dt>
		<dt><logic:equal name="priceReport" property="overallSoftwareFlag"
			value="true">
			<bean:write name="priceReport" property="softwareNameAssumption" />
		</logic:equal></dt>
		<dt><logic:equal name="priceReport" property="overallProcessorFlag"
			value="true">
			<bean:write name="priceReport" property="processorAssumption" />
		</logic:equal></dt>
		<dt><logic:equal name="priceReport" property="overallUserFlag"
			value="true">
			<bean:write name="priceReport" property="userAssumption" />
		</logic:equal></dt>
		<dt><logic:equal name="priceReport" property="priceLevelFlag"
			value="true">
			<bean:write name="priceReport" property="priceLevelAssumption" />
		</logic:equal></dt>
	</dl>

	<div class="hrule-dots"></div>

	<br>

	<h2>PO Entry Form</h2>
	<p>Use the form below to update PO numbers for the given assets. The
	individual line item PO number text fields will take precedence over
	the overall PO number. The overall PO Number cannot be blank if one or
	more of the individual PO numbers is blank. The usage date and po date
	are required fields. Once the form is submitted, an archive of the
	price report will be created in preparation for MOET creation. If you
	feel you have made a mistake, please see an administrator of the tool.</p>
	<p class="hrule-dots"></p>
	<logic:messagesPresent>
		<html:messages id="msg">
			<li class="red-dark"><bean:write name="msg" /></li>
		</html:messages>
	</logic:messagesPresent>
	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="poNumber">Overall PO number: </label></td>
			<td>
			<div class="input-note">max. 16 chars</div>
			<html:text name="priceReport" property="poNumber" size="16" />
		</tr>
		<tr>
			<td class="t1"><label for="poDate">PO acquisition date: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select name="priceReport" property="poDate">
				<html:option value=""></html:option>
				<html:option value="01/15/2012">01/15/2012</html:option>
				<html:option value="10/15/2011">10/15/2011</html:option>
				<html:option value="04/15/2011">07/15/2011</html:option>
				<html:option value="04/15/2011">04/15/2011</html:option>
				<html:option value="01/15/2011">01/15/2011</html:option>
				<html:option value="10/15/2010">10/15/2010</html:option>
				<html:option value="07/15/2010">07/15/2010</html:option>
				<html:option value="04/15/2010">04/15/2010</html:option>
				<html:option value="01/15/2010">01/15/2010</html:option>
				<html:option value="10/15/2009">10/15/2009</html:option>
				<html:option value="07/15/2009">07/15/2009</html:option>
				<html:option value="04/15/2009">04/15/2009</html:option>
				<html:option value="01/15/2009">01/15/2009</html:option>
				<html:option value="10/15/2008">10/15/2008</html:option>
				<html:option value="07/15/2008">07/15/2008</html:option>
				<html:option value="04/15/2008">04/15/2008</html:option>
				<html:option value="01/15/2008">01/15/2008</html:option>
				<html:option value="10/15/2007">10/15/2007</html:option>
				<html:option value="07/15/2007">07/15/2007</html:option>
				<html:option value="04/15/2007">04/15/2007</html:option>
				<html:option value="01/15/2007">01/15/2007</html:option>
				<html:option value="10/15/2006">10/15/2006</html:option>
				<html:option value="07/15/2006">07/15/2006</html:option>
				<html:option value="04/15/2006">04/15/2006</html:option>
				<html:option value="01/15/2006">01/15/2006</html:option>
				<html:option value="10/15/2005">10/15/2005</html:option>
				<html:option value="07/15/2005">07/15/2005</html:option>
				<html:option value="04/15/2005">04/15/2005</html:option>
				<html:option value="01/15/2005">01/15/2005</html:option>
			</html:select>
		</tr>
		<tr>
			<td class="t1"><label for="usageDate">Usage date: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select name="priceReport" property="usageDate">
				<html:option value=""></html:option>
				<html:option value="12/31/2011">12/31/2011</html:option>
				<html:option value="09/30/2011">09/30/2011</html:option>
				<html:option value="03/31/2011">06/30/2011</html:option>
				<html:option value="03/31/2011">03/31/2011</html:option>
				<html:option value="12/31/2010">12/31/2010</html:option>
				<html:option value="09/30/2010">09/30/2010</html:option>
				<html:option value="06/30/2010">06/30/2010</html:option>
				<html:option value="03/31/2010">03/31/2010</html:option>
				<html:option value="12/31/2009">12/31/2009</html:option>
				<html:option value="09/30/2009">09/30/2009</html:option>
				<html:option value="06/30/2009">06/30/2009</html:option>
				<html:option value="03/31/2009">03/31/2009</html:option>
				<html:option value="12/31/2008">12/31/2008</html:option>
				<html:option value="09/30/2008">09/30/2008</html:option>
				<html:option value="06/30/2008">06/30/2008</html:option>
				<html:option value="03/31/2008">03/31/2008</html:option>
				<html:option value="12/31/2007">12/31/2007</html:option>
				<html:option value="09/30/2007">09/30/2007</html:option>
				<html:option value="06/30/2007">06/30/2007</html:option>
				<html:option value="03/31/2007">03/31/2007</html:option>
				<html:option value="12/31/2006">12/31/2006</html:option>
				<html:option value="09/30/2006">09/30/2006</html:option>
				<html:option value="06/30/2006">06/30/2006</html:option>
				<html:option value="03/31/2006">03/31/2006</html:option>
				<html:option value="12/31/2005">12/31/2005</html:option>
				<html:option value="09/30/2005">09/30/2005</html:option>
				<html:option value="06/30/2005">06/30/2005</html:option>
				<html:option value="03/31/2005">03/31/2005</html:option>
			</html:select>
		</tr>
	</table>

	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top:2em;">
		<tr class="tablefont">
			<th colspan="19" style="white-space:nowrap; background-color:#bd6;">Details</th>
		</tr>
		<tr style="background-color:#dfb;" class="tablefont">
			<th nowrap="nowrap">PO Number</th>
			<th nowrap="nowrap">LPID</th>
			<th nowrap="nowrap">Country</th>
			<th nowrap="nowrap">Hostname</th>
			<th nowrap="nowrap">Serial Number</th>
			<th nowrap="nowrap">Machine Type</th>
			<th nowrap="nowrap">Machine Model</th>
			<th nowrap="nowrap">Scan Date</th>
			<th nowrap="nowrap">Hardware Owner</th>
			<th nowrap="nowrap">Software Owner</th>
			<th nowrap="nowrap">Processor Count</th>
			<th nowrap="nowrap">User Count</th>
			<th nowrap="nowrap">Authenticated</th>
			<th nowrap="nowrap">SKU</th>
			<th nowrap="nowrap">License Type</th>
			<th nowrap="nowrap">Software Name</th>
			<th nowrap="nowrap">Agreement Type</th>
			<th nowrap="nowrap">SPLA Quarterly Price</th>
			<th nowrap="nowrap">ESPLA Yearly Price</th>
		</tr>
		<%alternate = true;
		%>
		<logic:iterate id="priceReportArchive" name="priceReport"
			property="details" indexId="index">
			<%alternate = alternate ? false : true;
		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>

			<td><html:text name="priceReportArchive" property="poNumber"
				indexed="true"></html:text>
			<td><bean:write name="priceReportArchive" property="lpid" /></td>
			<td><bean:write name="priceReportArchive" property="country" /></td>
			<td><bean:write name="priceReportArchive" property="nodeName" /></td>
			<td><bean:write name="priceReportArchive" property="serialNumber" /></td>
			<td><bean:write name="priceReportArchive" property="machineType" /></td>
			<td><bean:write name="priceReportArchive" property="machineModel" /></td>
			<td><bean:write name="priceReportArchive" property="scanDate" /></td>
			<td><bean:write name="priceReportArchive" property="nodeOwner" /></td>
			<td><bean:write name="priceReportArchive" property="softwareOwner" /></td>
			<td><bean:write name="priceReportArchive" property="processorCount" /></td>
			<td><bean:write name="priceReportArchive" property="userCount" /></td>
			<td><bean:write name="priceReportArchive" property="authenticated" /></td>
			<td><bean:write name="priceReportArchive" property="sku" /></td>
			<td><bean:write name="priceReportArchive" property="licenseType" /></td>
			<td><bean:write name="priceReportArchive"
				property="productDescription" /></td>
			<td><bean:write name="priceReportArchive"
				property="licenseAgreementType" /></td>
			<td><bean:write name="priceReportArchive"
				property="splaQuarterlyPrice" /></td>
			<td><bean:write name="priceReportArchive" property="esplaYearlyPrice" /></td>

		</logic:iterate>
		<tr style="font-size:8pt">
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<th style="white-space:nowrap; background-color:#bd6;">Totals</th>
			<th style="white-space:nowrap; background-color:#bd6;"><bean:write
				name="priceReport" property="totalSplaPrice" /></th>
			<th style="white-space:nowrap; background-color:#bd6;"><bean:write
				name="priceReport" property="totalEsplaPrice" /></th>
		</tr>
	</table>
	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>
</html:form>
</div>
</div>

<!-- start related links -->
<!-- stop related links -->
</div>
