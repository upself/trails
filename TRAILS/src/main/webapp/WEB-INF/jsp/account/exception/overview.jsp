<div class="ibm-columns">
	<div class="ibm-col-1-1">
	<p class="ibm-confidential">IBM Confidential</p>
	<p>This page displays the total number of data exceptions assigned per data exception type.</p>
	<p id="msg"></p>
	<p><a href="https://www-950.ibm.com/ram/assetDetail/generalDetails.faces?guid=0DFB1651-7375-F052-0886-9CBEBA19BB53" target="_blank">See GLOBAL SW EDUCATION: Managing TRAILS Data Exceptions for more details.</a></p>
	   <table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-alternating" summary="Exception OverView">
			<thead>
				<tr>
					<th scope="col">Data exception</th>
					<th scope="col">Assigned #</th>
					<th scope="col">Total #</th>
				</tr>
			</thead>
			<tbody id="data_exception_summary_list">
			</tbody>
			</tbody>
		</table>
		<span class="ibm-spinner-large" id="loading" style="display: none"></span>
	</div>
</div>

<script>
$(function(){
	$("#titleContent").text($("#titleContent").text() + ": ${account.name}(${account.account})");
	
	var url = '${pageContext.request.contextPath}/ws/exceptions/overview/${accountId}';
	$.ajax({
		url : url,
		type : "GET",
		dataType : 'json',
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert(textStatus);
		},
		beforeSend : function() {
			showLoading();
		},
		success : function(result) {
			var html = '';
			var list = result.dataList;
			if(null == list || list == undefined || list.length == 0){
				html += "<tr><td colspan='3' align='center'>No data found</td></tr>"
			}else{
				$("#msg").html('Clicking on the data exception type will take you to the corresponding data exception detail page.');
				
				var assignedDataExpTotalNum = 0;
				var dataExpTotalNum = 0;
				
				for(var i = 0; i < list.length; i++){
					html += "<tr>";
					html += "<td><a href='${pageContext.request.contextPath}/account/exceptions/"+list[i].url+".htm'>" + list[i].name + "</a></td>";
					html += "<td>" + list[i].assigned + "</td>";
					html += "<td>" + list[i].total + "</td>";
					html += "</tr>";
					
					assignedDataExpTotalNum += list[i].assigned;
					dataExpTotalNum += list[i].total;
				}
				
				html += "<tr>";
				html += "<td style=\"font-weight: bold\">Total:</td>";
				html += "<td>" + assignedDataExpTotalNum + "</td>";
				html += "<td>" + dataExpTotalNum + "</td>";
				html += "</tr>";
				
			}
			$("#data_exception_summary_list").html(html);
		},
		complete : function() {
			hideLoading();
		}
	});
})

function showLoading() {
  $('#loading').show();
}

function hideLoading() {
  $('#loading').hide();
}
</script>