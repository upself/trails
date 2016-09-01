<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<div class="ibm-columns" style="width:95%">
	<div class="ibm-col-1-1">
		<div id="fourth-level">
			<h1>Reconcile details</h1>
			<p class="ibm-important">IBM Confidential</p>
		</div>
	</div>
</div>
<div class="ibm-columns" style="width:95%">
	<div class="ibm-col-1-1">
	<h2>&nbsp;</h2>
		<p class="lead-in">Reconcile details</p>
		<h3>&nbsp;</h3>
		<table class="ibm-data-table" cellspacing="1" cellpadding="0" summary="TRAILS reconciliation detail">
			<tr>
				<td>Hostname:</td>
				<td><s:property
					value="reconcile.installedSoftware.softwareLpar.hardwareLpar.name" /></td>
			</tr>
			<tr>
				<td>Asset type:</td>
				<td><s:property
					value="reconcile.installedSoftware.softwareLpar.hardwareLpar.hardware.machineType.type" /></td>
			</tr>
			<tr>
				<td>Hardware processor count:</td>
				<td><s:property
					value="reconcile.installedSoftware.softwareLpar.hardwareLpar.hardware.processorCount" /></td>
			</tr>
			<tr>
				<td>Processor count:</td>
				<td><s:property
					value="reconcile.installedSoftware.softwareLpar.processorCount" /></td>
			</tr>
			<tr>
				<td>Installed product name:</td>
				<td><s:property
					value="reconcile.installedSoftware.software.softwareName" /></td>
			</tr>
			<tr>
				<td>Action performed:</td>
				<td><s:property value="reconcile.reconcileType.name" /></td>
			</tr>
			<tr>
				<td>Machine level:</td>
				<td><s:property value="reconcile.machineLevelAsString" /></td>
			</tr>
			<tr>
				<td>Recon user:</td>
				<td><s:property value="reconcile.remoteUser" /></td>
			</tr>
			<tr>
				<td>Recon date/time:</td>
				<td><s:date name="reconcile.recordTime" format="MM-dd-yyyy" /></td>
			</tr>
			<tr>
				<td>Covered by:</td>
				<td><s:property
					value="reconcile.parentInstalledSoftware.software.softwareName" /></td>
			</tr>
			<tr>
				<td>Comment:</td>
				<td><s:property value="reconcile.comments" /></td>
			</tr>
		</table>

<br />
<display:table name="reconcile.usedLicenses" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" 
	summary="used Licenses" id="row" cellspacing="1" cellpadding="0">
	<display:column property="license.productName" title="Product name" />
	<display:column property="license.fullDesc" title="License full description" />
	<display:column property="license.version" title="Version" />
	<display:column property="license.capacityType.description" title="Capacity type" />
	<display:column property="usedQuantity" title="Used quantity" />
	<display:column property="license.expireDate" title="Expiration date" class="date" format="{0,date,MM-dd-yyyy}" />
	<display:column property="license.poNumber" title="PO number" />
	<display:column property="license.cpuSerial" title="Serial number" />
	<display:column property="license.ibmOwned" title="IBM owned license" />
	<display:column property="license.extSrcId" title="SWCM ID" />
	<display:column property="license.sku" title="SKU" />
	<display:column property="license.recordTime" title="Record time" />
</display:table>
	</div>
</div>

<p class="note">&nbsp;</p>
