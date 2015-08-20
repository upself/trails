<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- show loading -->
<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.showLoading.js"></script>
<link href="${pageContext.request.contextPath}/css/showLoading.css" rel="stylesheet" type="text/css" />
<p>IBM Confidential</p>
<br />
<p>Below lists the unique processor brands and models as taken from
the software group website located <a
	href="https://www-112.ibm.com/software/howtobuy/passportadvantage/valueunitcalculator/vucalc.wss?jadeAction=DOWNLOAD_PVU_TABLE_SELECT">here</a>.
Click on one of the links to customize processor value unit mappings
and/or view further details.</p>
<br />
<br />
<script type="text/javascript">
$(document).ready(function(){
	$(".loading").showLoading();
});
var url = "${pageContext.request.contextPath}/ws/pvu/getAll";
$
		.ajax({
			url : url,
			type : "GET",
			dataType : 'json',
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert(textStatus);
				$(".loading").hideLoading();
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
						html += "<td><a href='${pageContext.request.contextPath}/admin/pvuMapping/updatePvuMap.htm?pvuId=" + list[i].id 
								//+ "&processorBrand="+list[i].processorBrand+"&processorModel="+list[i].processorModel
								+"'>"
								+ list[i].processorBrand
								+ "</a></td>";		
						html += "<td id='level_td'>" + list[i].processorModel
								+ "</td>";
						html += "</tr>"; 
					}
				}
				$("#pvu_list").html(html);
				$(".loading").hideLoading();
			}
		});
</script>
<br />
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table"
			summary="Sortable PVU Mapping">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Processor brand</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Processor model</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="pvu_list">
			<tr class="loading">
			</tr>
			</tbody>
		</table>
	</div>

<!-- 
<display:table name="pvuArrayList" class="ibm-data-table ibm-alternating" id="row" summary="Processor Information"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0">
	<display:column property="processorBrand" title="Processor brand"
		href="${pageContext.request.contextPath}/admin/pvuMapping/updatePvuMap.htm"
		paramId="pvuId" paramProperty="id" />/>
	<display:column property="processorModel" title="Processor model" />
</display:table>
 -->