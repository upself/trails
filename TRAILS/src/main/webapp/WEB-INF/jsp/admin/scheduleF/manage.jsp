<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jquery.liveSearch.js"
	type="text/javascript"></script>
	<link rel="stylesheet"
	href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
<style>
.ui-autocomplete-loading, .isv-submiting {
	background: white
		url("${pageContext.request.contextPath}/images/ui-anim_basic_16x16.gif")
		right center no-repeat;
}

.ui-autocomplete {
	max-height: 200px;
	overflow-y: auto;
	/* prevent horizontal scrollbar */
	overflow-x: hidden;
}

.no-close .ui-dialog-titlebar-close {
	display: none
}

#progressbar .ui-progressbar-value {
	background-color: #ccc;
}

* html .ui-autocomplete {
	height: 200px;
}
</style>
<script type="text/javascript">
	var loadingMsg = "<p id=\"dialogmsg\">Loading in progress, please wait a while.</p><div id=\"progressbar\"></div>";

	function isArray(obj) {
		return Object.prototype.toString.call(obj) === '[object Array]';
	}

	$(function() {

		initPage();

		$("#level").change(function() {
			var levelVal = $("#level").val();
			if (levelVal == 'account') {
				$('#inputAccount').css("display", "block");
			} else {
				$('#inputAccount').css("display", "none");
			}
		});

		var searchAccountJsonURI = "${pageContext.request.contextPath}/search/accountJson.htm";
		$("#account").autocomplete(
				{
					change : function(event, ui) {
						if (ui.item == null) {
							$("#customerId").val('');
						}
					},
					source : function(request, response) {
						$.ajax({
							url : searchAccountJsonURI,
							dataType : "json",
							data : {
								q : request.term
							},
							success : function(data) {
								if (isArray(data)) {
									var result = new Array()
									for (i = 0; i < data.length; i++) {
										var obj = {
											"id" : data[i].accountId,
											"label" : data[i].account + "-"
													+ data[i].accountName,
											"value" : data[i].account + "-"
													+ data[i].accountName
										};
										result.push(obj);
									}
									response(result);
								} else {
									response(data);
								}
							}
						});
					},
					minLength : 3,
					select : function(event, ui) {
						$("#customerId").val(ui.item.id);
					}
				});

		var manufacturerJsonURI = "${pageContext.request.contextPath}/admin/priorityISV/manufacturer.htm";
		$("#manufacturer").autocomplete(
				{
					change : function(event, ui) {
						if (ui.item == null) {
							$("#manufacturerId").val('');
						}
					},
					source : function(request, response) {
						$.ajax({
							url : manufacturerJsonURI,
							dataType : "json",
							data : {
								q : request.term
							},
							success : function(data) {
								if (isArray(data)) {
									var result = new Array()
									for (i = 0; i < data.length; i++) {
										var obj = {
											"id" : data[i].id,
											"label" : data[i].manufacturerName
													+ "-" + data[i].definitionSource,
											"value" : data[i].manufacturerName
													+ "-" + data[i].definitionSource,
										};
										result.push(obj);
									}
									response(result);
								} else {
									response(data);
								}
							}
						});
					},
					minLength : 3,
					select : function(event, ui) {
						$("#manufacturerId").val(ui.item.id);
					}
				});

		$("#btnSubmit").click(function() {
			resetErrors();
			if (validateEmpty()) {
				callRestApi();
			}

			return false;
		});

		$("#btnCancel")
				.click(
						function() {
							window.location.href = "${pageContext.request.contextPath}/admin/priorityISV/list.htm";
						});

	});

	function initPage() {
		$("#dialog").html(loadingMsg);
		$("#dialog").dialog({
			dialogClass : 'no-close',
			closeOnEscape : false,
			modal : true,
			width : 500,
			open : function(event, ui) {
				$("#progressbar").progressbar({
					value : false
				});
			},
			title : "Loading",
			buttons : {}
		});

		var urlRequest = "${pageContext.request.contextPath}/ws/priorityISV/isv/<s:property value='id' />";
		jQuery.ajax({
			url : urlRequest,
			method : "GET",
			success : function(result) {
				var level = result.data.level.toLowerCase();
				$("#level").val(level);
				if (level == 'account') {
					$('#inputAccount').css("display", "block");
					$("#account").val(
							result.data.accountNumber + "-"
									+ result.data.accountName);
					$("#customerId").val(result.data.customerId);
				}

				$("#manufacturerId").val(result.data.manufacturerId);
				$("#manufacturer").val(result.data.manufacturerName);
				$("#evidenceLocation").val(result.data.evidenceLocation);
				$("#status").val(result.data.statusId);
				$("#businessJustification").val(
						result.data.businessJustification);
				$("#dialog").dialog("close");
			}

		});
	}

	function callRestApi() {

		if ($("#level").val() == 'global') {
			$("#customerId").val('');
			$("#account").val('');
		}

		var obj = "{\"level\":\"" + $("#level").val() + "\",\"customerId\":\""
				+ $("#customerId").val() + "\",\"manufacturerId\":\""
				+ $("#manufacturerId").val() + "\",\"evidenceLocation\":\""
				+ $("#evidenceLocation").val() + "\",\"statusId\":\""
				+ $("#status").val() + "\",\"businessJustification\":\""
				+ $("#businessJustification").val() + "\"}";

		var urlRequest = "${pageContext.request.contextPath}/ws/priorityISV/isv/<s:property value='id' />";

		jQuery.ajax({
			cache : true,
			async : false,
			method : 'PUT',
			url : urlRequest,
			contentType : "application/json",
			data : obj,
			beforeSend : function() {
				$("#dialogmsg").text("");
				$("#dialog").dialog({
					title : "Updating priority ISV",
					dialogClass : 'no-close',
					closeOnEscape : false,
					modal : true,
					width : 500,
					open : function(event, ui) {
						$("#progressbar").progressbar({
							value : false
						});
					}
				});
			},
			headers : {
				"Access-Control-Allow-Headers" : "Content-Type"
			},
			success : function(data) {
				submitEnded(data);
			},
			error : function(jqXHR, status, error) {
				submitEnded(status + ":" + error);
			}
		});

	}

	function submitEnded(data) {

		var message = data.msg;
		var urlSuccess = "${pageContext.request.contextPath}/admin/priorityISV/list.htm";

		$("#progressbar").progressbar("disable");

		if (data.status == '200') {
			$("#dialog").text(message + " Click OK redirect to list page.");
			$("#dialog").dialog({
				title : "Done",
				modal : true,
				buttons : {
					Ok : function() {
						$("#dialog").dialog("close");
						window.location.href = urlSuccess;
					}
				}
			});
		} else {
			$("#dialog").text(message);
			$("#dialog").dialog({
				title : "Done",
				modal : true,
				buttons : {
					Ok : function() {
						$("#dialog").dialog("close");
						initPage();
					}
				}
			});
		}

	}

	function resetErrors() {
		$("#levelError").css("display", "none");
		$("#accountError").css("display", "none");
		$("#manufacturerError").css("display", "none");
		$("#evidenceLocationError").css("display", "none");
		$("#businessJustificationError").css("display", "none");
	}

	function validateEmpty() {
		var passed = true;
		var isLevelGoodForAccount = false;
		if ($("#level").val() == null || $("#level").val() == '') {
			$("#levelError").text("Please select a level");
			$("#levelError").css("display", "block");
			passed = false;
		} else {
			if ($("#level").val() == 'account') {
				isLevelGoodForAccount = true;
			}
		}

		if (isLevelGoodForAccount
				&& ($("#customerId").val() == null || $("#customerId").val() == '')) {
			$("#accountError").text("Please chose a valid account.");
			$("#accountError").css("display", "block");
		}

		if ($("#evidenceLocation").val() == null
				|| $("#evidenceLocation").val() == '') {
			$("#evidenceLocationError").text("Please enter evidence location.");
			$("#evidenceLocationError").css("display", "block");
			passed = false;
		}

		if ($("#manufacturerId").val() == null
				|| $("#manufacturerId").val() == '') {
			$("#manufacturerError").text("Please select a valid manufacturer.");
			$("#manufacturerError").css("display", "block");
			passed = false;
		}

		if ($("#businessJustification").val() == null
				|| $("#businessJustification").val() == '') {
			$("#businessJustificationError").text(
					"Please enter business justification.");
			$("#businessJustificationError").css("display", "block");
			passed = false;
		}

		return passed;
	}
