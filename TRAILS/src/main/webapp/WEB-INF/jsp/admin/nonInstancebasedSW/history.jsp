<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table"
			summary="Sortable Non Instance based SW history table">
			<caption>
                <em>Non Instance based SW history</em>
                </caption>
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Software title</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Manufacturer</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Restriction</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Non Instance based only</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Capacity type </span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Remote users</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Record time</span><span class="ibm-icon"></span></a></th>
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
	$.ajax({
		url: "${pageContext.request.contextPath}/ws/noninstance/history/<s:property value='nonInstanceId' />",
		type: "GET",
		dataType:'json',
		error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(textStatus);
    	},
		success:function(data){
			var html = '';
			if(data.status != 200){
				html += "<tr><td colspan='8'>"+data.msg+"</td></tr>"
			}else{
				var list = data.dataList;
				for(var i = 0; i < list.length; i++){
					html += "<tr>";
					html += "<td>" + list[i].softwareName + "</td>";
					html += "<td>" + list[i].manufacturerName + "</td>";
					html += "<td>" + list[i].restriction + "</td>";
					if(list[i].baseOnly == 1){
						html += "<td>Y</td>";
					}else{
						html += "<td>N</td>";
					}
					html += "<td>" + list[i].capacityDesc +"</td>";
					html += "<td>" + list[i].statusDesc + "</td>";
					html += "<td>" + list[i].remoteUser + "</td>";
					html += "<td>" + list[i].recordTime + "</td>";
					html += "</tr>";
				}
			}
			$("#non_instance_list").html(html);
		}
	}); 
};
</script>






