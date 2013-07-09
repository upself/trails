<%@ taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
<!--
function setAction() {
	var lfReportList = document.reportList;
	var lbCustomerOwnedCustomerManagedSearchChecked = lfReportList.customerOwnedCustomerManagedSearch.checked;
	var lbCustomerOwnedIBMManagedSearchChecked = lfReportList.customerOwnedIBMManagedSearch.checked;
	var lbIBMOwnedIBMManagedSearchChecked = lfReportList.ibmOwnedIBMManagedSearch.checked;
	var lbTitlesNotSpecifiedInContractScopeSearchChecked = lfReportList.titlesNotSpecifiedInContractScopeSearch.checked;

	if (!lbCustomerOwnedCustomerManagedSearchChecked &&
			!lbCustomerOwnedIBMManagedSearchChecked &&
			!lbIBMOwnedIBMManagedSearchChecked &&
			!lbTitlesNotSpecifiedInContractScopeSearchChecked) {
		alert("Please select at least one checkbox");

		return false;
	} else {
		var lsReportFileName = lfReportList.reportFileName.value;
	
		lfReportList.name.value = lsReportFileName;
		lfReportList.customerOwnedCustomerManagedSearchChecked.value = lbCustomerOwnedCustomerManagedSearchChecked ? "true" : "";
		lfReportList.customerOwnedIBMManagedSearchChecked.value = lbCustomerOwnedIBMManagedSearchChecked ? "true" : "";
		lfReportList.ibmOwnedIBMManagedSearchChecked.value = lbIBMOwnedIBMManagedSearchChecked ? "true" : "";
		lfReportList.titlesNotSpecifiedInContractScopeSearchChecked.value = lbTitlesNotSpecifiedInContractScopeSearchChecked ? "true" : "";
		lfReportList.action = "/TRAILS/report/download/" + lsReportFileName + "<s:property value='%{#attr.account.account}' />" + ".tsv";

		return true;
	}
}
//-->
</script>
<s:form action="reportList" method="get" namespace="/report/download"
	theme="simple">
	<s:hidden name="name" />
	<s:hidden name="customerOwnedCustomerManagedSearchChecked" />
	<s:hidden name="customerOwnedIBMManagedSearchChecked" />
	<s:hidden name="ibmOwnedIBMManagedSearchChecked" />
	<s:hidden name="titlesNotSpecifiedInContractScopeSearchChecked" />
	<table class="basic-table" cellspacing="0" cellpadding="0">
	    <tr>
	      <td><label for="reportFileName">Report name:</label></td>
	    </tr>
		<tr>
			<td><s:select
				name="reportFileName" label="Report" list="reportList" id="reportFileName"
				listKey="reportFileName" listValue="reportDisplayName" />&nbsp;&nbsp;
			<span class="button-blue"><s:submit value="GO"
				onclick="return setAction()" alt="Download report" /></span></td>
		</tr>
		<tr>
			<td><s:checkbox
				label="Customer owned/customer managed titles/vendors"
				name="customerOwnedCustomerManagedSearch" id="customerOwnedCustomerManagedSearch"/><label
				for="customerOwnedCustomerManagedSearch">Customer
			owned/customer managed titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox
				label="Customer owned/IBM managed titles/vendors"
				name="customerOwnedIBMManagedSearch" id="customerOwnedIBMManagedSearch"/><label
				for="customerOwnedIBMManagedSearch">Customer owned/IBM
			managed titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="IBM owned/IBM managed titles/vendors"
				name="ibmOwnedIBMManagedSearch" id="ibmOwnedIBMManagedSearch"/><label
				for="ibmOwnedIBMManagedSearch">IBM owned/IBM managed
			titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="Titles not specified in contract scope"
				name="titlesNotSpecifiedInContractScopeSearch" id="titlesNotSpecifiedInContractScopeSearch"/><label
				for="titlesNotSpecifiedInContractScopeSearch">Titles not
			specified in contract scope</label></td>
		</tr>
	</table>
</s:form>
