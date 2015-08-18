<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-v17ePagination-1.0.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table"
			summary="Sortable Non Instance based SW history table">
			<caption>
                <em>Non Instance based SW history</em>
                </caption>
			<thead>
				<tr>
					<th scope="col">Software title</th>
					<th scope="col">Manufacturer</th>
					<th scope="col">Restriction</th>
					<th scope="col">Non Instance based only</th>
					<th scope="col">Capacity type</th>
					<th scope="col">Status</th>
					<th scope="col">Remote users</th>
					<th scope="col">Record time</th>
				</tr>
			</thead>
			<tbody id="non_instance_list">
				
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
	$("#pagebar").v17ePagination('destroy').v17ePagination({
		showInfo: true,
		showPageSizes: true,
		remote: {
			url: "${pageContext.request.contextPath}/ws/noninstance/history/<s:property value='nonInstanceId' />",
			type: "GET",
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='8' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
						html += "<td>" + list[i].software.softwareName + "</td>";
						html += "<td>" + list[i].manufacturer.manufacturerName + "</td>";
						html += "<td>" + list[i].restriction + "</td>";
						if(list[i].baseOnly == 1){
							html += "<td>Y</td>";
						}else{
							html += "<td>N</td>";
						}
						html += "<td>" + list[i].capacityType.description +"</td>";
						html += "<td>" + list[i].status.description + "</td>";
						html += "<td>" + list[i].remoteUser + "</td>";
						html += "<td>" + list[i].recordTime + "</td>";
						html += "</tr>";
					}
				}
				$("#non_instance_list").html(html);
			}
		}
	});
};
</script>






