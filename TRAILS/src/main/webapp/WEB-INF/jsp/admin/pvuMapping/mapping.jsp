<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<jsp:include page="mappingHead.jsp"></jsp:include>
<p>Add or Remove one or more Asset machine models, based on the PVU
details listed at the bottom of the screen. Click Submit to save your
selections.</p>
<br />

Processor brand: ${pvu.processorBrand}
<br />
Processor model: ${pvu.processorModel}

<div class="clear"></div>
<br />
<div class="map_hidden" id="map_stat_wait">
<h3>Wait, refreshing model list.</h3>
</div>

<div class="map_hidden" id="map_stat_not_available">
<h3>All asset models had been mapped with other processor
brand/model of software group.</h3>
</div>

<div class="map_hidden" id="map_stat_mt_wait">
<h3>Wait, refreshing machine type list.</h3>
</div>
<br />
<s:form action="updatePvuMap" method="post" namespace="/admin/pvuMapping" theme="simple">

	<s:hidden name="pvuId" id="pvu_id"></s:hidden>

	<label for="asset_processor_brand_select">Asset processor type: </label>
	<s:select name="selectedProcessorBrands" list="selectedProcessorBrands"
		id="asset_processor_brand_select" value="" cssClass="map_freez_width"
		headerValue="Please make a selection" headerKey=""
		onchange="getMachineTypes(this.value);" />
	<br />
	<br />

	<label for="machineTypeSelect">Machine type: </label>
	<s:select name="machineTypeId" list="machineTypeList"
		id="machineTypeSelect" value="" cssClass="map_dropdown_width"
		headerValue="Please select an Asset processor type" headerKey=""
		onchange="getAvailableProcessorModels(this.value);" />
	<br />
	<br />
			<div class="map_result_title">
				<label for="free_model_select">Free asset machine model</label> 
				<s:select name="free_model_select" list="freeProcessorModels" cssClass="map_items" id="free_model_select" multiple="true" size="10"></s:select>
			</div>
		
		
			<div class="map_seprator">
				<span class="button-gray"> 
					<input type="button" value="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Add&gt;&gt;&nbsp;&nbsp;" id="button_add" /> 
					<br />
					<br />
					<input type="button" value="&lt;&lt;Remove" id="button_remove" /> 
				</span>
			</div>
		
		
			<div class="map_result_title">
				<div class="label">Mapped asset machine model</div> 
			    <div class="date">
			    <!-- 
			     <label for="mapped_model_hide_select">mapped model select hide</label>
			    <label for="mapped_model_select">mapped model select</label>
			     -->	    
				    <s:select name="selectedProcessorModels" list="selectedProcessorModels" 
					cssClass="map_items" id="mapped_model_select" size="10" multiple="true">
					</s:select>		
				</div>
			</div>
			<div style="float:left">
				<br/>
				<br/>
					<input value="Submit" id="submit_button" name="ibm-submit" class="ibm-btn-pri" type="submit">
					<input value="Cancel" id="map_cancel" name="ibm-cancel" class="ibm-btn-pri" type="submit">
				<br/>
			</div>
</s:form>
<br />
<br />
<div class="hrule-dots">
<br />
</div>

<script type="text/javascript">
var url = "${pageContext.request.contextPath}/ws/pvu/getPvuById/<s:property value='pvuId'/>";
$
		.ajax({
			url : url,
			type : "GET",
			dataType : 'json',
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert(textStatus);
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
						html += "<td>" + list[i].processorArchitecture + "</td>";		
						html += "<td>" + list[i].serverVendor + "</td>";
						html += "<td>" + list[i].serverBrand + "</td>";
						html += "<td>" + list[i].processorVendor + "</td>";
						html += "<td>" + list[i].processorType + "</td>";
						html += "<td>" + list[i].valueUnitsPerCore + "</td>";
						html += "<td>" + list[i].status + "</td>";
						html += "</tr>"; 
					}
				}
				$("#processor_info_list").html(html);
			}
		});
</script>

	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table"
			summary="Sortable PVU Mapping">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Processor architecture</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Server vendor</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Server brand</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Processor vendor</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Processor type</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>PVUs per core</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Status</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="processor_info_list">
				
			</tbody>
		</table>
	</div>


