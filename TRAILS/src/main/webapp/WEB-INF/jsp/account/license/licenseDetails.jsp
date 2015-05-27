<%@ taglib prefix="s" uri="/struts-tags"%>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h1>License details: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<br />
<br />

<h2 class="bar-blue-med-light">License details</h2>
<table cellspacing="0" cellpadding="0" class="basic-table">
	<tr>
		<td><span class="caption">Primary component</span></td>
		<td><s:property value="license.productName" /></td>
	</tr>
	<tr>
		<td><span class="caption">Catalog match</span></td>
		<td><s:property value="license.catalogMatch" /></td>
	</tr>
	<tr>
		<td><span class="caption">License name</span></td>
		<td><s:property value="license.fullDesc" /></td>
	</tr>
	<tr>
		<td><span class="caption">Software product PID</span></td>
		<td><s:property value="license.pId" /></td>
	</tr>
	<tr>
		<td><span class="caption">Capacity type</span></td>
		<td><s:property value="license.capacityType.code" /> - <s:property value="license.capacityType.description" /></td>
	</tr>
	<tr>
		<td><span class="caption">Total qty</span></td>
		<td><s:property value="license.quantity" /></td>
	</tr>
	<tr>
		<td><span class="caption">Available qty</span></td>
		<td><s:property value="license.availableQty" /></td>
	</tr>
	<tr>
		<td><span class="caption">Expiration date</span></td>
		<td><s:date name="license.expireDate" format="MM-dd-yyyy" /></td>
	</tr>
	<tr>
		<td><span class="caption">PO number</span></td>
		<td><s:property value="license.poNumber" /></td>
	</tr>
	<tr>
		<td><span class="caption">Serial number</span></td>
		<td><s:property value="license.cpuSerial" /></td>
	</tr>
	<tr>
		<td><span class="caption">License owner</span></td>
		<td>
			<s:if test="license.ibmOwned == true">IBM</s:if>
			<s:else>Customer</s:else>
		</td>
	</tr>
	<tr>
		<td><span class="caption">Pool</span></td>
		<td><s:property value="license.poolAsString" /></td>
	</tr>
	<tr>
		<td><span class="caption">SWCM ID</span></td>
		<td><s:property value="license.extSrcId" /></td>
	</tr>
	<tr>
		<td><span class="caption">Record date/time</span></td>
		<td><s:date name="license.recordTime" format="MM-dd-yyyy HH:mm:ss" /></td>
	</tr>
</table>
