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
$(function() {
 	var licenseId = ${licenseId};
	feedPage(licenseId);
	$("#titleContent").text("License details: ${account.name}(${account.account})");
	});

	function feedPage(licenseId) {
		var urlRequest = "${pageContext.request.contextPath}/ws/license/detail/"+licenseId+"";
		jQuery.ajax({
			url : urlRequest,
			type : "GET",
			timeout : 180000,
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
				if (result.status != '200') {
					alert(result.msg);
				}
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
			}
		});
	}

	
	

</script>

<div class="ibm-container">
	<div class="ibm-container-body">
		<form id="myLicenseForm" onsubmit="submitForm(); return false;"
			action="/" class="ibm-column-form" enctype="multipart/form-data"
			method="post">

			<p>
				<label for=productName>Primary component:</label>
				<span> <label id="productName"></label></span> 
			</p>
			<p>
				<label for=catalogMatch>Catalog match:</label>
				<span> <label id="catalogMatch"></label></span> 
			</p>			
			<p>
				<label for=fullDesc>License name:</label>
				<span> <label id="fullDesc"></label></span> 
			</p>
			<p>
				<label for=swproPID>Software product PID:</label>
				<span> <label id="swproPID" ></label>
				</span> 
			</p>
			<p>
				<label for=capacityType>Capacity type:</label>
				<span> <label id="capacityType" ></label>
				</span> 
			</p>
			<p>
				<label for=totalQtyString>Total qty:</label>
				<span> <label id="totalQtyString"></label></span> 
			</p>
			<p>
				<label for=availableQtyString>Available qty:</label>
				<span> <label id="availableQtyString"></label></span> 
			</p>
			<p>
				<label for=expireDateString>Expiration date:</label>
				<span> <label id="expireDateString"></label></span> 
			</p>
			<p>
				<label for=poNumber>PO number:</label>
				<span> <label id="poNumber"></label></span> 
			</p>
			<p>
				<label for=cpuSerial>Serial number:</label>
				<span> <label id="cpuSerial"></label></span> 
			</p>
			<p>
				<label for=licenseOwner>License owner:</label>
				<span> <label id="licenseOwner"></label></span> 
			</p>
			<p>
				<label for=poolAsString>Pool:</label>
				<span> <label id="poolAsString"></label></span> 
			</p>
			<p>
				<label for=extSrcId>SWCM ID:</label>
				<span> <label id="extSrcId"></label></span> 
			</p>
			<p>
				<label for=recordTimeAsString>Record date/time:</label>
				<span> <label id="recordTimeAsString"></label></span> 
			</p>
			
		</form>
	</div>
</div>