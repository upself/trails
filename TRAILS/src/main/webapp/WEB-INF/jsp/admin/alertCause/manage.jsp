<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("select").find("option").each(function() {
			var str = $(this).text();
			if (str.match("^\!")) {
				$(this).attr("selected", true);
			}
		});
	});
</script>
<h1 class="oneline">Edit</h1>
<div style="font-size: 22px; display: inline">&nbsp;cause code</div>
<p class="confidential">IBM Confidential</p>
<br />
<p>Edit the cause code's name. Press the Save button to save your
	changes. Fields marked with an asterisk (*) are required.</p>
<br />
<div class="hrule-dots"></div>
<br />
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h2 class="bar-blue-med-light">Cause code details</h2>
<br />
<s:form action="update" method="post" namespace="/admin/alertCause"
	theme="simple">
	<s:hidden name="alertCauseId" />
	<s:hidden name="alertTypeId" />
	<!--Alert -->
	<div class="float-left" style="width: 30%;">
		<label for="alertCauseName">Alert:</label>
	</div>
	<div class="float-left" style="width: 70%;">
		<s:property value="alertCauseForm.alertTypeCause.pk.alertType.name" />
	</div>
	<br />
	<br />
	<!-- Name -->
	<div class="float-left" style="width: 30%;">
		<label for="alertCauseName">*Name</label>
	</div>
	<div class="float-left" style="width: 70%;">
		<s:textfield name="alertCauseForm.alertCauseName" required="true"
			size="50" id="alertCauseName" maxlength="255" />
	</div>
	<br />
	<br />
	<!--Responsibility-->
	<div class="float-left" style="width: 30%;">
		<label for="alertCauseName">Responsibility:</label>
	</div>
	<div class="float-left" style="width: 70%;">
		<s:select name="alertCauseForm.alertCauseResponsibilityId"
			list="alertCauseForm.alertCauseResponsibilities" listKey="id"
			listValue="name" headerKey="0" />
	</div>
	<br />
	<br />
	<!-- Status -->
	<div class="float-left" style="width: 30%;">
		<label for="alertCauseName">Status:</label>
	</div>
	<div class="float-left" style="width: 70%;">
		<s:select name="alertCauseForm.state" list="alertCauseForm.status" />
	</div>
	<br />
	<br />
	<div class="button-bar">
		<div class="buttons">
			<span class="button-blue"> <s:submit value="Save" alt="Save" />
				<s:submit value="Cancel" method="cancel" alt="Cancel" />
			</span>
		</div>
	</div>
</s:form>
