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
		success:function(data){
			var html="";
			for(var i = 0; i < data.length; i++){
				html += "<tr>";
				html += "<td>" + data[i].softwareName + "</td>";
				html += "<td>" + data[i].manufacturerName + "</td>";
				html += "<td>" + data[i].restriction + "</td>";
				if(data[i].baseOnly == 1){
					html += "<td>Y</td>";
				}else{
					html += "<td>N</td>";
				}
				html += "<td>" + data[i].capacityDesc +"</td>";
				html += "<td>" + data[i].statusDesc + "</td>";
				html += "<td>" + data[i].remoteUser + "</td>";
				html += "<td>" + data[i].recordTime + "</td>";
				html += "</tr>";
			}
			
			$("#non_instance_list").html(html);
		},
		error:function(xhr, type, exception){
			alert(xhr.responseText, "Failed"); 
		}
	}); 
};
</script>






