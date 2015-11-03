<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jquery.liveSearch.js" type="text/javascript"></script>

<script type="text/javascript">
    
       $(document).ready(function() 
		 {
    	   var reportName = document.getElementById("reportFileName").options[document.getElementById("reportFileName").selectedIndex].text;
       	if(reportName == 'Software compliance summary'){
       		document.getElementById('checkboxlist').style.display='block';
       		document.getElementById('comments').style.display='none';
       	} else {
       		document.getElementById('checkboxlist').style.display='none';
       		document.getElementById('comments').style.display='block';
       	} 
		 });  

	function setAction() {
		var lfReportList = document.reportList;
		var lbCustomerOwnedCustomerManagedSearchChecked = lfReportList.customerOwnedCustomerManagedSearch.checked;
		var lbCustomerOwnedIBMManagedSearchChecked = lfReportList.customerOwnedIBMManagedSearch.checked;
		var lbIBMOwnedIBMManagedSearchChecked = lfReportList.ibmOwnedIBMManagedSearch.checked;
		var lbIbmO3rdMSearchChecked = lfReportList.ibmO3rdMSearch.checked;
		var lbCustO3rdMSearchChecked = lfReportList.custO3rdMSearch.checked;
		var lbIbmOibmMSWCOSearchChecked = lfReportList.ibmOibmMSWCOSearch.checked;
		var lbCustOibmMSWCOSearchChecked = lfReportList.custOibmMSWCOSearch.checked;
		var lbTitlesNotSpecifiedInContractScopeSearchChecked = lfReportList.titlesNotSpecifiedInContractScopeSearch.checked;
		var lbSelectAllChecked = lfReportList.selectAll.checked;
		var lsReportFileName = lfReportList.reportFileName.value;
		
	  if(lsReportFileName == 'softwareComplianceSummary' ){
		if (!lbCustomerOwnedCustomerManagedSearchChecked
				&& !lbCustomerOwnedIBMManagedSearchChecked
				&& !lbIBMOwnedIBMManagedSearchChecked
				&& !lbIbmO3rdMSearchChecked
				&& !lbCustO3rdMSearchChecked
				&& !lbIbmOibmMSWCOSearchChecked
				&& !lbCustOibmMSWCOSearchChecked
				&& !lbTitlesNotSpecifiedInContractScopeSearchChecked
				&& !lbSelectAllChecked ) {
			alert("Please select at least one checkbox");

			return false;
		} else {

			lfReportList.name.value = lsReportFileName;
			lfReportList.customerOwnedCustomerManagedSearchChecked.value = lbCustomerOwnedCustomerManagedSearchChecked ? "true"
					: "";
			lfReportList.customerOwnedIBMManagedSearchChecked.value = lbCustomerOwnedIBMManagedSearchChecked ? "true"
					: "";
			lfReportList.ibmOwnedIBMManagedSearchChecked.value = lbIBMOwnedIBMManagedSearchChecked ? "true"
					: "";
			lfReportList.ibmO3rdMSearchChecked.value = lbIbmO3rdMSearchChecked ? "true"
					: "";
			lfReportList.custO3rdMSearchChecked.value = lbCustO3rdMSearchChecked ? "true"
					: "";
			lfReportList.ibmOibmMSWCOSearchChecked.value = lbIbmOibmMSWCOSearchChecked ? "true"
					: "";
			lfReportList.custOibmMSWCOSearchChecked.value = lbCustOibmMSWCOSearchChecked ? "true"
					: "";
			lfReportList.titlesNotSpecifiedInContractScopeSearchChecked.value = lbTitlesNotSpecifiedInContractScopeSearchChecked ? "true"
					: "";
			lfReportList.selectAllChecked.value = lbSelectAllChecked ? "true"
					: "";
			lfReportList.action = "/TRAILS/report/download/" + lsReportFileName
					+ "<s:property value='%{#attr.account.account}' />"
					+ ".tsv";

			return true;
		}
	  } else {
		  
			lfReportList.name.value = lsReportFileName;
			lfReportList.selectAllChecked.value = "true"
					;
			lfReportList.action = "/TRAILS/report/download/" + lsReportFileName
					+ "<s:property value='%{#attr.account.account}' />"
					+ ".tsv";

			return true;
	  }
	}

