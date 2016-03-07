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
	$("#titleContent").text($("#titleContent").text() + ": ${account.name}(${account.account})");
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
				$("#licenseName").text(result.data.licenseName);
				$("#swproPID").text(result.data.swproPID);
				$("#capacityType").text(result.data.capacityType);
				$("#totalQty").text(result.data.totalQty);
				$("#availableQty").text(result.data.availableQty);
				$("#expirationDate").text(result.data.expirationDate);
				$("#poNumber").text(result.data.poNumber);
				$("#serialNumber").text(result.data.serialNumber);
				$("#licenseOwner").text(result.data.licenseOwner);
				$("#pool").text(result.data.pool);
				$("#swcmId").text(result.data.swcmId);
				$("#recordDateTime").text(result.data.recordDateTime);
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
				<label for="primaryComponent">Primary component:</label> <span></span>
			</p>
			<p>
				<label for=productName>RESTPrimary component:</label>
				<span> <label id="productName"></label></span> 
			</p>
			<p>
				<label for=catalogMatch>RESTCatalog match:</label>
				<span> <label id="catalogMatch"></label></span> 
			</p>			
			<p>
				<label for="catalogMatch">Catalog match:</label> <span></span>
			</p>
			<p>
				<label for=licenseName>RESTLicense name:</label>
				<span> <label id="licenseName"></label></span> 
			</p>
			<p>
				<label for="licenseName">License name:</label> <span></span>
			</p>
			
			<p>
				<label for=swproPID>RESTSoftware product PID:</label>
				<span> <label id="swproPID" ></label>
				</span> 
			</p>
			
			<p>
				<label for="softwareProductPID">Software product PID:</label> <span></span>
			</p>
			<p>
				<label for=capacityType>RESTCapacity type:</label>
				<span> <label id="capacityType" ></label>
				</span> 
			</p>
			<p>
				<label for="capacityType">Capacity type:</label>
					<span> - </span>
			</p>
			<p>
				<label for=totalQty>RESTTotal qty:</label>
				<span> <label id="totalQty"></label></span> 
			</p>
			<p>
				<label for="totalQty">Total qty:</label> <span></span>
			</p>
			<p>
				<label for=availableQty>RESTAvailable qty:</label>
				<span> <label id="availableQty"></label></span> 
			</p>
			<p>
				<label for="availableQty">Available qty:</label> <span></span>
			</p>
			<p>
				<label for=expirationDate>RESTExpiration date:</label>
				<span> <label id="expirationDate"></label></span> 
			</p>
			<p>
				<label for="expirationDate">Expiration date:</label> <span></span>
			</p>
			<p>
				<label for=poNumber>RESTPO number:</label>
				<span> <label id="poNumber"></label></span> 
			</p>
			<p>
				<label for="poNumber">PO number:</label> <span></span>
			</p>
			<p>
				<label for=serialNumber>RESTSerial number:</label>
				<span> <label id="serialNumber"></label></span> 
			</p>
			<p>
				<label for="serialNumber">Serial number:</label> <span></span>
			</p>
			<p>
				<label for=licenseOwner>RESTLicense owner:</label>
				<span> <label id="licenseOwner"></label></span> 
			</p>
			<p>
				<label for="licenseOwner">License owner:</label> 
				<span></span>
			</p>
			<p>
				<label for=pool>RESTPool:</label>
				<span> <label id="pool"></label></span> 
			</p>
			<p>
				<label for="pool">Pool:</label> <span></span>
			</p>
			<p>
				<label for=swcmId>RESTSWCM ID:</label>
				<span> <label id="swcmId"></label></span> 
			</p>
			<p>
				<label for="swcmId">SWCM ID:</label> <span></span>
			</p>
			<p>
				<label for=recordDateTime>RESTRecord date/time:</label>
				<span> <label id="recordDateTime"></label></span> 
			</p>
			<p>
				<label for="recordDateTime">Record date/time:</label> <span></span>
			</p>
			
		</form>
	</div>
</div>