</script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						var flag = '${scheduleFId}';
						if (flag == '') {
							$('#scopeArrayList option[value="3"]').attr(
									"selected", true);
							$('#swFinanceArrayList option[value="IBM"]').attr(
									"selected", true);
						}

						//AB added begin
						var scopeSelectedVal = $(
								'#scopeArrayList option:selected').text()
								.split(",")[0];
						var scopeSelectedVal2 = $(
								'#scopeArrayList option:selected').text()
								.split(",")[1];
						var scopeLoad = scopeSelectedVal + scopeSelectedVal2;

						if (scopeSelectedVal == 'IBM owned') {
							$("#swFinanceArrayList").find(
									"option[value='CUSTO']").css({
								display : "none"
							});
							$('#swFinanceArrayList option[value="IBM"]').attr(
									"selected", true);
						}
						;

						if (scopeLoad != 'Customer owned Customer managed') {
							$('#swFinanceArrayList option[value="N/A"]').css({
								display : "none"
							});
							$("#swFinanceArrayList")
									.find("option[value='N/A']").css({
										display : "none"
									});
						}
						;

						$("#scopeArrayList")
								.change(
										function() {
											var scopeVal = $(
													'#scopeArrayList option:selected')
													.text().split(",")[0];
											var scopeVal2 = $(
													'#scopeArrayList option:selected')
													.text().split(",")[1];
											var scopeInIf = scopeVal
													+ scopeVal2;

											if (scopeVal == 'IBM owned') {
												$("#swFinanceArrayList")
														.find(
																"option[value='CUSTO']")
														.css({
															display : "none"
														});
												$(
														'#swFinanceArrayList option[value="IBM"]')
														.attr("selected", true);
											} else {
												$("#swFinanceArrayList")
														.find(
																"option[value='CUSTO']")
														.css({
															display : ""
														});
											}

											if (scopeInIf != 'Customer owned Customer managed') {
												$(
														'#swFinanceArrayList option[value="IBM"]')
														.attr("selected", true);
												$("#swFinanceArrayList").find(
														"option[value='N/A']")
														.css({
															display : "none"
														});
											} else {
												$("#swFinanceArrayList").find(
														"option[value='N/A']")
														.css({
															display : ""
														});
											}
										});
						//AB added end

						if ($('#softwareStatus').val() == 'true') {
							$('select[id="statusArrayList"]').find(
									'option[value="2"]').attr("disabled",
									"disabled");
						} else {
							$('select[id="statusArrayList"]').find(
									'option[value="2"]').removeAttr("disabled");
						}

						var value = $('#levelArrayList').val();
						levelChange(value);

					});

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
														if (type.name == 'scheduleFView.softwareName') {
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
																		'select[id="statusArrayList"]')
																		.find(
																				'option[value="1"]')
																		.attr(
																				"selected",
																				true);
																$(
																		'select[id="statusArrayList"]')
																		.find(
																				'option[value="2"]')
																		.attr(
																				"disabled",
																				"disabled");
															} else {
																$(
																		'select[id="statusArrayList"]')
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
<div id="dialog"></div>
<div class="ibm-container">
	<div class="ibm-container-body">
		<h2>Schedule F details</h2>

		<form id="myForm" onsubmit="submitForm(); return false;" action="/"
			class="ibm-column-form" enctype="multipart/form-data" method="post">
		
			<s:if test="#request.scheduleFView != null">
				<p>
				<input name="id"
					value="<s:property value='#request.scheduleFView.id'/>"
					type="hidden" />
					</p>
			</s:if>
        
			<p>
				<label for="softwareTitle">Software title:</label> <input
					name="scheduleFView.softwareTitle" id="softwareTitle"
					value="<s:property value='#request.scheduleFView.softwareTitle'/>"
					size="40" type="text" onKeyUp="keyup(this)">
			</p>

			<p>
				<label for="softwareName">Software name:</label> <input
					name="scheduleFView.softwareName" id="softwareName"
					value="<s:property value='#request.scheduleFView.softwareName'/>"
					size="40" type="text" onKeyUp="keyup(this)">
			</p>
			<p>
			<s:hidden id="softwareStatus" name="scheduleFView.softwareStatus" />
            </p>
			<p>
				<label for="manufacturer">Manufacturer:</label> <input
					name="scheduleFView.manufacturer" id="manufacturer"
					value="<s:property value='#request.scheduleFView.manufacturer'/>"
					size="40" type="text" onKeyUp="keyup(this)">
			</p>

			<p>
				<label for="scopeArrayList">Level:</label> <select name="level"
					id="level_id">
					<option value="PRODUCT"
						<s:if test="#request.scheduleFView.level eq 'PRODUCT'">selected="selected"</s:if>>PRODUCT</option>
					<option value="HWOWNER"
						<s:if test="#request.scheduleFView.level eq 'HWOWNER'">selected="selected"</s:if>>HWOWNER</option>
					<option value="HWBOX"
						<s:if test="#request.scheduleFView.level eq 'HWBOX'">selected="selected"</s:if>>HWBOX</option>
					<option value="HOSTNAME"
						<s:if test="#request.scheduleFView.level eq 'HOSTNAME'">selected="selected"</s:if>>HOSTNAME</option>
				</select>

			</p>

			<div class="clear"></div>
			<div id="levelSpan"></div>
			<s:if test="%{scheduleFView.hwowner!=null}">
				<p>
					<label id="hwownerLabel" for="hwowerid">Hwowner:</label> <select
						name="scheduleFView.hwowner" id="hwowerid" onChange="hwowerChng()">
						<option value="IBM">IBM</option>
						<option value="CUSTO">CUSTO</option>
					</select>
				</p>
			</s:if>

			<s:if
				test="%{scheduleFView.serial!=null && scheduleFView.machineType!=null}">
				<p>
					<label id="serialLabel" for="serialNumber">Serial:</label> <input
						name="scheduleFView.serial" id="serial"
						value="<s:property value='#request.scheduleFView.serial'/>"
						size="40" type="text" onKeyUp="keyup(this)">
				</p>
				<p>
					<label id="machineTypeLabel" for="machineType">MachineType:</label>
					<input name="scheduleFView.machineType" id="machineType"
						value="<s:property value='#request.scheduleFView.machineType'/>"
						size="40" type="text" onKeyUp="keyup(this)">
				</p>
			</s:if>
			<s:if test="%{scheduleFView.hostname!=null}">
				<p>
					<label id="hostnameLabel" for="hostname">Hostname:</label> <input
						name="scheduleFView.hostname" id="hostname"
						value="<s:property value='#request.scheduleFView.hostname'/>"
						size="40" type="text" onKeyUp="keyup(this)">
				</p>
			</s:if>
			<div id="level"></div>
			<div class="clear"></div>

			<p>
				<label for="scopeArrayList">Scope:</label>
				<s:select id="scopeArrayList" list="scopeArrayList" listKey="id"
					listValue="description" name="scheduleFView.scopeId"
					onChange="hwowerChng()" />
			</p>

			<!-- AB added -->
			<p>
				<label for="swFinanResp">SW Financial Resp:</label> <select
					name="scheduleFView.swFinanResp" id="swFinanResp_id">
					<option value="N/A"
						<s:if test="#request.scheduleFView.swFinanResp eq 'N/A'">selected="selected"</s:if>>N/A</option>
					<option value="IBM"
						<s:if test="#request.scheduleFView.swFinanResp eq 'IBM'">selected="selected"</s:if>>IBM</option>
					<option value="CUSTO"
						<s:if test="#request.scheduleFView.swFinanResp eq 'CUSTO'">selected="selected"</s:if>>CUSTO</option>
				</select>
			</p>
			<p>
				<label for="complianceReporting">Compliance reporting:</label>
				<s:text name="account.softwareComplianceManagement" />
			</p>

			<p>
				<label for="sourceArrayList">Source:</label>
				<s:select id="sourceArrayList" list="sourceArrayList" listKey="id"
					listValue="description" name="scheduleFView.sourceId" />
			</p>

			<p>
				<label for="sourceLocation">Source location:</label> <input
					name="scheduleFView.sourceLocation" id="sourceLocation"
					value="<s:property value='#request.scheduleFView.sourceLocation'/>"
					size="40" type="text" onKeyUp="keyup(this)">
			</p>

			<p>
				<label for="statusArrayList">Status:</label>
				<s:select id="statusArrayList" list="statusArrayList" listKey="id"
					listValue="description" name="scheduleFView.statusId" />
			</p>

			<p>
				<label for="businessJustification">Business Justification:<span
					class="ibm-required">*</span></label> <input type="text"
					value="" size="40" id="businessJustification"
					name="scheduleFView.businessJustification" /><span
					class="ibm-error-link" id="businessJustificationError"
					style="display: none"></span>
			</p>
			<div class="ibm-alternate-rule">
				<hr>
			</div>
			<div class="ibm-buttons-row">
				<p>
					<input type="button" class="ibm-btn-arrow-pri" name="ibm-submit"
						value="Submit" id="btnSubmit" /> <input type="button"
						class="ibm-btn-arrow-pri" name="ibm-cancel" value="Cancel"
						id="btnCancel" />
				</p>
			</div>

		</form>
	</div>
</div>

<%-- <display:table name="scheduleF.scheduleFHList" class="basic-table" id="row" summary="Schedule F list"
	decorator="org.displaytag.decorator.TotalTableDecorator" cellspacing="1"
	cellpadding="0">
	<display:column property="softwareName" title="Software name" />
	<display:column property="level" title="Level" />
	<display:column property="hwOwner" title="Hw owner" />
	<display:column property="hostname" title="Hostname" />
	<display:column property="serial" title="Serial" />
	<display:column property="machineType" title="Machine Type" />
	<display:column property="softwareTitle" title="Software title" />
	<display:column property="manufacturer" title="Manufacturer" />
	<display:column property="scope.description"  title="Scope" />
		<!-- AB added -->
	<display:column property="SWFinanceResp"  title="SW Financial Resp" />
	
	<display:column property="source.description"  title="Source" />
	<display:column property="sourceLocation" title="Source location" />
	<display:column property="status.description" title="Status" />
	<display:column property="businessJustification"
		title="Business justification" />
	<display:column property="remoteUser" title="Remote User" />
	<display:column property="recordTime" class="date"
		format="{0,date,MM-dd-yyyy}" title="Record Time" />
</display:table> --%>
