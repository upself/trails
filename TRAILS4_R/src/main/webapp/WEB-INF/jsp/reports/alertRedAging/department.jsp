<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="basic-table" id="row"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="AlertRedAging summary by department"
	cellspacing="1" cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/alertRedAging/department.htm">
	<display:setProperty name="export.excel.filename"
		value="alertRedAgingDepartment.xls" />
	<display:column title="Department" group="1"
		href="account.htm?geographyId=${geography.id}&regionId=${region.id}&countryCodeId=${countryCode.id}"
		paramId="departmentId" paramProperty="id" media="html">
		<s:if test="%{#attr.row.name==''}">
			empty string
		</s:if>
		<s:else>
			<s:property value="%{#attr.row.name}" />
		</s:else>
	</display:column>
	<display:column property="name" title="Department" media="excel" />
	<display:column property="alertName" title="Alert" />
	<display:column property="red91Sum" title="Red(91-120)" total="true"
		format="{0,number,0}" />
	<display:column property="red121Sum" title="Red(121-150)" total="true"
		format="{0,number,0}" />
	<display:column property="red151Sum" title="Red(151-180)" total="true"
		format="{0,number,0}" />
	<display:column property="red181Sum" title="Red(181-365)" total="true"
		format="{0,number,0}" />
	<display:column property="red366Sum" title="Red(366+)" total="true"
		format="{0,number,0}" />
	<display:column property="totalRed" title="Red Total" total="true"
		format="{0,number,0}" />
</display:table>
