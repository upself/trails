<div class="ibm-columns">
<div class="ibm-col-1-1">
<p class="ibm-confidential">IBM Confidential</p>
<div class="ibm-alternate-rule"><hr/></div>
	<s:if test="addCollection.size!=0||removeCollection.size!=0">
	    <p>Your modification has been successful. See details below.
	    Click <a
	        href="${pageContext.request.contextPath}/admin/pvuMapping/updatePvuMap.htm?pvuId=${pvuId}">here</a>
	    to return to PVU Map screen.</p>
	    <br />
	    <br />
	    <div class="hrule-dots"></div>
	    <br />
	    <s:if test="addCollection.size!=0">
	        <p>Added mapping(s):</p>
	        <display:table name="addCollection" class="ibm-data-table ibm-alternating" id="id"
	            decorator="org.displaytag.decorator.TotalTableDecorator"
	            cellspacing="1" cellpadding="0">
	            <display:column title="Processor brand">${pvu.processorBrand}</display:column>
	            <display:column title="Processor model">${pvu.processorModel}</display:column>
	            <display:column title="Asset processor type">${currentProcessorBrand}</display:column>
	            <display:column title="Machine type">${machineType.name}</display:column>
	            <display:column title="Asset machine model">${id}</display:column>
	        </display:table>
	    </s:if>
	    <br />
	    <s:if test="removeCollection.size!=0">
	        <p>Removed mapping(s):</p>
	        <display:table name="removeCollection" class="ibm-data-table ibm-alternating" 
	            id="id" summary="remove Collection"
	            decorator="org.displaytag.decorator.TotalTableDecorator"
	            cellspacing="1" cellpadding="0">
	            <display:column title="Processor brand">${pvu.processorBrand}</display:column>
	            <display:column title="Processor model">${pvu.processorModel}</display:column>
	            <display:column title="Asset processor type">${currentProcessorBrand}</display:column>
	            <display:column title="Machine type">${machineType.name}</display:column>
	            <display:column title="Asset machine model">${id}</display:column>
	        </display:table>
	    </s:if>
	</s:if>
	<s:else>
	No changes to PVU Mapping have been made. Click <a
	        href="${pageContext.request.contextPath}/admin/pvuMapping/updatePvuMap.htm?pvuId=${pvuId}">here</a> to return to PVU Map screen.
	</s:else>
	<div class="ibm-alternate-rule"><hr/></div>
</div>
</div>