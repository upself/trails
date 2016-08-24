<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/trails_style.css">

<jsp:include page="mappingHead.jsp"></jsp:include>
<div class="ibm-columns">
	<p class="ibm-confidential">IBM Confidential</p>
	<div class="ibm-col-1-1">
	<div class="ibm-alternate-rule"><hr/></div>
		<p>Add or Remove one or more Asset machine models, based on the PVU details listed at the bottom of the screen. Click Submit to save your selections.</p>
	</div>
	<br />
	<div class="ibm-col-1-1" style="font-size: 12px;">
		Processor brand: ${pvu.processorBrand}<br />
		Processor model: ${pvu.processorModel}<br />
	</div>
</div>
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
<script type="text/javascript">
$('#button_remove').click(function(event) {
    event.preventDefault();
    var mafSelected = $('#asset_processor_brand_select>option:selected');
    var modSelected = $('#mapped_model_select>option:selected');
     
    if(mafSelected.length==0||modSelected.length==0){
       alert('Select one or more mapped asset machine models to remove.'); 
       return;
    }
    modSelected.remove().appendTo('#free_model_select').sort();
    setTimeout(removeSelection,0);
    return;     
  });
  
  
  $("#button_add").click(function(event) {
      event.preventDefault();   
      var resSelected=$('#free_model_select>option:selected');
      if(resSelected.length==0){
         alert('Select one or more free processor models to map.');
      }
      resSelected.remove().appendTo('#mapped_model_select');
      return;
  }); 
</script>
<div class="ibm-columns">
	<div class="ibm-col-1-1">

	<s:form action="updatePvuMap" method="post" namespace="/admin/pvuMapping" theme="simple">
	
		<s:hidden name="pvuId" id="pvu_id"></s:hidden>
	<div>
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
	</div>
		<br />
		<br />
			<div id="map_zone">
					<div class="map_result_title">
						<label for="free_model_select">Free asset machine model</label> 
						<s:select name="free_model_select" list="freeProcessorModels" cssClass="map_items" id="free_model_select" multiple="true" size="10"></s:select>
					</div>
				
				
					<div class="map_seprator">
						<span> 
						<p class="ibm-button-link">
							<a href="#" id="button_add" class="ibm-btn-small">&nbsp;&nbsp;&nbsp;Add&gt;&gt;&nbsp;&nbsp;</a><br>
							<a href="#" id="button_remove" class="ibm-btn-small">&lt;&lt;Remove</a>
						</p>
							<br />
							<br />
						</span>
					</div>
				
				
					<div class="map_result_title">
						<div class="label">Mapped asset machine model</div> 
					    <!-- 
					     <label for="mapped_model_hide_select">mapped model select hide</label>
					    <label for="mapped_model_select">mapped model select</label>
					     -->	    
						    <s:select name="selectedProcessorModels" list="selectedProcessorModels" 
							cssClass="map_items" id="mapped_model_select" size="10" multiple="true">
							</s:select>		
					</div>
			</div>
			<div id="mapping_submit" style="width:100%;float:left">
				<input value="Submit" id="submit_button" name="ibm-submit" class="ibm-btn-pri" type="submit">
				<input value="Cancel" id="map_cancel" name="ibm-cancel" class="ibm-btn-pri" type="submit">
				<br/>
			</div>
	</s:form>
	</div>
</div>
<div class="ibm-rule">
</div>

<!-- 
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
				if (data.data.status == 400) {
					html += "<tr><td colspan='7'>" + data.msg
							+ "</td></tr>"
				} else {
					var list = data.data.processorValueUnitInfo;
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
	<br>
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
 -->
<div>
<br>
	<display:table name="pvu.processorValueUnitInfo" class="ibm-data-table ibm-sortable-table" summary="PVU mapping"
		id="id" decorator="org.displaytag.decorator.TotalTableDecorator"
		cellspacing="1" cellpadding="0">
		<display:column property="processorArchitecture"
			title="Processor architecture" />
		<display:column property="serverVendor" title="Server vendor" />
		<display:column property="serverBrand" title="Server brand" />
		<display:column property="processorVendor" title="Processor vendor" />
		<display:column property="processorType" title="Processor type" />
		<display:column property="valueUnitsPerCore" title="PVUs per core" />
		<display:column property="status" title="Status" />
	</display:table>
</div>
