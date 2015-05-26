<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>


<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
	
<style type="text/css">
table.gridtable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	width:100%;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #dedede;
}
table.gridtable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
</style>

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
				var date = $(this).datepicker('getDate')
				caculateNextDeliveryDate(date, cycle);
				changed();
			}
		});

		$("#reportDeliveryCycle").change(
				function(event, data) {
					var date = $("#lastReportDeliveryDate").datepicker(
							'getDate')
					if (date != null) {
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
		
		function validateFields(){
			var qmx=$("#qmxReference").val();
			if(qmx==null || qmx==''){
				alert("QMX is required!");
				return;
			}
		}

		frm
				.submit(function() {
					validateFields();
					
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
			historySection.append("<table id='historytable' class='gridtable'><tr><th>Last Date</th><th>Cycle</th><th>Next Date</th><th>QMX</th><th>Created Date</th><th>User</th></tr></table>");
			
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
				var newRow=("<tr>"+"<td>" + data[i].lastDate + "</td>"+"<td>" + cyc + "</td>"+"<td>" + data[i].nextDate 
						+ "</td>"+"<td>" + data[i].qmx + "</td>"+"<td>" + data[i].createdDate + "</td>"+"<td>" + data[i].user + "</td>"+"</tr>");
				$("#historytable tr:last").after(newRow);
			}
		}

	});
</script>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h1 class="oneline">Schedule F</h1>
<div style="font-size: 22px; display: inline">
	&nbsp;:
	<s:property value="account.name" />
	(
	<s:property value="account.account" />
	)
</div>
<p class="confidential">IBM Confidential</p>
<br />
<p>To edit a schedule F record, press one of the links below. If you
	want to add a new record, press the Add link.</p>
<br />
<div class="hrule-dots"></div>
<br />
<form id="reportTracking">
	<label>Report Delivery Cycle:</label> <select
		name="reportForm.reportDeliveryCycle" id="reportDeliveryCycle">
		<option value="7">Weekly</option>
		<option value="30">Monthly</option>
		<option value="60">Every Other Month</option>
		<option value="90">Quarterly</option>
		<option value="120">Every Four Months</option>
		<option value="182">Bi-Annually</option>
		<option value="365">Annually</option>
	</select> <label>Next Report Delivery Due Date:</label> <input type="text"
		id="nextReportDeliveryDueDate"
		name="reportForm.nextReportDeliveryDate" readonly> <br /> <br />
	<label>Last Report Delivery Date:</label> <input type="text"
		id="lastReportDeliveryDate" name="reportForm.lastReportDeliveryDate" readonly>
	<label for="qmxReference">Evidence Posted to QMX: </label>
	<s:textfield id="qmxReference" name="reportForm.qmxReference"
		required="true" />
</form>
<input type="button" id="reportTrackingUpdateBtn" value="Update">
<input type="button" id="reportTrackingRestoreBtn" value="Restore">
<br />
<br />
<style>
#reportTrackingHistory table, #reportTrackingHistory th,
	#reportTrackingHistory td {
	border: 1px solid black;
}
</style>
<div id="reportTrackingHistory" style="width:60%">
	<h3>Report Delivery Tracking History</h3>
	<div id="historyContent"></div>

</div>
<div class="hrule-dots"></div>
<br />

<div style="float: right">
	<input type="button" value="Add" id="addScheduleF"/>
</div>
<br />
<br />

<s:hidden name="page" value="%{#attr.page}" />
<s:hidden name="dir" value="%{#attr.dir}" />
<s:hidden name="sort" value="%{#attr.sort}" />

<display:table name="data" class="basic-table" id="row"
	summary="scheduleF View"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0" requestURI="list.htm" defaultsort="1"
	export="true">
	<display:setProperty name="export.excel.filename"
		value="SheduleF_View.xls" />
	<display:column property="softwareName" sortProperty="SF.softwareName"
		title="Software name" sortable="true"
		href="/TRAILS/admin/scheduleF/manage.htm" paramProperty="id"
		paramId="scheduleFId" media="html" />
	<display:column property="level" sortProperty="SF.level" title="Level"
		sortable="true" />
	<display:column property="hwOwner" sortProperty="SF.hwOwner"
		title="Hw Owner" sortable="true" />
	<display:column property="hostname" sortProperty="SF.hostname"
		title="Hostname" sortable="true" />
	<display:column property="serial" sortProperty="SF.serial"
		title="Serial" sortable="true" />
	<display:column property="machineType" sortProperty="SF.machineType"
		title="Machine Type" sortable="true" />
	<display:column property="account.account" title="Account Number"
		media="excel" />
	<display:column property="softwareTitle" title="Software title"
		media="excel" />
	<display:column property="softwareName" title="Software name"
		media="excel" />
	<display:column property="softwareTitle"
		sortProperty="SF.softwareTitle" title="Software title" sortable="true"
		media="html" />
	<display:column property="manufacturer" sortProperty="SF.manufacturer"
		title="Manufacturer" sortable="true" />
	<display:column property="scope.description"
		sortProperty="SF.scope.description" title="Scope" sortable="true" />
	<!-- AB added -->
	<display:column property="SWFinanceResp"
		sortProperty="SF.SWFinanceResp" title="SW Financial Resp"
		sortable="true" />
	<display:column property="source.description"
		sortProperty="SF.source.description" title="Source" sortable="true" />

	<display:column property="sourceLocation"
		sortProperty="SF.sourceLocation" title="Source location"
		sortable="true" />
	<display:column property="status.description"
		sortProperty="SF.status.description" title="Status" sortable="true" />
	<display:column property="businessJustification"
		title="Business Justification" media="excel" />
	<s:if test="account.softwareComplianceManagement == 'YES'">
		<display:column value="YES" title="Compliance" sortable="false" />
	</s:if>
	<s:else>
		<display:column value="NO" title="Compliance" sortable="false" />
	</s:else>
</display:table>
