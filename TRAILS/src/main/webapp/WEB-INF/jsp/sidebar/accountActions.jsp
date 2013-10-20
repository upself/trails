<%@taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sx" uri="/struts-dojo-tags"%>
<sx:head />
<s:url id="alertUrl" namespace="/account/alert" action="summary" />
<div class="callout">
	<h2 class="bar-green-med-light">
		<span class="style3">Account alerts</span>
	</h2>
	<sx:div href="%{#alertUrl}?type=ALERT" cssClass="table-wrap"
		delay="200" loadingText="Loading..." showLoadingText="true">
	</sx:div>
	<br /> <br />
	<h2 class="bar-green-med-light">
		<span class="style3">Account exceptions</span>
	</h2>
    Please use data exception reports on the left navigation
	<!--<sx:div href="%{#alertUrl}?type=DATA_EXCEPTION" cssClass="table-wrap" delay="200" loadingText="Loading..." showLoadingText="true"> 
</sx:div>  -->
	<br /> <br />
</div>
<br />
<br />

<h2 class="bar-green-med-light">
	<span class="style3">Account reports</span>
</h2>
<s:a
	href="/TRAILS/report/download/freeLicensePool%{#attr.account.account}.tsv?name=freeLicensePool"
	cssClass="download-link">Free license pool</s:a>
<s:a
	href="/TRAILS/report/download/hardwareBaseline%{#attr.account.account}.tsv?name=hardwareBaseline"
	cssClass="download-link">Hardware baseline</s:a>
<s:a
	href="/TRAILS/report/download/reconciliationSummary%{#attr.account.account}.tsv?name=reconciliationSummary"
	cssClass="download-link">Reconciliation summary</s:a>
<s:a
	href="/TRAILS/report/download/softwareLparBaseline%{#attr.account.account}.tsv?name=softwareLparBaseline"
	cssClass="download-link">Software LPAR baseline</s:a>
<s:include value="/WEB-INF/jsp/include/reportModule.jsp" />
</div>