function reportChange(id) {
	var reportName = document.getElementById(id).options[document.getElementById(id).selectedIndex].text;
	if(reportName == 'Software compliance summary'){
		document.getElementById('checkboxlist').style.display='block';
		document.getElementById('comments').style.display='none';
	} else {
		document.getElementById('checkboxlist').style.display='none';
		document.getElementById('comments').style.display='block';
	}
}
$("#go-btn-link-report").click(function(){
	setAction();
	$("#reportList").submit();
});

</script>
<s:form action="reportList" method="get" namespace="/report/download"
	theme="simple">
	<s:hidden name="name" />
	<s:hidden name="customerOwnedCustomerManagedSearchChecked" />
	<s:hidden name="customerOwnedIBMManagedSearchChecked" />
	<s:hidden name="ibmOwnedIBMManagedSearchChecked" />
	<s:hidden name="ibmO3rdMSearchChecked" />
	<s:hidden name="custO3rdMSearchChecked" />
	<s:hidden name="ibmOibmMSWCOSearchChecked" />
	<s:hidden name="custOibmMSWCOSearchChecked" />
	<s:hidden name="titlesNotSpecifiedInContractScopeSearchChecked" />
	<s:hidden name="selectAllChecked" />
	<table class="basic-table" cellspacing="0" cellpadding="0">
		<tr>
			<td><label for="reportFileName">Report name:</label></td>
		</tr>
		<tr>
		<div style="float:right">
			<td>
			<s:select name="reportFileName" label="Report"
					list="reportList" id="reportFileName" listKey="reportFileName"
					listValue="reportDisplayName"  onChange="reportChange(this.id)" />&nbsp;&nbsp; 
				<p class="ibm-button-link-alternate ibm-btn-small" style="float:right">
					<a id="go-btn-link-report" class="ibm-btn-small" href="#" alt="Download report" >Go</a>
				</p>
			</td>
		</div>
		</tr>
 	<table id="checkboxlist" class="basic-table" cellspacing="0" cellpadding="0">
		<tr>
			<td><s:checkbox
					label="Customer owned/customer managed titles/vendors"
					name="customerOwnedCustomerManagedSearch"
					id="customerOwnedCustomerManagedSearch" /><label
				for="customerOwnedCustomerManagedSearch">Customer
					owned/customer managed titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox
					label="Customer owned/IBM managed titles/vendors"
					name="customerOwnedIBMManagedSearch"
					id="customerOwnedIBMManagedSearch" /><label
				for="customerOwnedIBMManagedSearch">Customer owned/IBM
					managed titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="IBM owned/IBM managed titles/vendors"
					name="ibmOwnedIBMManagedSearch" id="ibmOwnedIBMManagedSearch" /><label
				for="ibmOwnedIBMManagedSearch">IBM owned/IBM managed
					titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="IBM owned/ managed by 3rd party
					titles/vendors"
					name="ibmO3rdMSearch" id="ibmO3rdMSearch" /><label
				for="ibmO3rdMSearch">IBM owned/ managed by 3rd party
					titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="Customer owned/ managed by 3rd party 
					titles/vendors"
					name="custO3rdMSearch" id="custO3rdMSearch" /><label
				for="custO3rdMSearch">Customer owned/ managed by 3rd party 
					titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="IBM owned/IBM managed SW consumption based 
					titles/vendors"
					name="ibmOibmMSWCOSearch" id="ibmOibmMSWCOSearch" /><label
				for="ibmOibmMSWCOSearch">IBM owned/IBM managed SW consumption based 
					titles/vendors</label></td>
		</tr>
				<tr>
			<td><s:checkbox label="Customer owned/IBM managed SW consumption based 
					titles/vendors"
					name="custOibmMSWCOSearch" id="custOibmMSWCOSearch" /><label
				for="custOibmMSWCOSearch">Customer owned/IBM managed SW consumption based 
					titles/vendors</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="Titles not specified in contract scope"
					name="titlesNotSpecifiedInContractScopeSearch"
					id="titlesNotSpecifiedInContractScopeSearch" /><label
				for="titlesNotSpecifiedInContractScopeSearch">Titles not
					specified in contract scope</label></td>
		</tr>
				<tr>
			<td><s:checkbox label="selectAll"
					name="selectAll"
					id="selectAll" /><label
				for="selectAll">SelectALL</label></td>
		</tr>
		</table>
		<table id="comments" class="basic-table" cellspacing="0" cellpadding="0">
    	<tr><td>
             Scope Selection was removed </br>
             All reports here are return with "Full mode"
          </td>
        </tr>
        </table>
	</table>
</s:form>
