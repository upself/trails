<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Microsoft Product Form</h1>
<br>
<p>Use this form to add a new Microsoft product. When you are finished,
click the submit button. Press the Cancel button to discard your
changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled in
to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/SaveNewMicrosoftProduct">

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1">*<label for="text_productDescription">Product Description</label>: </td>
			<td class="t1">
			<html:text styleId="text_productDescription" property="productDescription" size="32" />
		</tr>
	</table>
	<p/>
	<div class="hrule-dots"></div>

	<div class="clear"></div>
	<div class="button-bar">

	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel onkeypress="return(this.onclick());">Cancel</html:cancel></span></div>
	</div>
</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
