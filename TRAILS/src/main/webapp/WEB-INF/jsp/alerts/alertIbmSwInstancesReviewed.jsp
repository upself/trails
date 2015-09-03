<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-v17ePagination-1.0.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<h6>IBM Confidential</h6>
		<p>This page displays number of active auditable software instances on active software scans where manufacturer is IBM and there was no valid action taken in TRAILS to cover the software instance. Only includes those instances where scan has been matched to corresponding hardware record (SOM2b) and software contract scope is defined (SOM3). Assigment of these alerts can be performed in the reconciliation workspace.</p>
		
		<div style="text-align:right">
			<a href="${pageContext.request.contextPath}/ws/alertIbmSwInstancesReviewed/download/${accountId}">Download SOM4a: IBM SW INSTANCES REVIEWED alert report</a>
		</div>
		<br />
	</div>
	
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" summary="Sortable Non Instance based SW table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak">Oldest alert status</th>
					<th scope="col" class="ibm-sort nobreak">Installed component</th>
					<th scope="col" class="ibm-sort nobreak">Number of instances</th>
					<th scope="col" class="ibm-sort nobreak">Date loaded</th>
					<th scope="col" class="ibm-sort nobreak">Oldest alert age</th>
				</tr>
			</thead>
			<tbody id="tb">
				
			</tbody>
		</table>
		<p class="ibm-table-navigation" id="pagebar"></p>
		
	</div>
</div>
<script>
$(function(){
	searchData();
});

function searchData(){
	var params = {};
	params['accountId'] = '${accountId}';
	params['sort'] = 'alertAge';
	params['dir'] = 'desc';
	
	$("#pagebar").v17ePagination({
		showInfo: true,
		showPageSizes: true,
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
						html += "<td><a href='${pageContext.request.contextPath}/account/recon/settingsSoftware.htm?productInfoName=" + list[i].softwareItemName + "'>"  + list[i].softwareItemName + "</a></td>"; 
						html += "<td>" + list[i].alertCount + "</td>";
						html += "<td>" + list[i].creationTime + "</td>";
						html += "<td>" + list[i].alertAge + "</td>";
// 						html += "<td><a href='javascript:void()' onclick='displayPopUp(\"alertWithDefinedContractScope.htm?id=" + list[i].tableId+"\");return false;'>View</a></td>";
						html += "</tr>";
					}
				}
				$("#tb").html(html);
			}
		}
	}); 
}

function displayPopUp(page) {
	
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=840,height=500');
}


</script>