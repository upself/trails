<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<p class="ibm-confidential">IBM Confidential</p>
		<p>This page displays number of active auditable software instances on active software scans where manufacturer is IBM and there was no valid action taken in TRAILS to cover the software instance. Only includes those instances where scan has been matched to corresponding hardware record (SOM2b) and software contract scope is defined (SOM3). Assigment of these alerts can be performed in the reconciliation workspace.</p>
		
		<div style="text-align:right">
			<a href="${pageContext.request.contextPath}/ws/alertIbmSwInstancesReviewed/download/${accountId}">Download SOM4a: IBM SW INSTANCES REVIEWED alert report</a>
		</div>
		<br />
	</div>
	
	<div class="ibm-col-1-1">
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-alternating" summary="SOM4a: IBM SW INSTANCES REVIEWED">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Oldest alert status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Installed component</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Number of instances</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Date loaded</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Oldest alert age</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="tb">
				
			</tbody>
		</table>
	</div>
</div>
<script>
$(function(){
	$("#titleContent").text($("#titleContent").text() + " Alert: ${account.name}(${account.account})");
	searchData();
});

function searchData(){
	var params = {};
	params['accountId'] = '${accountId}';
	params['sort'] = 'alertAge';
	params['dir'] = 'desc';
	
	$("#page").paginationTable({
		remote: {
			url: "${pageContext.request.contextPath}/ws/alertIbmSwInstancesReviewed/search",
			type: "POST",
			params: params,
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='5' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
// 						html += "<td><input value='"+list[i].tableId+"' type='checkbox'></td>";
						html += "<td>" + list[i].alertStatus + "</td>";
						html += "<td><a href='${pageContext.request.contextPath}/account/recon/settingsSoftware.htm?productInfoName=" + encodeURIComponent(list[i].softwareItemName) + "'>"  + list[i].softwareItemName + "</a></td>"; 
						html += "<td>" + list[i].alertCount + "</td>";
						html += "<td>" + list[i].creationTime + "</td>";
						html += "<td>" + list[i].alertAge + "</td>";
// 						html += "<td><a href='javascript:void()' onclick='displayPopUp(\"alertWithDefinedContractScope.htm?id=" + list[i].tableId+"\");return false;'>View</a></td>";
						html += "</tr>";
					}
				}
				$("#tb").html(html);
			}
		},
		orderColumns: ['alertAge','softwareItemName','alertCount','creationTime','alertAge']
	}); 
}

function displayPopUp(page) {
	
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=840,height=500');
}


</script>