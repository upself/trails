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
$(function() {

// 	var licenseId = 490363;
	feedPage(/*licenseId*/);
	$("#titleContent").text($("#titleContent").text() + ": ${account.name}(${account.account})");
	}

	function feedPage(/*licenseId*/) {
		var urlRequest = "${pageContext.request.contextPath}/ws/license/<s:property value='licenseId' />";
		var accountId = '${account.id}';
		jQuery.ajax({
			url : urlRequest,
			type : "GET",
			data : {
				"accountId" : accountId
			},
			dataType : 'json',
			timeout : 180000,
			success : function(result) {
				alert(result.data + ":" + status);
				$("#swproPID").text(result.data.swproPID);
				$("#productName").text(result.data.productName);
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
				<input name="id" id="id" value="" type="hidden" />
			</p>

			<p>
				<label for="primaryComponent">Primary component:</label> <span><s:text
						name="license.productName" /></span>
			</p>
			<p>
				<label for=productName>RESTPrimary component:</label>
				<span> <label id="productName" name="productName"></label>
				</span> <input type="hidden" id="productName" />
			</p>
			<p>
				<label for="catalogMatch">Catalog match:</label> <span><s:text
						name="license.catalogMatch" /></span>
			</p>
			<p>
				<label for="licenseName">License name:</label> <span><s:text
						name="license.fullDesc" /></span>
			</p>
			
			<p>
				<label for=swproPID>RESTSoftware product PID:</label>
				<span> <label id="swproPID" name="swproPID"></label>
				</span> <input type="hidden" id="swproPID" />
			</p>
			
			<p>
				<label for="softwareProductPID">Software product PID:</label> <span><s:text
						name="license.swproPID" /></span>
			</p>
			<p>
				<label for="capacityType">Capacity type:</label>
					<span><s:text	name="license.capacityType.code" /> - <s:text name="license.capacityType.description" /></span>
			</p>
			
			<p>
				<label for="totalQty">Total qty:</label> <span><s:text
						name="license.quantity" /></span>
			</p>
			<p>
				<label for="availableQty">Available qty:</label> <span><s:text
						name="license.availableQty" /></span>
			</p>
			<p>
				<label for="expirationDate">Expiration date:</label> <span><s:text
						name="license.expireDate" /></span>
			</p>
			<p>
				<label for="poNumber">PO number:</label> <span><s:text
						name="license.poNumber" /></span>
			</p>
			<p>
				<label for="serialNumber">Serial number:</label> <span><s:text
						name="license.cpuSerial" /></span>
			</p>
			<p>
				<label for="licenseOwner">License owner:</label> 
				<span><s:if test="license.ibmOwned == true">IBM</s:if> <s:else>Customer</s:else></span>
			</p>
<%-- 			<td><s:if test="license.ibmOwned == true">IBM</s:if> <s:else>Customer</s:else> --%>
			<p>
				<label for="pool">Pool:</label> <span><s:text
						name="license.poolAsString" /></span>
			</p>
			<p>
				<label for="swcmId">SWCM ID:</label> <span><s:text
						name="license.extSrcId" /></span>
			</p>
			<p>
				<label for="recordDateTime">Record date/time:</label> <span><s:text
						name="license.recordTime" /></span>
			</p>
			
		</form>
	</div>
</div>