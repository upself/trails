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


<div style="padding-left: 10px; width: 100%">
Hello
 <s:url id="alertUrl" namespace="/account/alert" action="summary" />
	<h2 style="background-color: #d7d7d8">
		<label style="padding-left: 15px" >Account alerts</label>
	</h2>		
<!-- 		<div id="alertSummary" class="table-wrap">Loading...</div> -->
<!-- 		<br /> <br /> -->
<!-- 		<h2 class="bar-green-med-light"> -->
<%--  			<span class="style3">Account exceptions</span> --%>
<!-- 		</h2> -->
<!-- 		Please use data exception reports on the left navigation -->
<!-- 		<br /> <br /> -->


<!--  	<br /> <br />  -->
<!--  	<h2 class="bar-green-med-light">  -->
<%--  			<span class="style3">Account reports</span>  --%>
<!--  	</h2>  -->
<%--  		<s:a  --%>
<%--  			href="/TRAILS/report/download/freeLicensePool%{#attr.account.account}.tsv?name=freeLicensePool"  --%>
<%--  			cssClass="download-link">Free license pool</s:a>  --%>
<%--  		<s:a  --%>
<%--  			href="/TRAILS/report/download/hardwareBaseline%{#attr.account.account}.tsv?name=hardwareBaseline"  --%>
<%--  			cssClass="download-link">Hardware baseline</s:a>  --%>
<%--  		<s:a  --%>
<%--  			href="/TRAILS/report/download/reconciliationSummary%{#attr.account.account}.tsv?name=reconciliationSummary"  --%>
<%--  			cssClass="download-link">Reconciliation summary</s:a>  --%>
<%--  		<s:a  --%>
<%--  			href="/TRAILS/report/download/softwareLparBaseline%{#attr.account.account}.tsv?name=softwareLparBaseline"  --%>
<%--  			cssClass="download-link">Software LPAR baseline</s:a>  --%>
<%--  		<s:include value="/WEB-INF/jsp/include/reportModule.jsp" /> --%>
</div>