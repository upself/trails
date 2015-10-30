<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table"
			summary="Non Instance based SW history table">
			<caption>
                <em>Non Instance based SW history</em>
                </caption>
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software title</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Manufacturer</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Restriction</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Non Instance based only</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Capacity type</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Remote users</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Record time</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="non_instance_list">
				
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
		},
		orderColumns: ['software.softwareName','manufacturer.manufacturerName','restriction','baseOnly','capacityType.description','status.description','remoteUser','recordTime']
	});
};
</script>






