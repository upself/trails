<div class="ibm-columns">
	<div class="ibm-col-1-1">
	    <p class="ibm-confidential">IBM Confidential</p>
		<p>Below lists the unique processor brands and models as taken from the software group website located 
		<a href="https://www-112.ibm.com/software/howtobuy/passportadvantage/valueunitcalculator/vucalc.wss?jadeAction=DOWNLOAD_PVU_TABLE_SELECT">here</a>.
		Click on one of the links to customize processor value unit mappings and/or view further details.
		</p>

	</div>
	<div class="ibm-col-1-1">
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-alternating" summary="Sortable PVU Mapping">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Processor brand</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Processor model</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="pvu_list">
			</tbody>
		</table>
	</div>
</div>
	
<script type="text/javascript">
$(document).ready(function(){
	searchData();
});
function searchData(){
	$("#page").paginationTable('destroy').paginationTable({
		remote: {
			url: "${pageContext.request.contextPath}/ws/pvu/getAll",
			type : "POST",
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='2' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
						html += "<td><a href='${pageContext.request.contextPath}/admin/pvuMapping/updatePvuMap.htm?pvuId=" + list[i].id  +"'>" + list[i].processorBrand + "</a></td>";
						html += "<td>" + list[i].processorModel + "</td>";
						html += "</tr>";
					}
				}
				$("#pvu_list").html(html);
			}
		},
		orderColumns: ['processorBrand','processorModel']
	}); 
};
</script>