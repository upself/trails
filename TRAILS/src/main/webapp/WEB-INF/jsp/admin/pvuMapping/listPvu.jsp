<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<h1>PVU mapping</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>Below lists the unique processor brands and models as taken from
the software group website located <a
	href="https://www-112.ibm.com/software/howtobuy/passportadvantage/valueunitcalculator/vucalc.wss?jadeAction=DOWNLOAD_PVU_TABLE_SELECT">here</a>.
Click on one of the links to customize processor value unit mappings
and/or view further details.</p>
<br />
<br />
<div class="hrule-dots"></div>
<br />
<display:table name="pvuArrayList" class="basic-table" id="row" summary="Processor Information"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0">
	<display:column property="processorBrand" title="Processor brand"
		href="${pageContext.request.contextPath}/admin/pvuMapping/updatePvuMap.htm"
		paramId="pvuId" paramProperty="id" />/>
	<display:column property="processorModel" title="Processor model" />
</display:table>