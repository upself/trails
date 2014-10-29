<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="workspaceLink" action="workspace" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>

<h1>Reconciliation workspace settings</h1>
<h2>Confirm reconciliation workspace settings</h2>
<br />
<p>Reconciliation workspace settings sucessfully updated. Use the
navigation on the left to proceed to the workspace or click <s:a
	href="%{workspaceLink}">here</s:a>.</p>
<br />
<div class="hrule-dots"></div>

<p class="sub-title">Reconciliation settings</p>

<div class="float-left" style="width:30%;"><label
	for="reconcileType">Reconcile type:</label></div>
<div class="float-left" style="width:70%;"><s:property
	value="reconcileTypeName" /></div>

<div class="clear"></div>
<div class="hrule-dots"></div>

<p class="sub-title">Alert settings</p>

<div class="float-left" style="width:30%;"><label
	for="alertStatus">Alert status:</label></div>
<div class="float-left" style="width:70%;"><s:property
	value="reconSetting.alertStatus" /></div>
<br />
<br />
<div class="float-left" style="width:30%;"><label for="alertColor">Alert
color:</label></div>
<div class="float-left" style="width:70%;"><s:property
	value="reconSetting.alertColor" /></div>
<br />
<br />
<div class="float-left" style="width:30%;"><label for="assigned">Assignment</label></div>
<div class="float-left" style="width:70%;"><s:property
	value="reconSetting.assigned" /></div>
<br />
<br />
<div class="float-left" style="width:30%;"><label for="assignee">Assignee:</label></div>
<div class="float-left" style="width:70%;"><s:property
	value="reconSetting.assignee" /></div>

<div class="clear"></div>
<div class="hrule-dots"></div>

<p class="sub-title">Hardware settings</p>

<div class="float-left" style="width:30%;"><label for="hostname">Owner:</label></div>
<div class="float-left" style="width:70%;"><s:property
	value="reconSetting.owner" /></div>
<br />
<br />
<div class="float-left" style="width:30%;"><label for="countries">Country(s):</label></div>
<div class="float-left" style="width:70%;"><s:iterator
	value="reconSetting.countries">
	<s:property />
</s:iterator></div>
<br />
<br />
<div class="float-left" style="width:30%;"><label for="hostname">Hostname(s):</label></div>
<div class="float-left" style="width:70%;"><s:iterator
	value="reconSetting.names">
	<s:property />
</s:iterator></div>
<br />
<br />
<div class="float-left" style="width:30%;"><label for="products">Serial
number(s):</label></div>
<div class="float-left" style="width:70%;"><s:iterator
	value="reconSetting.serialNumbers">
	<s:property />
</s:iterator></div>

<div class="clear"></div>
<div class="hrule-dots"></div>

<p class="sub-title">Software settings</p>

<div class="float-left" style="width:30%;"><label for="products">Product(s):</label></div>
<div class="float-left" style="width:70%;"><s:iterator
	value="reconSetting.productInfoNames">
	<s:property />
</s:iterator></div>
