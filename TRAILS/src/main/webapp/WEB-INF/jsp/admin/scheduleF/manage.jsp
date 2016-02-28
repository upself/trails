<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
<%@ taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
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
		}

		scopeFlip();

		$("#scopeDescription").change(
				function() {
					var scopeVal = $('#scopeDescription option:selected')
							.text().split(",")[0];
					var scopeVal2 = $('#scopeDescription option:selected')
							.text().split(",")[1];
					var scopeInIf = scopeVal + scopeVal2;

					if (scopeVal == 'IBM owned') {
						$("#swFinanceArrayList").find("option[value='CUSTO']")
								.css({
									display : "none"
								});
						$('#swFinanceArrayList option[value="IBM"]').attr(
								"selected", true);
					} else {
						$("#swFinanceArrayList").find("option[value='CUSTO']")
								.css({
									display : ""
								});
					}

					if (scopeInIf != 'Customer owned Customer managed') {
						$('#swFinanceArrayList option[value="IBM"]').attr(
								"selected", true);
						$("#swFinanceArrayList").find("option[value='N/A']")
								.css({
									display : "none"
								});
					} else {
						$("#swFinanceArrayList").find("option[value='N/A']")
								.css({
									display : ""
								});
					}
				});
		if ($('#softwareStatus').val() == 'true') {
			$("#statusDescription").find('option[value="2"]').attr("disabled",
					"disabled");
		} else {
			$("#statusDescription").find('option[value="2"]').removeAttr(
					"disabled");
		}

		var value = $('#levelArrayList').val();
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
		if (true) {
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
			if ($('#hwowerid').length) {
				$("div.hwownerLb").show();
				$("#hwownerLabel").show();
				$("div.hwownerva").show();
				$("#hwowerid").show();
			} else {
				$("#levelSpan")
						.after(
								'<div id="hwownerLb" class="float-left" style="width:30%;"><label id="hwownerLabel" for="hwowerid">Hwowner:</label></div>'
										+ '<div id="hwownerva" class="float-left" style="width:70%;"><select name="scheduleFView.hwowner" id="hwowerid"  onChange="hwowerChng()"><option value="IBM" selected="selected">IBM</option><option value="CUSTO">CUSTO</option></select></div>');
			}
		} else {
			$("div.hwownerLb").hide();
			$("#hwownerLabel").hide();
			$("div.hwownerva").hide();
			$("#hwowerid").hide();
			$("#alertLabel1").remove();
			$("div.alert1").empty();
			$("#alertLabel2").remove();
			$("div.alert2").empty();
		}
		if (value == 'HWBOX') {
			if ($('#serial').length && $('#machineType').length) {
				$("#serialLabel").show();
				$("#serial").show();
				$("#machineTypeLabel").show();
				$("#machineType").show();
				$("div.serialLb").show();
				$("div.serialva").show();
				$("div.machinetLb").show();
				$("div.machietva").show();
			} else {
				$("#levelSpan")
						.after(
								'<div id="serialLb" class="float-left" style="width:30%;"><label id="serialLabel" for="serialNumber">Serial:</label></div>'
										+ '<div id="serialva" class="float-left" style="width:70%;"><input type="text" name="scheduleFView.serial" value="" id="serial"/></div>'
										+ '<div id="machinetLb" class="float-left" style="width:30%;"><label id="machineTypeLabel" for="machineType">MachineType:</label></div>'
										+ '<div id="machietva" class="float-left" style="width:70%;"><input type="text" name="scheduleFView.machineType" value="" id="machineType" onKeyUp="keyup(this)"/></div>');
			}
		} else {
			$("#serialLabel").hide();
			$("#serial").hide();
			$("#machineTypeLabel").hide();
			$("#machineType").hide();
			$("div.serialLb").hide();
			$("div.serialva").hide();
			$("div.machinetLb").hide();
			$("div.machietva").hide();
			$("#alertLabel1").remove();
			$("div.alert1").empty();
			$("#alertLabel2").remove();
			$("div.alert2").empty();
		}
		if (value == 'HOSTNAME') {
			if ($('#hostname').length) {
				$("#hostnameLabel").show();
				$("#hostname").show();
				$("div.hwownerLb").show();
				$("div.hwownerva").show();
			} else {
				$("#levelSpan")
						.after(
								'<div id="hostnameLb" class="float-left" style="width:30%;"><label id="hostnameLabel" for="hostname">Hostname:</label></div>'
										+ '<div id="hostnameva" class="float-left" style="width:70%;"><input type="text" name="scheduleFView.hostname" value="" id="hostname"/></div>');
			}
		} else {
			$("#hostnameLabel").hide();
			$("#hostname").hide();
			$("div.hwownerLb").hide();
			$("div.hwownerva").hide();
			$("#alertLabel1").remove();
			$("div.alert1").empty();
			$("#alertLabel2").remove();
			$("div.alert2").empty();
		}
	}

	function hwowerChng() {
		var levelvalue = $('#levelArrayList option:selected').val();
		var hwovalue = $('#hwowerid option:selected').val();
		var selectedVal = $('#scopeArrayList option:selected').text()
				.split(",")[0];
		$("#alertLabel1").remove();
		$("div.alert1").empty();
		$("#alertLabel2").remove();
		$("div.alert2").empty();
		if (levelvalue == 'HWOWNER') {
			if (hwovalue == 'IBM' && selectedVal != 'IBM owned') {

				$("#level")
						.after(
								'<div id="alert1" class="float-left" " style="width:30%;color:RED;"><label id="alertLabel1">Your selected HW owner is not matched to selected Scope !</label></div>');

			} else {
				$("#alertLabel1").remove();
				$("div.alert1").empty();
			}

			if (hwovalue == 'CUSTO' && selectedVal != 'Customer owned') {

				$("#level")
						.after(
								'<div id="alert2" class="float-left" " style="width:30%;color:RED;"><label id="alertLabel2">Your selected HW owner is not matched to selected Scope !</label></div>');

			} else {
				$("#alertLabel2").remove();
				$("div.alert2").empty();
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
		var currentSw = $("#softwareName").val();
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
														if (type.name == currentSw) {
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
																$("#statusDescription")
																		.find(
																				'option[value="1"]')
																		.attr(
																				"selected",
																				true);
																$("#statusDescription")
																		.find(
																				'option[value="2"]')
																		.attr(
																				"disabled",
																				"disabled");
															} else {
																$("#statusDescription")
																		.find(
																				'option[value="2"]')
																		.removeAttr(
																				"disabled");
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
</script>

<div class="ibm-container">
	<div class="ibm-container-body">
		<h2>Schedule F details</h2>

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
				<label for="softwareTitle">Software title:</label> <input
					name="softwareTitle" id="softwareTitle" value="" size="40"
					type="text" >
			</p>

			<p>
				<label for="softwareName">Software name:</label> <input
					name="softwareName" id="softwareName" value="" size="40"
					type="text" onKeyUp="keyup(this)">
			</p>
			<p>
				<input name="softwareStatus" id="softwareStatus" value=""
					type="hidden" />
			</p>
			<p>
				<input name="accountId" id="accountId"
					value="<s:property value='account.id' />" type="hidden" />
			</p>
			<p>
				<label for="manufacturer">Manufacturer:</label> <input
					name="manufacturer" id="manufacturer" value="" size="40"
					type="text">
			</p>

			<p>
				<label for="scopeArrayList">Level:</label> <select name="level"
					id="level" onchange="levelSltChng(this)">
					<option value="PRODUCT">PRODUCT</option>
					<option value="HWOWNER">HWOWNER</option>
					<option value="HWBOX">HWBOX</option>
					<option value="HOSTNAME">HOSTNAME</option>
				</select>

			</p>

			<div class="clear"></div>
			<div id="levelSpan"></div>

			<p>
				<label id="hwownerLabel" for="hwOwner">Hwowner:</label> <select
					name="hwOwner" id="hwOwner" onChange="hwowerChng()">
					<option value="IBM">IBM</option>
					<option value="CUSTO">CUSTO</option>
				</select>
			</p>


			<p>
				<label id="serialLabel" for="serialNumber">Serial:</label> <input
					name="serial" id="serial" value="" size="40" type="text"
					onKeyUp="keyup(this)">
			</p>
			<p>
				<label id="machineTypeLabel" for="machineType">MachineType:</label>
				<input name="machineType" id="machineType" value="" size="40"
					type="text" onKeyUp="keyup(this)">
			</p>


			<p>
				<label id="hostnameLabel" for="hostName">Hostname:</label> <input
					name="hostName" id="hostName" value="" size="40" type="text"
					>
			</p>

			<div id="level"></div>
			<div class="clear"></div>

			<p>
				<label for="scopeDescription">Scope:</label> <select
					name="scopeDescription" id="scopeDescription">
				</select>
			</p>

			<p>
				<label for="swfinanceResp">SW Financial Resp:</label> <select
					name="swfinanceResp" id="swfinanceResp">
					<option value="N/A">N/A</option>
					<option value="IBM">IBM</option>
					<option value="CUSTO">CUSTO</option>
				</select>
			</p>
			<p>
				<label for="complianceReporting">Compliance reporting:</label>
				<s:text name="account.softwareComplianceManagement" />
			</p>

			<p>
				<label for="sourceDescription">Source:</label> <select
					name="sourceDescription" id="sourceDescription">
				</select>
			</p>

			<p>
				<label for="sourceLocation">Source location:</label> <input
					name="sourceLocation" id="sourceLocation" value="" size="40"
					type="text" >
			</p>

			<p>
				<label for="statusDescription">Status:</label> <select
					name="statusDescription" id="statusDescription">
				</select>
			</p>
			<p>
				<input name="statusId" id="statusId" value="" type="hidden" />
			</p>

			<p>
				<label for="businessJustification">Business Justification:<span
					class="ibm-required">*</span></label> <input type="text" value="" size="40"
					id="businessJustification" name="businessJustification" /><span
					class="ibm-error-link" id="businessJustificationError"
					style="display: none"></span>
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


