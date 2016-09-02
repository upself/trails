<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Reconcile workspace: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>

<h2>Action: Customer owned and customer managed</h2>
<br />
<p>Please confirm your action below and hit the confirm button to
execute your request against the database. If you selected to run on
something other than "SELECTED", your action will run on all of those
assets with installed software matching those listed.  Due to the potential volume
of updates in the request, it may take more than a few minutes. Please
do not close your browser or navigate to another url while the process
is completing. You will be presented with your initial workspace once
the request has completed.</p>
<br />
<div class="hrule-dots"></div>
<br />

<s:form action="applyManualRecon" namespace="/account/recon"
	theme="simple">
	<div class="float-left" style="width:25%;"><label for="runon">Run
	on:</label></div>
	<div class="float-left" style="width:75%;"><s:property
		value="runon" /></div>

	<div class="float-left" style="width:25%;"><label for="automated">Overwrite
	automated reconciliations:</label></div>
	<div class="float-left" style="width:75%;"><s:property
		value="automated" /></div>

	<div class="float-left" style="width:25%;"><label for="automated">Overwrite
	manual reconciliations:</label></div>
	<div class="float-left" style="width:75%;"><s:property
		value="manual" /></div>

	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"> <s:submit
		value="Confirm" /><s:submit method="cancel" value="Cancel" /> </span></div>
	</div>
</s:form>
<div class="clear"></div>
<div class="hrule-dots"></div>
<div class="clear"></div>
<small> <display:table name="data.list" class="basic-table" summary="Cusotmer Owned Confirmation"
	id="row" cellspacing="1" cellpadding="0">
	<display:column property="alertStatus" title="" />
	<display:column property="alertAgeI" title="Age" />
	<display:column property="hostname" title="Hostname" />
	<display:column property="serial" title="Serial" />
	<display:column property="country" title="Country" />
	<display:column property="owner" title="Owner" />
	<display:column property="assetType" title="Asset type" />
	<display:column property="processorCount" title="Processor count" />
	<display:column property="hardwareStatus" title="Hardware Status" />
	<display:column property="lparStatus" title="Lpar Status" />
	<display:column property="productInfoName" title="Software name" />
	<display:column property="reconcileTypeName" title="Reconcile type" />
	<display:column property="assignee" title="Assignee" />
</display:table> </small>