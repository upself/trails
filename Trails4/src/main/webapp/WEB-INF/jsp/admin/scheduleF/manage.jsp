<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<h1 class="oneline">Manage</h1><div style="font-size:22px; display:inline">&nbsp;Schedule F: <s:property value="account.name" />(<s:property
	value="account.account" />)</div>
<p class="confidential">IBM Confidential</p>
<br />

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h2 class="bar-blue-med-light">Schedule F details</h2>
<br />
<s:form action="save" method="post" namespace="/admin/scheduleF" theme="simple">
	<div class="float-left" style="width:30%;">Account:</div>
	<div class="float-left" style="width:70%;">
		<s:property value="account.name" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="softwareTitle">Software title:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="softwareTitle" name="scheduleFForm.softwareTitle"
			required="true" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="softwareName">Software name:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="softwareName" name="scheduleFForm.softwareName"
			required="true" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="manufacturer">Manufacturer:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="manufacturer" name="scheduleFForm.manufacturer"
			required="true" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="scopeArrayList">Scope:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="scopeArrayList" list="scopeArrayList" listKey="id"
			listValue="description" name="scheduleFForm.scopeId" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="complianceReporting">Compliance reporting:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:text name="account.softwareComplianceManagement" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="sourceArrayList">Source:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="sourceArrayList" list="sourceArrayList" listKey="id"
			listValue="description" name="scheduleFForm.sourceId" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="sourceLocation">Source location:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="sourceLocation" name="scheduleFForm.sourceLocation"
			required="true" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="statusArrayList">Status:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="statusArrayList" list="statusArrayList" listKey="id"
			listValue="description" name="scheduleFForm.statusId" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="businessJustification">Business justification:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="businessJustification"
			name="scheduleFForm.businessJustification" required="true" />
	</div>
	<div class="button-bar">
		<div class="buttons"><span class="button-blue">
			<s:submit value="Save" method="doSave" />
			<s:submit value="Cancel" method="doCancel" />
		</span></div>
	</div>
</s:form>
<br />
<br />
<display:table name="scheduleF.scheduleFHList" class="basic-table" id="row" summary="Schedule F list"
	decorator="org.displaytag.decorator.TotalTableDecorator" cellspacing="1"
	cellpadding="0">
	<display:column property="softwareName" title="Software name" />
	<display:column property="softwareTitle" title="Software title" />
	<display:column property="manufacturer" title="Manufacturer" />
	<display:column property="scope.description"  title="Scope" />
	<display:column property="source.description"  title="Source" />
	<display:column property="sourceLocation" title="Source location" />
	<display:column property="status.description" title="Status" />
	<display:column property="businessJustification"
		title="Business justification" />
	<display:column property="remoteUser" title="Status" />
	<display:column property="recordTime" class="date"
		format="{0,date,MM-dd-yyyy}" title="Status" />
</display:table>
