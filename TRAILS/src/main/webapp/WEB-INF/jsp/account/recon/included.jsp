<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Reconcile workspace: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>

<h2>Action: Included with other product</h2>
<br />
<p>Choose which component to use as the parent component for the Included with other product reconciliation action. 
The list of available components is filtered to only show components which match the Schedule F scope of the selected alert. 
When you are finished, click on the "Next" button to be taken to a confirmation page. 
Click on cancel to return to the workspace.</p>
<br />
<div class="hrule-dots"></div>
<br />
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<s:form action="showIncludedConfirmation" namespace="/account/recon"
	theme="simple">
	<div class="float-left" style="width:25%;"><label for="runon">Product:</label></div>
	<div class="float-left" style="width:75%;"><s:select
		name="installedSoftwareId" label="Software"
		list="recon.installedSoftwareList" listKey="id"
		listValue="software.softwareName" /></div>
		
	<div class="float-left" style="width:25%; margin-top:5px;"><label for="automated">Comments:</label></div>
	
	<div class="float-left" style="width:75%; margin-top:5px;"><s:textarea rows="4" cols="63" name="comments" id="comments" wrap="virtual" /></div>

	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"> <s:submit
		value="Next" /><s:submit method="cancel" value="Cancel" /> </span></div>
	</div>
</s:form>

<div class="clear"></div>
<div class="hrule-dots"></div>
<div class="clear"></div>
<small> <display:table name="list" class="basic-table" summary="inclued list"
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
