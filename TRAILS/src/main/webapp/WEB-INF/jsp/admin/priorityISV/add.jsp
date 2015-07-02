<!-- BEGIN PRIORITY ISV ADD -->
<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
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

* html .ui-autocomplete {
	height: 200px;
}

.no-close .ui-dialog-titlebar-close {
	display: none
}

#progressbar .ui-progressbar-value {
	background-color: #ccc;
}
</style>
<script type="text/javascript">
	function isArray(obj) {
		return Object.prototype.toString.call(obj) === '[object Array]';
	}

	$(function() {

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
													+ "-" + data[i].website,
											"value" : data[i].manufacturerName
													+ "-" + data[i].website,
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

	});

	function callRestApi() {

		var obj = "{\"level\":\"" + $("#level").val() + "\",\"customerId\":\""
				+ $("#customerId").val() + "\",\"manufacturerId\":\""
				+ $("#manufacturerId").val() + "\",\"evidenceLocation\":\""
				+ $("#evidenceLocation").val() + "\",\"statusId\":\""
				+ $("#status").val() + "\",\"businessJustification\":\""
				+ $("#businessJustification").val() + "\"}";

		var urlRequest = "${pageContext.request.contextPath}/ws/priorityISV/isv";

		jQuery.ajax({
			cache : true,
			async : false,
			method : 'PUT',
			url : urlRequest,
			contentType : "application/json",
			data : obj,
			beforeSend : function() {
				$("#dialog").dialog({
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
				submitEnded(data.msg);
			},
			error : function(jqXHR, status, error) {
				submitEnded(status + ":" + error);
			}
		});

	}

	function submitEnded(message) {
		var urlSuccess = "${pageContext.request.contextPath}/admin/priorityISV/list.htm";

		$("#progressbar").progressbar("disable");
		$("#dialog").text(message + " Click OK redirect to list page.");
		$("#dialog").dialog({
			title : "Done",
			modal : true,
			buttons : {
				Ok : function() {
					$(this).dialog("close");
					window.location.href = urlSuccess;
				}
			}
		});
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

<div class="ibm-container">
	<div class="ibm-container-body">
		<h2>Add new priority ISV item.</h2>
		<form class="ibm-column-form">
			<p>
				<label for="level">Level:<span class="ibm-required">*</span>
				</label> <span><select id="level" name="level"
					onchange="levelChanged()">
						<option selected="selected" value="">Select one</option>
						<option value="account">Account</option>
						<option value="global">Global</option>
				</select></span><span class="ibm-error-link" style="display: none" id="levelError"></span>
			</p>

			<p id="inputAccount" style="display: none">
				<label for="account">Account: <span class="ibm-required">*</span></label>
				<span><input id="account" size="40"></span><span
					class="ibm-error-link" id="accountError" style="display: none"></span>
				<input type="hidden" id="customerId" />
			</p>

			<p>
				<label for="manufacturer">Manufacturer:<span
					class="ibm-required">*</span></label> <span><input size="40"
					id="manufacturer" name="manufacturer" /></span><span
					class="ibm-error-link" id="manufacturerError" style="display: none"></span><input
					type="hidden" id="manufacturerId" />
			</p>

			<p>
				<label for="evidenceLocation">Evidence location:<span
					class="ibm-required">*</span></label> <span><input type="text"
					value="" size="40" id="evidenceLocation" name="evidenceLocation" /></span>
				<span class="ibm-error-link" id="evidenceLocationError"
					style="display: none"></span>
			</p>

			<p>
				<label for="status">Status:<span class="ibm-required">*</span>
				</label> <span><select id="status" name="status">
						<option value="2" selected="selected">ACTIVE</option>
						<option value="1">INACTIVE</option>
				</select></span>
			</p>

			<p>
				<label for="businessJustification">Business Justification:<span
					class="ibm-required">*</span></label> <span><input type="text"
					value="" size="40" id="businessJustification"
					name="businessJustification" /></span><span class="ibm-error-link"
					id="businessJustificationError" style="display: none"></span>
			</p>

			<div class="ibm-alternate-rule">
				<hr>
			</div>
			<p>Description to be added here.</p>
			<div class="ibm-rule">
				<hr>
			</div>
			<div class="ibm-buttons-row">
				<p>
					<input type="button" class="ibm-btn-arrow-pri" name="ibm-submit"
						value="Submit" id="btnSubmit" />
				</p>
			</div>
		</form>
	</div>
</div>
<div id="dialog" title="Submitting Priority ISV">
	<div id="progressbar"></div>
</div>
<!-- END PRIORITY ISV ADD -->