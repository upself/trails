<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sx" uri="/struts-dojo-tags"%>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h1>Reports listing: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<br />
<br />

<h2 class="bar-blue-med-light">Alert reports</h2><br />
<span class="download-link">
	<a href="/TRAILS/reports/alertRedAging/accountDetail.htm?d-49653-e=2&6578706f7274=1&accountId=<s:property value="%{#attr.account.id}" />">Aging red alerts</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/alertHardware<s:property value="%{#attr.account.account}" />.xls?name=alertHardware">HW w/o HW LPAR alert</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/alertHardwareLpar<s:property value="%{#attr.account.account}" />.xls?name=alertHardwareLpar">HW LPAR w/o SW LPAR alert</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/alertSoftwareLpar<s:property value="%{#attr.account.account}" />.xls?name=alertSoftwareLpar">SW LPAR w/o HW LPAR alert</a>
</span>
<span class="download-link">
	<a href="/TRAILS/reports/operational/accountDetailDownload.htm?d-49653-e=2&6578706f7274=1&accountId=<s:property value="%{#attr.account.id}" />">Operational metrics</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/alertExpiredScan<s:property value="%{#attr.account.account}" />.xls?name=alertExpiredScan">Outdated SW LPAR alert</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/pendingCustomerDecisionDetail<s:property value="%{#attr.account.account}" />.tsv?name=pendingCustomerDecisionDetail">Pending customer decision reconciled detail alert</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/pendingCustomerDecisionSummary<s:property value="%{#attr.account.account}" />.tsv?name=pendingCustomerDecisionSummary">Pending customer decision reconciled summary alert</a>
</span>


<h2 class="bar-blue-med-light">Data Exception Reports</h2><br />
<sx:head />
<s:url id="alertUrl" namespace="/account/alert" action="alertList"/>
<div class="callout">
<sx:div href="%{#alertUrl}?type=DATA_EXCEPTION" cssClass="table-wrap" delay="200" loadingText="Loading..." showLoadingText="true"> 
</sx:div>
</div>

<h2 class="bar-blue-med-light">SOM reports</h2><br />
<span class="download-link">
	<a href="/TRAILS/ws/alertHardwareCfgData/download/<s:property value="%{#attr.account.id}" />">SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED</a>
</span>
<span class="download-link">
	<a href="/TRAILS/ws/alertWithDefinedContractScope/download/<s:property value="%{#attr.account.id}" />">SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE</a>
</span>
<span class="download-link">
	<a href="/TRAILS/ws/alertIbmSwInstancesReviewed/download/<s:property value="%{#attr.account.id}" />">SOM4a: IBM SW INSTANCES REVIEWED</a>
</span>
<span class="download-link">
	<a href="/TRAILS/ws/alertPriorityIsvSwInstancesReviewed/download/<s:property value="%{#attr.account.id}" />">SOM4b: PRIORITY ISV SW INSTANCES REVIEWED</a>
</span>
<span class="download-link">
	<a href="/TRAILS/ws/alertIsvSwInstancesReviewed/download/<s:property value="%{#attr.account.id}" />">SOM4c: ISV SW INSTANCES REVIEWED</a>
</span>


<h2 class="bar-blue-med-light">Miscellaneous reports</h2><br />
<span class="download-link">
	<a href="/TRAILS/report/download/casueCodeSummary<s:property value="%{#attr.account.account}" />.tsv?name=casueCodeSummary">Cause code summary report</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/softwareVariance<s:property value="%{#attr.account.account}" />.tsv?name=softwareVariance">Contract scope to installed software variance</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/freeLicensePool<s:property value="%{#attr.account.account}" />.tsv?name=freeLicensePool">Free license pool</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/hardwareBaseline<s:property value="%{#attr.account.account}" />.tsv?name=hardwareBaseline">Hardware baseline</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/reconciliationSummary<s:property value="%{#attr.account.account}" />.tsv?name=reconciliationSummary">Reconciliation summary</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/softwareLparBaseline<s:property value="%{#attr.account.account}" />.tsv?name=softwareLparBaseline">Software LPAR baseline</a>
</span>

<s:include value="/WEB-INF/jsp/include/reportModule.jsp" />
