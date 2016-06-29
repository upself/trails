<%@taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>

<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$("#alertSummary")
								.load(
										"${pageContext.request.contextPath}/account/alert/summary.htm?type=ALERT");
					});
</script>


<div style="padding-left: 15px; width: 100%">
	<s:url id="alertUrl" namespace="/account/alert" action="summary" />
	<h2 style="background-color: #d7d7d8">
		<label style="padding-left: 10px">Account alerts</label>
	</h2>
	<div id="alertSummary" class="table-wrap" style="padding-top: 10px">Loading...</div>
	<br />
	
	<h2 style="background-color: #d7d7d8">
		<label style="padding-left: 10px">Account reports</label>
	</h2>
	<ul class="ibm-link-list">
		<li><a
			href="/TRAILS/report/download/freeLicensePool${account.account}.tsv?name=freeLicensePool">Free
				license pool</a></li>
		<li><a
			href="/TRAILS/report/download/hardwareBaseline${account.account}.tsv?name=hardwareBaseline">Hardware
				baseline</a></li>
		<li><a
			href="/TRAILS/report/download/reconciliationSummary${account.account}.tsv?name=reconciliationSummary">Reconciliation
				summary</a></li>
		<li><a
			href="/TRAILS/report/download/softwareLparBaseline${account.account}.tsv?name=softwareLparBaseline">Software
				LPAR baseline</a></li>
	</ul>
	<s:include value="/WEB-INF/jsp/include/reportModule.jsp" />
</div>