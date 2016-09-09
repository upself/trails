<%@taglib prefix="s" uri="/struts-tags"%>
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>

<script type="text/javascript">
$(function(){
	loadAccountAlertSummary();
});

 function loadAccountAlertSummary(){
	 var params = {};
	 params['accountId'] = '${account.id}';
	 params['alertType'] = 'ALERT';
	 
	
	$.ajax({
		url : '${pageContext.request.contextPath}/ws/alert/account/summary',
		type : 'POST',
		dataType : 'json',
		data : params,
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			console.log(textStatus);
		},
		success : function(data) {
			var html = "";

			html += "<table cellspacing='0' cellpadding='0' class='ibm-data-table ibm-alternating'>";

			if (data.msg != "SUCCESS") {
				html += "<tr><td>There is no alert.</tr></td>";
			} else {
				for (var i = 0; i < data.dataList.length; i++) {
					var item = data.dataList[i];
					var url = "/TRAILS/account/alerts/";
					if(item.code == "HARDWARE"){
					  url += "alertHardware" + ".htm";
					}
					else if(item.code == "HWCFGDTA"){
					  url += "alertHardwareCfgData" + ".htm";
					}
					else if(item.code == "HARDWARE_LPAR"){
					  url += "alertHardwareLpar" + ".htm";
					}
					else if(item.code == "SOFTWARE_LPAR"){
					  url += "alertSoftwareLpar" + ".htm";
					}
					else if(item.code == "EXPIRED_SCAN"){
					  url += "alertExpiredScan" + ".htm";
					}
					else if(item.code == "SWISCOPE"){
					  url += "alertWithDefinedContractScope" + ".htm";
					}
					else if(item.code == "SWIBM"){
					  url += "alertIbmSwInstancesReviewed" + ".htm";
					}
					else if(item.code == "SWISVPR"){
					  url += "alertPriorityIsvSwInstancesReviewed" + ".htm";
					}
					else if(item.code == "SWISVNPR"){
					  url += "alertIsvSwInstancesReviewed" + ".htm";
					}
					
					html += "<tr>";
					html += "<td>"+item.total+"</td>";
					html += "<td><a href='"+url+"'>"+item.name+"</a></td>";
					html += "</tr>";
				}
			}

			html += "</table>";
			$('#alertSummary').html(html);
		}
	});
	}
</script>


<div style="width: 100%">
	<h3 style="background-color: #d7d7d8">
		<label>Account alerts</label>
	</h3>
	<div id="alertSummary" class="ibm-data-table ibm-alternating" style="padding-top: 10px; min-height: 250px">Loading...</div>

	<h3 style="background-color: #d7d7d8">
		<label>Account reports</label>
	</h3>
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