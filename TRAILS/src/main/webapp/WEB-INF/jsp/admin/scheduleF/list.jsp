<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
<%@ taglib prefix="s" uri="/struts-tags"%>
	
<script>
	$(function() {
		function caculateNextDeliveryDate(date, cycle) {
			var lastDeliveryTime = date.getTime();
			var nextDeliveryTime = lastDeliveryTime + cycle * 24 * 60 * 60
					* 1000;
			var nextDeliveryDate = new Date(nextDeliveryTime);
			var dataStr = (nextDeliveryDate.getMonth() + 1) + '/'
					+ nextDeliveryDate.getDate() + '/'
					+ nextDeliveryDate.getFullYear()
			$('#nextReportDeliveryDueDate').val(dataStr);
		}

		function btnRender(add) {
			if (add) {
				$("#reportTrackingRestoreBtn").attr("disabled", "true");
				$("#reportTrackingUpdateBtn").removeAttr("disabled");
				$("#reportTrackingUpdateBtn").val("Add");
			} else {
				$("#reportTrackingRestoreBtn").attr("disabled", "true");
				$("#reportTrackingUpdateBtn").attr("disabled", "true");
				$("#reportTrackingUpdateBtn").val("Update");
			}
		}

		function changed() {
			$("#reportTrackingRestoreBtn").removeAttr("disabled");
			$("#reportTrackingUpdateBtn").removeAttr("disabled");
		}

		restore();

		function restore() {
			var str = "${pageContext.request.contextPath}//admin/scheduleF/getReportTracking.htm";
			$("#reportTrackingUpdateBtn").attr("disabled", "true");
			$("#reportTrackingRestoreBtn").val('Loading...');
			var add = false;
			$.getJSON(str, function(data) {
				$.each(data, function(key, value) {
					if (key == 'reportDeliveryCycle') {
						$("#reportDeliveryCycle").val(value);
					} else if (key == 'nextReportDeliveryDate') {
						$("#nextReportDeliveryDueDate").val(value);
					} else if (key == 'lastReportDeliveryDate') {
						$("#lastReportDeliveryDate").val(value);
					} else if (key == 'qmxReference') {
						$("#qmxReference").val(value);
					} else if (key == 'empty') {
						add = true;
					}
				});
				$("#reportTrackingRestoreBtn").val('Restore');
				btnRender(add)
			});

		}
		$("#reportTrackingRestoreBtn").click(restore);

		$("#lastReportDeliveryDate").datepicker({
			changeMonth : true,
			changeYear : true,
			showButtonPanel : true,
			onSelect : function(dateStr) {
				var cycle = $("#reportDeliveryCycle").val();
				var date = $(this).datepicker('getDate');
				caculateNextDeliveryDate(date, cycle);
				changed();
			}
		});

		$("#reportDeliveryCycle").change(
				function() {
					var dateStr = $("#lastReportDeliveryDate").val();
					var date=new Date(dateStr);
					if (dateStr!=null && dateStr!='' && date != null) {
						caculateNextDeliveryDate(date,
								$("#reportDeliveryCycle").val());
					}
					changed();
				});

		var frm = $("#reportTracking");
		$("#reportTrackingUpdateBtn").click(function() {
			$("#reportTrackingUpdateBtn").val("Updating...");
			$("#reportTrackingRestoreBtn").attr("disabled", "true");
			$("#reportTrackingUpdateBtn").attr("disabled", "true");
			frm.submit();
		});

		$("#qmxReference").change(function() {
			changed();
		});

		frm
				.submit(function() {
					
					$
							.ajax({
								type : "POST",
								url : "${pageContext.request.contextPath}//admin/scheduleF/mergeReportTracking.htm",
								data : frm.serialize(),
								success : function(data) {
									if (data == 'add' || data == 'error') {
										btnRender(true);
									} else {
										btnRender(false);
										var active = $(
												"#reportTrackingHistory")
												.accordion("option", "active");
										if ((typeof active)==='number') {
											$("#historyContent").html(
													"reloading...");
											fetchHistory();
										}
									}

								}
							});

					return false;
				});

		$("#reportTrackingHistory").accordion({
			active : false,
			collapsible : true,
			heightStyle : "content",
			beforeActivate : function(event, ui) {
				if (ui.oldHeader.length == 0) {
					$("#historyContent").html("Loading...");
					fetchHistory();
				}
			}
		});
		
		$("#addScheduleF").click(function(){
			location.href="/TRAILS/admin/scheduleF/manage.htm";
		});

		function fetchHistory() {
			var url = "${pageContext.request.contextPath}//admin/scheduleF/getReportTrackingHistory.htm";
			$.getJSON(url, function(data) {
				$.each(data, function(key, value) {
					if (key == 'empty') {
						$("#historyContent").html("No history found.");
					} else {
						drawTable(data);
					}
				});

			});
		}

		function drawTable(data) {
			var historySection = $("#historyContent");
			historySection.empty();
			historySection.append("<table id='historytable' class='ibm-data-table' cellspacing='0' cellpadding='0' border='0'><thead><tr><th class='ibm-sort'>Last Date</th><th class='ibm-sort'>Cycle</th><th class='ibm-sort'>Next Date</th><th class='ibm-sort'>QMX</th><th class='ibm-sort'>Record Date</th><th class='ibm-sort'>User</th></tr></thead>");
			
			var newRow;
			for (var i = 0; i < data.length; i++) {
				var cyc;
				if(data[i].cycle==7){
					cyc="weekly";
				}else if(data[i].cycle==30){
					cyc="Monthly";
				}else if(data[i].cycle==60){
					cyc="Every Other Month";
				}else if(data[i].cycle==90){
					cyc="Quarterly";
				}else if(data[i].cycle==120){
					cyc="Every Four Months";
				}else if(data[i].cycle==182){
					cyc="Bi-Annualy";
				}else if(data[i].cycle==365){
					cyc="Annualy";
				}
				newRow=newRow + ("<tr>"+"<td>" + data[i].lastDate + "</td>"+"<td>" + cyc + "</td>"+"<td>" + data[i].nextDate 
						+ "</td>"+"<td>" + data[i].qmx + "</td>"+"<td>" + data[i].createdDate + "</td>"+"<td>" + data[i].user + "</td>"+"</tr>");
			}
				$("#historytable").append("<tbody>"+newRow+"</tbody></table>");
		}		

	});
