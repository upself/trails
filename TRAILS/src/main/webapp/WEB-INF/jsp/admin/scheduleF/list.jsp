<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>


<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">

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

		function restored(add) {
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
				restored(add)
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
									alert(data);
									if (data == 'add' || data == 'error') {
										restored(true);
									} else {
										restored(false);
									}
								}
							});

					return false;
				});

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
		id="lastReportDeliveryDate" name="reportForm.lastReportDeliveryDate">
	<label for="qmxReference">Evidence Posted to QMX: </label>
	<s:textfield id="qmxReference" name="reportForm.qmxReference"
		required="true" />
</form>
<input type="button" id="reportTrackingUpdateBtn" value="Update">
<input type="button" id="reportTrackingRestoreBtn" value="Restore">
<div class="hrule-dots"></div>
<br />

<div style="float: right">
	<s:a href="/TRAILS/admin/scheduleF/manage.htm">Add</s:a>
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
