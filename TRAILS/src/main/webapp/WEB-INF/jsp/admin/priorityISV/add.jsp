<!-- BEGIN PRIORITY ISV ADD -->
<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
<style>
.ui-autocomplete-loading {
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
</style>
<script type="text/javascript">
	function isArray(obj) {
		return Object.prototype.toString.call(obj) === '[object Array]';
	}

	$(function() {

		var requestUri = "${pageContext.request.contextPath}/search/accountJson.htm";
		$("#account").autocomplete(
				{
					source : function(request, response) {
						$.ajax({
							url : requestUri,
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
						alert(ui.item ? "Selected: " + ui.item.label
								+ " value:" + ui.item.value + " id:"
								+ ui.item.id : "Nothing selected, input was "
								+ this.value);
					}
				});
	});
</script>

<div class="ibm-container">
	<div class="ibm-container-body">
		<h2>Add new priority ISV item.</h2>
		<form method="post" enctype="multipart/form-data"
			class="ibm-column-form" action="[test]">
			<p>
				<label for="level">Level:<span class="ibm-required">*</span>
					<span class="ibm-item-note">(e.g., Account, Global.)</span></label> <span><select
					id="level" name="level" onchange="levelChanged()">
						<option selected="selected" value="">Select one</option>
						<option value="account">Account</option>
						<option value="global">Global</option>
				</select></span>
			</p>

			<p>
				<label for="account">Account: <span class="ibm-required">*</span></label>
				<input id="account" size="40">
			</p>

			<p>
				<label for="manufacturer">Manufacturer:<span
					class="ibm-required">*</span></label> <span><input type="text"
					value="" size="40" id="manufacturer" name="manufacturer" /></span>
			</p>

			<p>
				<label for="evidenceLocation">Evidence location:<span
					class="ibm-required">*</span></label> <span><input type="text"
					value="" size="40" id="evidenceLocation" name="evidenceLocation" /></span>
			</p>

			<p>
				<label for="businessJustification">Business Justification:<span
					class="ibm-required">*</span></label> <span><input type="text"
					value="" size="40" id="businessJustification"
					name="businessJustification" /></span>
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
					<input type="submit" class="ibm-btn-arrow-pri" name="ibm-submit"
						value="Submit" />
				</p>
			</div>
		</form>
	</div>
</div>
<!-- END PRIORITY ISV ADD -->