</script>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>

<div style="font-size: 22px; display: inline">
	<s:property value="account.name" />
	(
	<s:property value="account.account" />
	)
</div>
<p style="font-weight:bold">IBM Confidential</p>
<br />
<div class="ibm-rule" style="width:108%"><hr><hr></div>
<div style="font-size: 18px;">
<h2>Software License Management Report Delivery Tracking</h2>
</div>
<p style="font-size: 16px;">Track the required report delivery cycle and most recent report delivery date.</p>
<br>
	<form id="reportTracking">
		<div id="firstline" style="width:100%;float:left">
		   <div id="line1col1" style="width:30%; float:left">
			<label>Report Delivery Cycle:</label> 
		   </div>
		   <div id="line1col2" style="width:20%; float:left">
			<select
				name="reportForm.reportDeliveryCycle" id="reportDeliveryCycle">
				<option value="7">Weekly</option>
				<option value="30">Monthly</option>
				<option value="60">Every Other Month</option>
				<option value="90">Quarterly</option>
				<option value="120">Every Four Months</option>
				<option value="182">Bi-Annually</option>
				<option value="365">Annually</option>
			</select> 
		   </div>
		   <div id="line1col3" style="width:30%; float:left">
			 <label>Next Report Delivery Due Date:</label> 
		   </div>
		   <div id="line1col4" style="width:20%; float:left">
			<input type="text" id="nextReportDeliveryDueDate" name="reportForm.nextReportDeliveryDate" readonly style="background-color:#EAEAEA"> 
		   </div>			
		</div>
		
		<br /> 
		<div id="secondline" style="width:100%;float:left;margin-top:10px">
			<div id="line2col1" style="width:30%; float:left">
				<label>Last Report Delivery Date:</label> 
			</div>
			<div id="line2col2" style="width:20%; float:left">
				<input type="text" id="lastReportDeliveryDate" name="reportForm.lastReportDeliveryDate" readonly style="width:138px">
			</div>
			<div id="line2col3" style="width:30%; float:left">
				<label for="qmxReference">Evidence Posted to QMX: </label>
			</div>			
			<div id="line2col4" style="width:20%; float:left">
				<s:textfield id="qmxReference" name="reportForm.qmxReference" required="true" />
			</div>
		</div>	
	</form>
	<div style="width:110%">
		<div id="addRTdiv" style="float: left;width:10%">
			<p class="ibm-button-link-alternate ibm-btn-small">
			    <a class="ibm-btn-small" id="reportTrackingUpdateBtn" href="#">Add</a>
			</p>
		</div>
		<div id="updateRTdiv" style="float: left;width:5%">
			<p class="ibm-button-link-alternate ibm-btn-small">
			    <a class="ibm-btn-small" id="reportTrackingRestoreBtn" href="#">Restore</a>
			</p>
		</div>
	</div>
