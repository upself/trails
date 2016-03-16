<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>

<div class="ibm-columns" style="width: 155%;">
	<div class="ibm-col-1-1" style="width:100%;">
		<h6>IBM Confidential</h6>
		<p>
			The following reports reflect metric purification where customer financial responsible software has been counted towards closed alerts where IBM has documented report delivery dates in Schedule F Report Date Tracking.
		</p>
		<br />
	</div>
	<br />
	<div class="ibm-col-1-1" style="font-size: 12px; width:100%;">
		Data last refreshed: <span id="reportTimestamp"></span><br />
		Data age (in minutes): <span id="reportMinutesOld"></span><br />
	</div>
	<div class="ibm-col-1-1" style="width:100%;">
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" summary="Alert overview">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak">Software Operational Metrics</th>
					<th scope="col" class="ibm-sort nobreak">Assigned #</th>
					<th scope="col" class="ibm-sort nobreak">Green(0-45)</th>
					<th scope="col" class="ibm-sort nobreak">Yellow(46-90)</th>
					<th scope="col" class="ibm-sort nobreak">Red(91+)</th>
				</tr>
			</thead>
			<tbody id="tb">
				<tr>
					<td colspan="5">
						<span class="ibm-spinner-large"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<script>
$(function(){
	$("#titleContent").text($("#titleContent").text() + ": ${account.name}(${account.account})");
	searchData();
});

function searchData(){
	$.ajax({
        type: "POST",
        url: '${pageContext.request.contextPath}/ws/alert/overview',
        data: {'accountId':'${accountId}'},
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(errorThrown);
        },
        success: function(data) {
           var reportTimestamp = data.data.reportTimestamp;
           var reportMinutesOld = data.data.reportMinutesOld;
           var html='';
           var assignTotal = greenTotal = yellowTotal = redTotal = 0;
           
           for(var i=0; i<data.data.overviewList.length; i++){
        	   html += '<tr>';
        	   html += '<td>' + data.data.overviewList[i].alertName + '</td>';
        	   html += '<td>' + data.data.overviewList[i].assignedCount + '</td>';
        	   html += '<td>' + data.data.overviewList[i].greenSum + '</td>';
        	   html += '<td>' + data.data.overviewList[i].yellowSum + '</td>';
        	   html += '<td>' + data.data.overviewList[i].redSum + '</td>';
        	   html += '</tr>';
        	   
        	   assignTotal += data.data.overviewList[i].assignedCount;
        	   greenTotal += data.data.overviewList[i].greenSum;
        	   yellowTotal += data.data.overviewList[i].yellowSum;
        	   redTotal += data.data.overviewList[i].redSum;
           }
           
           html += '<tr><td></td><td>'+assignTotal+'</td><td>'+greenTotal+'</td>';
           html += '<td>'+yellowTotal+'</td><td>'+redTotal+'</td></tr>';
           
           $('#reportTimestamp').text(reportTimestamp);
           $('#reportMinutesOld').text(reportMinutesOld);
           $('#tb').html(html);
        }
    });
}
</script>