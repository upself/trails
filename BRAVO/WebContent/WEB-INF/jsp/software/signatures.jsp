<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>

<div class="indent">
<h3>Tivoli Signatures <img
	src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
	width="14" height="14" alt="contextual field help icon" /></h3>
</div>
<display:table name="signatureList" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two"
	id="small">
	<display:setProperty name="basic.empty.showtable" value="true" />

	<display:column property="softwareSignature.fileName" title="Name"
		headerClass="blue-med" />
	<display:column property="softwareSignature.fileSize" title="Size"
		headerClass="blue-med" />
	<display:column property="softwareSignature.softwareVersion"
		title="Version" headerClass="blue-med" />
	<display:column property="path"
		title="Path" headerClass="blue-med" />

</display:table>
