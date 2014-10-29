<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<h1>PVU mapping</h1>
<p class="confidential">IBM Confidential</p>
<br />
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
<s:form action="updatePvuMap" method="post"
	namespace="/admin/pvuMapping" theme="simple">

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

	<div class="map_result_title"><label for="free_model_select">Free
	asset machine model</label> <s:select name="free_model_select"
		list="freeProcessorModels" cssClass="map_items" id="free_model_select"
		multiple="true" size="10"></s:select></div>


	<div class="map_seprator"><span class="button-gray"> <input
		type="button"
		value="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Add&gt;&gt;&nbsp;&nbsp;"
		id="button_add" /> <br />
	<br />
	<input type="button" value="&lt;&lt;Remove" id=button_remove /> </span></div>

	<div class="map_result_title"><div class="label">Mapped asset machine model</div> 
	    <div class="date">
	    <label for="mapped_model_hide_select">mapped model select hide</label>
	    <label for="mapped_model_select">mapped model select</label>
	    
	    <s:select
		name="selectedProcessorModels" list="selectedProcessorModels" 
		cssClass="map_items" id="mapped_model_select" size="10"
		multiple="true">
		</s:select>
		
		</div>
	</div>


	<div class="clear"></div>

	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"> <s:submit
		value="Submit" id="submit_button" alt="Submit" /><s:submit
		value="Cancel" id="map_cancel" alt="Cancel" /> </span></div>
	</div>
</s:form>
<br />
<br />
<div class="hrule-dots"></div>
<br />
<display:table name="pvu.processorValueUnitInfo" class="basic-table" summary="PVU mapping"
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



