<%@ taglib prefix="s" uri="/struts-tags"%>
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<h6>IBM Confidential</h6>
	</div>
	<br /><br /><br />
	<div class="ibm-col-1-1">
		<h6>Alert reports</h6>
		<ul class="ibm-link-list">
			<li>
				<a class="ibm-download-link" href="/TRAILS/reports/alertRedAging/accountDetail.htm?d-49653-e=2&6578706f7274=1&accountId=${account.id}">Aging red alerts</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/reports/operational/accountDetailDownload.htm?d-49653-e=2&6578706f7274=1&accountId=${account.id}">Operational metrics</a>
			</li>
		</ul>
		<!-- Alert reports end -->
		
		<div class="ibm-rule"></div>
		<h6>Data Exception Reports</h6>
		<ul class="ibm-link-list" id="dataException">
			<li id="loading">Loading...</li>
		</ul>
		<!-- Alert reports end -->
		
		<div class="ibm-rule"></div>
		<h6>SOM reports</h6>
		<ul class="ibm-link-list">
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertHardware/download/${account.id}">SOM1a: HW WITH HOSTNAME</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertHardwareCfgData/download/${account.id}">SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertHardwareLpar/download/${account.id}">SOM2a: HW LPAR WITH SW LPAR</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertSwLparWithHwLpar/download/${account.id}">SOM2b: SW LPAR WITH HW LPAR</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertUnExpiredSWLpar/download/${account.id}">SOM2c: UNEXPIRED SW LPAR</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertWithDefinedContractScope/download/${account.id}">SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertIbmSwInstancesReviewed/download/${account.id}">SOM4a: IBM SW INSTANCES REVIEWED</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertPriorityIsvSwInstancesReviewed/download/${account.id}">SOM4b: PRIORITY ISV SW INSTANCES REVIEWED</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/ws/alertIsvSwInstancesReviewed/download/${account.id}">SOM4c: ISV SW INSTANCES REVIEWED</a>
			</li>
		</ul>
		<!-- SOM reports end -->
		
		<div class="ibm-rule"></div>
		<h6>Miscellaneous reports</h6>
		<ul class="ibm-link-list">
			<li>
				<a class="ibm-download-link" href="/TRAILS/report/download/casueCodeSummary${account.account}.tsv?name=casueCodeSummary">Cause code summary report</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/report/download/softwareVariance${account.account}.tsv?name=softwareVariance">Contract scope to scanned component variance</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/report/download/freeLicensePool${account.account}.tsv?name=freeLicensePool">Free license pool</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/report/download/hardwareBaseline${account.account}.tsv?name=hardwareBaseline">Hardware baseline</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/report/download/reconciliationSummary${account.account}.tsv?name=reconciliationSummary">Reconciliation summary</a>
			</li>
			<li>
				<a class="ibm-download-link" href="/TRAILS/report/download/softwareLparBaseline${account.account}.tsv?name=softwareLparBaseline">Software LPAR baseline</a>
			</li>
		</ul>
		<!-- Miscellaneous reports end -->
		
		<div class="ibm-rule"></div>
		<s:include value="/WEB-INF/jsp/include/v17eReportModule.jsp" />
	</div>
</div>
<script>
$(function(){
	$("#titleContent").text($("#titleContent").text() + ": ${account.name}(${account.account})");
	initDataExceptionReport();
});

function initDataExceptionReport(){
	$.get("${pageContext.request.contextPath}/account/alert/alertList.htm?type=DATA_EXCEPTION",function(data){
		var $html = $(data);
		var dataExceptionHtml = '';
		$('#loading').hide();
		$html.find("a").each(function(){
			var li = $('<li></li>')
			var alink = $(this).addClass('ibm-download-link');
			
			li.append(alink);
			$('#dataException').append(li);
		});
	})
}
</script>

