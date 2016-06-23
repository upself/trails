<%@ taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){
	var reportName = document.getElementById("reportFileName").options[document.getElementById("reportFileName").selectedIndex].text;
   	//document.getElementById('checkboxlist').style.display='none';
   	document.getElementById('comments').style.display='block';
});
 

	function setAction() {
		var lfReportList = document.reportList;
		var lbSelectAllChecked = true;
		var lsReportFileName = lfReportList.reportFileName.value;
		
			lfReportList.name.value = lsReportFileName;
			lfReportList.selectAllChecked.value = "true";
			lfReportList.action = "/TRAILS/report/download/" + lsReportFileName + "<s:property value='%{#attr.account.account}' />" + ".tsv";

			return true;
	  
	}

function reportChange(id) {
	var reportName = document.getElementById(id).options[document.getElementById(id).selectedIndex].text;
		//document.getElementById('checkboxlist').style.display='none';
		document.getElementById('comments').style.display='block';
}

</script>
<s:form action="reportList" method="get" namespace="/report/download" theme="simple">
	<s:hidden name="name" />
	<s:hidden name="selectAllChecked" />
	<table class="basic-table" cellspacing="0" cellpadding="0">
		<tr>
			<td><label for="reportFileName">Report name:</label></td>
		</tr>
		<tr>
			<td>
				<s:select name="reportFileName" label="Report" list="reportList" id="reportFileName"
					listKey="reportFileName" listValue="reportDisplayName" onChange="reportChange(this.id)" />&nbsp;&nbsp; 
				<input type="submit" onclick="return setAction()" value="GO" class="ibm-btn-cancel-pri ibm-btn-small" /> 
			</td>
		</tr>
		<table id="comments" class="basic-table" cellspacing="0" cellpadding="0">
			<tr>
				<td>Scope Selection was removed </br> All reports here are return with "Full mode"
				</td>
			</tr>
		</table>
	</table>
</s:form>
