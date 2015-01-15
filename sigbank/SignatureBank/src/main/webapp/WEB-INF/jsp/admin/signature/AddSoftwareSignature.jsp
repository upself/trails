<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>

<h1>Manage By Software: <span class="orange-dark"><bean:write
	name="user.container" property="product.name" /></span></h1>

<div id="fourth-level">
<ul class="text-tabs">
	<li><html:link page="/SoftwareFilter.do">Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterSearchSetup.do">Search Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterMove.do">Manage Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareSignature.do">Sigs</html:link>
	|</li>
	<li><html:link page="/SoftwareSignatureSearchSetup.do">Search Sigs</html:link>
	|</li>
	<li><html:link page="/SoftwareSignatureMove.do">Manage Sigs</html:link>
	|</li>
	<li><html:link page="/AddSoftwareSignature.do" styleClass="active">Add Signature</html:link>
	</li>
</ul>
</div>
<h2>New Software Signature Request Form</h2>
<br>
<p>Use this form to request a new software signature for your
selected software. When you are finished, click the submit button. Press
the Cancel button to discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/AddSoftwareSignatureSave">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="fileName">*File name: </label></td>
			<td>
			<div class="input-note">maximum 128 characters. <font
				color="red"> Windows signatures <br>
			must be in all caps. Unix signatures are case sensitive.</font></div>
			<html:text property="fileName" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="fileSize">*File size: </label></td>
			<td>
			<div class="input-note">must be an integer</div>
			<html:text property="fileSize" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="softwareVersion">*Software
			version: </label></td>
			<td>
			<div class="input-note">maximum 32 characters</div>
			<html:text property="softwareVersion" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="osType">*Operating system: </label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="osType" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="JVM">JVM</html:option>
				<html:option value="OS/400">OS/400</html:option>
				<html:option value="Unix">Unix</html:option>
				<html:option value="Windows">Windows</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="endOfSupport">End of support
			date: </label></td>
			<td>
			<div class="input-note">MM/DD/YYYY</div>
			<html:text property="endOfSupport" styleClass="input" /></td>
		</tr>

		<tr>
			<td class="t1"><label for="checksumQuick">Checksum
			quick: </label></td>
			<td>
			<div class="input-note">maximum 8 characters</div>
			<html:text property="checksumQuick" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="checksumCrc32">Checksum
			crc32: </label></td>
			<td>
			<div class="input-note">maximum 8 characters</div>
			<html:text property="checksumCrc32" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="checksumMd5">Checksum md5: </label></td>
			<td>
			<div class="input-note">maximum 8 characters</div>
			<html:text property="checksumMd5" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="changeJustification">*Signature
			creation justification: </label></td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:textarea rows="4" cols="64" property="changeJustification" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="comments">Additional
			Comments:</label></td>
			<td>
			<div class="input-note">maximum 255 characters</div>
			<html:textarea rows="4" cols="64" property="comments" /></td>
		</tr>
	</table>
	<p>&nbsp;</p>
	<div class="hrule-dots">&nbsp;</div>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>

</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->