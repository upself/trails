<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-v17ePagination-1.0.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table"
			summary="Priority ISV history table">
			<caption>
                <em>Priority ISV SW History</em>
                </caption>
			<thead>
				<tr>
					<th scope="col">Manufacturer Name</th>
					<th scope="col">Level</th>
					<th scope="col">CNDB Name</th>
					<th scope="col">CNDB ID</th>
					<th scope="col">Evidence Location</th>
					<th scope="col">Status</th>
					<th scope="col">Business Justification</th>
					<th scope="col">Remote User</th>
					<th scope="col">Record Time</th>
				</tr>
			</thead>
			<tbody id="priority_isv_history_list">
			</tbody>
		</table>
		<p id="pagebar" class="ibm-table-navigation"></p>
	</div>
</div>
<script>
$(function(){
	searchData();
});

function searchData(){
	$("#pagebar").v17ePagination({
		showInfo: true,
		showPageSizes: true,
		remote: {
			url: "${pageContext.request.contextPath}/ws/priorityISV/isvh/<s:property value='priorityISVSoftwareId'/>",
			type: "GET",
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='9' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
						html += "<td>" + list[i].manufacturerName + "</td>";
						html += "<td>" + list[i].level + "</td>";
						html += "<td>" + (list[i].accountName == null ? "ALL" : list[i].accountName) + "</td>";
						html += "<td>" + (list[i].accountNumber == null ? "" : list[i].accountNumber) + "</td>";
						html += "<td>" + list[i].evidenceLocation + "</td>";
						html += "<td>" + list[i].statusDesc + "</td>";
						html += "<td>" + list[i].businessJustification+ "</td>";
						html += "<td>" + list[i].remoteUser + "</td>";
						html += "<td>" + list[i].recordTime + "</td>";
						html += "</tr>";
					}
				}
				$("#priority_isv_history_list").html(html);
			}
		}
	});
};
</script>