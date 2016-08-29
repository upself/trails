<h1>Alert type/cause code mapping</h1>
<p class="ibm-confidential">IBM Confidential</p>
<br />
<p>Below is a list of the alert types in the application. Press one of the links
to customize cause code mappings.</p>
<br />
<br />
<s:if test="hasActionMessages()">
	<s:actionmessage />
	<br />
</s:if>
<br />
<display:table class="basic-table" name="alertTypeList" summary="alert type list"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0">
	<display:column property="name" title="Alert type name"
		href="/TRAILS/admin/alertTypeCauseMapping/map.htm"
		paramId="alertTypeId" paramProperty="id" />
</display:table>
