<%@ taglib prefix="s" uri="/struts-tags"%>
<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script type="text/javascript">
	var loadingMsg = "<p id=\"dialogmsg\">please wait a while.</p><div id=\"progressbar\"></div>";

	function isArray(obj) {
		return Object.prototype.toString.call(obj) === '[object Array]';
	}
	$(function() {
		var scheduleFId = '${scheduleFForm.scheduleFId}';
		if (scheduleFId == null || scheduleFId == ""
				|| scheduleFId == undefined) {
			populateArraryList();
			$("#spinner").hide();
			$("#scopeDescription").val("IBM owned, IBM managed");
			$("#swfinanceResp").val("IBM");

		} else {
			feedPage(scheduleFId);
			searchData(scheduleFId);
		}

		scopeFlip();
		
		$("#statusDescription").change(function() {
		   var statusId =	$('#statusDescription option:selected').attr("id");
		        $("#statusId").val(statusId);
		});

		$("#scopeDescription").change(
				function() {
					var scopeVal = $('#scopeDescription option:selected')
							.text().split(",")[0];
					var scopeVal2 = $('#scopeDescription option:selected')
							.text().split(",")[1];
					var scopeInIf = scopeVal + scopeVal2;

					if (scopeVal == 'IBM owned') {
						$("#swfinanceResp").find("option[value='CUSTO']").css({
							display : "none"
						});
						$('#swfinanceResp option[value="IBM"]').attr(
								"selected", true);
					} else {
						$("#swfinanceResp").find("option[value='CUSTO']").css({
							display : ""
						});
					}

					if (scopeInIf != 'Customer owned Customer managed') {
						$('#swfinanceResp option[value="IBM"]').attr(
								"selected", true);
						$("#swfinanceResp").find("option[value='N/A']").css({
							display : "none"
						});
					} else {
						$("#swfinanceResp").find("option[value='N/A']").css({
							display : ""
						});
					}
					if ( $('#level').val() == 'HWOWNER' ){
						 hwowerChng();
					}
				});
		if ($('#softwareStatus').val() == true) {
			$("#statusDescription").find('option[value="ACTIVE"]').attr(
					"disabled", "disabled");
		} else {
			$("#statusDescription").find('option[value="ACTIVE"]').removeAttr(
					"disabled");
		}

		var value = $('#level').val();
		levelChange(value);
	});

	function feedPage(scheduleFId) {
		var urlRequest = "${pageContext.request.contextPath}/ws/scheduleF/"
				+ scheduleFId + "";
		var accountId = '${account.id}';
		jQuery.ajax({
			url : urlRequest,
			type : "POST",
			data : {
				"accountId" : accountId
			},
			dataType : 'json',
			timeout : 180000,
			beforeSend : function() {
				$("#spinner").show();
				$("#btnSubmit").attr('disabled', true);
				populateArraryList();
			},
			complete : function(XMLHttpRequest, status) {
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', false);
				if (status == 'timeout') {
					alert("Request Timeout !");
					this.abort();
				}
			},
			success : function(result) {
				if (result.status != '200') {
					alert(result.msg);
					$("#spinner").hide();
					$("#btnSubmit").attr('disabled', false);
				}
				$("#id").val(result.data.id);
				$("#softwareTitle").val(result.data.softwareTitle);
				$("#softwareName").val(result.data.softwareName);
				$("#softwareStatus").val(result.data.softwareStatus);
				$("#manufacturer").val(result.data.manufacturer);
				$("#level").val(result.data.level);
				$("#hwOwner").val(result.data.hwOwner);
				$("#serial").val(result.data.serial);
				$("#machineType").val(result.data.machineType);
				$("#hostName").val(result.data.hostName);
				$("#scopeDescription").val(result.data.scopeDescription);
				$("#sourceDescription").val(result.data.sourceDescription);
				$("#statusDescription").val(result.data.statusDescription);
				$("#statusId").val(result.data.statusId);
				$("#swfinanceResp").val(result.data.swfinanceResp);
				$("#sourceLocation").val(result.data.sourceLocation);
				$("#businessJustification").val(
						result.data.businessJustification);
				levelChange(result.data.level);
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});
	}

	function populateArraryList() {
		jQuery.ajax({
			url : "${pageContext.request.contextPath}/ws/scheduleF/scopes",
			type : "GET",
			success : function(result) {
				outputlist("scopeDescription", result.dataList);
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});

		jQuery.ajax({
			url : "${pageContext.request.contextPath}/ws/scheduleF/sources",
			type : "GET",
			success : function(result) {
				outputlist("sourceDescription", result.dataList);
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});

		jQuery.ajax({
			url : "${pageContext.request.contextPath}/ws/scheduleF/status",
			type : "GET",
			success : function(result) {
				outputlist("statusDescription", result.dataList);
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});
	}

	function outputlist(elemet, items) {
		for (var i = 0; i < items.length; i++) {
			$("#" + elemet + "").append(
					"<option id='"+items[i].id+"' value='"+items[i].description+"'>"
							+ items[i].description + "</option>");
		}
	}

	function submitForm() {
		if (validateForm()) {
			$.ajax({
				cache : true,
				type : "POST",
				url : '${pageContext.request.contextPath}/ws/scheduleF/save',
				data : $('#myScheduleFForm').serialize(),
				dataType : 'json',
				async : false,
				beforeSend : function(XMLHttpRequest) {
					$("#spinner").show();
					$("#btnSubmit").attr('disabled', true);
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					alert(textStatus);
				},
				success : function(data) {
					alert(data.msg);
				},
				complete : function(XMLHttpRequest, textStatu) {
					$("#spinner").hide();
					$("#btnSubmit").attr('disabled', false);
				}
			});
		}
	}

	function validateForm() {
		var softwareName = $("#softwareName").val();
		var softwareTitle = $("#softwareTitle").val();
		var manufacturerName = $("#manufacturer").val();
		var sourceLocation = $("#sourceLocation").val();
		var businessJustification = $("#businessJustification").val();

		if(softwareName.trim() == ''){
			alert('Software Name is required');
			return false;
		}
			
		if(softwareTitle.trim() == ''){
			alert('Software Title is required');
			return false;
		}
		
		if(manufacturerName.trim() == ''){
			alert('Manufacturer is required');
			return false;
		}
		
		if(sourceLocation.trim() == ''){
			alert('SourceLocation is required');
			return false;
		}
		
		if(businessJustification.trim() == ''){
			alert('businessJustification is required');
			return false;
		}
		
		return true;
	}

	function scopeFlip() {
		var scopeSelectedVal = $('#scopeDescription option:selected').text()
				.split(",")[0];
		var scopeSelectedVal2 = $('#scopeDescription option:selected').text()
				.split(",")[1];
		var scopeLoad = scopeSelectedVal + scopeSelectedVal2;

		if (scopeSelectedVal == 'IBM owned') {
			$("#swfinanceResp").find("option[value='CUSTO']").css({
				display : "none"
			});
			$('#swfinanceResp option[value="IBM"]').attr("selected", true);
		}
		if (scopeLoad != 'Customer owned Customer managed') {
			$('#swfinanceResp option[value="N/A"]').css({
				display : "none"
			});
			$("#swfinanceResp").find("option[value='N/A']").css({
				display : "none"
			});
		}
	}

	function levelSltChng(objSelect) {
		var value = objSelect.value;
		levelChange(value);
	}

	function levelChange(value) {
		if (value == 'HWOWNER') {
			if ($('#hwOwner').length) {
				$("#hwownerLabel").show();
				$("#hwOwner").show();
				hwowerChng();
			} else {
				$("#levelSpan")
						.after(
								'<label id="hwownerLabel" for="hwOwner">Hwowner:</label>'
										+ '<span><select name="hwOwner" id="hwOwner" onChange="hwowerChng()"> <option value="IBM">IBM</option><option value="CUSTO">CUSTO</option> </select></span>');
			}
		} else {
			$("#hwownerLabel").hide();
			$("#hwOwner").hide();
			$("#alertLabel1").remove();
			$("#alertLabel2").remove();
		}
		if (value == 'HWBOX') {
			if ($('#serial').length && $('#machineType').length) {
				$("#serialLabel").show();
				$("#serial").show();
				$("#machineTypeLabel").show();
				$("#machineType").show();
			} else {
				$("#levelSpan")
						.after(
								'<label id="serialLabel" for="serialNumber">Serial:</label>'
										+ '<span><input name="serial" id="serial" value="" size="40"></span>'
										+ '<label id="machineTypeLabel" for="machineType">MachineType:</label>'
										+ '<span><input name="machineType" id="machineType" value="" size="40" onKeyUp="keyup(this)"></span>');
			}
		} else {
			$("#serialLabel").hide();
			$("#serial").hide();
			$("#machineTypeLabel").hide();
			$("#machineType").hide();
			$("#alertLabel1").remove();
			$("#alertLabel2").remove();
		}
		if (value == 'HOSTNAME') {
			if ($('#hostName').length) {
				$("#hostnameLabel").show();
				$("#hostName").show();
			} else {
				$("#levelSpan")
						.after(
								'<label id="hostnameLabel" for="hostName">Hostname:</label>'
										+ '<span><input name="hostName" id="hostName" value="" size="40"></span>');
			}
		} else {
			$("#hostnameLabel").hide();
			$("#hostName").hide();
			$("#alertLabel1").remove();
			$("#alertLabel2").remove();
		}
	}

	function hwowerChng() {
		var levelvalue = $('#level option:selected').val();
		var hwovalue = $('#hwOwner option:selected').val();
		var selectedVal = $('#scopeDescription option:selected').text().split(
				",")[0];
		$("#alertLabel1").remove();
		$("#alertLabel2").remove();
		if (levelvalue == 'HWOWNER') {
			if (hwovalue == 'IBM' && selectedVal != 'IBM owned') {

				$("#hwOwner")
						.after(
								'<label id="alertLabel1">Your selected HW owner is not matched to selected Scope !</label>');

			} else {
				$("#alertLabel1").remove();
			}

			if (hwovalue == 'CUSTO' && selectedVal != 'Customer owned') {

				$("#hwOwner")
						.after(
								'<label id="alertLabel2">Your selected HW owner is not matched to selected Scope !</label>');

			} else {
				$("#alertLabel2").remove();
			}
		}
	}

	$(document.body)
			.click(
					function(event) {
						var liveSearch = $("#jquery-live-search");
						if (liveSearch.length) {
							var clicked = $(event.target);
							if (!(clicked.is("#jquery-live-search")
									|| clicked.parents("#jquery-live-search").length || clicked
									.is(this))) {
								liveSearch.slideUp();
							}
						}
					});

	var lastValue = '';

	function keyup(type) {
		var value = $.trim(type.value);
		if (value == $.trim('') || value == '' || value == lastValue) {
			return;
		}
		lastValue = value;

		var liveSearch = $("#jquery-live-search");

		if (!liveSearch.length) {
			liveSearch = $("<div id='jquery-live-search'></div>").appendTo(
					document.body).hide().slideUp(0);
		}

		var inputPos = $(type).position();
		var inputHeight = $(type).outerHeight();

		liveSearch.css({
			"position" : "absolute",
			"top" : inputPos.top + inputHeight + "px",
			"left" : inputPos.left + "px"
		});

		if (this.timer) {
			clearTimeout(this.timer);
		}

		this.timer = setTimeout(
				function() {

					$
							.ajax({
								url : "${pageContext.request.contextPath}/admin/liveSearch.htm",
								async : true,
								type : "POST",
								data : {
									key : value,
									label : type.name
								},
								beforeSend : function() {
									liveSearch.empty();
									liveSearch.append("searching...").fadeIn(
											400);
								},
								error : function() {
									liveSearch.empty();
									liveSearch.append("error").fadeIn(400);
								},
								success : function(data, status) {
									liveSearch.empty();
									if (!data.length) {
										liveSearch
												.append("no matched item found.")
									} else {
										liveSearch.append(data);
									}
									liveSearch.show("slow");

									var over = {
										"color" : "white",
										"background" : "blue"
									};

									var out = {
										"color" : "black",
										"background" : "white"
									};

									$("li.prompt").hover(function() {
										$(this).css(over);
									}, function() {
										$(this).css(out);
									});

									$("li.prompt")
											.click(
													function() {
														if (type.name == 'softwareName') {
															type.value = $(this)
																	.text()
																	.slice(11,
																			-10);
															if ($(this)
																	.text()
																	.slice(
																			-10,
																			$(
																					this)
																					.text().length) == '(INACTIVE)') {
																$(
																		"#statusDescription")
																		.find(
																				'option[value="INACTIVE"]')
																		.attr(
																				"selected",
																				true);
																$(
																		"#statusDescription")
																		.find(
																				'option[value="ACTIVE"]')
																		.attr(
																				"disabled",
																				true);
															} else {
																$(
																		"#statusDescription")
																		.find(
																				'option[value="ACTIVE"]')
																		.attr(
																				"disabled",
																				false);
															}
														} else {
															type.value = $(this)
																	.text();
														}
													});
								}
							})
				}, 1000);

	}
	
	function searchData(scheduleFId) {
		var params = {};
		params['sort'] = 'id';
		params['dir'] = 'desc';
		
		$("#schFhTable").paginationTable('destroy').paginationTable({
			remote: {
				url: "${pageContext.request.contextPath}/ws/scheduleF/history/" + scheduleFId +"",
				type: "POST",
				params: params,
				success: function(result, pageIndex){
					var html = '';
					var list = result.data.list;
					if(null == list || list == undefined || list.length == 0){
						html += "<tr><td colspan='16' align='center'>No data found</td></tr>"
					}else{
						for(var i = 0; i < list.length; i++){
							html += "<tr>";
							html += "<td>" + list[i].softwareName + "</td>";
							html += "<td>" + list[i].level + "</td>";
							html += "<td>" + list[i].hwOwner + "</td>";
							html += "<td>" + list[i].hostname  + "</td>";
							html += "<td>" + list[i].serial + "</td>";
							html += "<td>" + list[i].machineType + "</td>";
							html += "<td>" + list[i].softwareTitle+ "</td>";
							html += "<td>" + list[i].manufacturer + "</td>";
							html += "<td>" + list[i].scopeDescription + "</td>";
							html += "<td>" + list[i].SWFinanceResp + "</td>";
							html += "<td>" + list[i].sourceDescription + "</td>";
							html += "<td>" + list[i].sourceLocation + "</td>";
							html += "<td>" + list[i].statusDescription + "</td>";
							html += "<td>" + list[i].businessJustification + "</td>";
							html += "<td>" + list[i].remoteUser + "</td>";
							html += "<td>" + list[i].recordTime + "</td>";
							html += "</tr>"; 
						}
					}
					$("#scheduleF_history_list").html(html);
				}
			},
			orderColumns: ['softwareName','level','hwOwner','hostname','serial','machineType','softwareTitle','manufacturer']
		});
	}

</script>

<div class="ibm-container">
	<div class="ibm-container-body">
		<h2>Schedule F details</h2>
		<div id="dialog"></div>
		<form id="myScheduleFForm" onsubmit="submitForm(); return false;"
			action="/" class="ibm-column-form" enctype="multipart/form-data"
			method="post">
			<div id="spinner">
				<span class="ibm-spinner-large"></span>
			</div>
			<p>
				<input name="id" id="id" value="" type="hidden" />
			</p>

			<p>
				<label for="softwareTitle">Software title:<span
					class="ibm-required">*</span></label> <span><input
					name="softwareTitle" id="softwareTitle" value="" size="40" /></span>
			</p>

			<p>
				<label for="softwareName">Software name:<span
					class="ibm-required">*</span></label><span> <input
					name="softwareName" id="softwareName" size="40"
					onKeyUp="keyup(this)" /></span> <span> <input
					name="softwareStatus" id="softwareStatus" value="" type="hidden" />
				</span> <span><input name="accountId" id="accountId"
					value="<s:property value='account.id' />" type="hidden" /></span>
			</p>

			<p>
				<label for="manufacturer">Manufacturer:<span
					class="ibm-required">*</span></label> <span><input size="40"
					id="manufacturer" name="manufacturer" /></span><span
					class="ibm-error-link" id="manufacturerError" style="display: none"></span><input
					type="hidden" id="manufacturerId" />
			</p>

			<p id="levelSpan">
				<label for="level">Level:</label> <span><select name="level"
					id="level" onchange="levelSltChng(this)">
						<option value="PRODUCT">PRODUCT</option>
						<option value="HWOWNER">HWOWNER</option>
						<option value="HWBOX">HWBOX</option>
						<option value="HOSTNAME">HOSTNAME</option>
				</select></span>
				<label id="hwownerLabel" for="hwOwner">Hwowner:</label> <span>
					<select name="hwOwner" id="hwOwner" onChange="hwowerChng()">
						<option value="IBM">IBM</option>
						<option value="CUSTO">CUSTO</option>
				</select>
				</span> <label id="serialLabel" for="serialNumber">Serial:</label> <span><input
					name="serial" id="serial" value="" size="40"></span> <label
					id="machineTypeLabel" for="machineType">MachineType:</label> <span><input
					name="machineType" id="machineType" value="" size="40"
					onKeyUp="keyup(this)"></span> <label id="hostnameLabel"
					for="hostName">Hostname:</label> <span><input
					name="hostName" id="hostName" value="" size="40"></span>
			</p>
			<p>
				<label for="scopeDescription">Scope:</label> <span><select
					name="scopeDescription" id="scopeDescription">
				</select></span>
			</p>

			<p>
				<label for="swfinanceResp">SW Financial Resp:</label> <span><select
					name="swfinanceResp" id="swfinanceResp">
						<option value="N/A">N/A</option>
						<option value="IBM">IBM</option>
						<option value="CUSTO">CUSTO</option>
				</select></span>
			</p>
			<p>
				<label for="complianceReporting">Compliance reporting:</label> <span><s:text
						name="account.softwareComplianceManagement" /></span>
			</p>
			<p>
				<label for="sourceDescription">Source:</label> <span><select
					name="sourceDescription" id="sourceDescription">
				</select></span>
			</p>
			<p>
				<label for="sourceLocation">Source location:</label> <span><input
					name="sourceLocation" id="sourceLocation" value="" size="40"
					type="text"> </span>
			</p>
			<p>
				<label for="statusDescription">Status:</label> <span><select
					name="statusDescription" id="statusDescription">
				</select></span>
				<span><input name="statusId" id="statusId" value="" type="hidden" /></span>
			</p>
			<p>
				<label for="businessJustification">Business Justification:<span
					class="ibm-required">*</span></label> <span> <input type="text"
					value="" size="40" id="businessJustification"
					name="businessJustification" /></span><span class="ibm-error-link"
					id="businessJustificationError" style="display: none"></span>
			</p>
			<div class="ibm-alternate-rule">
				<hr>
			</div>
			<div class="ibm-buttons-row">
				<p>
					<input type="submit" class="ibm-btn-arrow-pri" name="ibm-submit"
						value="Submit" id="btnSubmit" />
				</p>
			</div>
		</form>
	</div>
</div>

<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table id="schFhTable" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table"
			summary="ScheduleF history table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Level</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Hw owner</span><span class="ibm-icon"></span></a></th>
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
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Business justification</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Remote User</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>date</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="scheduleF_history_list">
			</tbody>
		</table>
	</div>
</div>
