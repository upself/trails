<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
$(function() {
	$("#titleContent").text($("#titleContent").text() + ": ${account.name}(${account.account})");

	searchData();
});
	function searchData() {
		var params = {};
		params['accountId'] = '${account.id}';
		params['sort'] = 'id';
		params['dir'] = 'desc';
		var requestURI="${requestURI}";
		var restUrl=null;
		var order=null;
		if(requestURI=="license.htm"){
			restUrl="${pageContext.request.contextPath}/ws/license/all/licenseBaseline";
			orders=['licenseId','fullDesc','productName','swproPID','capacityType.description','availableQty','quantity','expireDate','cpuSerial','extSrcId'];
		}else{
			restUrl="${pageContext.request.contextPath}/ws/license/all/licenseFreePool";//licenseFreePool.htm
			orders=['licenseId','license.fullDesc','software.softwareName','license.swproPID','capacityType.description','license.availableQty','license.quantity','license.expireDate','license.cpuSerial','license.extSrcId'];
		}
		$("#licTable").paginationTable('destroy').paginationTable({
			remote: {
				url: restUrl,
				type: "GET",
				params: params,
				success: function(result, pageIndex){
					var html = '';
					var list = result.data.list;
					if(null == list || list == undefined || list.length == 0){
						html += "<tr><td colspan='10' align='center'>No data found</td></tr>"
					}else{
						for(var i = 0; i < list.length; i++){
							html += "<tr>"; 
							html += "<td>" +list[i].catalogMatch+ "</td>";
							html += "<td>" + list[i].fullDesc + "</td>";
							html += "<td><a href='${pageContext.request.contextPath}/account/license/licenseDetails.htm?licenseId=" + list[i].licenseId + "'>" + list[i].productName + "</a></td>";		
							html += "<td>" + list[i].swproPID + "</td>"
							if(list[i].capTypeDesc==""){
								html += "<td></td>";
							}else{
								html += "<td>" + list[i].capTypeDesc + "</td>";
							}
							
							html += "<td>" + list[i].availableQty + "</td>";
							html += "<td>" + list[i].quantity + "</td>";
							if(list[i].expireDate!=null){
								var str=list[i].expireDate;
								html += "<td>" + str.substring(0,10) + "</td>";							
							}else{
								html += "<td></td>";		
							}
							html += "<td>" + list[i].cpuSerial + "</td>";
							html += "<td>" + list[i].extSrcId + "</td>";
							html += "</tr>"; 
						}
					}
					$("#license_list").html(html);
				}
			},
			orderColumns: orders
		});
	}	
	
</script>
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<div class="ibm-columns">
	<div class="ibm-col-1-1">
	<p style="font-weight:bold">IBM Confidential</p>
	</div>
	
	<div class="ibm-col-1-1">
		<s:a href="/TRAILS/report/download/freeLicensePool%{#attr.account.account}.tsv?name=freeLicensePool">Download free license pool report</s:a> <br>
		<s:a href="/TRAILS/report/download/licenseBaseline%{#attr.account.account}.tsv?name=licenseBaseline&selectAllChecked=true">Download License baseline report</s:a>
	</div>
	<br />
	<br />
	
	<div class="ibm-col-1-1" style="margin-left: 0px;">
			<table id="licTable" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" style="width:140%" summary="License list">
				<thead>
					<tr>
						<th scope="col"><span>Catalog match</span><span class="ibm-icon"></span></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>License name</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Primary Component</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software product PID</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Capacity type</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Avail qty</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Total qty</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Exp date</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Serial</span><span class="ibm-icon"></span></a></th>
						<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>SWCM ID</span><span class="ibm-icon"></span></a></th>
					</tr>
				</thead>
				<tbody id="license_list" />
			</table>
	</div>
</div>