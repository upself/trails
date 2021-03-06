<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- BEGIN CASUE CODE  UPDATE -->
<script type="text/javascript">
	$(function() {
		initRespList();
		initPage();
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
							window.location.href = "${pageContext.request.contextPath}/admin/alertCause/list.htm";
						});
		$("#responsibility").change(function() {
			var id = $(this).children(":selected").attr("id");
			$("#responsibilityId").val(id);
		});
	});

	function initRespList() {
		var url = "${pageContext.request.contextPath}/ws/adminCauseCode/responsibilities";
		$.ajax({
			url : url,
			type : "GET",
			dataType : 'json',
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert(textStatus);
			},
			beforeSend : function() {
				showLoading();
			},
			success : function(data) {
				var list = data.dataList;
				for (var i = 0; i < list.length; i++) {
					$('#responsibility').append(
							$("<option></option>").attr({
								"value" : list[i].name,
								"id" : list[i].id
							})
									.text(list[i].name));
				}
			},
			complete : function() {
				hideLoading();
			}
		});
	}

	function initPage() {
		var url = "${pageContext.request.contextPath}/ws/adminCauseCode/cause/<s:property value='alertCauseId' />/type/<s:property value='alertTypeId' />";
		$
				.ajax({
					url : url,
					type : "GET",
					dataType : 'json',
					error : function(XMLHttpRequest, textStatus, errorThrown) {
						alert(textStatus);
					},
					beforeSend : function() {
						showLoading();
					},
					success : function(result) {
						$("#alertTypeId").val(result.data.pk.alertType.id);
						$("#alertTypename").text(result.data.pk.alertType.name);
						$("#causeTypeId").val(result.data.pk.alertCause.id);
						$("#causeType").val(result.data.pk.alertCause.name);
						$("#responsibilityId")
								.val(
										result.data.pk.alertCause.alertCauseResponsibility.id);
						$("#responsibility")
								.val(
										result.data.pk.alertCause.alertCauseResponsibility.name);
						$("#status").val(result.data.status);
					},
					complete : function() {
						hideLoading();
					}
				});
	}

	function callRestApi() {

		var obj = "{\"pk\":{\"alertType\":{\"id\":" + $("#alertTypeId").val()
				+ ",\"name\":\" " + $("#alertTypename").text()
				+ "\",\"code\":\"\"},\"alertCause\":{\"id\":"
				+ $("#causeTypeId").val() + ",\"name\":\" "
				+ $("#causeType").val()
				+ "\",\"showInGui\":true,\"alertCauseResponsibility\":{\"id\":"
				+ $("#responsibilityId").val() + " ,\"name\":\" "
				+ $("#responsibility").val() + "\"}}},\"status\":\""
				+ $("#status").val() + "\"}";

		var urlRequest = "${pageContext.request.contextPath}/ws/adminCauseCode/saveOrUpdate";

		jQuery.ajax({
			cache : true,
			async : false,
			method : 'PUT',
			url : urlRequest,
			contentType : "application/json",
			data : obj,
			beforeSend : function() {
				showLoading();
			},
			headers : {
				"Access-Control-Allow-Headers" : "Content-Type"
			},
			success : function(data) {
				afterSubmit(data);
			},
			error : function(jqXHR, status, error) {
				afterSubmit(status + ":" + error);
			},
			complete : function() {
				hideLoading();
			}
		});

	}

	function afterSubmit(data) {

		var message = data.msg;
		var urlSuccess = "${pageContext.request.contextPath}/admin/alertCause/list.htm";

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

	function validateEmpty() {
		var passed = true;

		if ($("#causeType").val() == null || $("#causeType").val() == '') {
			$("#causeTypeError").text("Please enter Alert Cause Name.");
			$("#causeTypeError").css("display", "block");
			passed = false;
		}

		return passed;
	}

	function resetErrors() {
		$("#causeTypeError").css("display", "none");
	}

	function openLink(url) {
		window.location.href = url;
	}

	function showLoading() {
		$('#loading').show();
	}

	function hideLoading() {
		$('#loading').hide();
	}
</script>
<br/>
<div id="dialog"></div>
<div class="ibm-columns">
    <p class="ibm-confidential">IBM Confidential</p>
    <div class="ibm-col-1-1">    
		<p>Edit the cause code's name. Press the Save button to save your
			changes. Fields marked with an asterisk (*) are required.</p>
		<br />
		<form class="ibm-column-form">
			<span class="ibm-spinner-large" id="loading" style="display: none"></span>
			<!--Alert -->
			<p>
				<label for="alertTypename">Alert:<span class="ibm-required">*</span>
				</label><span> <label id="alertTypename" name="alertTypename"></label>
				</span> <input type="hidden" id="alertTypeId" />
			</p>

			<!-- Name -->
			<p>
				<label for="causeType">Name:<span class="ibm-required">*</span></label>
				<span><input size="40" id="causeType" name="causeType" /></span><span
					class="ibm-error-link" id="causeTypeError" style="display: none"></span>
				<input type="hidden" id="causeTypeId" />
			</p>
			<!--Responsibility-->
			<p>
				<label for="responsibility">Responsibility:<span
					class="ibm-required">*</span>
				</label> <span> <select name="responsibility" id="responsibility"
					style="max-width: 270px;">
				</select>
				</span> <input type="hidden" id="responsibilityId" />
			</p>
			<!-- Status -->
			<p>
				<label for="status">Status:<span class="ibm-required">*</span>
				</label> <span><select id="status" name="status">
						<option value="ACTIVE" selected="selected">ACTIVE</option>
						<option value="INACTIVE">INACTIVE</option>
				</select></span>
			</p>

			<div class="ibm-buttons-row">
				<p>
					<input type="button" class="ibm-btn-pri" name="ibm-submit"
						value="Submit" id="btnSubmit" /> <input type="button"
						class="ibm-btn-pri" name="ibm-cancel" value="Cancel"
						id="btnCancel" />
				</p>
			</div>
		</form>
	</div>
</div>
<!-- END CASUE CODE  UPDATE -->





