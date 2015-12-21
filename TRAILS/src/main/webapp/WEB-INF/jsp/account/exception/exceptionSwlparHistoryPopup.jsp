<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<div class="ibm-columns">
	<div class="ibm-col-5-4">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="Data Exception History">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Comments</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Assignee</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Creation Time</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Record Time</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="data_exception_history_list">
			</tbody>
		</table>
	</div>
</div>

<script>
$(function(){
	$.get('${pageContext.request.contextPath}/ws/exceptions/${dataExpType}/history/${exceptionId}',function(result){
		var html = '';
		var list = result.dataList;
		if(null == list || list == undefined || list.length == 0){
			html += "<tr><td colspan='4' align='center'>No data found</td></tr>"
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
	});
})
</script>