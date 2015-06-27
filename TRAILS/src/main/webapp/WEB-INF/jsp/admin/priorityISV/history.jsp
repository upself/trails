<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<!-- show loading -->
<script src="${pageContext.request.contextPath}/js/jquery.showLoading.js"></script>
<link href="${pageContext.request.contextPath}/css/showLoading.css" rel="stylesheet" type="text/css" />

<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table"
			summary="Sortable Non Instance based SW history table">
			<caption>
                <em>Priority ISV History</em>
                </caption>
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Manufacturer Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Level</span><span class="ibm-icon"></span></a></th>
					<!-- <th scope="col" class="ibm-sort"><a href="#sort"><span>CNDB Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>CNDB ID</span><span class="ibm-icon"></span></a></th> -->
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Evidence Location</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Business Justification</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Remote Users</span><span class="ibm-icon"></span></a></th>
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
			//url : "${pageContext.request.contextPath}/ws/noninstance/history/<s:property value='nonInstanceId'/>",
			url : "${pageContext.request.contextPath}/ws/noninstance/history/3",
			//url : "${pageContext.request.contextPath}/ws/priorityISV/isvh/<s:property value='isvId'/>",
			type : "GET",
			dataType : 'json',

			error : function(XMLHttpRequest, textStatus, errorThrown) {
				var html = "<tr><td colspan='9'>" + "Error happend when querying the data, please contact system admin."
				+ "</td></tr>"
				$("#priority_isv_history_list").html(html);
				$(".loading").hideLoading();
			},
			
			success : function(data) {
				data = mockData();
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
						/*html += "<td>" + list[i].cndbname + "</td>";
						html += "<td>" + list[i].cndbid + "</td>";*/
						html += "<td>" + list[i].evidenceLocation + "</td>";
						html += "<td>" + list[i].statusDesc + "</td>";
						html += "<td>" + list[i].businessJustification+ "</td>";
						html += "<td>" + list[i].remoteUser + "</td>";
						html += "<td>" + formatDate(new Date(list[i].recordTime)) + "</td>";
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

	function mockData() {
		var data = {
			"status" : "200",
			"msg" : "The Priority ISV Software History Data has been found for priorityISVSoftwareId = 1.",
			"data" : null,
			"dataList" : [ {
				"id" : 1,
				"priorityISVSoftwareId" : 1,
				"level" : "ACCOUNT",
				"customerId" : 16793,
				"accountName" : "CEMEX U.A.EMIRATES WORKSTATIONS",
				"accountNumber" : 169628,
				"manufacturerId" : 2,
				"manufacturerName" : "CENTENNIAL SOFTWARE",
				"evidenceLocation" : "Larry Testing Record - History 1",
				"statusId" : 2,
				"statusDesc" : "ACTIVE",
				"businessJustification" : "Larry Testing Record - History 1",
				"remoteUser" : "liuhaidl@cn.ibm.com",
				"recordTime" : 1435271644180
			}, {
				"id" : 2,
				"priorityISVSoftwareId" : 1,
				"level" : "ACCOUNT",
				"customerId" : 17601,
				"accountName" : "STATE STREET - CUST OWNED - SERVER",
				"accountNumber" : 173709,
				"manufacturerId" : 3,
				"manufacturerName" : "COMPTEL",
				"evidenceLocation" : "Larry Testing Record - History 2",
				"statusId" : 2,
				"statusDesc" : "ACTIVE",
				"businessJustification" : "Larry Testing Record - History 2",
				"remoteUser" : "liuhaidl@cn.ibm.com",
				"recordTime" : 1435271648512
			}, {
				"id" : 3,
				"priorityISVSoftwareId" : 1,
				"level" : "GLOBAL",
				"customerId" : null,
				"accountName" : null,
				"accountNumber" : null,
				"manufacturerId" : 3,
				"manufacturerName" : "COMPTEL",
				"evidenceLocation" : "Larry Testing Record - History 3",
				"statusId" : 2,
				"statusDesc" : "ACTIVE",
				"businessJustification" : "Larry Testing Record - History 3",
				"remoteUser" : "liuhaidl@cn.ibm.com",
				"recordTime" : 1435271652313
			} ]
		}
		return data;
	}

	function formatDate(inputdate) {
		var year = inputdate.getYear();
		var month = inputdate.getMonth() + 1;
		var date = inputdate.getDate();
		var hour = inputdate.getHours();
		var minute = inputdate.getMinutes();
		var second = inputdate.getSeconds();
		return year + "-" + month + "-" + date + " " + hour + ":" + minute
				+ ":" + second;
	}
</script>