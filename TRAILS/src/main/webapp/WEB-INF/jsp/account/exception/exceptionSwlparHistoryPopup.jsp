<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<div class="ibm-columns">
	<div class="ibm-col-5-4">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-alternating" summary="Data Exception History">
			<thead>
				<tr>
					<th scope="col">Comments</th>
					<th scope="col">Assignee</th>
					<th scope="col">Creation Time</th>
					<th scope="col">Record Time</th>
				</tr>
			</thead>
			<tbody id="data_exception_history_list">
			</tbody>
		</table>
	</div>
</div>

<script>
$(function(){
	$.ajax({
		url: "${pageContext.request.contextPath}/ws/exceptions/${dataExpType}/history/${exceptionId}",
		type: 'GET',
		dataType: 'json',
		success: function(result){
			var html = '';
			var list = result.dataList;
			if(null == list || list == undefined || list.length == 0){
				html += "<tr><td colspan='8' align='center'>No data found</td></tr> " 
			}else{
				for(var i = 0; i < list.length; i++){
					html += "<tr>";
					html += "<td>" + list[i].comment + "</td>";
					html += "<td>" + list[i].assignee + "</td>";
					html += "<td>" + list[i].creationTime + "</td>";
					html += "<td>" + list[i].recordTime +"</td>";
					html += "</tr>";
			}
			}
			$("#data_exception_history_list").html(html);
		}
	}); 

})
</script>
</script>