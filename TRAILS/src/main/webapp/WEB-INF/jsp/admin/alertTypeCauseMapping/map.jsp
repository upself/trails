<s:head />
<h1>Alert type/cause code mapping</h1>
<p class="ibm-confidential">IBM Confidential</p>
<br />
<p>Add or remove cause codes associated with the selected alert type using the
form below. Press the Save button to save your changes.</p>
<br />
<br />
<h2 class="bar-blue-med-light">Alert type/cause code mappings</h2>
<br />
<br />
<s:form action="save" method="post"
	namespace="/admin/alertTypeCauseMapping" theme="simple">
	<s:hidden name="alertTypeId" />
	<div class="float-left" style="width: 30%;">Alert type name:</div>
	<div class="float-left" style="width: 70%;">
		<s:property value="alertTypeCauseMappingForm.alertTypeName" />
	</div>
	<br />
	<br />
	<s:optiontransferselect leftTitle = "Available alert causes"
		list="alertTypeCauseMappingForm.availableAlertCauseList" listKey="id"
		listValue="name" cssStyle="width: 300px" size="10" rightTitle="Mapped alert causes" doubleList="alertTypeCauseMappingForm.mappedAlertCauseList"
		doubleListKey="id" doubleListValue="name"
		doubleName="alertTypeCauseMappingForm.mappedAlertCauseIdArray" doubleCssStyle="width: 300px" doubleSize="10"
		buttonCssStyle="display: block; width: auto; text-align: center; float: left; margin-top: 60px; margin: 10px; margin-top: 40px"
		addToRightLabel="Add >>" addToLeftLabel="<< Remove"
		allowUpDownOnLeft="false" allowUpDownOnRight="false"
		allowAddAllToLeft="false" allowAddAllToRight="false" allowSelectAll="false" />
	<div class="clear"></div>
	<div class="clear"></div>
	<br />
	<br />
	<div class="button-bar"><div class="buttons"><span class="button-blue">
		<s:submit value="Save" />
		<s:submit value="Cancel" method="cancel" />
	</span></div></div>
</s:form>
