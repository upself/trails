<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<!-- show loading -->
<script src="${pageContext.request.contextPath}/js/jquery.showLoading.js"></script>
<link href="${pageContext.request.contextPath}/css/showLoading.css" rel="stylesheet" type="text/css" />

<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table"
			summary="Priority ISV history table">
			<caption>
                <em>Priority ISV SW History</em>
                </caption>
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Manufacturer Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Level</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>CNDB Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>CNDB ID</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Evidence Location</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Business Justification</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Remote User</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Record Time</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="priority_isv_history_list">
			<tr class="loading"></tr>
			</tbody>
		</table>
	</div>
</div>
<script>
	
	$(function() {
		searchData();
	});

	function searchData() {
		$(".loading").showLoading();
		$.ajax({
			url : "${pageContext.request.contextPath}/ws/priorityISV/isvh/<s:property value='priorityISVSoftwareId'/>",
			type : "GET",
			dataType : 'json',

			error : function(XMLHttpRequest, textStatus, errorThrown) {
				var html = "<tr><td colspan='9'>" + "Error happend when querying the data, please contact system admin."
				+ "</td></tr>"
				$("#priority_isv_history_list").html(html);
				$(".loading").hideLoading();
			},
			
			success : function(data) {
				var html = '';
				if (data.status != 200) {
					html += "<tr><td colspan='9'>" + data.msg
							+ "</td></tr>"
				} else {
					var list = data.dataList;
					for (var i = 0; i < list.length; i++) {
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
				$(".loading").hideLoading();
			},
			
			complete : function(XMLHttpRequest, textStatus) {
				$(".loading").hideLoading();
			}
		});
	};

	function formatDate(inputdate) {
		var year = inputdate.getFullYear();
		var month = inputdate.getMonth() + 1;
		month = appendZero(month);
		var date = inputdate.getDate();
		date = appendZero(date);
		var hour = inputdate.getHours();
		hour = appendZero(hour);
		var minute = inputdate.getMinutes();
		minute = appendZero(minute);
		var second = inputdate.getSeconds();
		second = appendZero(second);
		return year + "-" + month + "-" + date + " " + hour + ":" + minute
				+ ":" + second;
	}
	
	function appendZero(number){
		return number > 9 ? number : "0" + number;
	}
</script>