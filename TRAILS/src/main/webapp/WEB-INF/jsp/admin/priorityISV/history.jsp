<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table"
			summary="Priority ISV history table">
			<caption>
               <em>Priority ISV SW History</em>
            </caption>
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Manufacturer Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Level</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>CNDB Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>CNDB ID</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Evidence Location</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Business Justification</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Remote User</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Record Time</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="priority_isv_history_list">
			</tbody>
		</table>
	</div>
</div>
<script>
$(function(){
	searchData();
});

function searchData(){
	$("#page").paginationTable({
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
		},
		orderColumns: ['manufacturerName','level','accountName','accountNumber','evidenceLocation','statusDesc','businessJustification','remoteUser','recordTime']
	});
};
</script>