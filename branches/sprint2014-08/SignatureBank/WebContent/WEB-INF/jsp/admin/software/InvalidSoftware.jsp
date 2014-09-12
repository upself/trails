<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Software Details Page</h1>
<br>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
	<div></div><p><label for="invalid">Add Software is invalid since migration ! </label></p></div>
	<div class="hrule-dots">&nbsp;</div>
	<div class="clear">&nbsp;</div>

