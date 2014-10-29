<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<%boolean alternate = true;%>

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
			<th colspan="8" style="white-space:nowrap; background-color:#bd6;">Product
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

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">
	<tr class="tablefont">
		<th colspan="18" style="white-space:nowrap; background-color:#bd6;">Details</th>
	</tr>
	<tr style="background-color:#dfb;" class="tablefont">
		<th nowrap="nowrap">PO Number</th>
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

		<td><bean:write name="priceReportArchive" property="poNumber" /></td>
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
		<th style="white-space:nowrap; background-color:#bd6;">Totals</th>
		<th style="white-space:nowrap; background-color:#bd6;"><bean:write
			name="priceReport" property="totalSplaPrice" /></th>
		<th style="white-space:nowrap; background-color:#bd6;"><bean:write
			name="priceReport" property="totalEsplaPrice" /></th>
	</tr>
</table>

</div>

<!-- start related links -->
<!-- stop related links -->
</div>
