<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<%boolean alternate = true;%>

<html:form action="/ApprovePriceReport">

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
							out
									.println("<tr class=\"gray\" style=\"font-size:8pt\">");
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

	<br>

	<logic:equal name="priceReport" property="pod" value="Q0XF">
		<h2>LPID entry form/approval form</h2>
		<p>Use the form below to update the LPID for the given assets. The
		individual line item LPID text fields will take precedence over the
		overall LPID. The overall LPID cannot be blank if one or more of the
		individual LPIDs is blank. Once the form is submitted, this price
		report will be marked as approved and an archive of the price report
		will be created in preparation for the asset team to fill in PO
		numbers. If you feel you have made a mistake, please see an
		administrator of the tool. Please Note: For Webhosting accounts, all
		OS charges will be directed to the pool LPID regardless of the overall
		LPID shown. Your signoff indicates that you agree that all charges are
		correct and that OS SW will be charged to the pool and non OS SW will
		be paid by the LPID you select.</p>
	</logic:equal>
	<logic:notEqual name="priceReport" property="pod" value="Q0XF">
		<h2>LPID entry form/approval form</h2>
		<p>Use the form below to update the LPID for the given assets. The
		individual line item LPID text fields will take precedence over the
		overall LPID. The overall LPID cannot be blank if one or more of the
		individual LPIDs is blank. Once the form is submitted, this price
		report will be marked as approved and an archive of the price report
		will be created in preparation for the asset team to fill in PO
		numbers. If you feel you have made a mistake, please see an
		administrator of the tool.</p>
	</logic:notEqual>
	<p class="hrule-dots"></p>

	<bean:define id="lpids" name="priceReport" property="lpids" />
	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="lpid">Overall LPID: </label></td>
			<td>
			<div class="input-note">Select one</div>
			<html:select name="priceReport" property="lpid">
				<html:option value=""></html:option>
				<html:options collection="lpids" property="value"
					labelProperty="label" />
			</html:select></td>
		</tr>
	</table>

	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top:2em;">
		<tr class="tablefont">
			<th colspan="18" style="white-space:nowrap; background-color:#bd6;">Details</th>
		</tr>
		<tr style="background-color:#dfb;" class="tablefont">
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
		<logic:iterate id="priceReportDetail" name="priceReport"
			property="details" indexId="index">
			<%alternate = alternate ? false : true;
					if (alternate) {
						out
								.println("<tr class=\"gray\" style=\"font-size:8pt\">");
					} else {
						out.println("<tr style=\"font-size:8pt\">");
					}

					%>

			<td><html:select name="priceReportDetail" property="lpid"
				indexed="true">
				<html:option value=""></html:option>
				<html:options collection="lpids" property="value"
					labelProperty="label" />
			</html:select>
			<td><bean:write name="priceReportDetail" property="country" /></td>
			<td><bean:write name="priceReportDetail" property="nodeName" /></td>
			<td><bean:write name="priceReportDetail" property="serialNumber" /></td>
			<td><bean:write name="priceReportDetail" property="machineType" /></td>
			<td><bean:write name="priceReportDetail" property="machineModel" /></td>
			<td><bean:write name="priceReportDetail" property="scanDate" /></td>
			<td><bean:write name="priceReportDetail" property="nodeOwner" /></td>
			<td><bean:write name="priceReportDetail" property="softwareOwnerFlag" /><bean:write
				name="priceReportDetail" property="softwareOwner" /></td>
			<td><bean:write name="priceReportDetail" property="processorFlag" /><bean:write
				name="priceReportDetail" property="processorCount" /></td>
			<td><bean:write name="priceReportDetail" property="userFlag" /><bean:write
				name="priceReportDetail" property="userCount" /></td>
			<td><bean:write name="priceReportDetail" property="authenticatedFlag" /><bean:write
				name="priceReportDetail" property="authenticated" /></td>
			<td><bean:write name="priceReportDetail" property="sku" /></td>
			<td><bean:write name="priceReportDetail" property="licenseType" /></td>
			<td><bean:write name="priceReportDetail" property="noOsFlag" /><bean:write
				name="priceReportDetail" property="productDescription" /></td>
			<td><bean:write name="priceReportDetail"
				property="licenseAgreementTypeFlag" /><bean:write
				name="priceReportDetail" property="licenseAgreementType" /></td>
			<td><bean:write name="priceReportDetail"
				property="splaQuarterlyPrice" /></td>
			<td><bean:write name="priceReportDetail" property="esplaYearlyPrice" /></td>

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
	<div class="clear"></div>
	<div class="button-bar">
		<div class="buttons">
			<span class="button-blue"><html:submit property="Lock" value="Lock">Lock</html:submit></span>
			<span class="button-blue"><html:submit property="Approve" value="Approve">Approve</html:submit></span>
			<span class="button-blue"><html:submit property="Reject" value="Reject">Reject</html:submit></span>
			<span class="button-blue"><html:cancel>Cancel</html:cancel></span>
		</div>
	</div>
</html:form>
</div>
</div>

<!-- start related links -->
<!-- stop related links -->
</div>
