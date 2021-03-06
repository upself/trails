<script type="text/javascript">
	$(function() {
		var licenseId = ${licenseId};
		feedPage(licenseId);
		$("#titleContent").text("License Details: ${account.name}(${account.account})");
	});

	function feedPage(licenseId) {
		var urlRequest = "${pageContext.request.contextPath}/ws/license/detail/"
				+ licenseId + "";
		jQuery.ajax({
			url : urlRequest,
			type : "GET",
			timeout : 180000,
			beforeSend : function(XMLHttpRequest) {
				 $("#myForm").hide();
			},
			success : function(result) {
				$("#productName").text(result.data.productName);
				$("#catalogMatch").text(result.data.catalogMatch);
				$("#fullDesc").text(result.data.fullDesc);
				$("#swproPID").text(result.data.swproPID);
				$("#capacityType").text(result.data.capacityType);
				$("#totalQtyString").text(result.data.totalQtyString);
				$("#availableQtyString").text(result.data.availableQtyString);
				$("#expireDateString").text(result.data.expireDateString);
				$("#poNumber").text(result.data.poNumber);
				$("#cpuSerial").text(result.data.cpuSerial);
				$("#licenseOwner").text(result.data.licenseOwner);
				$("#poolAsString").text(result.data.poolAsString);
				$("#extSrcId").text(result.data.extSrcId);
				$("#recordTimeAsString").text(result.data.recordTimeAsString);
				$("#skuAsString").text(result.data.skuAsString);
				if (result.status != '200') {
					alert(result.msg);
				}
			},
			complete : function(XMLHttpRequest, status) {
				$("#spinner").hide();
				$("#myForm").show();
				if (status == 'timeout') {
					alert("Request Timeout !");
					this.abort();
				}
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
			}
		});
	}
</script>
<div class="ibm-columns">
<div class="ibm-col-1-1">
<p class="ibm-confidential">IBM Confidential</p>
</div>
		<div class="ibm-col-1-1">
		      <div class="ibm-rule">
			    <hr />
		      </div>
				<span id="spinner" class="ibm-spinner-large"></span>
				<form id="myForm" class="ibm-column-form">
					<p style="padding: 3px;">
						<label for="productName" style="width: 30%">Primary
							component:</label> <span id="productName"></span>
					</p>
					<p style="padding: 3px">
						<label for="catalogMatch" style="width: 30%">Catalog
							match:</label> <span id="catalogMatch"></span>
					</p>
					<p style="padding: 3px">
						<label for="fullDesc" style="width: 30%">License name:</label> <span
							id="fullDesc"></span>
					</p>
					<p style="padding: 3px">
						<label for="skuAsString" style="width: 30%">SKU</label> <span id="skuAsString"> </span>
					</p>
					<p style="padding: 3px">
						<label for="swproPID" style="width: 30%">Software product
							PID:</label> <span id="swproPID"> </span>
					</p>
					<p style="padding: 3px">
						<label for="capacityType" style="width: 30%">Capacity
							type:</label> <span id="capacityType"> </span>
					</p>
					<p style="padding: 3px">
						<label for="totalQtyString" style="width: 30%">Total qty:</label>
						<span id="totalQtyString"></span>
					</p>
					<p style="padding: 3px">
						<label for="availableQtyString" style="width: 30%">Available
							qty:</label> <span id="availableQtyString"> </span>
					</p>
					<p style="padding: 3px">
						<label for="expireDateString" style="width: 30%">Expiration
							date:</label> <span id="expireDateString"> </span>
					</p>
					<p style="padding: 3px">
						<label for="poNumber" style="width: 30%">PO number:</label> <span
							id="poNumber"></span>
					</p>
					<p style="padding: 3px">
						<label for="cpuSerial" style="width: 30%">Serial number:</label> <span
							id="cpuSerial"></span>
					</p>
					<p style="padding: 3px">
						<label for="licenseOwner" style="width: 30%">License
							owner:</label> <span id="licenseOwner"></span>
					</p>
					<p style="padding: 3px">
						<label for="poolAsString" style="width: 30%">Pool:</label> <span
							id="poolAsString"></span>
					</p>
					<p style="padding: 3px">
						<label for="extSrcId" style="width: 30%">SWCM ID:</label> <span
							id="extSrcId"></span>
					</p>
					<p style="padding: 3px">
						<label for="recordTimeAsString" style="width: 30%">Record
							date/time:</label> <span id="recordTimeAsString"> </span>
					</p>

				</form>
		</div>
</div>

