<div class="ibm-columns">
	<div class="ibm-col-1-1">
	<p class="ibm-confidential">IBM Confidential</p>
	<p>
			Below is a list of the cause codes in the application. Press one
	of the links to edit the cause code details. You can also add a new
	cause code to the application by pressing the Add a cause code link.
	</p>
		<br />
	</div>
	<!-- SORTABLE DATA TABLE -->
	<div class="ibm-col-1-1">
		<div style="height: 80px; width: 100%; float: left">
			<div style="float: right">
				<div style="width: 200px">
					<p class='ibm-button-link'>
						<a class="ibm-btn-small" href="javascript:void(0)"
							onclick="openLink('${pageContext.request.contextPath}/admin/alertCause/add.htm')"
							id="addAlerCasue">Add cause code</a>
					</p>
				</div>
			</div>
		</div>
		<table id="alertcauseTable" cellspacing="0" cellpadding="0" border="0"
			class="ibm-data-table ibm-sortable-table" summary="Cause Code list">
			<thead>
				<tr>
					<th scope="col"><span>Alert</span><span class="ibm-icon"></span></th>
					<th scope="col"><span>Cause code name</span><span
						class="ibm-icon"></span></th>
					<th scope="col"><span>Responsibility</span><span
						class="ibm-icon"></span></th>
					<th scope="col"><span>Status</span><span class="ibm-icon"></span></th>
				</tr>
			</thead>
			<tbody id="cause_code_list" />
		</table>
		<span class="ibm-spinner-large" id="loading" style="display: none"></span>
		<span class="ibm-error-link" id="causeTypeError" style="display: none"></span>
	</div>

</div>
<script>
	$(function() {
		searchData();
	});

	function searchData() {
		var url = "${pageContext.request.contextPath}/ws/adminCauseCode/list";
		$
				.ajax({
					url : url,
					type : "GET",
					dataType : 'json',
					error : function(XMLHttpRequest, textStatus, errorThrown) {
						/*	alert(textStatus); */
						$("#causeTypeError").text(textStatus);
						$("#causeTypeError").css("display", "block");
					},
					beforeSend : function() {
						showLoading();
					},
					success : function(data) {
						var html = '';
						if (data.status == 400) {
							html += "<tr><td colspan='7'>" + data.msg
									+ "</td></tr>"
						} else {
							var list = data.dataList;
							for (var i = 0; i < list.length; i++) {
								html += "<tr>";
								html += "<td>" + list[i].pk.alertType.name
										+ "</td>";
								html += "<td><a href='${pageContext.request.contextPath}/admin/alertCause/edit.htm?alertCauseId="
										+ list[i].pk.alertCause.id
										+ "&alertTypeId="
										+ list[i].pk.alertType.id
										+ "'>"
										+ list[i].pk.alertCause.name + "</td>";
								html += "<td>"
										+ list[i].pk.alertCause.alertCauseResponsibility.name
										+ "</td>";
								html += "<td>" + list[i].status + "</td>";
								html += "</tr>";
							}
						}
						$("#cause_code_list").html(html);
					},
					complete : function() {
						hideLoading();
						$("#causeTypeError").css("display", "none");
					}
				});
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