<br>
<style>
#reportTrackingHistory table, #reportTrackingHistory th,
	#reportTrackingHistory td {
	border: 1px solid black;
}
</style>
<div id="reportTrackingHistory" style="width:110%;float:left">
	<h2>Report Delivery Tracking History</h2>
	<div id="historyContent" style="max-height:180px"></div>
</div>
<br>
<div class="ibm-rule" style="width:108%"><hr><hr></div>
<div style="float: left">
<div style="font-size: 18px;">
<h2 class="oneline">Schedule F</h2>
</div>
<p style="width:110%;font-size: 16px;">To edit a schedule F record, press one of the links below. If you want to add a new record, press the Add button.</p>
	<div style="width:110%">
		<div id="addScheFdiv" style="float: right;width:10%">
			<p class="ibm-button-link-alternate ibm-btn-small">
			    <a class="ibm-btn-small" id="addScheduleF" href="#">Add</a>
			</p>
		</div>
		<div id="downloadDiv" style="float: right;width:15%">
			<p class="ibm-button-link-alternate ibm-btn-small">
			    <a class="ibm-btn-small" id="download" href="#">Export Report</a>
			</p>
		</div>
	</div>
</div>
<br />
<br />
<!-- 
<s:hidden name="page" value="%{#attr.page}" />
<s:hidden name="dir" value="%{#attr.dir}" />
<s:hidden name="sort" value="%{#attr.sort}" />
 -->
<div class="ibm-col-1-1">
		<table id="schFTable" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" summary="Schedule F list">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Level</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Hw Owner</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Hostname</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Serial</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Machine Type</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software title</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Manufacturer</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Scope</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>SW Financial Resp</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Source</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Source location</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><span>Compliance</span></th>
				</tr>
			</thead>
			<tbody id="schedule_f_list" />
		</table>
</div>

<script type="text/javascript">


$("#download").click(function() {
			$(this).attr("href","${pageContext.request.contextPath}/ws/scheduleF/download/${account.id}")
		});
$("#addScheduleF").click(function() {
	$(this).attr("href","${pageContext.request.contextPath}/admin/scheduleF/manage.htm")
});		
		
$(function() {
	searchData();
});

function searchData() {
	var params = {};
	params['accountId'] = '${account.id}';
	params['sort'] = 'id';
	params['dir'] = 'desc';
	
	$("#schFTable").paginationTable('destroy').paginationTable({
		remote: {
			url: "${pageContext.request.contextPath}/ws/scheduleF/all",
			type: "POST",
			params: params,
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='14' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
						html += "<td><a href='${pageContext.request.contextPath}/admin/scheduleF/manage.htm?scheduleFId=" + list[i].id + "'>" + list[i].softwareName + "</a></td>";		
						html += "<td>" + list[i].level + "</td>";
						html += "<td>" + list[i].hwOwner + "</td>";
						html += "<td>" + list[i].hostName + "</td>"
						html += "<td>" + list[i].serial + "</td>";
						html += "<td>" + list[i].machineType + "</td>";
						html += "<td>" + list[i].softwareTitle + "</td>";
						html += "<td>" + list[i].manufacturer + "</td>";
						html += "<td>" + list[i].scopeDescription + "</td>";
						html += "<td>" + list[i].swfinanceResp + "</td>";
						html += "<td>" + list[i].sourceDescription + "</td>";
						html += "<td>" + list[i].sourceLocation + "</td>";
						html += "<td>" + list[i].statusDescription + "</td>";
						if(list[i].softwareComplianceManagement== 'YES'){
							html += "<td>YES</td>";						
						}else{
							html += "<td>NO</td>";		
						}
						html += "</tr>"; 
					}
				}
				$("#schedule_f_list").html(html);
			}
		},
		orderColumns: ['softwareName','level','hwOwner','hostname','serial','machineType','softwareTitle','manufacturer','scope.description','swfinanceResp','source.description','sourceLocation','status.description','account.softwareComplianceManagement']
	});
}

</script>
